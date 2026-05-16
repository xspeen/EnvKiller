# core/portscanner.pyx
# Port scanner - scans common ports
# MADE BY XSPEEN

import socket
import time
from concurrent.futures import ThreadPoolExecutor

cdef class PortScanner:
    cdef str target
    cdef list open_ports
    cdef dict service_map
    cdef int timeout
    
    def __cinit__(self):
        self.open_ports = []
        self.timeout = 1
        self.service_map = {
            21: 'FTP', 22: 'SSH', 23: 'Telnet', 25: 'SMTP', 53: 'DNS',
            80: 'HTTP', 110: 'POP3', 111: 'RPC', 135: 'RPC', 139: 'NetBIOS',
            143: 'IMAP', 443: 'HTTPS', 445: 'SMB', 993: 'IMAPS', 995: 'POP3S',
            1433: 'MSSQL', 3306: 'MySQL', 3389: 'RDP', 5432: 'PostgreSQL',
            5900: 'VNC', 6379: 'Redis', 8080: 'HTTP-Alt', 8443: 'HTTPS-Alt',
            27017: 'MongoDB', 9200: 'Elasticsearch'
        }
    
    cpdef list scan(self, str target, bint full=False):
        self.target = target
        self.open_ports = []
        
        print(f"[+] Port scanning: {target}")
        
        ports = list(self.service_map.keys()) if not full else range(1, 1025)
        ports = sorted(set(ports))
        
        with ThreadPoolExecutor(max_workers=50) as executor:
            futures = [executor.submit(self._scan_port, port) for port in ports]
            for future in futures:
                port, is_open, service = future.result()
                if is_open:
                    self.open_ports.append({'port': port, 'service': service})
                    print(f"  [+] Port {port} OPEN - {service}")
        
        return self.open_ports
    
    cdef tuple _scan_port(self, int port):
        service = self.service_map.get(port, 'Unknown')
        try:
            sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            sock.settimeout(self.timeout)
            result = sock.connect_ex((self.target, port))
            sock.close()
            return (port, result == 0, service)
        except:
            return (port, False, service)
