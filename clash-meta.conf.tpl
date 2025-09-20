
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
  - RULE-SET,https://shadowrocket.ebac.dev/lists/apple-private.list,PROXY
  - RULE-SET,https://shadowrocket.ebac.dev/lists/notion.list,PROXY
  - RULE-SET,https://shadowrocket.ebac.dev/lists/github.list,PROXY
  - RULE-SET,https://shadowrocket.ebac.dev/lists/cursor.list,PROXY
  - RULE-SET,https://shadowrocket.ebac.dev/lists/discord.list,PROXY
  - RULE-SET,https://shadowrocket.ebac.dev/lists/cloudflare.list,PROXY
  - RULE-SET,https://shadowrocket.ebac.dev/lists/misc.list,PROXY
  - RULE-SET,https://shadowrocket.ebac.dev/lists/microsoft.list,PROXY

  # всё остальное напрямую
  - MATCH,DIRECT
