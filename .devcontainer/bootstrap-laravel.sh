#!/usr/bin/env bash
set -Eeuo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

echo "Preparing Edubooster Exam Board..."

command -v php >/dev/null 2>&1 || { echo "PHP is missing from this Codespace." >&2; exit 1; }
command -v composer >/dev/null 2>&1 || { echo "Composer is missing from this Codespace." >&2; exit 1; }
command -v node >/dev/null 2>&1 || { echo "Node.js is missing from this Codespace." >&2; exit 1; }
command -v npm >/dev/null 2>&1 || { echo "npm is missing from this Codespace." >&2; exit 1; }

php -v
composer --version
node --version
npm --version

if [ ! -f artisan ]; then
    echo "Creating a fresh Laravel application..."
    TEMP_DIR="$(mktemp -d)"
    trap 'rm -rf "$TEMP_DIR"' EXIT

    composer create-project laravel/laravel "$TEMP_DIR/laravel" --no-interaction
    rm -rf "$TEMP_DIR/laravel/vendor"
    cp -an "$TEMP_DIR/laravel/." "$ROOT_DIR/"
else
    echo "Laravel application already exists; installing PHP dependencies..."
fi

composer install --no-interaction --prefer-dist

if [ ! -f .env ]; then
    cp .env.example .env
fi

set_env() {
    local key="$1"
    local value="$2"
    if grep -q "^"${key}"=" .env; then
        sed -i "s|^"${key}"=.*|"${key}"="${value}"|" .env
    else
        printf '%s=%s\n' "$key" "$value" >> .env
    fi
}

set_env APP_ENV local
set_env APP_DEBUG true
set_env APP_URL http://localhost:8000
set_env DB_CONNECTION sqlite
set_env DB_DATABASE "$ROOT_DIR/database/database.sqlite"

mkdir -p database storage/logs storage/framework/cache/data storage/framework/sessions storage/framework/views bootstrap/cache
touch database/database.sqlite

php artisan key:generate --force
php artisan config:clear
php artisan migrate --force

if [ -f package-lock.json ]; then
    npm ci --no-audit --no-fund
else
    npm install --no-audit --no-fund
fi
npm run build

php artisan optimize:clear
chmod -R ug+rwX storage bootstrap/cache

echo
echo "Laravel bootstrap completed successfully."
echo "The application will start automatically on port 8000."
