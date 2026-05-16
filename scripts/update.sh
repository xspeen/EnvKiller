#!/bin/bash
# Self-update script
# MADE BY XSPEEN

RED='\033[0;91m'
GREEN='\033[0;92m'
NC='\033[0m'

echo -e "${GREEN}[+] Updating EnvKiller...${NC}"

# Pull latest changes
git pull origin main

# Reinstall dependencies
pip3 install -r requirements.txt --upgrade

# Rebuild binaries
python3 setup.py build_ext --inplace

echo -e "${GREEN}[+] Update complete!${NC}"
