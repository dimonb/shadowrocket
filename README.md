# Shadowrocket Configuration

A comprehensive Shadowrocket configuration repository with optimized proxy rules, domain lists, and server configurations for enhanced privacy and access control.

## 📋 Overview

This repository contains Shadowrocket configuration files designed to provide:
- **Smart routing** based on geographical location and service type
- **Ad blocking** and privacy protection
- **Optimized access** to various services and platforms
- **Country-specific** proxy configurations

## 🗂️ Project Structure

```
shadowrocket/
├── README.md                 # This file
├── CNAME                     # Custom domain configuration (e.g., shadowrocket.ebac.dev)
├── ru.conf                   # Main configuration (static rules)
├── ru2.conf                  # Alternative configuration using hosted RULE-SETs
├── contabo.conf.tpl          # Contabo server config template (copy → contabo.conf)
├── cloudflare-worker.js      # Optional Cloudflare Worker for rules hosting
└── lists/                    # Domain and service-specific lists (hosted)
    ├── ads.list             # Advertisement/analytics domains
    ├── apple-private.list   # Apple private relay and related
    ├── binance.list         # Binance-related domains
    ├── chatgpt.list         # ChatGPT/OpenAI domains
    ├── google.list          # Google services
    ├── meta.list            # Meta/Facebook services
    ├── rutracker.list       # RuTracker domains
    ├── telegram.list        # Telegram servers
    ├── tiktok.list          # TikTok domains
    ├── twitter.list         # Twitter/X domains
    ├── whatsapp.list        # WhatsApp domains
    └── zoom.list            # Zoom meeting domains
```

## ⚙️ Configuration Files

### Main Configurations

- **`ru.conf`** - Primary configuration with local inline rules
- **`ru2.conf`** - Alternative configuration that references hosted RULE-SETs
- **`contabo.conf.tpl`** - Template for Contabo servers (copy to `contabo.conf` and fill in)
- **`cloudflare-worker.js`** - Worker script to serve lists/configs via Cloudflare

### Key Features

#### Proxy Groups
- **proxy** - General proxy with automatic testing
- **il** - Israel-specific proxy group
- **br** - Brazil-specific proxy group  
- **us** - United States-specific proxy group

#### Smart Routing
- **Geographic routing** based on IP location
- **Service-specific** routing for social media and streaming
- **Local network** bypass for internal resources
- **Ad blocking** and privacy protection

## 🎯 Domain Lists

The `lists/` directory contains specialized domain lists for different services. These lists are also hosted for remote inclusion.

| List | Purpose | Description |
|------|---------|-------------|
| `ads.list` | Ad Blocking | Advertisement and tracking domains |
| `apple-private.list` | Apple | Apple Private Relay and related |
| `binance.list` | Crypto Trading | Binance exchange domains |
| `chatgpt.list` | AI Services | ChatGPT and OpenAI domains |
| `google.list` | Google Services | Google search, maps, and other services |
| `meta.list` | Social Media | Facebook, Instagram, and Meta services |
| `rutracker.list` | File Sharing | RuTracker torrent tracker |
| `telegram.list` | Messaging | Telegram servers and domains |
| `tiktok.list` | Social Media | TikTok and ByteDance services |
| `twitter.list` | Social Media | Twitter/X platform domains |
| `whatsapp.list` | Messaging | WhatsApp messaging service |
| `zoom.list` | Video Conferencing | Zoom meeting and webinar domains |

## 🌐 Hosted Endpoints

- **Lists base URL**: `https://s.dimonb.com/lists/`
  - Example: `https://s.dimonb.com/lists/ads.list`
  - Used in `ru2.conf` via `RULE-SET,https://s.dimonb.com/lists/<name>.list,...`
- **CNAME**: `shadowrocket.ebac.dev` (for custom hosting/config delivery)

## 🚀 Quick Start

1. **Clone the repository:**
   ```bash
   git clone https://github.com/yourusername/shadowrocket.git
   cd shadowrocket
   ```

2. **Choose your configuration:**
   - Inline rules (local file): use `ru.conf`
   - Hosted lists (remote RULE-SETs): use `ru2.conf`
   - Contabo servers: copy `contabo.conf.tpl` → `contabo.conf` and adjust values

3. **Import to Shadowrocket:**
   - Open Shadowrocket app
   - Go to Settings → Config
   - Import the chosen configuration file (or a URL if hosted)

4. **Customize domain lists:**
   - Modify files in `lists/` directory as needed
   - For hosted usage, deploy updated lists to your hosting (see below)

## 🔧 Configuration Details

### DNS Settings
- Primary: `1.1.1.1` (Cloudflare)
- Secondary: `1.0.0.1` (Cloudflare)
- Tertiary: `8.8.8.8` (Google)
- Fallback: System DNS

### Proxy Testing
- **Interval**: 600 seconds (10 minutes)
- **Tolerance**: 100ms
- **Timeout**: 5 seconds
- **Test URL**: `http://www.gstatic.com/generate_204`

### Geographic Rules
- **Russia**: Direct connection (in `ru.conf`)
- **China**: Direct connection  
- **Israel**: Israel proxy group
- **Brazil**: Brazil proxy group
- **Other countries**: General proxy

## 🛡️ Privacy Features

- **Ad blocking** for common advertising networks
- **Analytics blocking** (e.g., Yandex Metrica)
- **Social media** routing through proxies
- **Local network** protection

## ☁️ Hosting Notes

- Lists are referenced remotely in `ru2.conf` using `https://s.dimonb.com/lists/*.list`.
- You can self-host using a static site/CDN or the provided `cloudflare-worker.js`.
- If using a custom domain, set the CNAME (example provided in `CNAME`).

## 🔄 Updates

This configuration is regularly updated to:
- Add new service domains
- Update proxy server lists
- Improve routing rules
- Enhance privacy protection

## 📝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is open source. If you need a specific license, add a `LICENSE` file (e.g., MIT).

## ⚠️ Disclaimer

This configuration is provided for educational and personal use. Users are responsible for complying with local laws and regulations regarding internet usage and proxy services.

## 🔗 Links

- **Shadowrocket**: [Official App Store](https://apps.apple.com/app/shadowrocket/id932747118)
- **Documentation**: [Shadowrocket Wiki](https://github.com/Johnshall/Shadowrocket-ADBlock-Rules-Forever)
- **Issues**: [GitHub Issues](https://github.com/yourusername/shadowrocket/issues)

---

**Last updated**: 2025-08-28
