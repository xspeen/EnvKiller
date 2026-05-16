# lib/anti_debug.py
# Anti-debugging measures
# MADE BY XSPEEN

import sys
import os

class AntiDebug:
    @staticmethod
    def check_debugger() -> bool:
        """Check if debugger is present"""
        # Check for debugger in Python
        if sys.gettrace() is not None:
            return True
        
        # Check for common debugger environments
        debug_vars = ['PYCHARM_HOSTED', 'PYDEV_CONSOLE_ENCODING', 'DEBUGPY_LAUNCHER']
        for var in debug_vars:
            if var in os.environ:
                return True
        
        return False
    
    @staticmethod
    def protect():
        """Exit if debugger detected"""
        if AntiDebug.check_debugger():
            print("\033[91m[!] Debugger detected. Exiting.\033[0m")
            sys.exit(1)
