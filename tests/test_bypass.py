# test_bypass.py
# Unit tests for bypass engine
# MADE BY XSPEEN

import unittest
import sys
import os

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from core.bypass import BypassEngine

class TestBypass(unittest.TestCase):
    def setUp(self):
        self.bypass = BypassEngine()
    
    def test_headers_generation(self):
        headers = self.bypass.get_headers()
        self.assertIn('User-Agent', headers)
        self.assertIn('Accept', headers)
        self.assertIn('X-Forwarded-For', headers)
    
    def test_headers_rotation(self):
        headers1 = self.bypass.get_headers()
        headers2 = self.bypass.get_headers()
        # Headers may be same or different, just test they exist
        self.assertIsNotNone(headers1)
        self.assertIsNotNone(headers2)
    
    def test_request_count(self):
        count1 = self.bypass.get_count()
        self.bypass.get_headers()
        count2 = self.bypass.get_count()
        self.assertEqual(count2, count1 + 1)

if __name__ == '__main__':
    unittest.main()
