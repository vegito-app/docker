#!/bin/bash

set -euo pipefail

debian-dockerd-install.sh

exec "$@"