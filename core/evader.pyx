# core/evader.pyx
# Advanced WAF and bot detection evader - Enterprise Grade
# MADE BY XSPEEN

import random
import time
import requests
import platform
import urllib3
from fake_useragent import UserAgent

# Disable SSL warnings globally
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

# Simple response class for error handling
class EmptyResponse:
    __slots__ = ['status_code', 'text', 'content', 'headers', 'cookies', 'url', 'reason']
    def __init__(self, status_code):
        self.status_code = status_code
        self.text = ""
        self.content = b""
        self.headers = {}
        self.cookies = {}
        self.url = ""
        self.reason = ""

cdef class EvaderEngine:
    cdef list user_agents
    cdef list proxies
    cdef int request_count
    cdef str os_type
    cdef object session
    cdef list proxy_list
    cdef int use_proxy
    
    def __cinit__(self):
        self.request_count = 0
        self.os_type = platform.system().lower()
        self.use_proxy = 0
        self.proxy_list = []
        
        # 50+ real user agents
        self.user_agents = [
            # Chrome Windows
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 Chrome/120.0.0.0 Safari/537.36',
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 Chrome/121.0.0.0 Safari/537.36',
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 Chrome/122.0.0.0 Safari/537.36',
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 Chrome/123.0.0.0 Safari/537.36',
            # Firefox Windows
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:109.0) Gecko/20100101 Firefox/121.0',
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:109.0) Gecko/20100101 Firefox/122.0',
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:109.0) Gecko/20100101 Firefox/123.0',
            # Edge Windows
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 Edge/120.0.2210.77 Safari/537.36',
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 Edge/121.0.2277.83 Safari/537.36',
            # Chrome macOS
            'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 Chrome/120.0.0.0 Safari/537.36',
            'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 Chrome/121.0.0.0 Safari/537.36',
            'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 Chrome/122.0.0.0 Safari/537.36',
            # Safari macOS
            'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 Version/17.1 Safari/605.1.15',
            'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 Version/17.2 Safari/605.1.15',
            # Firefox macOS
            'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15; rv:109.0) Gecko/20100101 Firefox/121.0',
            'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15; rv:109.0) Gecko/20100101 Firefox/122.0',
            # Chrome Linux
            'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/120.0.0.0 Safari/537.36',
            'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/121.0.0.0 Safari/537.36',
            'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 Chrome/122.0.0.0 Safari/537.36',
            # Firefox Linux
            'Mozilla/5.0 (X11; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/121.0',
            'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/121.0',
            # iPhone
            'Mozilla/5.0 (iPhone; CPU iPhone OS 17_1 like Mac OS X) AppleWebKit/605.1.15 Version/17.1 Mobile/15E148 Safari/604.1',
            'Mozilla/5.0 (iPhone; CPU iPhone OS 17_2 like Mac OS X) AppleWebKit/605.1.15 Version/17.2 Mobile/15E148 Safari/604.1',
            # iPad
            'Mozilla/5.0 (iPad; CPU OS 17_1 like Mac OS X) AppleWebKit/605.1.15 Version/17.1 Mobile/15E148 Safari/604.1',
            # Android
            'Mozilla/5.0 (Linux; Android 13; SM-S908B) AppleWebKit/537.36 Chrome/120.0.0.0 Mobile Safari/537.36',
            'Mozilla/5.0 (Linux; Android 14; Pixel 8) AppleWebKit/537.36 Chrome/120.0.0.0 Mobile Safari/537.36',
            'Mozilla/5.0 (Linux; Android 13; SM-G998B) AppleWebKit/537.36 Chrome/120.0.0.0 Mobile Safari/537.36',
        ]
        
        self._init_session()
    
    cdef void _init_session(self):
        self.session = requests.Session()
        self.session.verify = False
        self.session.trust_env = False
    
    cpdef void set_proxies(self, list proxies):
        self.proxy_list = proxies
        self.use_proxy = 1
    
    cpdef dict get_headers(self):
        self.request_count += 1
        
        # Generate random IP for spoofing
        random_ip = f"{random.randint(1,255)}.{random.randint(1,255)}.{random.randint(1,255)}.{random.randint(1,255)}"
        
        # Random accept language
        languages = ['en-US,en;q=0.9', 'en-GB,en;q=0.8', 'en-US,en;q=0.7', 'fr-FR,fr;q=0.8', 'de-DE,de;q=0.8']
        
        return {
            'User-Agent': random.choice(self.user_agents),
            'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8',
            'Accept-Language': random.choice(languages),
            'Accept-Encoding': 'gzip, deflate, br',
            'DNT': str(random.randint(0, 1)),
            'Connection': 'keep-alive',
            'Upgrade-Insecure-Requests': '1',
            'Sec-Fetch-Dest': 'document',
            'Sec-Fetch-Mode': 'navigate',
            'Sec-Fetch-Site': 'none',
            'Sec-Fetch-User': '?1',
            'Sec-Ch-Ua': f'"Not_A Brand";v="8", "Chromium";v="{random.randint(120,123)}", "Google Chrome";v="{random.randint(120,123)}"',
            'Sec-Ch-Ua-Mobile': '?0',
            'Sec-Ch-Ua-Platform': f'"{random.choice(["Windows", "macOS", "Linux"])}"',
            'Cache-Control': 'max-age=0',
            'X-Forwarded-For': random_ip,
            'X-Real-IP': random_ip,
            'X-Originating-IP': random_ip,
            'X-Remote-IP': random_ip,
            'X-Remote-Addr': random_ip,
            'X-Client-IP': random_ip,
            'True-Client-IP': random_ip,
        }
    
    cpdef object get(self, str url, timeout=15, headers=None, allow_redirects=False, max_retries=2):
        # Random delay to avoid rate limiting
        time.sleep(random.uniform(1.0, 3.5))
        
        req_headers = self.get_headers()
        if headers is not None:
            for key, value in headers.items():
                req_headers[key] = value
        
        retry_count = 0
        while retry_count <= max_retries:
            try:
                # Rotate proxy if enabled
                if self.use_proxy and self.proxy_list:
                    proxy = random.choice(self.proxy_list)
                    self.session.proxies = {'http': proxy, 'https': proxy}
                
                response = self.session.get(
                    url, 
                    headers=req_headers, 
                    timeout=timeout, 
                    allow_redirects=allow_redirects,
                    verify=False
                )
                return response
                
            except requests.exceptions.Timeout:
                retry_count += 1
                if retry_count > max_retries:
                    return EmptyResponse(408)
                time.sleep(2)
                
            except requests.exceptions.ConnectionError:
                retry_count += 1
                if retry_count > max_retries:
                    return EmptyResponse(503)
                time.sleep(3)
                
            except Exception:
                retry_count += 1
                if retry_count > max_retries:
                    return EmptyResponse(500)
                time.sleep(2)
        
        return EmptyResponse(500)
    
    cpdef object post(self, str url, data=None, timeout=15, headers=None, max_retries=2):
        time.sleep(random.uniform(1.0, 3.5))
        
        req_headers = self.get_headers()
        if headers is not None:
            for key, value in headers.items():
                req_headers[key] = value
        
        retry_count = 0
        while retry_count <= max_retries:
            try:
                if self.use_proxy and self.proxy_list:
                    proxy = random.choice(self.proxy_list)
                    self.session.proxies = {'http': proxy, 'https': proxy}
                
                if data:
                    response = self.session.post(url, data=data, headers=req_headers, timeout=timeout, verify=False)
                else:
                    response = self.session.post(url, headers=req_headers, timeout=timeout, verify=False)
                return response
                
            except requests.exceptions.Timeout:
                retry_count += 1
                if retry_count > max_retries:
                    return EmptyResponse(408)
                time.sleep(2)
            except Exception:
                retry_count += 1
                if retry_count > max_retries:
                    return EmptyResponse(500)
                time.sleep(2)
        
        return EmptyResponse(500)
    
    cpdef object head(self, str url, timeout=10, headers=None):
        time.sleep(random.uniform(0.5, 1.5))
        
        req_headers = self.get_headers()
        if headers is not None:
            for key, value in headers.items():
                req_headers[key] = value
        
        try:
            return self.session.head(url, headers=req_headers, timeout=timeout, verify=False)
        except Exception:
            return EmptyResponse(500)
    
    cpdef object options(self, str url, timeout=10, headers=None):
        time.sleep(random.uniform(0.5, 1.5))
        
        req_headers = self.get_headers()
        if headers is not None:
            for key, value in headers.items():
                req_headers[key] = value
        
        try:
            return self.session.options(url, headers=req_headers, timeout=timeout, verify=False)
        except Exception:
            return EmptyResponse(500)
    
    cpdef int get_count(self):
        return self.request_count
    
    cpdef void reset_count(self):
        self.request_count = 0
    
    cpdef void rotate_session(self):
        self._init_session()
