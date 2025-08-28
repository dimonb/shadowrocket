const API_HOST = "<CNAME>";

// ---------- proxy to origin (shadowrocket.ebac.dev) ----------
async function forwardRequest(request, pathWithSearch) {
  const originRequest = new Request(request, { method: "GET" });
  originRequest.headers.delete("cookie");
  const target = `https://${API_HOST}${pathWithSearch}`;
  console.log(`Forwarding to origin: ${target}`);
  return fetch(target, originRequest);
}

// ---------- IPv4 helpers for NETSET normalization ----------
const reIPv4Cidr = /^(?:\d{1,3}\.){3}\d{1,3}\/(?:[0-9]|[12][0-9]|3[0-2])$/;

const ipToInt = (ip) =>
  ip.split(".").reduce((acc, p) => (acc << 8) + (p | 0), 0) >>> 0;

const intToIp = (n) =>
  [(n >>> 24) & 255, (n >>> 16) & 255, (n >>> 8) & 255, n & 255].join(".");

const maskFromPrefix = (pfx) =>
  (pfx === 0 ? 0 : (0xffffffff << (32 - pfx)) >>> 0) >>> 0;

const cidrRange = (cidr) => {
  const [ip, pfxStr] = cidr.split("/");
  const pfx = parseInt(pfxStr, 10);
  const base = ipToInt(ip) & maskFromPrefix(pfx);
  const size = 2 ** (32 - pfx);
  return { start: base >>> 0, end: (base + size - 1) >>> 0, pfx };
};

// Нормализация raw .netset в покрывающие /16 блоки (не шире /16)
async function expandNetset(urlStr, suffix) {
  console.log(`Fetching NETSET: ${urlStr}`);
  const resp = await fetch(urlStr, { cf: { cacheEverything: true } });
  if (!resp.ok) {
    const msg = `Upstream NETSET failed: ${resp.status} ${resp.statusText}`;
    console.log(msg);
    return [`# NETSET fetch failed: ${urlStr} (${resp.status})`];
  }
  const text = await resp.text();

  const result = new Set();
  for (const raw of text.split(/\r?\n/)) {
    let line = raw.trim();
    if (!line || line.startsWith("#") || line.startsWith(";")) continue;
    line = line.replace(/^IP\s+/i, "");
    if (!reIPv4Cidr.test(line)) continue;

    const { start, end } = cidrRange(line);
    let cursor = start & 0xffff0000; // нижняя граница /16
    while (cursor <= end) {
      result.add(`${intToIp(cursor)}/16`);
      cursor = (cursor + 0x00010000) >>> 0; // шаг 65536 адресов
    }
  }

  const out = Array.from(result)
    .sort((a, b) => (a < b ? -1 : a > b ? 1 : 0))
    .map((cidr) => `IP-CIDR,${cidr}${suffix}`);

  console.log(`NETSET expanded to ${out.length} /16 blocks.`);
  return out;
}

// ---------- main worker ----------
export default {
  async fetch(request, env, ctx) {
    const url = new URL(request.url);
    const pathWithParams = url.pathname + url.search;

    console.log(`Incoming: ${url.toString()}`);

    // 1) обычный форвард
    let res = await forwardRequest(request, pathWithParams);
    console.log(`Origin status: ${res.status}`);
    if (res.status !== 404) return res;

    // 2) пробуем .tpl
    const tplPath = url.pathname + ".tpl" + url.search;
    console.log(`404 -> try template: ${tplPath}`);
    const tplRes = await forwardRequest(request, tplPath);
    if (!tplRes.ok) {
      console.log(`Template fetch failed: ${tplRes.status}`);
      return res; // исходный 404
    }

    const tplText = await tplRes.text();
    const lines = tplText.split(/\r?\n/);
    const out = [];

    // policy может быть "PROXY" или "PROXY,no-resolve" и т.п.
    const ruleRegex =
      /^\s*RULE-SET\s*,\s*([^,\s]+)\s*,\s*([^#]+?)\s*(?:#.*)?$/i;

    for (const rawLine of lines) {
      const m = rawLine.match(ruleRegex);
      if (!m) { out.push(rawLine); continue; }

      const listUrlStr = m[1].trim();
      const policyRaw = m[2].trim(); // может содержать запятые
      const suffix = `,${policyRaw}`;

      console.log(`Expand RULE-SET: ${listUrlStr} with suffix "${suffix}"`);

      try {
        const listUrl = new URL(listUrlStr);
        let listText;

        if (listUrl.host === url.host) {
          // важный случай: тот же хост -> через API_HOST
          const listPath = listUrl.pathname + listUrl.search;
          console.log(`Same host -> proxy via origin for: ${listPath}`);
          const r = await forwardRequest(request, listPath);
          if (!r.ok) {
            console.log(`Proxy list fetch failed: ${r.status}`);
            out.push(rawLine);
            continue;
          }
          listText = await r.text();
        } else {
          const r = await fetch(listUrl.toString());
          if (!r.ok) {
            console.log(`External list fetch failed: ${r.status}`);
            out.push(rawLine);
            continue;
          }
          listText = await r.text();
        }

        const listLines = listText.split(/\r?\n/);
        let netsetHandled = false;

        // 2.1 Сначала ищем #NETSET
        for (const LL of listLines) {
          const t = LL.trim();
          const netm = t.match(/^#NETSET\s+(\S+)/i);
          if (netm && netm[1]) {
            netsetHandled = true;
            out.push(`# RULE-SET,${listUrlStr}  (via NETSET ${netm[1]})`);
            const expanded = await expandNetset(netm[1], suffix);
            for (const line of expanded) out.push(line);
          }
        }

        if (netsetHandled) {
          // Если был #NETSET, обычные строки из этого RULE-SET не разворачиваем повторно
          continue;
        }

        // 2.2 Обычная развёртка списка доменов/правил
        out.push(`# RULE-SET,${listUrlStr}`);
        for (let L of listLines) {
          let t = L.trim();
          if (!t || t.startsWith("#")) continue;
          // отрезаем хвостовые комментарии
          const hashPos = t.indexOf("#");
          if (hashPos !== -1) t = t.slice(0, hashPos).trim();
          if (!t) continue;

          // убираем лишние пробелы вокруг запятых
          t = t.replace(/\s+,/g, ",").replace(/,\s+/g, ",");

          // если в строке уже есть ,PROXY|,DIRECT|,REJECT — заменим/добавим наш суффикс целиком
          if (/(,PROXY|,DIRECT|,REJECT)\s*$/i.test(t)) {
            t = t.replace(/,(PROXY|DIRECT|REJECT)\s*$/i, suffix);
          } else {
            t = `${t}${suffix}`;
          }
          out.push(t);
        }
      } catch (err) {
        console.log(`Error expanding RULE-SET: ${err?.message || err}`);
        out.push(rawLine);
      }
    }

    console.log(`Expanded ${out.length} lines total.`);
    return new Response(out.join("\n"), {
      status: 200,
      headers: { "content-type": "text/plain; charset=utf-8" },
    });
  },
};