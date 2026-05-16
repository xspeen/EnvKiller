#!/bin/bash
# Auto-install script
# MADE BY XSPEEN

RED='\033[0;91m'
GREEN='\033[0;92m'
NC='\033[0m'

echo -e "${GREEN}[+] Installing EnvKiller...${NC}"

# Install Python dependencies
pip3 install -r requirements.txt

# Build Cython binaries
python3 setup.py build_ext --inplace

# Make launchers executable
chmod +x run.sh
chmod +x scripts/*.sh

echo -e "${GREEN}[+] Installation complete!${NC}"
echo -e "${GREEN}[+] Run: python3 envkiller.py${NC}"
