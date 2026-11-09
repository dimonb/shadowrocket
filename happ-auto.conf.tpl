#HAPP,JSON,AUTH
#profile-title: dimonb.auto
#profile-update-interval: 6
{
  "remarks": "🔄 Авто",
  "log": { "loglevel": "warning" },
  "inbounds": [
    {
      "tag": "socks",
      "listen": "127.0.0.1",
      "port": 10808,
      "protocol": "socks",
      "settings": { "auth": "noauth", "udp": true },
      "sniffing": { "enabled": true, "destOverride": ["http", "tls", "quic"], "routeOnly": true }
    },
    {
      "tag": "http",
      "listen": "127.0.0.1",
      "port": 10809,
      "protocol": "http",
      "sniffing": { "enabled": true, "destOverride": ["http", "tls"], "routeOnly": true }
    }
  ],
  "outbounds": [
    "PROXY_OUTBOUNDS",
    { "tag": "direct", "protocol": "freedom" },
    { "tag": "block", "protocol": "blackhole" }
  ],
  "routing": {
    "domainStrategy": "AsIs",
    "rules": [
      {
        "ip": ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16", "169.254.0.0/16", "127.0.0.0/8", "fc00::/7", "fe80::/10", "::1/128"],
        "outboundTag": "direct"
      },
      { "network": "udp", "port": "443", "outboundTag": "block" },
      { "network": "tcp,udp", "balancerTag": "PROXY" }
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
