# core/worm.pyx
# Worm crawler - recursive link following
# MADE BY XSPEEN

import requests
import re
from urllib.parse import urljoin, urlparse
from collections import deque
from concurrent.futures import ThreadPoolExecutor

cdef class WormCrawler:
    cdef str start_url
    cdef set visited
    cdef list results
    cdef object session
    cdef int max_depth
    cdef int max_pages
    
    def __cinit__(self):
        self.visited = set()
        self.results = []
        self.max_depth = 3
        self.max_pages = 100
        self.session = requests.Session()
        self.session.headers.update({
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
        })
    
    cpdef list crawl(self, str url):
        self.start_url = url
        self.visited = set()
        self.results = []
        
        print(f"[+] Worm crawling: {url}")
        print(f"[+] Max depth: {self.max_depth}, Max pages: {self.max_pages}")
        
        queue = deque([(url, 0)])
        
        while queue and len(self.visited) < self.max_pages:
            current_url, depth = queue.popleft()
            if current_url in self.visited or depth > self.max_depth:
                continue
            
            result, new_links = self._crawl_page(current_url, depth)
            if result:
                self.results.append(result)
                for link in new_links[:20]:
                    if link not in self.visited and urlparse(link).netloc == urlparse(self.start_url).netloc:
                        queue.append((link, depth + 1))
        
        print(f"[+] Crawl complete. Visited {len(self.visited)} pages")
        return self.results
    
    cdef tuple _crawl_page(self, str url, int depth):
        if url in self.visited:
            return None, []
        
        self.visited.add(url)
        
        try:
            response = self.session.get(url, timeout=10)
            if response.status_code == 200:
                links = re.findall(r'href=["\'](https?://[^"\']+)["\']', response.text)
                links = list(set(links))
                
                result = {
                    'url': url,
                    'depth': depth,
                    'status': response.status_code,
                    'size': len(response.content),
                    'links_count': len(links)
                }
                print(f"  [+] [{depth}] {url} ({len(response.content)} bytes)")
                return result, links
        except Exception:
            pass
        
        return None, []
    
    cpdef list get_results(self):
        return self.results
