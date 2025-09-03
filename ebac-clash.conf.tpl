
#CLASH,AUTH

mixed-port: 7890
allow-lan: true
mode: Rule
log-level: info

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

  - RULE-SET,https://s.dimonb.com/lists/rutracker.list,PROXY
  - RULE-SET,https://s.dimonb.com/lists/binance.list,PROXY
  - RULE-SET,https://s.dimonb.com/lists/zoom.list,PROXY
  - RULE-SET,https://s.dimonb.com/lists/google.list,PROXY
  - RULE-SET,https://s.dimonb.com/lists/meta.list,PROXY
  - RULE-SET,https://s.dimonb.com/lists/telegram.list,PROXY
  - RULE-SET,https://s.dimonb.com/lists/twitter.list,PROXY
  - RULE-SET,https://s.dimonb.com/lists/tiktok.list,PROXY
  - RULE-SET,https://s.dimonb.com/lists/whatsapp.list,PROXY
  - RULE-SET,https://s.dimonb.com/lists/chatgpt.list,PROXY
  - RULE-SET,https://s.dimonb.com/lists/apple-private.list,PROXY
  - RULE-SET,https://s.dimonb.com/lists/ebac.list,PROXY
  - RULE-SET,https://s.dimonb.com/lists/notion.list,PROXY


  # всё остальное напрямую
  - MATCH,DIRECT