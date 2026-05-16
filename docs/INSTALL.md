# EnvKiller Installation Guide

## Linux / macOS / Termux

```bash
git clone https://github.com/xspeen/EnvKiller.git
cd EnvKiller
pip3 install -r requirements.txt
python3 setup.py build_ext --inplace
python3 envkiller.py
```

Windows

```powershell
git clone https://github.com/xspeen/EnvKiller.git
cd EnvKiller
pip install -r requirements.txt
python setup.py build_ext --inplace
python envkiller.py
```

Docker

```bash
docker build -t envkiller .
docker run -it envkiller
```

Requirements

· Python 3.7+
· pip
· git (for repository scanning)
