#!/usr/bin/env python3
"""
Check Python imports for syntax and key module availability
"""
import ast
import os
import sys


def check_import_syntax():
    """Parse all Python files to check import statements"""
    errors = []
    total_files = 0

    for root, dirs, files in os.walk('.'):
        dirs[:] = [d for d in dirs if d not in ['venv', 'node_modules', '.git', '__pycache__', 'bower_components']]
        
        for file in files:
            if file.endswith('.py'):
                filepath = os.path.join(root, file)
                total_files += 1
                try:
                    with open(filepath, 'r', encoding='utf-8') as f:
                        content = f.read()
                    ast.parse(content)
                except Exception as e:
                    errors.append(f'{filepath}: {e}')

    print(f'Analyzed {total_files} Python files')
    if errors:
        print(f'Found {len(errors)} parsing errors:')
        for error in errors[:10]:
            print(error)
        return False
    else:
        print('All files parsed successfully for import analysis')
        return True


def check_key_modules():
    """Test importing key application modules"""
    sys.path.insert(0, '.')
    
    modules_to_test = [
        'lemur',
        'lemur.factory',
        'lemur.auth.service',
        'lemur.certificates.service',
        'lemur.authorities.service'
    ]

    success = True
    for module in modules_to_test:
        try:
            __import__(module)
            print(f'✓ {module}')
        except Exception as e:
            print(f'✗ {module}: {e}')
            success = False
    
    return success


def main():
    print("Checking import syntax...")
    syntax_ok = check_import_syntax()
    
    print("\nChecking key module imports...")
    imports_ok = check_key_modules()
    
    if syntax_ok and imports_ok:
        print("\n✓ All import checks passed")
        return 0
    else:
        print("\n✗ Some import checks failed")
        return 1


if __name__ == "__main__":
    sys.exit(main())