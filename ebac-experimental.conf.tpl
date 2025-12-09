# Shadowrocket: 2024-07-03 12:53:21
[General]
bypass-system = true
skip-proxy = 192.168.0.0/16, 10.0.0.0/8, 172.16.0.0/12, localhost, *.local, captive.apple.com
tun-excluded-routes = 10.0.0.0/8, 100.64.0.0/10, 127.0.0.0/8, 169.254.0.0/16, 172.16.0.0/12, 192.0.0.0/24, 192.0.2.0/24, 192.88.99.0/24, 192.168.0.0/16, 198.18.0.0/15, 198.51.100.0/24, 203.0.113.0/24, 224.0.0.0/4, 255.255.255.255/32
dns-server = 1.1.1.1, 1.0.0.1, 8.8.8.8, system
ipv6 = true

[Proxy Group]
WS-auto = url-test, policy-regex-filter=((DE)|(FR)|(IE)).*WS, url=http://www.gstatic.com/generate_204, interval=600, timeout=5, tolerance=100
VLESS-auto = url-test, policy-regex-filter=((DE)|(FR)|(IE)).*VLESS, url=http://www.gstatic.com/generate_204, interval=600, timeout=5, tolerance=100
proxy = fallback, WS-auto, VLESS-auto, url=http://www.gstatic.com/generate_204, interval=600, timeout=5

[Rule]

# site to check ip
DOMAIN-SUFFIX,whatismyipaddress.com,PROXY

# reject returning empty-dict-200 for some ads
RULE-SET,https://shadowrocket.ebac.dev/lists/ads.list,REJECT-DICT

# force proxy
RULE-SET,https://shadowrocket.ebac.dev/lists/rutracker.list,PROXY
RULE-SET,https://shadowrocket.ebac.dev/lists/binance.list,PROXY
RULE-SET,https://shadowrocket.ebac.dev/lists/zoom.list,PROXY
RULE-SET,https://shadowrocket.ebac.dev/lists/google.list,PROXY
RULE-SET,https://shadowrocket.ebac.dev/lists/meta.list,PROXY
RULE-SET,https://shadowrocket.ebac.dev/lists/telegram.list,PROXY
RULE-SET,https://shadowrocket.ebac.dev/lists/twitter.list,PROXY
RULE-SET,https://shadowrocket.ebac.dev/lists/tiktok.list,PROXY
RULE-SET,https://shadowrocket.ebac.dev/lists/whatsapp.list,PROXY
RULE-SET,https://shadowrocket.ebac.dev/lists/chatgpt.list,PROXY
RULE-SET,https://shadowrocket.ebac.dev/lists/apple-private.list,PROXY
RULE-SET,https://shadowrocket.ebac.dev/lists/ebac.list,PROXY
RULE-SET,https://shadowrocket.ebac.dev/lists/notion.list,PROXY
RULE-SET,https://shadowrocket.ebac.dev/lists/github.list,PROXY
RULE-SET,https://shadowrocket.ebac.dev/lists/cursor.list,PROXY
RULE-SET,https://shadowrocket.ebac.dev/lists/discord.list,PROXY
RULE-SET,https://shadowrocket.ebac.dev/lists/cloudflare.list,PROXY
RULE-SET,https://shadowrocket.ebac.dev/lists/misc.list,PROXY
RULE-SET,https://shadowrocket.ebac.dev/lists/microsoft.list,PROXY
RULE-SET,https://shadowrocket.ebac.dev/lists/twilio.list,PROXY
RULE-SET,https://shadowrocket.ebac.dev/lists/payment-gates.list,PROXY

FINAL,DIRECT

[Host]
localhost = 127.0.0.1
