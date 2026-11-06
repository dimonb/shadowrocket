#CLASH,AUTH
# mihomo subscription (Clash Mi, Clash Verge Rev, FlClash, Clash Meta for Android).
# URL: https://<entry host>/ebac-mihomo.yaml?u=<user>&hash=<sha256("<user>.<SALT>")>&sub=<group>
# cfgapp fills PROXY_CONFIGS / PROXY_LIST from the subscription group (one entry per region,
# picked by hand in the VPN group) and expands the RULE-SET lines.
#
# Routing: everything goes through the VPN except Russian and Belarusian destinations.
#   1. block: public trackers, ads/analytics SDKs
#   2. always VPN: the ebac/constructor lists, Google Play, YouTube, Google, Microsoft (their
#      .ru/.by names too), ubs.com (a foreign bank listed in category-ru)
#   3. direct: private, category-ru, the RU/BY zones, IP-check services (RU sites compare
#      them with what they see to spot a split tunnel), Faceit/Tarkov/Steam/Riot (ping,
#      anti-cheat, account region)
#   4. direct by IP: private, ru, by; everything else: VPN
# Geo data: Loyalsoldier's v2ray-rules-dat via jsDelivr (reachable from RU), updated daily.
# Russian names resolve through Yandex DoH; the rest through Cloudflare DoH inside the VPN.

mixed-port: 7890
mode: rule
log-level: warning
ipv6: false
unified-delay: true
tcp-concurrent: true
find-process-mode: 'off'
profile:
  store-selected: true
geodata-mode: true
geo-auto-update: true
geo-update-interval: 24
geox-url:
  geoip: https://cdn.jsdelivr.net/gh/Loyalsoldier/v2ray-rules-dat@release/geoip.dat
  geosite: https://cdn.jsdelivr.net/gh/Loyalsoldier/v2ray-rules-dat@release/geosite.dat
dns:
  default-nameserver:
  - 77.88.8.8
  direct-nameserver:
  - https://77.88.8.8/dns-query
  enable: true
  enhanced-mode: redir-host
  ipv6: false
  nameserver:
  - https://1.1.1.1/dns-query
  nameserver-policy:
    +.localhost,+.local,+.internal,+.svc,+.test,+.invalid,+.example: rcode://name_error
    ? +.ru,+.su,+.xn--p1ai,+.by,+.xn--90ais,+.xn--80adxhks,+.moscow,+.tatar,+.xn--p1acf,+.xn--d1acj3b,+.ifconfig.me,+.ipify.org,+.ip.sb,+.ipapi.is,+.iplocate.io,+.showip.net,+.checkip.amazonaws.com,+.api.sypexgeo.net
    : https://77.88.8.8/dns-query
    geosite:private,category-ru,faceit,escapefromtarkov,steam,riot: https://77.88.8.8/dns-query
  proxy-server-nameserver:
  - https://77.88.8.8/dns-query
  respect-rules: true
  use-hosts: true
  use-system-hosts: true
hosts:
  lkfl2.nalog.ru: 213.24.64.175
  lknpd.nalog.ru: 213.24.64.181
sniffer:
  enable: true
  force-dns-mapping: true
  override-destination: false
  parse-pure-ip: true
  skip-domain:
  - +.localhost
  - +.local
  - +.lan
  - +.home.arpa
  - +.internal
  skip-dst-address:
  - 127.0.0.0/8
  - 10.0.0.0/8
  - 172.16.0.0/12
  - 192.168.0.0/16
  - 169.254.0.0/16
  sniff:
    HTTP:
      ports:
      - 80
      - 8080-8880
    QUIC:
      ports:
      - 443
    TLS:
      ports:
      - 443
      - 8443
proxies:
- PROXY_CONFIGS
proxy-groups:
- name: VPN
  type: select
  proxies:
  - PROXY_LIST
rules:
- GEOSITE,category-public-tracker,REJECT
- DOMAIN-SUFFIX,doubleclick.net,REJECT
- DOMAIN-SUFFIX,googlesyndication.com,REJECT
- DOMAIN-SUFFIX,admob.com,REJECT
- DOMAIN-SUFFIX,2mdn.net,REJECT
- DOMAIN-SUFFIX,applovin.com,REJECT
- DOMAIN-SUFFIX,applvn.com,REJECT
- DOMAIN-SUFFIX,unityads.unity3d.com,REJECT
- DOMAIN-SUFFIX,ads.prd.ie.internal.unity3d.com,REJECT
- DOMAIN-SUFFIX,mediation.unity3d.com,REJECT
- DOMAIN-SUFFIX,prd.mz.internal.unity3d.com,REJECT
- DOMAIN-SUFFIX,supersonicads.com,REJECT
- DOMAIN-SUFFIX,ssacdn.com,REJECT
- DOMAIN-SUFFIX,ironsrc.mobi,REJECT
- DOMAIN-SUFFIX,mintegral.com,REJECT
- DOMAIN-SUFFIX,mintegral.net,REJECT
- DOMAIN-SUFFIX,rayjump.com,REJECT
- DOMAIN-SUFFIX,mtgglobals.com,REJECT
- DOMAIN-SUFFIX,vungle.com,REJECT
- DOMAIN-SUFFIX,liftoff.io,REJECT
- DOMAIN-SUFFIX,liftoff-creatives.io,REJECT
- DOMAIN-SUFFIX,pangle.io,REJECT
- DOMAIN-SUFFIX,pangleglobal.com,REJECT
- DOMAIN-SUFFIX,pangle-ads.com,REJECT
- DOMAIN-SUFFIX,pangle-b.io,REJECT
- DOMAIN-SUFFIX,tiktokpangle.us,REJECT
- DOMAIN-SUFFIX,tiktokpangle-cdn-us.com,REJECT
- DOMAIN,pangolin16.sgsnssdk.com,REJECT
- DOMAIN,pangolin16.isnssdk.com,REJECT
- DOMAIN-SUFFIX,pglstatp-toutiao.com,REJECT
- DOMAIN-SUFFIX,pangolin-sdk-toutiao.com,REJECT
- DOMAIN-SUFFIX,pangolin-sdk-toutiao-b.com,REJECT
- DOMAIN-SUFFIX,pangolin-sdk-toutiao1.com,REJECT
- DOMAIN-SUFFIX,adcolony.com,REJECT
- DOMAIN-SUFFIX,fyber.com,REJECT
- DOMAIN-SUFFIX,inner-active.mobi,REJECT
- DOMAIN-SUFFIX,chartboost.com,REJECT
- DOMAIN-SUFFIX,chartboosts.com,REJECT
- DOMAIN-SUFFIX,inmobi.com,REJECT
- DOMAIN-SUFFIX,inmobi.net,REJECT
- DOMAIN-SUFFIX,inmobicdn.net,REJECT
- DOMAIN-SUFFIX,moloco.com,REJECT
- DOMAIN-SUFFIX,adsmoloco.com,REJECT
- DOMAIN-SUFFIX,bidmachine.io,REJECT
- DOMAIN-SUFFIX,tapjoy.com,REJECT
- DOMAIN-SUFFIX,tapjoy.net,REJECT
- DOMAIN-SUFFIX,tapjoyads.com,REJECT
- DOMAIN-SUFFIX,smaato.net,REJECT
- DOMAIN-SUFFIX,smaato.com,REJECT
- DOMAIN-SUFFIX,startappservice.com,REJECT
- DOMAIN-SUFFIX,startappexchange.com,REJECT
- DOMAIN-SUFFIX,startappnetwork.com,REJECT
- DOMAIN-SUFFIX,appodeal.com,REJECT
- DOMAIN-SUFFIX,appodealx.com,REJECT
- DOMAIN-SUFFIX,pubnative.net,REJECT
- DOMAIN-SUFFIX,pubnative.info,REJECT
- DOMAIN-SUFFIX,vervewireless.com,REJECT
- DOMAIN-SUFFIX,hyprmx.com,REJECT
- DOMAIN-SUFFIX,mobilefuse.com,REJECT
- DOMAIN-SUFFIX,pubmatic.com,REJECT
- DOMAIN-SUFFIX,amazon-adsystem.com,REJECT
- DOMAIN-SUFFIX,ogury.co,REJECT
- DOMAIN-SUFFIX,ogury.com,REJECT
- DOMAIN-SUFFIX,ogury.io,REJECT
- DOMAIN-SUFFIX,presage.io,REJECT
- DOMAIN-SUFFIX,an.facebook.com,REJECT
- DOMAIN-SUFFIX,adsbigo.com,REJECT
- DOMAIN-SUFFIX,admost.com,REJECT
- DOMAIN-SUFFIX,toponadss.com,REJECT
- DOMAIN-SUFFIX,tradplusad.com,REJECT
- DOMAIN-SUFFIX,kidoz.net,REJECT
- DOMAIN-SUFFIX,superawesome.tv,REJECT
- DOMAIN-SUFFIX,adinmotech.com,REJECT
- DOMAIN-SUFFIX,anzu.io,REJECT
- DOMAIN-SUFFIX,gadsme.com,REJECT
- DOMAIN-SUFFIX,an.yandex.ru,REJECT
- DOMAIN-SUFFIX,yandexadexchange.net,REJECT
- DOMAIN,adsdk.yandex.ru,REJECT
- DOMAIN-SUFFIX,adfox.ru,REJECT
- DOMAIN-SUFFIX,adfox.yandex.ru,REJECT
- DOMAIN-SUFFIX,banners.mobile.yandex.net,REJECT
- DOMAIN,banners-slb.mobile.yandex.net,REJECT
- DOMAIN-SUFFIX,awaps.yandex.net,REJECT
- DOMAIN-SUFFIX,awaps.yandex.ru,REJECT
- DOMAIN,offerwall.yandex.net,REJECT
- DOMAIN-SUFFIX,ad.mail.ru,REJECT
- DOMAIN-SUFFIX,alt-ad.mail.ru,REJECT
- DOMAIN,an.mail.ru,REJECT
- DOMAIN-SUFFIX,mradx.net,REJECT
- DOMAIN,mediator.imgsmail.ru,REJECT
- DOMAIN,media-advcycle.imgsmail.ru,REJECT
- DOMAIN-SUFFIX,vk-ads.ru,REJECT
- DOMAIN,prod.html5-ads.vk-apps.com,REJECT
- RULE-SET,https://shadowrocket.ebac.dev/lists/ebac.list,VPN
- RULE-SET,https://shadowrocket.ebac.dev/lists/constructor.list,VPN
- GEOSITE,google-play,VPN
- GEOSITE,youtube,VPN
- DOMAIN-SUFFIX,ubs.com,VPN
- GEOSITE,google,VPN
- GEOSITE,microsoft,VPN
- GEOSITE,private,DIRECT
- GEOSITE,category-ru,DIRECT
- DOMAIN-SUFFIX,ru,DIRECT
- DOMAIN-SUFFIX,su,DIRECT
- DOMAIN-SUFFIX,xn--p1ai,DIRECT
- DOMAIN-SUFFIX,by,DIRECT
- DOMAIN-SUFFIX,xn--90ais,DIRECT
- DOMAIN-SUFFIX,xn--80adxhks,DIRECT
- DOMAIN-SUFFIX,moscow,DIRECT
- DOMAIN-SUFFIX,tatar,DIRECT
- DOMAIN-SUFFIX,xn--p1acf,DIRECT
- DOMAIN-SUFFIX,xn--d1acj3b,DIRECT
- DOMAIN-SUFFIX,ifconfig.me,DIRECT
- DOMAIN-SUFFIX,ipify.org,DIRECT
- DOMAIN-SUFFIX,ip.sb,DIRECT
- DOMAIN-SUFFIX,ipapi.is,DIRECT
- DOMAIN-SUFFIX,iplocate.io,DIRECT
- DOMAIN-SUFFIX,showip.net,DIRECT
- DOMAIN-SUFFIX,checkip.amazonaws.com,DIRECT
- DOMAIN-SUFFIX,api.sypexgeo.net,DIRECT
- GEOSITE,faceit,DIRECT
- GEOSITE,escapefromtarkov,DIRECT
- GEOSITE,steam,DIRECT
- GEOSITE,riot,DIRECT
- GEOIP,private,DIRECT
- GEOIP,ru,DIRECT
- GEOIP,by,DIRECT
- MATCH,VPN
