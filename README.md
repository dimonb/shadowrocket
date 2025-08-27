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
├── CNAME                     # Custom domain configuration
├── ru.conf                   # Main Russian configuration
├── ru2.conf                  # Alternative Russian configuration
├── contabo.conf              # Contabo server configuration
├── contabo2.conf             # Alternative Contabo configuration
├── test.js                   # Testing utilities
└── lists/                    # Domain and service-specific lists
    ├── ads.list             # Advertisement domains
    ├── binance.list         # Binance-related domains
    ├── chatgpt.list         # ChatGPT domains
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

- **`ru.conf`** - Primary configuration optimized for Russian users
- **`ru2.conf`** - Alternative configuration with different routing rules
- **`contabo.conf`** - Configuration optimized for Contabo servers
- **`contabo2.conf`** - Alternative Contabo server configuration

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

The `lists/` directory contains specialized domain lists for different services:

| List | Purpose | Description |
|------|---------|-------------|
| `ads.list` | Ad Blocking | Advertisement and tracking domains |
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

## 🚀 Quick Start

1. **Clone the repository:**
   ```bash
   git clone https://github.com/yourusername/shadowrocket.git
   cd shadowrocket
   ```

2. **Choose your configuration:**
   - For Russian users: Use `ru.conf` or `ru2.conf`
   - For Contabo servers: Use `contabo.conf` or `contabo2.conf`

3. **Import to Shadowrocket:**
   - Open Shadowrocket app
   - Go to Settings → Config
   - Import the chosen configuration file

4. **Customize domain lists:**
   - Modify files in `lists/` directory as needed
   - Update main configuration to reference custom lists

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
- **Russia**: Direct connection
- **China**: Direct connection  
- **Israel**: Israel proxy group
- **Brazil**: Brazil proxy group
- **Other countries**: General proxy

## 🛡️ Privacy Features

- **Ad blocking** for common advertising networks
- **Analytics blocking** (Yandex Metrica, Google Analytics)
- **Social media** routing through proxies
- **Local network** protection

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

This project is open source and available under the [MIT License](LICENSE).

## ⚠️ Disclaimer

This configuration is provided for educational and personal use. Users are responsible for complying with local laws and regulations regarding internet usage and proxy services.

## 🔗 Links

- **Shadowrocket**: [Official App Store](https://apps.apple.com/app/shadowrocket/id932747118)
- **Documentation**: [Shadowrocket Wiki](https://github.com/Johnshall/Shadowrocket-ADBlock-Rules-Forever)
- **Issues**: [GitHub Issues](https://github.com/yourusername/shadowrocket/issues)

---

**Last updated**: 2024-07-03
