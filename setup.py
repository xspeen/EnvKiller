#!/usr/bin/env python3
# setup.py - Build obfuscated binaries
# MADE BY XSPEEN

import os
import sys
import shutil
from setuptools import setup, Extension
from Cython.Build import cythonize
from Cython.Distutils import build_ext

# Clean old builds
for d in ['build', 'dist']:
    if os.path.exists(d):
        shutil.rmtree(d)

# Find all .pyx files
pyx_files = []
for root, dirs, files in os.walk('.'):
    for file in files:
        if file.endswith('.pyx'):
            pyx_files.append(os.path.join(root, file))

print(f"[+] Found {len(pyx_files)} .pyx files to compile")

extensions = []
for pyx in pyx_files:
    module_name = pyx.replace('/', '.').replace('.pyx', '').replace('.\\', '')
    extensions.append(Extension(
        module_name,
        [pyx],
        extra_compile_args=['-O3', '-Wall', '-Wno-unused'],
        extra_link_args=[]
    ))

setup(
    name='EnvKiller',
    version='1.0.0',
    description='Advanced Secret Scanner',
    author='XSPEEN',
    ext_modules=cythonize(extensions,
                          compiler_directives={
                              'boundscheck': False,
                              'wraparound': False,
                              'cdivision': True,
                              'embedsignature': False
                          }),
    cmdclass={'build_ext': build_ext},
)

print("\033[92m[+] Build complete!\033[0m")
