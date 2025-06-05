# Lemur Setup Guide

This guide walks through the complete setup process for getting Lemur running locally for development.

## Prerequisites

- Python 3.9+
- Node.js 18+
- PostgreSQL
- Git

## Step 1: Initial Installation

1. **Install dependencies:**
   ```bash
   make develop
   ```
   This installs all Python and Node.js dependencies required for development.

2. **Build frontend assets:**
   ```bash
   npm run build_static
   ```
   This compiles the frontend JavaScript and CSS files.

## Step 2: Database Setup

1. **Create PostgreSQL user and database:**
   ```bash
   # Create user 'lemur' with password 'lemur'
   psql postgres -c "CREATE USER lemur WITH PASSWORD 'lemur';"
   
   # Create database 'lemur' owned by user 'lemur'
   psql postgres -c "CREATE DATABASE lemur OWNER lemur;"
   ```

## Step 3: Configuration

1. **Create config directory:**
   ```bash
   mkdir -p config
   ```

2. **Generate Lemur configuration file:**
   ```bash
   lemur create_config -c config/lemur.conf.py
   ```

3. **Edit configuration for local development:**
   Edit `config/lemur.conf.py` and set:
   ```python
   CORS = True
   DEBUG = True
   ```

   The configuration file includes:
   - Database connection to PostgreSQL: `postgresql://lemur:lemur@localhost:5432/lemur`
   - Security keys and tokens (auto-generated)
   - Default plugin configurations

## Step 4: Database Initialization

1. **Initialize migration repository:**
   ```bash
   lemur -c config/lemur.conf.py db init
   ```

2. **Run database migrations:**
   ```bash
   lemur -c config/lemur.conf.py db upgrade
   ```
   This creates all necessary database tables and schema.

3. **Initialize Lemur with default data:**
   ```bash
   printf "lemur\nadmin\n" | lemur -c config/lemur.conf.py init
   ```
   This creates:
   - Default roles (admin, operator, global_cert_issuer, read-only)
   - Admin user 'lemur' with password 'admin'
   - Default notification settings
   - Default certificate rotation policy (30 days before issuance)

## Step 5: Code Fixes Applied

During setup, the following fixes were applied:

### Factory Configuration Fix
**File:** `lemur/factory.py`
- **Issue:** AttributeError when script_info doesn't have config attribute
- **Fix:** Added safe attribute access with default None value:
  ```python
  config = getattr(script_info, 'config', None)
  ```

### Frontend Build Minification Fix
**File:** `gulp/build.js`
- **Issue:** Updated to use `gulp-csso` instead of deprecated minifier for CSS optimization
- **Fix:** Modified minification pipeline to use `csso()` for better CSS compression and compatibility
  ```javascript
  // Changed from:
  .pipe(minifycss())
  // To:
  .pipe(csso())
  ```

### Authentication Token Fix
**File:** `lemur/auth/service.py`
- **Issue:** JWT token payload "sub" field type inconsistency (integer vs string)
- **Fix:** Ensure consistent string type for JWT "sub" field:
  ```python
  # Token creation - convert to string:
  payload["sub"] = str(user.id)
  
  # Token validation - convert back to int:
  user = user_service.get(int(payload["sub"]))
  ```

### Plugin Loading Compatibility Fix
**File:** `lemur/factory.py`
- **Issue:** `entry_points()` API changed in newer Python versions
- **Fix:** Added fallback for backward compatibility:
  ```python
  try:
      # For newer versions of importlib.metadata (Python 3.10+)
      eps = entry_points(group="lemur.plugins")
  except TypeError:
      # Fallback for older versions
      eps = entry_points().get("lemur.plugins", [])
  ```

## Step 6: Running the Application

1. **Terminal 1 - Start backend:**
   ```bash
   lemur start -c config/lemur.conf.py -b 0.0.0.0:8000
   ```

2. **Terminal 2 - Start frontend development server:**
   ```bash
   node_modules/.bin/gulp serve
   ```

3. **Access the application:**
   Open browser to `http://localhost:3000`
   - Frontend runs on port 3000 with live reload
   - Backend API runs on port 8000
   - Frontend proxies API calls to backend

## Login Credentials

- **Username:** lemur
- **Password:** admin

## Verification Commands

The following scripts were created in the `verify/` directory for checking the codebase:

- `check_compilation.py` - Checks Python syntax compilation
- `check_imports.py` - Verifies import statements and key modules

## Notes

- This setup is configured for local development only
- The database and user credentials are simple for development convenience
- CORS and DEBUG are enabled for local development
- Plugin warnings about missing API keys (DigiCert, Entrust, etc.) are normal for local setup