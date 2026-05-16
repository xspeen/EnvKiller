#!/usr/bin/env python3
# ENVKILLER v1.0 - Advanced Secret Scanner
# MADE BY XSPEEN

import sys
import os
import time
import subprocess

# BIG RED HEADER BANNER
print("\033[91m")
print("███████╗███╗   ██╗██╗   ██╗██╗  ██╗██╗██╗     ██╗     ███████╗██████╗")
print("██╔════╝████╗  ██║██║   ██║██║ ██╔╝██║██║     ██║     ██╔════╝██╔══██╗")
print("█████╗  ██╔██╗ ██║██║   ██║█████╔╝ ██║██║     ██║     █████╗  ██████╔╝")
print("██╔══╝  ██║╚██╗██║╚██╗ ██╔╝██╔═██╗ ██║██║     ██║     ██╔══╝  ██╔══██╗")
print("███████╗██║ ╚████║ ╚████╔╝ ██║  ██╗██║███████╗███████╗███████╗██║  ██║")
print("╚══════╝╚═╝  ╚═══╝  ╚═══╝  ╚═╝  ╚═╝╚═╝╚══════╝╚══════╝╚══════╝╚═╝  ╚═╝")
print("")
print("                         ██╗   ██╗███████╗")
print("                         ██║   ██║██╔════╝")
print("                         ██║   ██║███████╗")
print("                         ╚██╗ ██╔╝╚════██║")
print("                          ╚████╔╝ ███████║")
print("                           ╚═══╝  ╚══════╝")
print("")
print("╔══════════════════════════════════════════════════════════════════════════════╗")
print("║                         ENVKILLER v1.0 - ADVANCED SECRET SCANNER              ║")
print("║                           MADE BY XSPEEN - ELITE EDITION                      ║")
print("║                                                                               ║")
print("║     ANY LINK · ANY OS · NO API KEYS · WORM MODE · UNDETECTABLE                ║")
print("╚══════════════════════════════════════════════════════════════════════════════╝")
print("\033[0m")

# Loading animation
print("\033[91m")
frames = ["[■□□□□□□□□□] 0%", "[■■□□□□□□□□] 10%", "[■■■□□□□□□□] 20%", "[■■■■□□□□□□] 30%",
          "[■■■■■□□□□□] 40%", "[■■■■■■□□□□] 50%", "[■■■■■■■□□□] 60%", "[■■■■■■■■□□] 70%",
          "[■■■■■■■■■□] 80%", "[■■■■■■■■■■] 100%"]
for frame in frames:
    sys.stdout.write(f"\r{frame} Loading EnvKiller Engine...")
    sys.stdout.flush()
    time.sleep(0.1)
print("\n\033[0m")

# Check Python version
if sys.version_info < (3, 7):
    print("\033[91m[!] Python 3.7+ required\033[0m")
    sys.exit(1)

# Add paths
ROOT_DIR = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, ROOT_DIR)

# Import core
try:
    from core.engine import EnvKillerEngine
except ImportError as e:
    print(f"\033[91m[!] Failed to import core: {e}\033[0m")
    print("[!] Run: python3 setup.py build_ext --inplace")
    sys.exit(1)

# Run
if __name__ == "__main__":
    try:
        engine = EnvKillerEngine()
        engine.start()
    except KeyboardInterrupt:
        print("\n\033[91m[!] Interrupted by user\033[0m")
        sys.exit(0)
    except Exception as e:
        print(f"\033[91m[!] Error: {e}\033[0m")
        sys.exit(1)
