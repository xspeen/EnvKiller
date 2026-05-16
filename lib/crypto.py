# lib/crypto.py
# Encryption utilities
# MADE BY XSPEEN

import base64
import hashlib

class Crypto:
    @staticmethod
    def xor_encrypt(data: str, key: int = 0x42) -> str:
        """Simple XOR encryption"""
        result = bytes([ord(c) ^ key for c in data])
        return base64.b64encode(result).decode()
    
    @staticmethod
    def xor_decrypt(data: str, key: int = 0x42) -> str:
        """Simple XOR decryption"""
        decoded = base64.b64decode(data)
        result = bytes([b ^ key for b in decoded])
        return result.decode()
    
    @staticmethod
    def hash_file(filepath: str) -> str:
        """Get SHA256 hash of file"""
        sha256 = hashlib.sha256()
        with open(filepath, 'rb') as f:
            for chunk in iter(lambda: f.read(4096), b''):
                sha256.update(chunk)
        return sha256.hexdigest()
