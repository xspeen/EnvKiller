#!/bin/bash
# Build standalone binaries
# MADE BY XSPEEN

RED='\033[0;91m'
GREEN='\033[0;92m'
NC='\033[0m'

echo -e "${GREEN}[+] Building EnvKiller binaries...${NC}"

# Build with PyInstaller
pyinstaller --onefile --name envkiller-linux envkiller.py

# For Windows (if on Linux with cross-compile)
# docker run --rm -v "$PWD":/src -e PYINSTALLER_CONFIG=--onefile cdrx/pyinstaller-windows

echo -e "${GREEN}[+] Binary saved to dist/envkiller-linux${NC}"
