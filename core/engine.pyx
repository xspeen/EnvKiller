# core/engine.pyx
# Main orchestration engine
# MADE BY XSPEEN

import sys
import os
import time
import requests
from colorama import Fore, Style

cdef class EnvKillerEngine:
    cdef str target
    cdef list results
    cdef int scan_id
    cdef str output_dir
    
    def __cinit__(self):
        self.results = []
        self.scan_id = int(time.time())
        self.output_dir = f"output/scan_{self.scan_id}"
        os.makedirs(self.output_dir, exist_ok=True)
    
    cpdef start(self):
        print(f"\n{Fore.CYAN}[⚡] EnvKiller Engine v1.0 Loaded{Style.RESET_ALL}")
        
        self.target = input(f"\n{Fore.YELLOW}[?] Enter target: {Style.RESET_ALL}")
        
        if not self.target:
            print(f"{Fore.RED}[!] No target{Style.RESET_ALL}")
            return
        
        print(f"{Fore.GREEN}[+] Target: {self.target}{Style.RESET_ALL}")
        
        # Detect type
        if 'github.com' in self.target:
            self._scan_github()
        elif 'pastebin.com' in self.target:
            self._scan_pastebin()
        elif self.target.startswith(('http://', 'https://')):
            self._scan_website()
        else:
            self._scan_generic()
        
        self._save_report()
    
    cdef void _scan_github(self):
        print(f"{Fore.CYAN}[+] Scanning GitHub...{Style.RESET_ALL}")
        import subprocess
        clone_dir = f"{self.output_dir}/repo"
        subprocess.run(['git', 'clone', '--depth', '1', self.target, clone_dir])
        self._scan_directory(clone_dir)
    
    cdef void _scan_directory(self, str path):
        import os, re
        patterns = {
            'AWS_KEY': r'AKIA[0-9A-Z]{16}',
            'GITHUB_TOKEN': r'gh[pous]_[0-9A-Za-z]{36}',
            'OPENAI_KEY': r'sk-[0-9A-Za-z]{48}'
        }
        for root, dirs, files in os.walk(path):
            for file in files:
                if file.endswith(('.env', '.json', '.py', '.js', '.txt')):
                    try:
                        with open(os.path.join(root, file), 'r', errors='ignore') as f:
                            content = f.read()
                        for name, pattern in patterns.items():
                            matches = re.findall(pattern, content)
                            for match in matches:
                                self.results.append({'type': name, 'value': match[:30], 'file': file})
                                print(f"  {Fore.RED}[!] {name}: {match[:30]}{Style.RESET_ALL}")
                    except:
                        pass
    
    cdef void _scan_website(self):
        print(f"{Fore.CYAN}[+] Scanning website...{Style.RESET_ALL}")
        try:
            r = requests.get(self.target, timeout=10)
            print(f"{Fore.GREEN}[+] Status: {r.status_code}{Style.RESET_ALL}")
            # Basic secret check in HTML
            if 'AKIA' in r.text:
                self.results.append({'type': 'AWS_KEY', 'value': 'Found in HTML', 'file': self.target})
                print(f"  {Fore.RED}[!] Possible AWS key in HTML{Style.RESET_ALL}")
        except Exception as e:
            print(f"{Fore.YELLOW}[!] Error: {e}{Style.RESET_ALL}")
    
    cdef void _scan_pastebin(self):
        print(f"{Fore.CYAN}[+] Scanning Pastebin...{Style.RESET_ALL}")
        paste_id = self.target.split('/')[-1]
        raw_url = f"https://pastebin.com/raw/{paste_id}"
        try:
            r = requests.get(raw_url, timeout=10)
            if r.status_code == 200:
                print(f"{Fore.GREEN}[+] Content fetched{Style.RESET_ALL}")
                # Check for secrets
                if 'AKIA' in r.text:
                    self.results.append({'type': 'AWS_KEY', 'value': 'Found in paste', 'file': self.target})
                    print(f"  {Fore.RED}[!] Possible AWS key found{Style.RESET_ALL}")
        except Exception as e:
            print(f"{Fore.YELLOW}[!] Error: {e}{Style.RESET_ALL}")
    
    cdef void _scan_generic(self):
        print(f"{Fore.CYAN}[+] Generic scan...{Style.RESET_ALL}")
        if os.path.exists(self.target):
            self._scan_directory(self.target)
        else:
            print(f"{Fore.YELLOW}[!] Cannot scan target{Style.RESET_ALL}")
    
    cdef void _save_report(self):
        import json
        report_path = os.path.join(self.output_dir, 'report.json')
        with open(report_path, 'w') as f:
            json.dump({
                'target': self.target,
                'scan_id': self.scan_id,
                'findings': self.results
            }, f, indent=2)
        print(f"{Fore.GREEN}[+] Report saved: {report_path}{Style.RESET_ALL}")
