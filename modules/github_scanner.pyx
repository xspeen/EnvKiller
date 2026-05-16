# modules/github_scanner.pyx
# GitHub repository scanner
# MADE BY XSPEEN

import subprocess
import os
import shutil
from core.scanner import SecretScanner

cdef class GitHubScanner:
    cdef str repo_url
    cdef str clone_dir
    cdef object scanner
    
    def __cinit__(self):
        self.scanner = SecretScanner()
    
    cpdef dict scan(self, str url):
        """Scan GitHub repository"""
        self.repo_url = url
        if not self.repo_url.endswith('.git'):
            self.repo_url += '.git'
        
        self.clone_dir = f"/tmp/envkiller_{abs(hash(url)) % 10000}"
        
        print(f"[+] Cloning: {self.repo_url}")
        
        # Clone repo
        result = subprocess.run(['git', 'clone', '--depth', '1', self.repo_url, self.clone_dir],
                                capture_output=True, text=True)
        
        if result.returncode != 0:
            return {'error': result.stderr, 'findings': []}
        
        print(f"[+] Scanning cloned repository")
        
        # Scan directory
        findings = self.scanner.scan_directory(self.clone_dir)
        
        # Cleanup
        shutil.rmtree(self.clone_dir, ignore_errors=True)
        
        return {
            'target': self.repo_url,
            'findings': findings,
            'total': len(findings)
        }
