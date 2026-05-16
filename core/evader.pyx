# core/evader.pyx
# WAF and bot detection evader - Cross-platform compatible
# MADE BY XSPEEN

import random
import time
import requests

cdef class EvaderEngine:
    cdef list user_agents
    cdef int request_count
    
    def __cinit__(self):
        self.request_count = 0
        
        self.user_agents = [
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 Chrome/120.0.0.0',
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 Chrome/121.0.0.0',
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:109.0) Gecko/20100101 Firefox/121.0',
            'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 Chrome/120.0.0.0',
            'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 Version/17.1 Safari/605.1.15',
            'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/120.0.0.0',
            'Mozilla/5.0 (X11; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/121.0',
            'Mozilla/5.0 (iPhone; CPU iPhone OS 17_1 like Mac OS X) AppleWebKit/605.1.15',
            'Mozilla/5.0 (iPad; CPU OS 17_1 like Mac OS X) AppleWebKit/605.1.15',
            'Mozilla/5.0 (Linux; Android 13; SM-S908B) AppleWebKit/537.36 Chrome/120.0.0.0',
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:109.0) Gecko/20100101 Firefox/120.0',
            'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 Chrome/119.0.0.0',
            'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/119.0.0.0',
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 Edge/120.0.2210.77',
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 Edge/119.0.2151.97',
            'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 Chrome/120.0.0.0 Safari/537.36',
            'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/121.0',
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 Chrome/118.0.5993.88',
        ]
    
    cpdef dict get_headers(self):
        """Get randomized headers for bot evasion"""
        self.request_count += 1
        
        cdef str random_ip = f"{random.randint(1,255)}.{random.randint(1,255)}.{random.randint(1,255)}.{random.randint(1,255)}"
        
        return {
            'User-Agent': random.choice(self.user_agents),
            'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
            'Accept-Language': 'en-US,en;q=0.5',
            'Accept-Encoding': 'gzip, deflate, br',
            'DNT': '1',
            'Connection': 'keep-alive',
            'Upgrade-Insecure-Requests': '1',
            'Sec-Fetch-Dest': 'document',
            'Sec-Fetch-Mode': 'navigate',
            'Sec-Fetch-Site': 'none',
            'Sec-Fetch-User': '?1',
            'Cache-Control': 'max-age=0',
            'X-Forwarded-For': random_ip,
            'X-Real-IP': random_ip,
            'X-Originating-IP': random_ip,
            'X-Remote-IP': random_ip,
            'X-Remote-Addr': random_ip,
        }
    
    cpdef object get(self, str url, dict kwargs=None):
        """Make GET request with evasion techniques"""
        if kwargs is None:
            kwargs = {}
        
        time.sleep(random.uniform(0.5, 3.0))
        
        cdef dict headers = self.get_headers()
        if 'headers' in kwargs:
            headers.update(kwargs['headers'])
        kwargs['headers'] = headers
        
        if 'timeout' not in kwargs:
            kwargs['timeout'] = 15
        
        try:
            return requests.get(url, **kwargs)
        except requests.exceptions.Timeout:
            return type('Response', (), {'status_code': 408, 'text': '', 'content': b''})()
        except requests.exceptions.ConnectionError:
            return type('Response', (), {'status_code': 503, 'text': '', 'content': b''})()
        except Exception:
            return type('Response', (), {'status_code': 500, 'text': '', 'content': b''})()
    
    cpdef object post(self, str url, dict data=None, dict kwargs=None):
        """Make POST request with evasion techniques"""
        if kwargs is None:
            kwargs = {}
        
        time.sleep(random.uniform(0.5, 3.0))
        
        cdef dict headers = self.get_headers()
        if 'headers' in kwargs:
            headers.update(kwargs['headers'])
        kwargs['headers'] = headers
        
        if 'timeout' not in kwargs:
            kwargs['timeout'] = 15
        
        try:
            if data:
                return requests.post(url, data=data, **kwargs)
            else:
                return requests.post(url, **kwargs)
        except Exception:
            return type('Response', (), {'status_code': 500, 'text': '', 'content': b''})()
    
    cpdef int get_count(self):
        """Return total request count"""
        return self.request_count
    
    cpdef void reset_count(self):
        """Reset request counter"""
        self.request_count = 0
