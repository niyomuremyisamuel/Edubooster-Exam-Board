#!/usr/bin/env bash
set -Eeuo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

if [ ! -f artisan ]; then
    echo "Laravel is not initialized yet. Run the Codespaces bootstrap first."
    exit 0
fi

mkdir -p storage/logs
PID_FILE="storage/logs/codespaces-server.pid"
LOG_FILE="storage/logs/codespaces-server.log"

if [ -f "$PID_FILE" ] && kill -0 "$(cat "$PID_FILE")" 2>/dev/null; then
    echo "Laravel development server is already running."
else
    rm -f "$PID_FILE"
    nohup php artisan serve --host=0.0.0.0 --port=8000 > "$LOG_FILE" 2>&1 &
    echo $! > "$PID_FILE"
    echo "Laravel development server started on port 8000."
fi
