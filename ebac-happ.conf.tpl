#HAPP,JSON,AUTH
#profile-title: ebac.auto
#profile-update-interval: 6
{
  "remarks": "🔄 Авто",
  "log": {
    "loglevel": "warning"
  },
  "inbounds": [
    {
      "tag": "socks",
      "listen": "127.0.0.1",
      "port": 10808,
      "protocol": "socks",
      "settings": {
        "auth": "noauth",
        "udp": true
      },
      "sniffing": {
        "enabled": true,
        "destOverride": [
          "http",
          "tls",
          "quic"
        ],
        "routeOnly": false
      }
    },
    {
      "tag": "http",
      "listen": "127.0.0.1",
      "port": 10809,
      "protocol": "http",
      "sniffing": {
        "enabled": true,
        "destOverride": [
          "http",
          "tls"
        ],
        "routeOnly": false
      }
    }
  ],
  "outbounds": [
    "PROXY_OUTBOUNDS",
    {
      "tag": "direct",
      "protocol": "freedom"
    },
    {
      "tag": "block",
      "protocol": "blackhole"
    }
  ],
  "routing": {
    "domainStrategy": "AsIs",
    "rules": [
      {
        "ip": [
          "10.0.0.0/8",
          "100.64.0.0/10",
          "172.16.0.0/12",
          "192.168.0.0/16",
          "169.254.0.0/16",
          "127.0.0.0/8",
          "fc00::/7",
          "fe80::/10",
          "::1/128"
        ],
        "outboundTag": "direct"
      },
      {
        "ruleSet": [
          "https://shadowrocket.ebac.dev/lists/ads.list"
        ],
        "outboundTag": "block"
      },
      {
        "ruleSet": [
          "https://shadowrocket.ebac.dev/lists/ebac.list",
          "https://shadowrocket.ebac.dev/lists/constructor.list",
          "https://shadowrocket.ebac.dev/lists/rutracker.list",
          "https://shadowrocket.ebac.dev/lists/binance.list",
          "https://shadowrocket.ebac.dev/lists/zoom.list",
          "https://shadowrocket.ebac.dev/lists/google.list",
          "https://shadowrocket.ebac.dev/lists/meta.list",
          "https://shadowrocket.ebac.dev/lists/telegram.list",
          "https://shadowrocket.ebac.dev/lists/twitter.list",
          "https://shadowrocket.ebac.dev/lists/tiktok.list",
          "https://shadowrocket.ebac.dev/lists/whatsapp.list",
          "https://shadowrocket.ebac.dev/lists/chatgpt.list",
          "https://shadowrocket.ebac.dev/lists/claude.list",
          "https://shadowrocket.ebac.dev/lists/apple-private.list",
          "https://shadowrocket.ebac.dev/lists/notion.list",
          "https://shadowrocket.ebac.dev/lists/github.list",
          "https://shadowrocket.ebac.dev/lists/cursor.list",
          "https://shadowrocket.ebac.dev/lists/discord.list",
          "https://shadowrocket.ebac.dev/lists/cloudflare.list",
          "https://shadowrocket.ebac.dev/lists/misc.list",
          "https://shadowrocket.ebac.dev/lists/microsoft.list",
          "https://shadowrocket.ebac.dev/lists/twilio.list",
          "https://shadowrocket.ebac.dev/lists/payment-gates.list",
          "https://shadowrocket.ebac.dev/lists/amazon.list"
        ],
        "network": "udp",
        "port": "443",
        "outboundTag": "block"
      },
      {
        "ruleSet": [
          "https://shadowrocket.ebac.dev/lists/ebac.list",
          "https://shadowrocket.ebac.dev/lists/constructor.list",
          "https://shadowrocket.ebac.dev/lists/rutracker.list",
          "https://shadowrocket.ebac.dev/lists/binance.list",
          "https://shadowrocket.ebac.dev/lists/zoom.list",
          "https://shadowrocket.ebac.dev/lists/google.list",
          "https://shadowrocket.ebac.dev/lists/meta.list",
          "https://shadowrocket.ebac.dev/lists/telegram.list",
          "https://shadowrocket.ebac.dev/lists/twitter.list",
          "https://shadowrocket.ebac.dev/lists/tiktok.list",
          "https://shadowrocket.ebac.dev/lists/whatsapp.list",
          "https://shadowrocket.ebac.dev/lists/chatgpt.list",
          "https://shadowrocket.ebac.dev/lists/claude.list",
          "https://shadowrocket.ebac.dev/lists/apple-private.list",
          "https://shadowrocket.ebac.dev/lists/notion.list",
          "https://shadowrocket.ebac.dev/lists/github.list",
          "https://shadowrocket.ebac.dev/lists/cursor.list",
          "https://shadowrocket.ebac.dev/lists/discord.list",
          "https://shadowrocket.ebac.dev/lists/cloudflare.list",
          "https://shadowrocket.ebac.dev/lists/misc.list",
          "https://shadowrocket.ebac.dev/lists/microsoft.list",
          "https://shadowrocket.ebac.dev/lists/twilio.list",
          "https://shadowrocket.ebac.dev/lists/payment-gates.list",
          "https://shadowrocket.ebac.dev/lists/amazon.list"
        ],
        "domain": [
          "domain:whatismyipaddress.com"
        ],
        "network": "tcp,udp",
        "balancerTag": "PROXY"
      },
      {
        "network": "tcp,udp",
        "outboundTag": "direct"
      }
    ]
  },
  "burstObservatory": {
    "pingConfig": {
      "destination": "https://www.gstatic.com/generate_204",
      "connectivity": "",
      "interval": "15s",
      "sampling": 2,
      "timeout": "5s"
    }
  }
}
