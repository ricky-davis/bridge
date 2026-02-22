#!/usr/bin/env bash
set -euo pipefail

# Downloads and installs a project-local Go toolchain into .tools/go/
# Usage:
#   scripts/bootstrap-go.sh 1.22.10
#   scripts/bootstrap-go.sh 1.23.5

VERSION="${1:-}"
if [[ -z "${VERSION}" ]]; then
  echo "usage: $0 <go-version> (e.g. 1.22.10)" >&2
  exit 2
fi

OS="linux"
ARCH="amd64"

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TOOLS_DIR="${ROOT_DIR}/.tools"
GOROOT="${TOOLS_DIR}/go"

mkdir -p "${TOOLS_DIR}"

TARBALL="go${VERSION}.${OS}-${ARCH}.tar.gz"
URL="https://go.dev/dl/${TARBALL}"

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

echo "Installing into ${GOROOT}..."
rm -rf "${GOROOT}.tmp" "${GOROOT}"
mkdir -p "${GOROOT}.tmp"

tar -C "${GOROOT}.tmp" -xzf "${TMP_DIR}/${TARBALL}"
# Tarball contains a top-level 'go/' directory.
mv "${GOROOT}.tmp/go" "${GOROOT}"
rm -rf "${GOROOT}.tmp"

echo "Done. Go version:"
"${GOROOT}/bin/go" version
