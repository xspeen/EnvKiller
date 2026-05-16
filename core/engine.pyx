# core/engine.pyx
# Main orchestration engine
# MADE BY XSPEEN

import sys
import os
import re
import time
import json
import subprocess
import shutil
import requests
from urllib.parse import urlparse
from colorama import Fore, Style, init
from .scanner import SecretScanner
from .worm import WormCrawler
from .portscanner import PortScanner
from .subdomainfinder import SubdomainFinder
from .evader import EvaderEngine

init(autoreset=True)

cdef class EnvKillerEngine:
    cdef str target
    cdef list results
    cdef int scan_id
    cdef str output_dir
    cdef object scanner
    cdef object crawler
    cdef object port_scanner
    cdef object subdomain_finder
    cdef object evader
    
    def __cinit__(self):
        self.results = []
        self.scan_id = int(time.time())
        self.output_dir = f"output/scan_{self.scan_id}"
        os.makedirs(self.output_dir, exist_ok=True)
        self.scanner = SecretScanner()
        self.crawler = WormCrawler()
        self.port_scanner = PortScanner()
        self.subdomain_finder = SubdomainFinder()
        self.evader = EvaderEngine()
    
    cpdef start(self):
        """Main entry point for scanning"""
        print(f"\n{Fore.CYAN}[+] EnvKiller Engine v1.0 Loaded{Style.RESET_ALL}")
        
        self.target = input(f"\n{Fore.YELLOW}[?] Enter target (URL, domain, IP, GitHub link, file): {Style.RESET_ALL}")
        
        if not self.target:
            print(f"{Fore.RED}[!] No target provided.{Style.RESET_ALL}")
            return
        
        print(f"{Fore.GREEN}[+] Target: {self.target}{Style.RESET_ALL}")
        print(f"{Fore.CYAN}[+] Scan ID: {self.scan_id}{Style.RESET_ALL}")
        
        cdef str target_type = self._detect_target_type()
        print(f"{Fore.CYAN}[+] Target type: {target_type}{Style.RESET_ALL}")
        
        self._run_scanner(target_type)
        self._print_results()
        self._save_reports()
    
    cdef str _detect_target_type(self):
        """Detect what type of target was provided"""
        cdef str t = self.target.lower()
        
        if 'github.com' in t:
            return 'github'
        elif 'gitlab.com' in t:
            return 'gitlab'
        elif 'bitbucket.org' in t:
            return 'bitbucket'
        elif 'pastebin.com' in t:
            return 'pastebin'
        elif t.startswith(('http://', 'https://')):
            if t.endswith(('.env', '.json', '.yaml', '.yml', '.txt', '.xml', '.conf', '.ini')):
                return 'direct_file'
            return 'website'
        elif re.match(r'^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$', self.target):
            return 'ip'
        elif os.path.exists(self.target):
            return 'local_file'
        else:
            return 'unknown'
    
    cdef void _run_scanner(self, str target_type):
        """Run appropriate scanner based on target type"""
        
        if target_type == 'github':
            self._scan_github()
        elif target_type == 'gitlab':
            self._scan_gitlab()
        elif target_type == 'bitbucket':
            self._scan_bitbucket()
        elif target_type == 'pastebin':
            self._scan_pastebin()
        elif target_type == 'direct_file':
            self._scan_direct_file()
        elif target_type == 'website':
            self._scan_website()
        elif target_type == 'ip':
            self._scan_ip()
        elif target_type == 'local_file':
            self._scan_local_file()
        else:
            print(f"{Fore.RED}[!] Unknown target type{Style.RESET_ALL}")
    
    cdef void _scan_github(self):
        """Scan GitHub repository"""
        print(f"{Fore.CYAN}[+] Scanning GitHub repository...{Style.RESET_ALL}")
        
        cdef str clone_dir = os.path.join(self.output_dir, 'repo')
        
        cdef object result = subprocess.run(
            ['git', 'clone', '--depth', '1', self.target, clone_dir],
            capture_output=True, text=True
        )
        
        if result.returncode != 0:
            print(f"{Fore.RED}[!] Git clone failed: {result.stderr}{Style.RESET_ALL}")
            return
        
        print(f"{Fore.GREEN}[+] Repository cloned to {clone_dir}{Style.RESET_ALL}")
        
        cdef list findings = self.scanner.scan_directory(clone_dir)
        self.results.extend(findings)
        
        shutil.rmtree(clone_dir, ignore_errors=True)
        
        print(f"{Fore.GREEN}[+] GitHub scan complete. Found {len(findings)} secrets.{Style.RESET_ALL}")
    
    cdef void _scan_gitlab(self):
        """Scan GitLab repository"""
        print(f"{Fore.CYAN}[+] Scanning GitLab repository...{Style.RESET_ALL}")
        
        cdef str clone_dir = os.path.join(self.output_dir, 'repo')
        
        cdef object result = subprocess.run(
            ['git', 'clone', '--depth', '1', self.target, clone_dir],
            capture_output=True, text=True
        )
        
        if result.returncode != 0:
            print(f"{Fore.RED}[!] Git clone failed{Style.RESET_ALL}")
            return
        
        cdef list findings = self.scanner.scan_directory(clone_dir)
        self.results.extend(findings)
        shutil.rmtree(clone_dir, ignore_errors=True)
        
        print(f"{Fore.GREEN}[+] GitLab scan complete. Found {len(findings)} secrets.{Style.RESET_ALL}")
    
    cdef void _scan_bitbucket(self):
        """Scan Bitbucket repository"""
        print(f"{Fore.CYAN}[+] Scanning Bitbucket repository...{Style.RESET_ALL}")
        
        cdef str clone_dir = os.path.join(self.output_dir, 'repo')
        
        cdef object result = subprocess.run(
            ['git', 'clone', '--depth', '1', self.target, clone_dir],
            capture_output=True, text=True
        )
        
        if result.returncode != 0:
            print(f"{Fore.RED}[!] Git clone failed{Style.RESET_ALL}")
            return
        
        cdef list findings = self.scanner.scan_directory(clone_dir)
        self.results.extend(findings)
        shutil.rmtree(clone_dir, ignore_errors=True)
        
        print(f"{Fore.GREEN}[+] Bitbucket scan complete. Found {len(findings)} secrets.{Style.RESET_ALL}")
    
    cdef void _scan_pastebin(self):
        """Scan Pastebin URL"""
        print(f"{Fore.CYAN}[+] Scanning Pastebin...{Style.RESET_ALL}")
        
        cdef str paste_id = self.target.split('/')[-1]
        cdef str raw_url = f"https://pastebin.com/raw/{paste_id}"
        
        try:
            cdef object response = self.evader.get(raw_url, {'timeout': 10})
            if response.status_code == 200:
                cdef list findings = self.scanner.scan_text(response.text, self.target)
                self.results.extend(findings)
                print(f"{Fore.GREEN}[+] Pastebin scan complete. Found {len(findings)} secrets.{Style.RESET_ALL}")
            else:
                print(f"{Fore.RED}[!] Failed to fetch paste: HTTP {response.status_code}{Style.RESET_ALL}")
        except Exception as e:
            print(f"{Fore.RED}[!] Error: {str(e)}{Style.RESET_ALL}")
    
    cdef void _scan_direct_file(self):
        """Download and scan direct file URL"""
        print(f"{Fore.CYAN}[+] Downloading file...{Style.RESET_ALL}")
        
        try:
            cdef object response = self.evader.get(self.target, {'timeout': 15})
            if response.status_code == 200:
                cdef str filename = os.path.basename(self.target.split('?')[0])
                cdef str filepath = os.path.join(self.output_dir, filename)
                
                with open(filepath, 'wb') as f:
                    f.write(response.content)
                
                print(f"{Fore.GREEN}[+] File saved: {filepath}{Style.RESET_ALL}")
                
                if filename.endswith(('.txt', '.env', '.json', '.yaml', '.yml', '.xml', '.conf', '.ini')):
                    cdef str content = response.text
                    cdef list findings = self.scanner.scan_text(content, self.target)
                    self.results.extend(findings)
                    print(f"{Fore.GREEN}[+] Found {len(findings)} secrets.{Style.RESET_ALL}")
            else:
                print(f"{Fore.RED}[!] Failed to download: HTTP {response.status_code}{Style.RESET_ALL}")
        except Exception as e:
            print(f"{Fore.RED}[!] Error: {str(e)}{Style.RESET_ALL}")
    
    cdef void _scan_website(self):
        """Scan website with worm crawling"""
        print(f"{Fore.CYAN}[+] Scanning website with worm crawler...{Style.RESET_ALL}")
        
        cdef list pages = self.crawler.crawl(self.target)
        print(f"{Fore.GREEN}[+] Crawled {len(pages)} pages{Style.RESET_ALL}")
        
        cdef dict page
        for page in pages:
            try:
                cdef object response = self.evader.get(page['url'], {'timeout': 10})
                if response.status_code == 200:
                    cdef list findings = self.scanner.scan_text(response.text, page['url'])
                    self.results.extend(findings)
            except Exception:
                pass
        
        cdef object parsed = urlparse(self.target)
        cdef str domain = parsed.netloc or parsed.path
        
        if domain and '.' in domain:
            print(f"{Fore.CYAN}[+] Running port scan on {domain}...{Style.RESET_ALL}")
            cdef list open_ports = self.port_scanner.scan(domain, False)
            cdef dict port_info
            for port_info in open_ports:
                self.results.append({
                    'type': 'OPEN_PORT',
                    'value': f"{port_info['port']} ({port_info['service']})",
                    'source': domain,
                    'severity': 'MEDIUM'
                })
            
            print(f"{Fore.CYAN}[+] Running subdomain discovery...{Style.RESET_ALL}")
            cdef list subdomains = self.subdomain_finder.find(domain)
            cdef dict sub
            for sub in subdomains:
                self.results.append({
                    'type': 'SUBDOMAIN',
                    'value': sub['full'],
                    'source': domain,
                    'severity': 'INFO'
                })
        
        print(f"{Fore.GREEN}[+] Website scan complete. Total findings: {len(self.results)}{Style.RESET_ALL}")
    
    cdef void _scan_ip(self):
        """Scan IP address"""
        print(f"{Fore.CYAN}[+] Scanning IP address...{Style.RESET_ALL}")
        
        cdef list open_ports = self.port_scanner.scan(self.target, False)
        cdef dict port_info
        
        for port_info in open_ports:
            self.results.append({
                'type': 'OPEN_PORT',
                'value': f"{port_info['port']} ({port_info['service']})",
                'source': self.target,
                'severity': 'MEDIUM'
            })
        
        print(f"{Fore.GREEN}[+] IP scan complete. Found {len(open_ports)} open ports.{Style.RESET_ALL}")
    
    cdef void _scan_local_file(self):
        """Scan local file or directory"""
        print(f"{Fore.CYAN}[+] Scanning local path...{Style.RESET_ALL}")
        
        cdef list findings
        
        if os.path.isfile(self.target):
            findings = self.scanner.scan_file(self.target)
            self.results.extend(findings)
        elif os.path.isdir(self.target):
            findings = self.scanner.scan_directory(self.target)
            self.results.extend(findings)
        else:
            print(f"{Fore.RED}[!] Path does not exist{Style.RESET_ALL}")
            return
        
        print(f"{Fore.GREEN}[+] Local scan complete. Found {len(self.results)} secrets.{Style.RESET_ALL}")
    
    cdef void _print_results(self):
        """Print results in formatted table"""
        print(f"\n{Fore.CYAN}{'='*80}{Style.RESET_ALL}")
        print(f"{Fore.RED}{'ENVKILLER SCAN RESULTS':^80}{Style.RESET_ALL}")
        print(f"{Fore.CYAN}{'='*80}{Style.RESET_ALL}")
        
        if not self.results:
            print(f"{Fore.YELLOW}[!] No secrets or findings discovered.{Style.RESET_ALL}")
        else:
            print(f"{Fore.RED}{'TYPE':<20} {'FINDING':<35} {'SEVERITY':<12} {'SOURCE'}{Style.RESET_ALL}")
            print(f"{Fore.CYAN}{'-'*80}{Style.RESET_ALL}")
            
            cdef dict r
            cdef str severity_color
            for r in self.results[:50]:
                if r.get('severity') == 'CRITICAL':
                    severity_color = Fore.RED
                elif r.get('severity') == 'HIGH':
                    severity_color = Fore.YELLOW
                else:
                    severity_color = Fore.WHITE
                print(f"{r.get('type', 'UNKNOWN'):<20} {r.get('value', 'N/A')[:35]:<35} {severity_color}{r.get('severity', 'INFO'):<12}{Style.RESET_ALL} {r.get('source', 'N/A')[:40]}")
        
        print(f"{Fore.CYAN}{'='*80}{Style.RESET_ALL}")
        print(f"{Fore.GREEN}[+] Total findings: {len(self.results)}{Style.RESET_ALL}")
    
    cdef void _save_reports(self):
        """Save results to JSON and HTML"""
        
        cdef str json_path = os.path.join(self.output_dir, 'report.json')
        with open(json_path, 'w') as f:
            json.dump({
                'target': self.target,
                'scan_id': self.scan_id,
                'timestamp': time.time(),
                'findings': self.results
            }, f, indent=2)
        print(f"{Fore.GREEN}[+] JSON report saved: {json_path}{Style.RESET_ALL}")
        
        cdef str html_path = os.path.join(self.output_dir, 'report.html')
        cdef str html_content = f"""<!DOCTYPE html>
<html>
<head>
    <title>EnvKiller Report - {self.target}</title>
    <style>
        body {{ font-family: monospace; background: #0a0a0a; color: #00ff00; padding: 20px; }}
        h1 {{ color: #ff0000; }}
        table {{ width: 100%; border-collapse: collapse; }}
        th {{ background: #ff0000; color: #000; padding: 10px; text-align: left; }}
        td {{ border: 1px solid #333; padding: 8px; }}
        .CRITICAL {{ background: #300; color: #ff0000; }}
        .HIGH {{ background: #330; color: #ff6600; }}
        .MEDIUM {{ background: #030; color: #ffff00; }}
        .INFO {{ background: #003; color: #00ff00; }}
    </style>
</head>
<body>
    <h1>ENVKILLER v1.0 - SCAN REPORT</h1>
    <h2>Target: {self.target}</h2>
    <h2>Scan ID: {self.scan_id}</h2>
    <h2>Date: {time.ctime()}</h2>
    <table>
        <tr><th>TYPE</th><th>FINDING</th><th>SEVERITY</th><th>SOURCE</th></tr>"""
        
        cdef dict r
        for r in self.results:
            html_content += f"""
        <tr>
            <td class="{r.get('severity', 'INFO')}">{r.get('type', 'UNKNOWN')}</td>
            <td>{r.get('value', 'N/A')}</td>
            <td class="{r.get('severity', 'INFO')}">{r.get('severity', 'INFO')}</td>
            <td>{r.get('source', 'N/A')[:60]}</td>
        </tr>"""
        
        html_content += f"""
    </table>
    <p>Total Findings: {len(self.results)}</p>
    <p>Made by XSPEEN</p>
</body>
</html>"""
        
        with open(html_path, 'w') as f:
            f.write(html_content)
        print(f"{Fore.GREEN}[+] HTML report saved: {html_path}{Style.RESET_ALL}")
