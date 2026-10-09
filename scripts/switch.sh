#!/usr/bin/env bash
# Switch to the current config.
# Usage: scripts/switch.sh [host]   (defaults to this machine's hostname)
set -euo pipefail

host=${1:-$(hostname)}
root=$(cd "$(dirname "$0")/.." && pwd)

sudo nixos-rebuild switch --option extra-experimental-features "nix-command flakes" --flake "$root#$host"
