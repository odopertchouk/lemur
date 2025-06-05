# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build Commands
- Install dependencies: `make develop`
- Run development server: `make run`
- Build frontend: `node_modules/.bin/gulp build` or `npm run build_static`
- Build frontend (compatibility mode): `npm run build_static_no_minify` or `node_modules/.bin/gulp build:no-minify`
- Package frontend: `node_modules/.bin/gulp package`

## Frontend Development Server
- Serve frontend (development): `node_modules/.bin/gulp serve`
- Serve frontend (built): `node_modules/.bin/gulp serve:dist`

## Running Full Application
1. **Terminal 1:** Run `lemur start -c config/lemur.conf.py -b 0.0.0.0:8000` (Python API backend on port 8000)
2. **Terminal 2:** Run `node_modules/.bin/gulp serve` (frontend with live reload and API proxy)
3. **Browser:** Access `http://localhost:3000` (frontend will proxy API calls to backend)

Note: Use the "no_minify" commands if you encounter CSS minification errors with newer Node.js versions.

## Test Commands
- Run all tests: `make test`
- Run Python tests: `make test-python` or `pytest`
- Run single test: `pytest lemur/tests/test_file.py::test_function_name`
- Run JS tests: `make test-js` or `npm test`
- `check_compilation.py` - Checks that all python code is syntactically correct
- `check_imports.py` - Check Python imports for syntax and key module availability 
- `check_key_modules.py` - Check if the main application modules can actually be imported   

## Lint Commands
- Run all linters: `make lint`
- Lint Python: `make lint-python` or `PYFLAKES_NODOCTEST=1 flake8 lemur`
- Lint JavaScript: `make lint-js` or `npm run lint`
- Type check: `mypy`

## Code Style
- Python: PEP 8 with exceptions (max line length 100)
- Indentation: 4 spaces for Python, 2 spaces for JS/HTML/CSS
- Use type annotations where appropriate
- Follow existing patterns for imports and error handling
- Database changes: Add nullable columns, remove code references before removing DB objects
- All PRs should target the `main` branch
- Include tests and documentation for changes

## Git Commit Rules
- NEVER add Claude Code signatures or Co-Authored-By lines to commits
- Keep commit messages clean and focused on the technical change
- Use conventional commit format when appropriate
