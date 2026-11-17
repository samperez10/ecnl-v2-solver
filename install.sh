#!/bin/sh
set -eu
umask 077
REPOSITORY=${ECNL_SOLVER_REPOSITORY:-samperez10/ecnl-v2-solver}
BASE="https://github.com/$REPOSITORY/releases/latest/download"
if [ "${PREFIX:-}" = "/data/data/com.termux/files/usr" ]; then
  PLATFORM=termux; ARCH=$(uname -m)
  [ "$ARCH" = aarch64 ] || { echo "No ECNL Solver V2 release is available for Termux $ARCH." >&2; exit 1; }
elif [ -r /etc/alpine-release ]; then
  PLATFORM=alpine; ARCH=$(apk --print-arch)
  case "$ARCH" in x86_64|aarch64) ;; *) echo "No Alpine release is available for $ARCH." >&2; exit 1 ;; esac
elif [ -r /etc/os-release ]; then
  . /etc/os-release
  [ "${ID:-}" = ubuntu ] || { echo "This installer supports Ubuntu, Alpine, and Termux." >&2; exit 1; }
  case "${VERSION_ID:-}:$(dpkg --print-architecture)" in
    22.04:amd64) PLATFORM=ubuntu-22.04; ARCH=x86_64 ;;
    22.04:arm64) PLATFORM=ubuntu-22.04; ARCH=aarch64 ;;
    22.04:armhf) PLATFORM=ubuntu-22.04; ARCH=armhf ;;
    24.04:amd64) PLATFORM=ubuntu-24.04; ARCH=x86_64 ;;
    *) echo "No ECNL Solver V2 release is available for Ubuntu ${VERSION_ID:-unknown} $(dpkg --print-architecture)." >&2; exit 1 ;;
  esac
else
  echo "Unsupported platform. Windows users should download ECNLSolver-Portable-x86_64.exe." >&2
  exit 1
fi
for command in curl tar sha256sum; do command -v "$command" >/dev/null 2>&1 || { echo "Missing required command: $command" >&2; exit 1; }; done
download() {
  if [ -n "${GH_TOKEN:-}" ]; then curl -fsSL -H "Authorization: Bearer $GH_TOKEN" -H "Accept: application/octet-stream" "$1" -o "$2"
  else curl -fsSL "$1" -o "$2"; fi
}
WORK=$(mktemp -d "${TMPDIR:-/tmp}/ecnl-solver-v2-install.XXXXXX")
cleanup() { rm -rf -- "$WORK"; }
trap cleanup EXIT HUP INT TERM
NAME="ecnl-solver-v2-$PLATFORM-$ARCH.tar.gz"
echo "Downloading ECNL Solver V2 for $PLATFORM $ARCH..."
download "$BASE/$NAME" "$WORK/$NAME"
download "$BASE/$NAME.sha256" "$WORK/$NAME.sha256"
(cd "$WORK" && sha256sum -c "$NAME.sha256")
tar -xzf "$WORK/$NAME" -C "$WORK"
echo "Archive verified. Starting installer..."
sh "$WORK/ecnl-solver-v2-$PLATFORM-$ARCH/install.sh" "$@"
