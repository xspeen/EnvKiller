# ENVKILLER v1.0

Advanced Secret Scanner | Zero API Keys | Cross-Platform | Worm Mode

![EnvKiller Logo](https://i.ibb.co/6cRfSpqs/digital-illustration-red-hooded-hacker-mascot-wearing-black-jacket-skull-mask-sports-esports-logo-de.jpg)

---

## BADGES

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-red.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Python 3.7+](https://img.shields.io/badge/Python-3.7+-red.svg)](https://python.org)
[![Security](https://img.shields.io/badge/Security-Pentesting-red.svg)](https://github.com/xspeen/EnvKiller)
[![OSINT](https://img.shields.io/badge/OSINT-Advanced-red.svg)](https://github.com/xspeen/EnvKiller)
[![Ethical Hacking](https://img.shields.io/badge/Ethical_Hacking-Professional-red.svg)](https://github.com/xspeen/EnvKiller)
[![Platform](https://img.shields.io/badge/Platform-Cross--Platform-red.svg)](https://github.com/xspeen/EnvKiller)

---

## OPERATING SYSTEMS

| OS | Status |
|----|--------|
| ![Windows](https://img.shields.io/badge/Windows-10%2011-red.svg) | Full Support |
| ![Kali](https://img.shields.io/badge/Kali-Linux-red.svg) | Full Support |
| ![Ubuntu](https://img.shields.io/badge/Ubuntu-20.04%2B-red.svg) | Full Support |
| ![Debian](https://img.shields.io/badge/Debian-11%2B-red.svg) | Full Support |
| ![Parrot](https://img.shields.io/badge/Parrot-OS-red.svg) | Full Support |
| ![Arch](https://img.shields.io/badge/Arch-Linux-red.svg) | Full Support |
| ![macOS](https://img.shields.io/badge/macOS-11%2B-red.svg) | Full Support |
| ![Termux](https://img.shields.io/badge/Termux-Android-red.svg) | Full Support |

---

## FEATURES

- Zero API keys required
- GitHub repository scanning with recursive file analysis
- GitLab and Bitbucket repository support
- Pastebin content extraction and secret detection
- Direct file download and analysis (.env, .json, .yaml, .xml)
- ZIP, TAR, GZ archive extraction and scanning
- Worm mode recursive web crawling with depth control
- Full port scanning across 1-65535 with service detection
- Subdomain enumeration via DNS brute force
- Directory brute forcing with 500+ common paths
- Secret pattern detection covering 50+ signature types
- WAF and bot detection evasion with rotating user agents
- Cross-platform compatibility without root privileges
- JSON, HTML, and CSV report generation
- Cython compilation for source obfuscation

---

## INSTALLATION

### Windows PowerShell (Administrator not required)

```powershell
git clone https://github.com/xspeen/EnvKiller.git
cd EnvKiller
pip install -r requirements.txt
python setup.py build_ext --inplace
python envkiller.py
```

Windows Command Prompt

```cmd
git clone https://github.com/xspeen/EnvKiller.git
cd EnvKiller
pip install -r requirements.txt
python setup.py build_ext --inplace
python envkiller.py
```

Kali Linux / Ubuntu / Debian / Parrot OS

```bash
sudo apt update
sudo apt install python3 python3-pip git -y
git clone https://github.com/xspeen/EnvKiller.git
cd EnvKiller
pip3 install -r requirements.txt
python3 setup.py build_ext --inplace
python3 envkiller.py
```

Arch Linux / Manjaro

```bash
sudo pacman -S python python-pip git --noconfirm
git clone https://github.com/xspeen/EnvKiller.git
cd EnvKiller
pip install -r requirements.txt
python setup.py build_ext --inplace
python envkiller.py
```

macOS

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install python3 git
git clone https://github.com/xspeen/EnvKiller.git
cd EnvKiller
pip3 install -r requirements.txt
python3 setup.py build_ext --inplace
python3 envkiller.py
```

Termux (Android)

```bash
pkg update && pkg upgrade
pkg install python git
git clone https://github.com/xspeen/EnvKiller.git
cd EnvKiller
pip install -r requirements.txt
python setup.py build_ext --inplace
python envkiller.py
```

Docker

```bash
docker build -t envkiller .
docker run -it envkiller
```

---

USAGE

Execute the main script and enter your target when prompted:

```bash
python envkiller.py
```

Target format is automatically detected. Supported target types:

· GitHub: https://github.com/username/repository
· GitLab: https://gitlab.com/username/project
· Bitbucket: https://bitbucket.org/username/repo
· Pastebin: https://pastebin.com/RAW_ID
· Direct file: https://example.com/path/file.env
· Website: https://example.com
· IP address: 192.168.1.1
· Local path: /home/user/secrets.env

---

OUTPUT

Results are saved to the output directory with timestamp:

```
output/scan_TIMESTAMP/
├── report.json      # JSON format for programmatic processing
├── report.html      # HTML report with severity coloring
└── findings.csv     # CSV export for spreadsheet analysis
```

---

SECURITY PATTERNS DETECTED

The scanner identifies the following categories of sensitive data:

Category Detection Count
AWS Access Keys AKIA pattern
AWS Secret Keys 40-character base64
GitHub Tokens ghp_ gho_ ghu_ ghr_ ghs_ patterns
OpenAI API Keys sk- pattern
Stripe Live/Test Keys sk_live_ sk_test_
Google API Keys AIza pattern
Slack Tokens xoxb xoxp xoxa patterns
Discord Bot Tokens MTAx pattern
Twilio Credentials SK prefix
SendGrid API Keys SG. pattern
JWT Tokens eyJ header pattern
Database Connection Strings MongoDB, MySQL, PostgreSQL, Redis
Private Keys RSA, SSH, PKCS8 formats
Generic API Keys 20-45 character alphanumeric
Email Addresses RFC 5322 compliant
IP Addresses IPv4 format
Passwords in Configuration password pass pwd variables

---

ARCHITECTURE

```
EnvKiller/
├── envkiller.py           Entry point
├── core/                  Compiled scanning engine
│   ├── scanner.pyx        Pattern matching core
│   ├── worm.pyx           Recursive crawler
│   ├── port_scanner.pyx   Network port scanner
│   ├── subdomain.pyx      DNS enumeration
│   └── dir_brute.pyx      Path brute forcer
├── modules/               Platform-specific handlers
├── lib/                   Obfuscation and anti-debug
├── wordlists/             Dictionary files
└── output/                Generated reports
```

---

BUILD FROM SOURCE

To recompile the Cython modules after modifications:

```bash
python setup.py build_ext --inplace
```

To create standalone executable:

```bash
pyinstaller --onefile --name envkiller envkiller.py
```

---

DISCLAIMER

This tool is designed for authorized security assessments and educational purposes. Users must obtain written permission from target owners before scanning. Unauthorized access violates computer fraud laws in most jurisdictions. The author assumes no liability for misuse.

---

LICENSE

GNU General Public License v3.0

---

AUTHOR

XSPEEN

GitHub: https://github.com/xspeen/EnvKiller
