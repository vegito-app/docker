#!/bin/sh

set -uo pipefail


caches_refresh_success=false
# 🧹 Function called at the end of the script to check for success
check_success() {
    if [ $caches_refresh_success = true ]; then
        echo "♻️ Flutter caches refreshed successfully."
    else
        echo "❌ Flutter caches refresh failed."
    fi
}

# 🚨 Register cleanup function to run on script exit
trap check_success EXIT

local_container_cache=${LOCAL_FLUTTER_CONTAINER_CACHE:-${LOCAL_DIR:-${PWD}}/.containers/android-studio}
mkdir -p $local_container_cache

# Flutter Gradle config
FLUTTER_GRADLE_CONFIG=${HOME}/.gradle
mkdir -p ${local_container_cache}/gradle
rm -rf $FLUTTER_GRADLE_CONFIG
ln -sf ${local_container_cache}/gradle $FLUTTER_GRADLE_CONFIG

# Flutter Java cache
FLUTTER_JAVA_CONFIG=${HOME}/.java
mkdir -p ${local_container_cache}/java
rm -rf $FLUTTER_JAVA_CONFIG
ln -sf ${local_container_cache}/java $FLUTTER_JAVA_CONFIG

# Flutter Dart config
FLUTTER_DART_TOOL_CONFIG=${HOME}/.dart-tool
mkdir -p ${local_container_cache}/.dart-tool
rm -rf $FLUTTER_DART_TOOL_CONFIG
ln -sf ${local_container_cache}/.dart-tool $FLUTTER_DART_TOOL_CONFIG

# Flutter Flutter config
FLUTTER_FLUTTER_CONFIG=${HOME}/flutter
rsync -av $FLUTTER_FLUTTER_CONFIG ${local_container_cache}
rm -rf $FLUTTER_FLUTTER_CONFIG
ln -sf ${local_container_cache}/flutter $FLUTTER_FLUTTER_CONFIG

# Flutter Pub config
FLUTTER_PUB_CACHE_CONFIG=${HOME}/.pub-cache
rsync -av $FLUTTER_PUB_CACHE_CONFIG ${local_container_cache}
rm -rf $FLUTTER_PUB_CACHE_CONFIG
ln -sf ${local_container_cache}/.pub-cache $FLUTTER_PUB_CACHE_CONFIG

# Flutter Dart server config
FLUTTER_DART_SERVER=${HOME}/.dartServer
mkdir -p ${local_container_cache}/.dartServer
rm -rf $FLUTTER_DART_SERVER
ln -sf ${local_container_cache}/.dartServer $FLUTTER_DART_SERVER

caches_refresh_success=true