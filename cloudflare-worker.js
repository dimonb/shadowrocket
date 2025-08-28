/**
 * Cloudflare Worker v4: proxy -> 404 -> .tpl -> expand RULE-SET (parallel, de-dup)
 * - Origin proxy: https://shadowrocket.ebac.dev
 * - If 404: fetch .tpl, expand RULE-SETs in parallel
 * - RULE-SET may include "#NETSET <url>"
 *   - IPv4 lines → cover with /IPV4_BLOCK_PREFIX blocks (configurable)
 *   - IPv6 lines → cover with /IPV6_BLOCK_PREFIX blocks (configurable)
 * - Subrequests to s.dimonb.com (same host) go via API_HOST to avoid worker bypass
 * - Final output is deduplicated
 */

const API_HOST = "shadowrocket.ebac.dev";
const ALT_HOST = "s.dimonb.com";

// ===== Aggregation targets =====
const IPV4_BLOCK_PREFIX = 18; // <-- requested: aggregate IPv4 up to /19
const IPV6_BLOCK_PREFIX = 32; // existing behavior

// --------------------------- Logging ---------------------------
const log = (...args) => console.log("[worker]", ...args);

// --------------------------- Proxy helpers ---------------------------
async function forwardRequest(request, pathWithSearch) {
  const target = `https://${API_HOST}${pathWithSearch}`;
  const originRequest = new Request(request, { method: "GET" });
  originRequest.headers.delete("cookie");
  log("Forwarding to origin:", target);
  return fetch(target, originRequest);
}

/** Fetch arbitrary URL. If host equals incoming host or ALT_HOST, proxy via API_HOST. */
async function smartFetch(urlStr, incomingHost, requestForHeaders) {
  const u = new URL(urlStr);
  if (u.host === incomingHost || u.host === ALT_HOST) {
    const path = u.pathname + u.search;
    log("Same/ALT host detected; proxy via origin for:", path);
    return forwardRequest(requestForHeaders, path);
  }
  return fetch(u.toString());
}

// --------------------------- NETSET / IP utils ---------------------------
const RE_IPV4_CIDR = /^(?:\d{1,3}\.){3}\d{1,3}\/(?:[0-9]|[12][0-9]|3[0-2])$/;
const RE_IPV6_CIDR = /^([0-9a-f:]+:+)+\/\d{1,3}$/i;

const ipToInt = (ip) => ip.split(".").reduce((acc, p) => (acc << 8) + (p | 0), 0) >>> 0;
const intToIp = (n) => [(n >>> 24) & 255, (n >>> 16) & 255, (n >>> 8) & 255, n & 255].join(".");
const maskFromPrefix = (pfx) => (pfx === 0 ? 0 : (0xffffffff << (32 - pfx)) >>> 0) >>> 0;

const cidrRangeV4 = (cidr) => {
  const [ip, pfxStr] = cidr.split("/");
  const pfx = parseInt(pfxStr, 10);
  const base = ipToInt(ip) & maskFromPrefix(pfx);
  const size = 2 ** (32 - pfx);
  return { start: base >>> 0, end: (base + size - 1) >>> 0 };
};

function floorToPrefixV4(addr, targetPfx) {
  const m = maskFromPrefix(targetPfx);
  return addr & m;
}

function blockSizeV4(targetPfx) {
  return 2 ** (32 - targetPfx);
}

/** Return list of covering IPv4 blocks with target prefix (e.g. /19) */
function ipv4CoverBlocks(cidr, targetPfx) {
  const { start, end } = cidrRangeV4(cidr);
  const size = blockSizeV4(targetPfx);
  let cursor = floorToPrefixV4(start, targetPfx);
  const out = [];
  while (cursor <= end) {
    out.push(`${intToIp(cursor)}/${targetPfx}`);
    cursor = (cursor + size) >>> 0;
  }
  return out;
}

// ---------- IPv6 helpers (BigInt) ----------
function parseIPv6ToBigInt(ipv6) {
  const [left, right = ""] = ipv6.split("::");
  const leftParts = left ? left.split(":") : [];
  const rightParts = right ? right.split(":") : [];
  const missing = 8 - (leftParts.length + rightParts.length);
  const parts = [
    ...leftParts,
    ...Array(Math.max(0, missing)).fill("0"),
    ...rightParts,
  ].map((h) => (h.length ? parseInt(h, 16) : 0));
  if (parts.length !== 8 || parts.some((x) => Number.isNaN(x) || x < 0 || x > 0xffff)) {
    throw new Error("Invalid IPv6 address: " + ipv6);
  }
  let value = 0n;
  for (const part of parts) value = (value << 16n) + BigInt(part);
  return value; // 128-bit unsigned
}

function ipv6CidrToBlocks(cidr, targetPfx = IPV6_BLOCK_PREFIX) {
  const [addr, pfxStr] = cidr.split("/");
  const pfx = BigInt(parseInt(pfxStr, 10));
  const width = 128n;
  const blockPrefix = BigInt(targetPfx);
  const value = parseIPv6ToBigInt(addr);
  const one = 1n;

  const mask = (pfx === 0n) ? 0n : (~0n << (width - pfx)) & ((one << width) - one);
  const base = value & mask;
  const size = one << (width - pfx);
  const end = base + size - one;

  const shift = width - blockPrefix; // e.g. 96 for /32
  const startIdx = Number(base >> shift);
  const endIdx = Number(end >> shift);

  const span = endIdx - startIdx + 1;
  if (span > 262144) {
    log(`IPv6 CIDR ${cidr} spans ${span} /${targetPfx} blocks; capping.`);
    return [toSlash32FromIndex(startIdx), `# WARNING: truncated ${span - 1} blocks for ${cidr}`];
  }

  const blocks = [];
  for (let i = startIdx; i <= endIdx; i++) blocks.push(toSlash32FromIndex(i));
  return blocks;
}

function toSlash32FromIndex(idx32) {
  const hi = (idx32 >>> 16) & 0xffff;
  const lo = idx32 & 0xffff;
  return `${hi.toString(16)}:${lo.toString(16)}::/32`;
}

// --------------------------- RULE-SET parsing ---------------------------
const RULE_RE = /^\s*RULE-SET\s*,\s*([^,\s]+)\s*,\s*([^#]+?)\s*(?:#.*)?$/i;
const NETSET_RE = /^#NETSET\s+(\S+)/i;

// Stable de-duplication while preserving first occurrence order
function dedupeLines(lines) {
  const seen = new Set();
  const out = [];
  for (const l of lines) {
    const key = l.trim();
    if (!seen.has(key)) { seen.add(key); out.push(l); }
  }
  return out;
}

/** Expand raw .netset text into lines, IPv4 -> /19, IPv6 -> /32 */
function netsetExpand(text, suffix) {
  const out = [];
  for (const raw of text.split(/\r?\n/)) {
    let line = raw.trim();
    if (!line || line.startsWith("#") || line.startsWith(";")) continue;
    line = line.replace(/^IP\s+/i, "");

    if (RE_IPV6_CIDR.test(line)) {
      try {
        const blocks = ipv6CidrToBlocks(line, IPV6_BLOCK_PREFIX);
        for (const b of blocks) {
          if (b.startsWith("#")) out.push(b); else out.push(`IP-CIDR,${b}${suffix}`);
        }
      } catch (e) {
        log("IPv6 parse error for", line, e?.message || e);
        out.push(`IP-CIDR,${line}${suffix}`);
      }
      continue;
    }

    if (!RE_IPV4_CIDR.test(line)) continue;
    const blocks4 = ipv4CoverBlocks(line, IPV4_BLOCK_PREFIX);
    for (const b of blocks4) out.push(`IP-CIDR,${b}${suffix}`);
  }
  return out;
}

async function expandNetset(urlStr, suffix) {
  log(`Fetching NETSET: ${urlStr}`);
  try {
    const resp = await fetch(urlStr, { cf: { cacheEverything: true } });
    if (!resp.ok) {
      log(`NETSET fetch failed: ${resp.status}`);
      return [`# NETSET fetch failed: ${urlStr} (${resp.status})`];
    }
    const text = await resp.text();
    const expanded = netsetExpand(text, suffix);
    log(`NETSET expanded ${expanded.length} entries (IPv4→/${IPV4_BLOCK_PREFIX}, IPv6→/${IPV6_BLOCK_PREFIX})`);
    return expanded;
  } catch (e) {
    log(`NETSET error ${urlStr}:`, e?.message || e);
    return [`# NETSET error: ${urlStr}`];
  }
}

/** Extract RULE-SET entries from template lines. Non-matching lines are preserved as-is. */
function parseTemplate(templateText) {
  const lines = templateText.split(/\r?\n/);
  const tasks = [];
  const passthrough = [];
  lines.forEach((raw, index) => {
    const m = raw.match(RULE_RE);
    if (!m) { passthrough[index] = raw; return; }
    const listUrl = m[1].trim();
    const suffix = `,${m[2].trim()}`; // keep commas e.g. ",PROXY,no-resolve"
    tasks.push({ index, url: listUrl, suffix });
  });
  return { tasks, passthrough, originalLineCount: lines.length };
}

// --------------------------- Expanders ---------------------------
async function expandRuleSet({ url, suffix }, incomingHost, requestForHeaders) {
  log(`Expanding RULE-SET: ${url} with suffix "${suffix}"`);
  const resp = await smartFetch(url, incomingHost, requestForHeaders);
  if (!resp.ok) {
    log(`List fetch failed: ${url} -> ${resp.status}`);
    return [`# RULE-SET fetch failed: ${url} (${resp.status})`];
  }
  const text = await resp.text();
  const lines = text.split(/\r?\n/);

  const netsetUrls = lines
    .map((l) => l.trim())
    .map((t) => (NETSET_RE.test(t) ? t.match(NETSET_RE)[1] : null))
    .filter(Boolean);

  if (netsetUrls.length > 0) {
    log(`Found ${netsetUrls.length} NETSET entr${netsetUrls.length > 1 ? "ies" : "y"} in ${url}`);
    const jobs = netsetUrls.map((nsUrl) => expandNetset(nsUrl, suffix));
    const results = await Promise.all(jobs);
    const merged = dedupeLines(results.flat());
    return [`# RULE-SET,${url}`, ...merged];
  }

  const out = [`# RULE-SET,${url}`];
  for (let L of lines) {
    let t = L.trim();
    if (!t || t.startsWith("#")) continue;
    const hashPos = t.indexOf("#");
    if (hashPos !== -1) t = t.slice(0, hashPos).trim();
    if (!t) continue;

    t = t.replace(/\s+,/g, ",").replace(/,\s+/g, ",");
    if (/(,PROXY|,DIRECT|,REJECT)\s*$/i.test(t)) {
      t = t.replace(/,(PROXY|DIRECT|REJECT)\s*$/i, suffix);
    } else {
      t = `${t}${suffix}`;
    }
    out.push(t);
  }
  return dedupeLines(out);
}

/** Process a .tpl body: run all RULE-SET expands in parallel and merge with passthrough lines. */
async function processTemplate(tplText, incomingHost, requestForHeaders) {
  const { tasks, passthrough, originalLineCount } = parseTemplate(tplText);
  log(`Template parsed: ${originalLineCount} lines, ${tasks.length} RULE-SET task(s)`);

  const expansions = await Promise.all(
    tasks.map((t) => expandRuleSet(t, incomingHost, requestForHeaders))
  );

  const output = [];
  const taskByIndex = new Map(tasks.map((t, i) => [t.index, expansions[i]]));
  for (let i = 0; i < originalLineCount; i++) {
    if (taskByIndex.has(i)) output.push(...taskByIndex.get(i));
    else output.push(passthrough[i] ?? "");
  }
  const finalOut = dedupeLines(output);
  log(`Template expansion complete. Total lines: ${finalOut.length}`);
  return finalOut.join("\n");
}

// --------------------------- Worker entry ---------------------------
export default {
  async fetch(request, env, ctx) {
    try {
      const url = new URL(request.url);
      const pathWithParams = url.pathname + url.search;

      log("Incoming:", url.toString());

      let res = await forwardRequest(request, pathWithParams);
      log("Origin status:", res.status);
      if (res.status !== 404) return res;

      const tplPath = url.pathname + ".tpl" + url.search;
      log("404 -> try template:", tplPath);
      const tplRes = await forwardRequest(request, tplPath);
      if (!tplRes.ok) { log("Template fetch failed:", tplRes.status); return res; }

      const tplText = await tplRes.text();
      const finalBody = await processTemplate(tplText, url.host, request);

      return new Response(finalBody, {
        status: 200,
        headers: { "content-type": "text/plain; charset=utf-8" },
      });
    } catch (e) {
      log("Worker error:", e?.stack || e?.message || String(e));
      return new Response("Worker error", { status: 500 });
    }
  },
};
