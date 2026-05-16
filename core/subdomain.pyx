# core/subdomain.pyx
# Subdomain discovery
# MADE BY XSPEEN

import socket
import dns.resolver
from concurrent.futures import ThreadPoolExecutor, as_completed

cdef class SubdomainFinder:
    cdef str domain
    cdef list found
    cdef list wordlist
    
    def __cinit__(self):
        self.found = []
        self.wordlist = [
            'www', 'mail', 'ftp', 'localhost', 'webmail', 'smtp', 'pop', 'ns1',
            'ns2', 'cpanel', 'whm', 'autodiscover', 'autoconfig', 'm', 'imap',
            'test', 'ns', 'blog', 'pop3', 'dev', 'www2', 'admin', 'forum',
            'news', 'vpn', 'ns3', 'mail2', 'new', 'mysql', 'old', 'lists',
            'support', 'mobile', 'mx', 'static', 'docs', 'beta', 'shop',
            'sql', 'secure', 'demo', 'cp', 'calendar', 'wiki', 'web',
            'media', 'email', 'images', 'img', 'download', 'dns', 'stats',
            'dashboard', 'portal', 'manage', 'start', 'info', 'apps',
            'api', 'cdn', 'remote', 'server', 'stage', 'vps', 'monitor',
            'help', 'transfer', 'drive', 'host', 'internal', 'database',
            'backup', 'ldap', 'proxy', 'logs', 'store', 'billing', 'status'
        ]
    
    cpdef list find(self, str domain):
        """Find subdomains"""
        self.domain = domain
        self.found = []
        
        print(f"[+] Subdomain discovery: {domain}")
        print(f"[+] Wordlist: {len(self.wordlist)} entries")
        
        with ThreadPoolExecutor(max_workers=50) as executor:
            futures = {executor.submit(self._check_subdomain, sub): sub for sub in self.wordlist}
            for future in as_completed(futures):
                sub, ip = future.result()
                if ip:
                    self.found.append({'subdomain': sub, 'full': f"{sub}.{domain}", 'ip': ip})
                    print(f"  [+] Found: {sub}.{domain} -> {ip}")
        
        # Try DNS enumeration
        self._dns_enum()
        
        print(f"[+] Found {len(self.found)} subdomains")
        return self.found
    
    cdef tuple _check_subdomain(self, str sub):
        """Check if subdomain resolves"""
        full = f"{sub}.{self.domain}"
        try:
            ip = socket.gethostbyname(full)
            return (sub, ip)
        except:
            return (sub, None)
    
    cdef void _dns_enum(self):
        """DNS record enumeration"""
        record_types = ['NS', 'MX', 'TXT', 'SOA']
        for rtype in record_types:
            try:
                answers = dns.resolver.resolve(self.domain, rtype)
                for answer in answers:
                    self.found.append({'subdomain': rtype, 'full': str(answer), 'ip': None})
                    print(f"  [+] DNS {rtype}: {answer}")
            except:
                pass
    
    cpdef dict get_results(self):
        return {'domain': self.domain, 'subdomains': self.found, 'total': len(self.found)}
