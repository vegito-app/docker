#!/bin/sh

set -euo pipefail

if [ "${LOCAL_ROBOTFRAMEWORK_CONTAINER_INSTALL:-true}" = "true" ]; then
    robotframework-container-install.sh
fi

#!/bin/sh

set -euo pipefail

trap "echo Exited with code $?." EXIT

# 🐧 Setup Debian Python
python-container-entrypoint.sh echo "✅ Debian Python setup complete."

if [ "${LOCAL_ROBOTFRAMEWORK_CONTAINER_INSTALL:-true}" = "true" ]; then
    robotframework-container-install.sh
fi

exec "$@"