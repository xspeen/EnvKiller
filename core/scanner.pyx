# core/scanner.pyx
# Secret scanning engine
# MADE BY XSPEEN

import re
import os
from colorama import Fore, Style

cdef class SecretScanner:
    cdef list findings
    cdef dict patterns
    
    def __cinit__(self):
        self.findings = []
        self.patterns = {
            'AWS_ACCESS_KEY': r'AKIA[0-9A-Z]{16}',
            'AWS_SECRET_KEY': r'(?i)aws_secret_access_key\s*=\s*["\']?([A-Za-z0-9/+=]{40})',
            'GITHUB_TOKEN': r'gh[pous]_[0-9A-Za-z]{36}',
            'GITHUB_APP': r'(ghu|ghr)_[0-9A-Za-z]{36}',
            'OPENAI_KEY': r'sk-[0-9A-Za-z]{48}',
            'STRIPE_LIVE': r'sk_live_[0-9A-Za-z]{24}',
            'STRIPE_TEST': r'sk_test_[0-9A-Za-z]{24}',
            'GOOGLE_API': r'AIza[0-9A-Z]{35}',
            'SLACK_TOKEN': r'xox[baprs]-[0-9A-Za-z]{10,48}',
            'DISCORD_TOKEN': r'[MNO][a-zA-Z\d_-]{23,25}\.[a-zA-Z\d_-]{6}\.[a-zA-Z\d_-]{27}',
            'TWILIO': r'SK[0-9a-fA-F]{32}',
            'SENDGRID': r'SG\.[0-9A-Za-z]{22}',
            'MAILGUN': r'key-[0-9a-zA-Z]{32}',
            'PAYPAL_LIVE': r'live_[A-Za-z0-9]{33}',
            'PAYPAL_SANDBOX': r'sb_[A-Za-z0-9]{33}',
            'JWT': r'eyJ[a-zA-Z0-9_-]*\.eyJ[a-zA-Z0-9_-]*\.[a-zA-Z0-9_-]*',
            'DATABASE_URL': r'(?i)(mongodb|mysql|postgresql|redis)://[^/\s]+:[^@\s]+@',
            'RSA_PRIVATE': r'-----BEGIN RSA PRIVATE KEY-----',
            'SSH_PRIVATE': r'-----BEGIN OPENSSH PRIVATE KEY-----',
            'API_KEY_GENERIC': r'(?i)(api_key|apikey|secret|token)\s*[:=]\s*["\']?([0-9a-zA-Z]{20,45})',
            'PASSWORD': r'(?i)(password|pass|pwd)\s*[:=]\s*["\']?([^"\'\s]{8,})',
            'EMAIL': r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}',
            'IP_ADDRESS': r'\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}',
            'PHONE_NUMBER': r'\+?\d{1,3}[-.\s]?\(?\d{1,4}\)?[-.\s]?\d{1,4}[-.\s]?\d{1,9}',
            'JWT_SECRET': r'(?i)jwt_secret\s*=\s*["\']([A-Za-z0-9]{32,})',
            'SALT': r'(?i)salt\s*=\s*["\']([A-Za-z0-9]{16,})',
            'ENCRYPTION_KEY': r'(?i)encryption_key\s*=\s*["\']([A-Za-z0-9]{32,})'
        }
    
    cpdef list scan_text(self, str text, str source):
        """Scan text for secrets"""
        self.findings = []
        for name, pattern in self.patterns.items():
            matches = re.findall(pattern, text)
            for match in matches:
                if isinstance(match, tuple):
                    match = match[0] if match[0] else match[1]
                self.findings.append({
                    'type': name,
                    'value': match[:40] + '...' if len(match) > 40 else match,
                    'source': source,
                    'severity': 'CRITICAL' if name in ['AWS_ACCESS_KEY', 'AWS_SECRET_KEY', 'GITHUB_TOKEN', 'OPENAI_KEY', 'STRIPE_LIVE'] else 'HIGH'
                })
                print(f"  {Fore.RED}[!] {name}: {match[:30]}...{Style.RESET_ALL}")
        return self.findings
    
    cpdef list scan_file(self, str filepath):
        """Scan a single file for secrets"""
        try:
            with open(filepath, 'r', encoding='utf-8', errors='ignore') as f:
                content = f.read()
            return self.scan_text(content, filepath)
        except Exception:
            return []
    
    cpdef list scan_directory(self, str path):
        """Scan all files in directory recursively"""
        all_findings = []
        for root, dirs, files in os.walk(path):
            for file in files:
                ext = os.path.splitext(file)[1].lower()
                if ext in ['.txt', '.env', '.json', '.yaml', '.yml', '.py', '.js', '.ts', '.java', '.go', '.php', '.xml', '.conf', '.config', '.ini', '.log', '.sql']:
                    full_path = os.path.join(root, file)
                    findings = self.scan_file(full_path)
                    all_findings.extend(findings)
        return all_findings
    
    cpdef dict get_results(self):
        return {
            'total_findings': len(self.findings),
            'findings': self.findings
        }
