# core/dir_brute.pyx
# Directory brute forcer
# MADE BY XSPEEN

import requests
from urllib.parse import urljoin
from concurrent.futures import ThreadPoolExecutor, as_completed

cdef class DirBruteForcer:
    cdef str target
    cdef list found
    cdef list wordlist
    
    def __cinit__(self):
        self.found = []
        self.wordlist = [
            'admin', 'backup', 'wp-admin', 'login', 'dashboard', 'api', 'v1', 'v2',
            'assets', 'static', 'images', 'css', 'js', 'uploads', 'download', 'files',
            'config', 'conf', 'etc', 'include', 'includes', 'lib', 'src', 'temp',
            'tmp', 'logs', 'log', 'data', 'db', 'database', 'sql', 'phpmyadmin',
            'pma', 'adminer', 'cpanel', 'webmail', 'mail', 'ftp', 'backend',
            'app', 'system', 'core', 'modules', 'vendor', 'node_modules', 'dist',
            'build', 'public', 'private', 'secret', 'internal', 'dev', 'test',
            'demo', '.git', '.env', '.htaccess', 'robots.txt', 'sitemap.xml'
        ]
    
    cpdef list brute(self, str target):
        """Brute force directories"""
        self.target = target.rstrip('/')
        self.found = []
        
        print(f"[+] Directory brute force: {self.target}")
        print(f"[+] Wordlist: {len(self.wordlist)} entries")
        
        with ThreadPoolExecutor(max_workers=50) as executor:
            futures = {executor.submit(self._check_path, path): path for path in self.wordlist}
            for future in as_completed(futures):
                path, status, size = future.result()
                if status in [200, 301, 302, 403, 401]:
                    url = urljoin(self.target + '/', path)
                    self.found.append({'path': path, 'url': url, 'status': status, 'size': size})
                    color = '\033[92m' if status == 200 else '\033[93m'
                    print(f"  {color}[{status}] {url}\033[0m")
        
        print(f"[+] Found {len(self.found)} directories/files")
        return self.found
    
    cdef tuple _check_path(self, str path):
        """Check if path exists"""
        url = urljoin(self.target + '/', path)
        try:
            r = requests.get(url, timeout=5, allow_redirects=False)
            return (path, r.status_code, len(r.content))
        except:
            return (path, None, 0)
