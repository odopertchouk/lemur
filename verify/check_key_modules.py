# check_key_modules.py
import sys
sys.path.insert(0, '.')

# Test key modules
modules_to_test = [
    'lemur',
    'lemur.factory',
    'lemur.auth.service',
    'lemur.certificates.service',
    'lemur.authorities.service'
]

for module in modules_to_test:
    try:
        __import__(module)
        print(f'✓ {module}')
    except Exception as e:
        print(f'✗ {module}: {e}')
