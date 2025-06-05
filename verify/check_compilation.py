#!/usr/bin/env python3
"""
Check all Python files for compilation errors
"""
import os
import sys

def main():
    os.system('find . -name "*.py" -not -path "./venv/*" -not -path "./node_modules/*" -not -path "./.git/*" | xargs python -m py_compile')
    print("Python compilation check completed")

if __name__ == "__main__":
    main()