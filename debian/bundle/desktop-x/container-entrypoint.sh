#!/bin/bash

set -euo pipefail

# 🐧 Setup Debian
debian-entrypoint.sh echo "✅ Debian setup complete."

desktop-x-install.sh

echo "✅ Desktop X setup complete."

exec "$@"