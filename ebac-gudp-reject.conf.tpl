# Shadowrocket: 2024-07-03 12:53:21
[General]
bypass-system = true
skip-proxy = 192.168.0.0/16, 10.0.0.0/8, 172.16.0.0/12, localhost, *.local, captive.apple.com
tun-excluded-routes = 10.0.0.0/8, 100.64.0.0/10, 127.0.0.0/8, 169.254.0.0/16, 172.16.0.0/12, 192.0.0.0/24, 192.0.2.0/24, 192.88.99.0/24, 192.168.0.0/16, 198.18.0.0/15, 198.51.100.0/24, 203.0.113.0/24, 224.0.0.0/4, 255.255.255.255/32
dns-server = 1.1.1.1, 1.0.0.1, 8.8.8.8, system
ipv6 = true

[Proxy Group]
proxy = url-test,interval=600,tolerance=100,timeout=5,url=http://www.gstatic.com/generate_204,policy-regex-filter=((DE)|(FR)|(IE)).*(WS)
ru-proxy = url-test,interval=600,tolerance=100,timeout=5,url=http://www.gstatic.com/generate_204,policy-regex-filter=(RU).*(VLESS)

[Rule]

# site to check ip
DOMAIN-SUFFIX,whatismyipaddress.com,PROXY

# reject returning empty-dict-200 for some ads
RULE-SET,https://shadowrocket.ebac.dev/lists/ads.list,REJECT-DICT

# Google Meet (Workspace)
AND,((PROTOCOL,UDP),(IP-CIDR,74.125.250.0/24)),REJECT
AND,((PROTOCOL,UDP),(IP-CIDR,74.125.247.128/32)),REJECT
AND,((PROTOCOL,UDP),(IP-CIDR,2001:4860:4864:5::/64)),REJECT

# Google Meet (Consumer / non-Workspace)
AND,((PROTOCOL,UDP),(IP-CIDR,142.250.82.0/24)),REJECT
AND,((PROTOCOL,UDP),(IP-CIDR,2001:4860:4864:6::/64)),REJECT

# YouTube (LLC ranges, networksdb.io 03.08.2025)
AND,((PROTOCOL,UDP),(IP-CIDR,104.237.160.0/19)),REJECT
AND,((PROTOCOL,UDP),(IP-CIDR,136.22.128.0/19)),REJECT
AND,((PROTOCOL,UDP),(IP-CIDR,208.117.224.0/19)),REJECT
AND,((PROTOCOL,UDP),(IP-CIDR,64.15.112.0/20)),REJECT
AND,((PROTOCOL,UDP),(IP-CIDR,216.73.80.0/20)),REJECT
AND,((PROTOCOL,UDP),(IP-CIDR,172.110.32.0/21)),REJECT
AND,((PROTOCOL,UDP),(IP-CIDR,208.65.152.0/22)),REJECT
AND,((PROTOCOL,UDP),(IP-CIDR,76.208.211.160/29)),REJECT


# force proxy
RULE-SET,https://shadowrocket.ebac.dev/lists/rutracker.list,ru-proxy
RULE-SET,https://shadowrocket.ebac.dev/lists/binance.list,ru-proxy
RULE-SET,https://shadowrocket.ebac.dev/lists/zoom.list,ru-proxy
RULE-SET,https://shadowrocket.ebac.dev/lists/google.list,ru-proxy
RULE-SET,https://shadowrocket.ebac.dev/lists/meta.list,ru-proxy
RULE-SET,https://shadowrocket.ebac.dev/lists/telegram.list,PROXY
RULE-SET,https://shadowrocket.ebac.dev/lists/twitter.list,ru-proxy
RULE-SET,https://shadowrocket.ebac.dev/lists/tiktok.list,ru-proxy
RULE-SET,https://shadowrocket.ebac.dev/lists/whatsapp.list,ru-proxy
RULE-SET,https://shadowrocket.ebac.dev/lists/chatgpt.list,ru-proxy
RULE-SET,https://shadowrocket.ebac.dev/lists/apple-private.list,ru-proxy
RULE-SET,https://shadowrocket.ebac.dev/lists/ebac.list,ru-proxy
RULE-SET,https://shadowrocket.ebac.dev/lists/notion.list,ru-proxy
RULE-SET,https://shadowrocket.ebac.dev/lists/github.list,ru-proxy
RULE-SET,https://shadowrocket.ebac.dev/lists/cursor.list,ru-proxy
RULE-SET,https://shadowrocket.ebac.dev/lists/discord.list,PROXY
RULE-SET,https://shadowrocket.ebac.dev/lists/cloudflare.list,ru-proxy
RULE-SET,https://shadowrocket.ebac.dev/lists/misc.list,ru-proxy
RULE-SET,https://shadowrocket.ebac.dev/lists/twilio.list,PROXY
RULE-SET,https://shadowrocket.ebac.dev/lists/payment-gates.list,PROXY
RULE-SET,https://shadowrocket.ebac.dev/lists/amazon.list,PROXY

FINAL,DIRECT

[Host]
localhost = 127.0.0.1
