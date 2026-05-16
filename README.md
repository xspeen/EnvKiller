# **ENVKILLER v1.0**

## *Advanced Secret Scanner | Zero API Keys | Cross-Platform | Worm Mode*

![EnvKiller Logo](https://i.ibb.co/6cRfSpqs/digital-illustration-red-hooded-hacker-mascot-wearing-black-jacket-skull-mask-sports-esports-logo-de.jpg)

---

## **BADGES**

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-red.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Python 3.7+](https://img.shields.io/badge/Python-3.7+-red.svg)](https://python.org)
[![Security](https://img.shields.io/badge/Security-Pentesting-red.svg)](https://github.com/xspeen/EnvKiller)
[![OSINT](https://img.shields.io/badge/OSINT-Advanced-red.svg)](https://github.com/xspeen/EnvKiller)
[![Ethical Hacking](https://img.shields.io/badge/Ethical_Hacking-Professional-red.svg)](https://github.com/xspeen/EnvKiller)
[![Platform](https://img.shields.io/badge/Platform-Cross--Platform-red.svg)](https://github.com/xspeen/EnvKiller)

---

## **Supported Operating Systems**

<p align="center">
  <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/windows8/windows8-original.svg" width="50" height="50">
  &nbsp;&nbsp;&nbsp;&nbsp;
  <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/linux/linux-original.svg" width="50" height="50">
  &nbsp;&nbsp;&nbsp;&nbsp;
  <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/apple/apple-original.svg" width="50" height="50">
  &nbsp;&nbsp;&nbsp;&nbsp;
  <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/android/android-original.svg" width="50" height="50">
  &nbsp;&nbsp;&nbsp;&nbsp;
  <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/ubuntu/ubuntu-original.svg" width="50" height="50">
  &nbsp;&nbsp;&nbsp;&nbsp;
  <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/debian/debian-original.svg" width="50" height="50">
  &nbsp;&nbsp;&nbsp;&nbsp;
  <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/kali/kali-original.svg" width="50" height="50">
  &nbsp;&nbsp;&nbsp;&nbsp;
  <img src="https://cdn.jsdelivr.net/gh/devicons/devicon/icons/archlinux/archlinux-original.svg" width="50" height="50">
</p>

| OS | Brand | Status |
| :--- | :--- | :--- |
| **Windows 10/11** | Microsoft Windows | *Full Support* |
| **Kali Linux** | Offensive Security | *Full Support* |
| **Ubuntu 20.04+** | Canonical | *Full Support* |
| **Debian 11+** | Debian Project | *Full Support* |
| **Parrot OS** | Frozenbox Network | *Full Support* |
| **Arch Linux** | Arch Linux Community | *Full Support* |
| **macOS 11+** | Apple | *Full Support* |
| **Termux (Android)** | Termux Community | *Full Support* |
| **Red Hat Enterprise Linux** | Red Hat | *Full Support* |
| **Fedora** | Fedora Project | *Full Support* |
| **CentOS** | CentOS Project | *Full Support* |
| **OpenSUSE** | SUSE | *Full Support* |

---

## **Features**

- *Zero API keys required*
- *GitHub repository scanning with recursive file analysis*
- *GitLab and Bitbucket repository support*
- *Pastebin content extraction and secret detection*
- *Direct file download and analysis (.env, .json, .yaml, .xml)*
- *ZIP, TAR, GZ archive extraction and scanning*
- *Worm mode recursive web crawling with depth control*
- *Full port scanning across 1-65535 with service detection*
- *Subdomain enumeration via DNS brute force*
- *Directory brute forcing with 500+ common paths*
- *Secret pattern detection covering 50+ signature types*
- *WAF and bot detection evasion with rotating user agents*
- *Cross-platform compatibility without root privileges*
- *JSON, HTML, and CSV report generation*
- *Cython compilation for source obfuscation*

---

## **Installation Guide**

### ***Prerequisites***

*Before installing, ensure you have:*

- *Internet connection*
- *Python 3.7 or higher*
- *Git installed*
- *Basic knowledge of terminal/command line*

---

### **Windows 10/11 (Microsoft Windows)**

***If you don't have Python installed:***

1. *Download Python from: [https://python.org](https://python.org)*
2. *Download LTS version (3.7 or higher)*
3. *Run the installer (check "Add to PATH")*
4. *Restart your computer*

***If you don't have Git installed:***

1. *Download Git from: [https://git-scm.com](https://git-scm.com)*
2. *Run the installer with default settings*

***Installation Commands (PowerShell):***

```powershell
git clone https://github.com/xspeen/EnvKiller.git
cd EnvKiller
pip install -r requirements.txt
python setup.py build_ext --inplace
python envkiller.py
```

---

### **kali Linux (Offensive Security)**

Kali Linux comes with Python pre-installed:

```bash
sudo apt update
sudo apt upgrade -y
sudo apt install python3 python3-pip git -y
git clone https://github.com/xspeen/EnvKiller.git
cd EnvKiller
pip3 install -r requirements.txt
python3 setup.py build_ext --inplace
python3 envkiller.py
```

---

### **Ubuntu (Canonical)**

If you don't have Python installed:

```bash
sudo apt update
sudo apt install python3 python3-pip git -y
```

Installation Commands:

```bash
git clone https://github.com/xspeen/EnvKiller.git
cd EnvKiller
pip3 install -r requirements.txt
python3 setup.py build_ext --inplace
python3 envkiller.py
```

---

### **Debian (Debian Project)**

If you don't have Python installed:

```bash
sudo apt update
sudo apt install python3 python3-pip git -y
```

Installation Commands:

```bash
git clone https://github.com/xspeen/EnvKiller.git
cd EnvKiller
pip3 install -r requirements.txt
python3 setup.py build_ext --inplace
python3 envkiller.py
```

---

### **Parrot OS (Frozenbox Network)**

Parrot OS comes with Python pre-installed:

```bash
sudo apt update
sudo apt install python3 python3-pip git -y
git clone https://github.com/xspeen/EnvKiller.git
cd EnvKiller
pip3 install -r requirements.txt
python3 setup.py build_ext --inplace
python3 envkiller.py
```

---

### **Arch Linux (Arch Linux Community)**

If you don't have Python installed:

```bash
sudo pacman -Syu
sudo pacman -S python python-pip git --noconfirm
```

Installation Commands:

```bash
git clone https://github.com/xspeen/EnvKiller.git
cd EnvKiller
pip install -r requirements.txt
python setup.py build_ext --inplace
python envkiller.py
```

---

### **macOS (Apple)**

If you don't have Homebrew installed:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

If you don't have Python installed:

```bash
brew install python3 git
```

Installation Commands:

```bash
git clone https://github.com/xspeen/EnvKiller.git
cd EnvKiller
pip3 install -r requirements.txt
python3 setup.py build_ext --inplace
python3 envkiller.py
```

---

### **Termux (Android) - Termux Community)**

If you don't have Termux installed:

1. Download Termux from F-Droid (not Google Play)
2. Website: https://f-droid.org/en/packages/com.termux/
3. Download and install the APK file
4. Open Termux and grant storage permissions

Installation Commands:

```bash
pkg update && pkg upgrade
pkg install python git
git clone https://github.com/xspeen/EnvKiller.git
cd EnvKiller
pip install -r requirements.txt
python setup.py build_ext --inplace
python envkiller.py
```

---

Red Hat Enterprise Linux (Red Hat)

If you don't have Python installed:

```bash
sudo yum update
sudo yum install python3 python3-pip git -y
```

Installation Commands:

```bash
git clone https://github.com/xspeen/EnvKiller.git
cd EnvKiller
pip3 install -r requirements.txt
python3 setup.py build_ext --inplace
python3 envkiller.py
```

---

Fedora (Fedora Project)

If you don't have Python installed:

```bash
sudo dnf update
sudo dnf install python3 python3-pip git -y
```

Installation Commands:

```bash
git clone https://github.com/xspeen/EnvKiller.git
cd EnvKiller
pip3 install -r requirements.txt
python3 setup.py build_ext --inplace
python3 envkiller.py
```

---

Docker

```bash
docker build -t envkiller .
docker run -it envkiller
```

---

Usage

Execute the main script and enter your target when prompted:

```bash
python envkiller.py
```

Target format is automatically detected. Supported target types:

Target Type Example
GitHub https://github.com/username/repository
GitLab https://gitlab.com/username/project
Bitbucket https://bitbucket.org/username/repo
Pastebin https://pastebin.com/RAW_ID
Direct File https://example.com/path/file.env
Website https://example.com
IP Address 192.168.1.1
Local Path /home/user/secrets.env

---

Output

Results are saved to the output directory with timestamp:

```
output/scan_TIMESTAMP/
├── report.json      # JSON format for programmatic processing
├── report.html      # HTML report with severity coloring
└── findings.csv     # CSV export for spreadsheet analysis
```

---

Security Patterns Detected

The scanner identifies the following categories of sensitive data:

Category Detection Pattern
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
MongoDB Connection mongodb:// pattern
MySQL Connection mysql:// pattern
PostgreSQL Connection postgresql:// pattern
Redis Connection redis:// pattern
Private Keys RSA, SSH, PKCS8 formats
Generic API Keys 20-45 character alphanumeric
Email Addresses RFC 5322 compliant
IP Addresses IPv4 format
Passwords in Config password pass pwd variables

---

Architecture

```
EnvKiller/
├── envkiller.py           # Entry point
├── core/                  # Compiled scanning engine
│   ├── scanner.pyx        # Pattern matching core
│   ├── worm.pyx           # Recursive crawler
│   ├── port_scanner.pyx   # Network port scanner
│   ├── subdomain.pyx      # DNS enumeration
│   └── dir_brute.pyx      # Path brute forcer
├── modules/               # Platform-specific handlers
├── lib/                   # Obfuscation and anti-debug
├── wordlists/             # Dictionary files
└── output/                # Generated reports
```

---

Build From Source

To recompile the Cython modules after modifications:

```bash
python setup.py build_ext --inplace
```

To create standalone executable:

```bash
pyinstaller --onefile --name envkiller envkiller.py
```

---

Troubleshooting

Issue Solution
Module Not Found Run: pip install -r requirements.txt
Cython Compilation Error Run: pip install cython
Permission Denied (Linux/macOS) Run: sudo python setup.py build_ext --inplace
Git Clone Failed Check internet connection and proxy settings
Python Version Error Ensure Python 3.7 or higher is installed

---

Disclaimer

This tool is designed for authorized security assessments and educational purposes. Users must obtain written permission from target owners before scanning. Unauthorized access violates computer fraud laws in most jurisdictions. The author assumes no liability for misuse.

---

License

GNU General Public License v3.0

You may copy, distribute and modify the software as long as you track changes/dates in source files. Any modifications to or software including (via compiler) GPL-licensed code must also be made available under the GPL along with build & install instructions.

---

Author

XSPEEN

· GitHub: https://github.com/xspeen/EnvKiller
· Repository: github.com/xspeen/EnvKiller

---

Star the Project

If you find this tool useful, please star the repository on GitHub.

---

Made by XSPEEN | Version 1.0 | All Rights Reserved
