# core/worm.pyx
# Worm crawler - recursive link following
# MADE BY XSPEEN

import requests
import re
from urllib.parse import urljoin, urlparse
from collections import deque
from concurrent.futures import ThreadPoolExecutor, as_completed

cdef class WormCrawler:
    cdef str start_url
    cdef set visited
    cdef list results
    cdef object session
    cdef int max_depth
    cdef int max_pages
    cdef int max_threads
    
    def __cinit__(self):
        self.visited = set()
        self.results = []
        self.max_depth = 3
        self.max_pages = 100
        self.max_threads = 20
        self.session = requests.Session()
        self.session.headers.update({
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 Chrome/120.0.0.0'
        })
    
    cpdef list crawl(self, str url):
        """Start worm crawling"""
        self.start_url = url
        self.visited = set()
        self.results = []
        
        print(f"[+] Worm crawling: {url}")
        print(f"[+] Max depth: {self.max_depth}, Max pages: {self.max_pages}")
        
        queue = deque([(url, 0)])
        
        with ThreadPoolExecutor(max_workers=self.max_threads) as executor:
            futures = []
            while queue and len(self.visited) < self.max_pages:
                current_url, depth = queue.popleft()
                if current_url in self.visited or depth > self.max_depth:
                    continue
                
                future = executor.submit(self._crawl_page, current_url, depth)
                futures.append(future)
                
                # Process completed futures
                for f in as_completed(list(futures)[:10]):
                    result, new_links = f.result()
                    if result:
                        self.results.append(result)
                        for link in new_links[:20]:
                            if link not in self.visited and urlparse(link).netloc == urlparse(self.start_url).netloc:
                                queue.append((link, depth + 1))
                    futures.remove(f)
        
        print(f"[+] Crawl complete. Visited {len(self.visited)} pages, found {len(self.results)} with content")
        return self.results
    
    cdef tuple _crawl_page(self, str url, int depth):
        """Crawl single page and extract links"""
        if url in self.visited:
            return None, []
        
        self.visited.add(url)
        
        try:
            response = self.session.get(url, timeout=10)
            if response.status_code == 200:
                # Extract all links
                links = re.findall(r'href=["\'](https?://[^"\']+)["\']', response.text)
                links += re.findall(r'src=["\'](https?://[^"\']+)["\']', response.text)
                links = list(set(links))
                
                result = {
                    'url': url,
                    'depth': depth,
                    'status': response.status_code,
                    'size': len(response.content),
                    'title': self._extract_title(response.text),
                    'links_count': len(links)
                }
                print(f"  [+] [{depth}] {url} ({len(response.content)} bytes) - {len(links)} links")
                return result, links
        except Exception as e:
            return None, []
        
        return None, []
    
    cdef str _extract_title(self, str html):
        """Extract page title from HTML"""
        match = re.search(r'<title>(.*?)</title>', html, re.IGNORECASE)
        return match.group(1)[:50] if match else 'No title'
    
    cpdef list get_results(self):
        return self.results
