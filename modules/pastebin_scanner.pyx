# modules/pastebin_scanner.pyx
# Pastebin scanner
# MADE BY XSPEEN

import requests
from core.scanner import SecretScanner

cdef class PastebinScanner:
    cdef object scanner
    
    def __cinit__(self):
        self.scanner = SecretScanner()
    
    cpdef dict scan(self, str url):
        """Scan Pastebin URL"""
        paste_id = url.split('/')[-1]
        raw_url = f"https://pastebin.com/raw/{paste_id}"
        
        print(f"[+] Fetching paste: {raw_url}")
        
        try:
            r = requests.get(raw_url, timeout=10)
            if r.status_code == 200:
                findings = self.scanner.scan_text(r.text, url)
                return {
                    'target': url,
                    'content_size': len(r.text),
                    'findings': findings,
                    'total': len(findings)
                }
            else:
                return {'error': f'HTTP {r.status_code}', 'findings': []}
        except Exception as e:
            return {'error': str(e), 'findings': []}
