# core/port_scanner.pyx
# Port scanner - scans all 65535 ports
# MADE BY XSPEEN

import socket
import time
from concurrent.futures import ThreadPoolExecutor, as_completed

cdef class PortScanner:
    cdef str target
    cdef list open_ports
    cdef dict service_map
    cdef int timeout
    cdef int max_threads
    
    def __cinit__(self):
        self.open_ports = []
        self.timeout = 1
        self.max_threads = 100
        self.service_map = {
            21: 'FTP', 22: 'SSH', 23: 'Telnet', 25: 'SMTP', 53: 'DNS',
            80: 'HTTP', 110: 'POP3', 111: 'RPC', 135: 'RPC', 139: 'NetBIOS',
            143: 'IMAP', 443: 'HTTPS', 445: 'SMB', 993: 'IMAPS', 995: 'POP3S',
            1433: 'MSSQL', 3306: 'MySQL', 3389: 'RDP', 5432: 'PostgreSQL',
            5900: 'VNC', 6379: 'Redis', 8080: 'HTTP-Alt', 8443: 'HTTPS-Alt',
            27017: 'MongoDB', 9200: 'Elasticsearch', 11211: 'Memcached', 22: 'SSH',
            25: 'SMTP', 53: 'DNS', 80: 'HTTP', 110: 'POP3', 111: 'RPC',
            135: 'RPC', 139: 'NetBIOS', 143: 'IMAP', 443: 'HTTPS', 445: 'SMB'
        }
    
    cpdef list scan(self, str target, bint full=False):
        """Scan ports on target"""
        self.target = target
        self.open_ports = []
        
        print(f"[+] Port scanning: {target}")
        
        if full:
            ports = range(1, 65536)
            print(f"[+] Full scan: 1-65535 ports")
        else:
            ports = list(self.service_map.keys())
            ports = sorted(set(ports))
            print(f"[+] Common ports: {len(ports)} ports")
        
        start = time.time()
        
        with ThreadPoolExecutor(max_workers=self.max_threads) as executor:
            futures = {executor.submit(self._scan_port, port): port for port in ports}
            for future in as_completed(futures):
                port, is_open, service = future.result()
                if is_open:
                    self.open_ports.append({'port': port, 'service': service})
                    print(f"  [+] Port {port} OPEN - {service}")
        
        elapsed = time.time() - start
        print(f"[+] Scan complete in {elapsed:.2f}s. Found {len(self.open_ports)} open ports.")
        return self.open_ports
    
    cdef tuple _scan_port(self, int port):
        """Scan single port"""
        service = self.service_map.get(port, 'Unknown')
        try:
            sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            sock.settimeout(self.timeout)
            result = sock.connect_ex((self.target, port))
            sock.close()
            return (port, result == 0, service)
        except:
            return (port, False, service)
    
    cpdef dict get_results(self):
        return {
            'target': self.target,
            'open_ports': self.open_ports,
            'total': len(self.open_ports)
        }
