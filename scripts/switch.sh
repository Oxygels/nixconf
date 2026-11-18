#!/usr/bin/env bash
# Switch to the current config.
# Usage: scripts/switch.sh [host]   (defaults to this machine's hostname)
set -euo pipefail

host=${1:-$(hostname)}
root=$(cd "$(dirname "$0")/.." && pwd)

sudo nixos-generate-config --no-filesystems --show-hardware-config \
  > "$root/hosts/$host/hardware-configuration.nix"

nh os switch "$root" -H "$host"
