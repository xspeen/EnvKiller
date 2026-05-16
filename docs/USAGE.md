# EnvKiller Usage Guide

## Basic Usage

```bash
python3 envkiller.py
```

Then enter your target when prompted.

Supported Targets

Type Example
GitHub https://github.com/username/repo
GitLab https://gitlab.com/username/project
Pastebin https://pastebin.com/abc123
Website https://example.com
IP Address 192.168.1.1
Local file /path/to/file.env

Output

Results are saved to output/scan_[timestamp]/:

· report.json - JSON format
· report.html - HTML report
· findings.csv - CSV export

Example

```bash
$ python3 envkiller.py

[?] Enter target: https://github.com/facebook/react

[+] Target: https://github.com/facebook/react
[+] Scanning GitHub...
[+] Cloning repository...
[+] Scanning files...
  [!] AWS_ACCESS_KEY: AKIAIOSFODNN7EXAMPLE...
  [!] EMAIL: admin@facebook.com...

[+] Report saved: output/scan_1234567890/report.json
