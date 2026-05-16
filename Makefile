.PHONY: all install build clean run

all: install build

install:
	pip3 install -r requirements.txt

build:
	python3 setup.py build_ext --inplace

clean:
	rm -rf build/ dist/ *.so *.pyd __pycache__ core/__pycache__

run:
	python3 envkiller.py
