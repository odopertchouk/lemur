# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Environment Setup

### Build Commands
- Install dependencies: `make develop`
- Run development server: `make run`
- Build frontend: `node_modules/.bin/gulp build` or `npm run build_static`
- Build frontend (compatibility mode): `npm run build_static_no_minify` or `node_modules/.bin/gulp build:no-minify`
- Package frontend: `node_modules/.bin/gulp package`

### Frontend Development Server
- Serve frontend (development): `node_modules/.bin/gulp serve`
- Serve frontend (built): `node_modules/.bin/gulp serve:dist`

### Running Full Application
1. **Terminal 1:** Run `lemur start -c config/lemur.conf.py -b 0.0.0.0:8000` (Python API backend on port 8000)
2. **Terminal 2:** Run `node_modules/.bin/gulp serve` (frontend with live reload and API proxy)
3. **Browser:** Access `http://localhost:3000` (frontend will proxy API calls to backend)

Note: Use the "no_minify" commands if you encounter CSS minification errors with newer Node.js versions.

## Testing and Quality Assurance

### Test Commands
- Run all tests: `make test`
- Run Python tests: `make test-python` or `pytest`
- Run single test: `pytest lemur/tests/test_file.py::test_function_name`
- Run JS tests: `make test-js` or `npm test`
- `check_compilation.py` - Checks that all python code is syntactically correct
- `check_imports.py` - Check Python imports for syntax and key module availability 
- `check_key_modules.py` - Check if the main application modules can actually be imported   
- When writing tests, add them one by one, and run the test right after you add it. 

### Plugin Testing
- Tests for plugins are in the directory tests/ that is in the same directory as the plugin source code.


### Linting and Code Quality
- Run all linters: `make lint`
- Lint Python: `make lint-python` or `PYFLAKES_NODOCTEST=1 flake8 lemur`
- Lint JavaScript: `make lint-js` or `npm run lint`
- Type check: `mypy`

## Code Style Guidelines

### Python Code Style
- Follow PEP 8 with exceptions (max line length 100)
- Use type annotations where appropriate
- Indentation: 4 spaces
- Use descriptive variable and function names
- For functions with more than 2 arguments, use explicit keyword arguments:
  ```python
  # Instead of:
  function my_function('a', 1, d)
  # Use:
  function my_function('a', count=1, file=d)
  ```
- **Use `current_app.logger` whenever possible**
- Document all functions and classes with docstrings
- Add inline comments for complex logic only
- Use double quotes (") for strings unless there's a conflict
- Use typehints for all function.
- Use clear DocStrings for classes and functions. Make sure to list all arguments, the return type and the exceptions.
- Don't leave whitespace at the end of strings, or have blanl lines with whitespace.
- Use `black` to fix formatting errors

### JavaScript/HTML/CSS Style
- Indentation: 2 spaces
- Follow existing patterns for imports and error handling
- Use consistent naming conventions (camelCase for variables/functions, PascalCase for classes)

### Database Guidelines
- Add nullable columns when making schema changes
- Remove code references before removing DB objects
- Document all schema changes in migrations

## Git Workflow

### Branch Management
1. Create feature branches from integration:
   ```bash
   git checkout integration
   git pull origin integration
   git checkout -b oleg/my-feature
   ```

### Commit Process
1. Check staged and tracked files:
   ```bash
   git status
   git diff
   git diff --staged
   ```
2. Add changes if necessary:
   ```bash
   git add <changed files>
   ```
3. Commit with structured message:
   ```bash
   git commit -m "Title of commit" -m " - line 1" -m " - line 2" ...
   ```
4. Push changes:
   ```bash
   git push origin oleg/my-feature
   ```

### Pull Request Guidelines
- Create PRs targeting the `integration` branch
- Use command: `gh pr create --base integration --head oleg/my-feature`
- Include tests and documentation for changes
- Never add Claude Code signatures or Co-Authored-By lines
- Keep commit messages clean and focused on technical changes
- Use conventional commit format when appropriate

## Security Guidelines
- Never commit changes to config/... files as they may contain secrets
- Use environment variables for sensitive configuration
- Follow principle of least privilege for database access
- Validate and sanitize all user inputs
- Keep dependencies up to date and audit regularly

## Documentation Requirements
- Update README.md for any command line interface changes
- Document all new features and significant changes
- Include examples for complex functionality
- Keep API documentation up to date
- Document any breaking changes clearly