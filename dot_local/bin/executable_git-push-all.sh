#!/bin/bash
# Push all personal repos at once
set -euo pipefail

echo "=== ~/notes ==="
cd ~/notes && git add -A && git commit --allow-empty -m "auto: $(date '+%Y-%m-%d %H:%M')" && git push || echo "nothing to push"

echo ""
echo "=== ~/Documents/notes ==="
cd ~/Documents/notes && git add -A && git commit --allow-empty -m "auto: $(date '+%Y-%m-%d %H:%M')" && git push || echo "nothing to push"
