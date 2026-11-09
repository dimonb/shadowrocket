#HAPP,JSON,AUTH
#profile-title: dimonb.auto
#profile-update-interval: 6
#routing: happ://routing/onadd/eyJOYW1lIjoiZGltb25iLmF1dG8iLCJMYXN0VXBkYXRlZCI6IjE3NjI3MjIwMDAiLCJHbG9iYWxQcm94eSI6InRydWUiLCJHZW9pcHVybCI6Imh0dHBzOi8vY2RuLmpzZGVsaXZyLm5ldC9naC9ydW5ldGZyZWVkb20vcnVzc2lhLXYycmF5LXJ1bGVzLWRhdEByZWxlYXNlL2dlb2lwLmRhdCIsIkdlb3NpdGV1cmwiOiJodHRwczovL2Nkbi5qc2RlbGl2ci5uZXQvZ2gvdjJmbHkvZG9tYWluLWxpc3QtY29tbXVuaXR5QHJlbGVhc2UvZGxjLmRhdCIsIkRpcmVjdFNpdGVzIjpbImdlb3NpdGU6Y2F0ZWdvcnktcnUiXSwiRGlyZWN0SXAiOlsiZ2VvaXA6cnUiLCJnZW9pcDpwcml2YXRlIl0sIlByb3h5U2l0ZXMiOltdLCJQcm94eUlwIjpbXSwiQmxvY2tTaXRlcyI6W10sIkJsb2NrSXAiOltdLCJEb21haW5TdHJhdGVneSI6IklQSWZOb25NYXRjaCIsIkZha2VETlMiOiJmYWxzZSJ9
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
      {
        "domain": [
          "domain:ru", "domain:xn--p1ai", "domain:su",
          "domain:yandex.net", "domain:yandex.com", "domain:yastatic.net", "domain:yandexcloud.net",
          "domain:yandex.cloud", "domain:vk.com", "domain:vk.me", "domain:vk.company",
          "domain:userapi.com", "domain:vkuser.net", "domain:vkuseraudio.net", "domain:vkuservideo.net",
          "domain:mycdn.me", "domain:sberbank.com", "domain:2gis.com", "domain:avito.st",
          "domain:ozonusercontent.com"
        ],
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
