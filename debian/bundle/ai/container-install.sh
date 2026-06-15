#!/bin/bash

set -euo pipefail

container_ai_install_success=false
# 🧹 Function called at the end of the script to check for success
check_success() {
    if [ $container_ai_install_success = true ]; then
        echo "♻️ AI container installed successfully."
    else
        echo "❌ AI container installation failed."
    fi
}

# 🚨 Register cleanup function to run on script exit
trap check_success EXIT

AI_WORKSPACES=${AI_WORKSPACES:-/workspaces/ai}

mkdir -p ${AI_WORKSPACES}/ollama/models
mkdir -p ${AI_WORKSPACES}/ollama/cache
mkdir -p ${AI_WORKSPACES}/huggingface
mkdir -p ${AI_WORKSPACES}/torch
mkdir -p ${AI_WORKSPACES}/torch_extensions
mkdir -p ${AI_WORKSPACES}/chromadb
mkdir -p ${HOME}/.ollama
mkdir -p ${HOME}/.cache

# Use a local directory to persist container caches and configurations across container rebuilds.
# You can override the default location by setting the CONTAINER_CACHE environment variable.
# Example: export CONTAINER_CACHE=/path/to/your/local/cache
# If CONTAINER_CACHE is not set, it will default to $LOCAL_WORKSPACE/.containers
local_container_cache=${CONTAINER_CACHE:-${LOCAL_WORKSPACE:-${PWD}}/.containers/ai}
mkdir -p $local_container_cache

# local hermes cache
LOCAL_HERMES_CACHE=${HOME}/.hermes
LOCAL_HERMES_CACHE_GLOBAL=${local_container_cache}/.hermes

mkdir -p "${LOCAL_HERMES_CACHE_GLOBAL}"

# Synchronize the version shipped in the image into the persistent cache.
# User configuration is preserved because rsync only updates files.
if [ -d "${LOCAL_HERMES_CACHE}" ]; then
    rsync -a "${LOCAL_HERMES_CACHE}/" "${LOCAL_HERMES_CACHE_GLOBAL}/"
fi

rm -rf "${LOCAL_HERMES_CACHE}"
ln -sfn "${LOCAL_HERMES_CACHE_GLOBAL}" "${LOCAL_HERMES_CACHE}"

AI_WORKSPACES_OLLAMA_CACHE_GLOBAL=${AI_WORKSPACES_OLLAMA_CACHE_GLOBAL:-${AI_WORKSPACES}/ollama/cache}
AI_WORKSPACES_OLLAMA_CACHE=${HOME}/.ollama/cache
mkdir -p ${AI_WORKSPACES_OLLAMA_CACHE_GLOBAL}
rsync -a "$AI_WORKSPACES_OLLAMA_CACHE/" "$AI_WORKSPACES_OLLAMA_CACHE_GLOBAL/" || true
rm -rf "$AI_WORKSPACES_OLLAMA_CACHE"
ln -sfn  $AI_WORKSPACES_OLLAMA_CACHE_GLOBAL $AI_WORKSPACES_OLLAMA_CACHE

AI_WORKSPACES_OLLAMA_MODELS_GLOBAL=${AI_WORKSPACES_OLLAMA_MODELS_GLOBAL:-${AI_WORKSPACES}/ollama/models}
AI_WORKSPACES_OLLAMA_MODELS=${HOME}/.ollama/models
mkdir -p ${AI_WORKSPACES_OLLAMA_MODELS_GLOBAL}
rsync -a "$AI_WORKSPACES_OLLAMA_MODELS/" "$AI_WORKSPACES_OLLAMA_MODELS_GLOBAL/" || true
rm -rf "$AI_WORKSPACES_OLLAMA_MODELS"
ln -sfn  $AI_WORKSPACES_OLLAMA_MODELS_GLOBAL $AI_WORKSPACES_OLLAMA_MODELS

ln -sfn ${AI_WORKSPACES}/chromadb         ${HOME}/.cache/chromadb
ln -sfn ${AI_WORKSPACES}/huggingface      ${HOME}/.cache/huggingface
ln -sfn ${AI_WORKSPACES}/torch            ${HOME}/.cache/torch
ln -sfn ${AI_WORKSPACES}/torch_extensions ${HOME}/.cache/torch_extensions

mkdir -p ~/.bashrc.d

cat <<'EOF' > ~/.bashrc.d/40-ai.sh
# Environment Variables

export OLLAMA_MODELS=${AI_WORKSPACES}/ollama/models
export HF_HOME=${AI_WORKSPACES}/huggingface
export TORCH_HOME=${AI_WORKSPACES}/torch
export CHROMA_DB_DIR=${AI_WORKSPACES}/chromadb
export TRANSFORMERS_CACHE=${HF_HOME}
export HF_HUB_DISABLE_TELEMETRY=1
export PYTORCH_CUDA_ALLOC_CONF=max_split_size_mb:512

# Developer friendly aliases

alias oll='ollama'
alias ollps='ollama ps'
alias ollls='ollama list'
EOF

container_ai_install_success=true