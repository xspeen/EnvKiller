# modules/web_scanner.pyx
# Website scanner
# MADE BY XSPEEN

import requests
from core.scanner import SecretScanner
from core.worm import WormCrawler

cdef class WebScanner:
    cdef object scanner
    cdef object crawler
    
    def __cinit__(self):
        self.scanner = SecretScanner()
        self.crawler = WormCrawler()
    
    cpdef dict scan(self, str url):
        """Scan website"""
        print(f"[+] Scanning website: {url}")
        
        all_findings = []
        
        # Crawl first
        pages = self.crawler.crawl(url)
        
        # Scan each page
        for page in pages:
            try:
                r = requests.get(page['url'], timeout=10)
                findings = self.scanner.scan_text(r.text, page['url'])
                all_findings.extend(findings)
            except:
                pass
        
        return {
            'target': url,
            'pages_crawled': len(pages),
            'findings': all_findings,
            'total_findings': len(all_findings)
        }
