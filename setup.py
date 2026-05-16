#!/usr/bin/env python3
import os
import glob
from setuptools import setup, Extension
from Cython.Build import cythonize

# Find all .pyx files automatically
pyx_files = glob.glob('core/*.pyx') + glob.glob('modules/*.pyx')

print(f"[+] Found {len(pyx_files)} .pyx files to compile")

extensions = []
for pyx in pyx_files:
    module_name = pyx.replace('/', '.').replace('.pyx', '')
    extensions.append(Extension(module_name, [pyx]))

setup(
    name='EnvKiller',
    version='1.0.0',
    description='Advanced Secret Scanner',
    author='XSPEEN',
    ext_modules=cythonize(extensions, 
                          compiler_directives={
                              'boundscheck': False,
                              'wraparound': False,
                          }),
)
