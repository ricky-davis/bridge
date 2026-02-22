#!/usr/bin/env bash
set -euo pipefail

# Downloads and installs a project-local Node.js toolchain into .tools/node/
# Usage:
#   scripts/bootstrap-node.sh 22.22.0

VERSION="${1:-}"
if [[ -z "${VERSION}" ]]; then
  echo "usage: $0 <node-version> (e.g. 22.22.0)" >&2
  exit 2
fi

OS="linux"
ARCH="x64"

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TOOLS_DIR="${ROOT_DIR}/.tools"
NODE_HOME="${TOOLS_DIR}/node"

mkdir -p "${TOOLS_DIR}"

TARBALL="node-v${VERSION}-${OS}-${ARCH}.tar.xz"
URL="https://nodejs.org/dist/v${VERSION}/${TARBALL}"

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "${TMP_DIR}"' EXIT

echo "Downloading ${URL}..."
if command -v curl >/dev/null 2>&1; then
  curl -fsSL -o "${TMP_DIR}/${TARBALL}" "${URL}"
elif command -v wget >/dev/null 2>&1; then
  wget -qO "${TMP_DIR}/${TARBALL}" "${URL}"
else
  echo "error: need curl or wget" >&2
  exit 1
fi

echo "Installing into ${NODE_HOME}..."
rm -rf "${NODE_HOME}.tmp" "${NODE_HOME}"
mkdir -p "${NODE_HOME}.tmp"

# Tarball contains a top-level 'node-vX.Y.Z-linux-x64/' directory.
tar -C "${NODE_HOME}.tmp" -xJf "${TMP_DIR}/${TARBALL}"
mv "${NODE_HOME}.tmp/node-v${VERSION}-${OS}-${ARCH}" "${NODE_HOME}"
rm -rf "${NODE_HOME}.tmp"

echo "Done. Node version:"
"${NODE_HOME}/bin/node" --version

# npm is a script that expects `node` on PATH via /usr/bin/env.
# Ensure PATH includes the freshly installed toolchain before calling npm.
PATH="${NODE_HOME}/bin:${PATH}"
export PATH
"${NODE_HOME}/bin/npm" --version
