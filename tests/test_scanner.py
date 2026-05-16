# test_scanner.py
# Unit tests for scanner
# MADE BY XSPEEN

import unittest
import sys
import os

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from core.scanner import SecretScanner

class TestScanner(unittest.TestCase):
    def setUp(self):
        self.scanner = SecretScanner()
    
    def test_aws_key_detection(self):
        text = "AWS_KEY=AKIAIOSFODNN7EXAMPLE"
        findings = self.scanner.scan_text(text, "test.txt")
        self.assertTrue(len(findings) > 0)
        self.assertEqual(findings[0]['type'], 'AWS_ACCESS_KEY')
    
    def test_github_token_detection(self):
        text = "GITHUB_TOKEN=ghp_aBcDeFgHiJkLmNoPqRsTuVwXyZ1234"
        findings = self.scanner.scan_text(text, "test.txt")
        self.assertTrue(len(findings) > 0)
        self.assertEqual(findings[0]['type'], 'GITHUB_TOKEN')
    
    def test_email_detection(self):
        text = "Contact: test@example.com"
        findings = self.scanner.scan_text(text, "test.txt")
        self.assertTrue(len(findings) > 0)
        self.assertEqual(findings[0]['type'], 'EMAIL')
    
    def test_no_false_positives(self):
        text = "This is safe text with no secrets"
        findings = self.scanner.scan_text(text, "test.txt")
        self.assertEqual(len(findings), 0)

if __name__ == '__main__':
    unittest.main()
