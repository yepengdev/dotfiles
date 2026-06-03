#!/bin/bash
# Push all personal repos at once
set -euo pipefail

echo "=== ~/org/deft ==="
cd ~/org/deft && git add -A && git commit --allow-empty -m "auto: $(date '+%Y-%m-%d %H:%M')" && git push || echo "nothing to push"

echo ""
echo "=== ~/org/denote ==="
cd ~/org/denote && git add -A && git commit --allow-empty -m "auto: $(date '+%Y-%m-%d %H:%M')" && git push || echo "nothing to push"
