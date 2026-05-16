# EnvKiller API Documentation

## Core Modules

### SecretScanner

```python
from core.scanner import SecretScanner

scanner = SecretScanner()
findings = scanner.scan_text("text to scan", "source.txt")
findings = scanner.scan_file("/path/to/file.env")
findings = scanner.scan_directory("/path/to/dir")
```

PortScanner

```python
from core.port_scanner import PortScanner

ps = PortScanner()
open_ports = ps.scan("192.168.1.1", full=False)  # full=True for 1-65535
```

SubdomainFinder

```python
from core.subdomain import SubdomainFinder

sf = SubdomainFinder()
subdomains = sf.find("example.com")
```

DirBruteForcer

```python
from core.dir_brute import DirBruteForcer

dbf = DirBruteForcer()
found = dbf.brute("https://example.com")
```

BypassEngine

```python
from core.bypass import BypassEngine

be = BypassEngine()
response = be.get("https://example.com")
```

Output Format

```json
{
  "target": "https://example.com",
  "scan_id": 1234567890,
  "findings": [
    {
      "type": "AWS_ACCESS_KEY",
      "value": "AKIAIOSFODNN7EXAMPLE",
      "source": "config.env",
      "severity": "CRITICAL"
    }
  ]
}
