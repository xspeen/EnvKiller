#!/bin/bash
# Docker entrypoint
# MADE BY XSPEEN

echo "[+] EnvKiller Docker Container Starting..."
cd /app
python3 setup.py build_ext --inplace
python3 envkiller.py
