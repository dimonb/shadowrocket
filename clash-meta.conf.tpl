
#CLASH,AUTH

mixed-port: 7890
allow-lan: true
mode: Rule
log-level: info
ipv6: true

dns:
  enable: true
  listen: 0.0.0.0:1053
  enhanced-mode: fake-ip
  nameserver:
    - https://1.1.1.1/dns-query
    - https://8.8.8.8/dns-query
  fallback:
    - https://dns.google/dns-query
    - https://cloudflare-dns.com/dns-query
  # NetBird (Constructor VPN): internal hosts need their real 10.x / 100.x address,
  # so the OS routes them into the NetBird tunnel instead of a fake IP into Clash
  fake-ip-filter:
    - "+.constr.dev"
    - "+.constructor.tech"
    - "+.constructor.org"
    - "+.constructor.dev"
    - "+.dev-constructor.dev"

tun:
  enable: true
  stack: system
  dns-hijack:
    - any:53
  auto-route: true
  auto-detect-interface: true

proxies:
  - PROXY_CONFIGS

proxy-groups:
  - name: PROXY
    type: url-test
    url: http://www.gstatic.com/generate_204
    interval: 600
    tolerance: 100
    proxies:
      - PROXY_LIST

rules:
  # check vpn cpnnected
  - DOMAIN-SUFFIX,whatismyipaddress.com,PROXY

  - RULE-SET,https://shadowrocket.ebac.dev/lists/rutracker.list,PROXY
  - RULE-SET,https://shadowrocket.ebac.dev/lists/binance.list,PROXY
  - RULE-SET,https://shadowrocket.ebac.dev/lists/zoom.list,PROXY
  - RULE-SET,https://shadowrocket.ebac.dev/lists/google.list,PROXY
  - RULE-SET,https://shadowrocket.ebac.dev/lists/meta.list,PROXY
  - RULE-SET,https://shadowrocket.ebac.dev/lists/telegram.list,PROXY
  - RULE-SET,https://shadowrocket.ebac.dev/lists/twitter.list,PROXY
  - RULE-SET,https://shadowrocket.ebac.dev/lists/tiktok.list,PROXY
  - RULE-SET,https://shadowrocket.ebac.dev/lists/whatsapp.list,PROXY
  - RULE-SET,https://shadowrocket.ebac.dev/lists/chatgpt.list,PROXY
  - RULE-SET,https://shadowrocket.ebac.dev/lists/claude.list,PROXY
  - RULE-SET,https://shadowrocket.ebac.dev/lists/apple-private.list,PROXY
  - RULE-SET,https://shadowrocket.ebac.dev/lists/notion.list,PROXY
  - RULE-SET,https://shadowrocket.ebac.dev/lists/github.list,PROXY
  - RULE-SET,https://shadowrocket.ebac.dev/lists/cursor.list,PROXY
  - RULE-SET,https://shadowrocket.ebac.dev/lists/discord.list,PROXY
  - RULE-SET,https://shadowrocket.ebac.dev/lists/cloudflare.list,PROXY
  - RULE-SET,https://shadowrocket.ebac.dev/lists/misc.list,PROXY
  - RULE-SET,https://shadowrocket.ebac.dev/lists/microsoft.list,PROXY
  - RULE-SET,https://shadowrocket.ebac.dev/lists/ebac.list,PROXY
  - RULE-SET,https://shadowrocket.ebac.dev/lists/twilio.list,PROXY
  - RULE-SET,https://shadowrocket.ebac.dev/lists/payment-gates.list,PROXY
  - RULE-SET,https://shadowrocket.ebac.dev/lists/amazon.list,PROXY
  # NetBird (Constructor VPN): internal Constructor addresses are reachable only
  # through the NetBird tunnel, never via PROXY (must stay above constructor.list).
  # Last before MATCH: IP rules resolve the name, so only names no list matched pay for it
  - IP-CIDR,100.64.0.0/10,DIRECT
  - IP-CIDR,10.0.0.0/8,DIRECT
  - IP-CIDR,172.16.0.0/12,DIRECT
  - RULE-SET,https://shadowrocket.ebac.dev/lists/constructor.list,PROXY

  # всё остальное напрямую
  - MATCH,DIRECT
