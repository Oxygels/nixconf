#!/usr/bin/env bash
# Install NixOS onto the disk mounted by partition.sh.
# Usage: scripts/install.sh <host>   (e.g. tower, laptop)
set -euo pipefail

if [ $# -ne 1 ]; then
  echo "usage: $0 <host>" >&2
  exit 1
fi
host=$1
root=$(cd "$(dirname "$0")/.." && pwd)

mountpoint -q /mnt || { echo "/mnt not mounted; run partition.sh first" >&2; exit 1; }

sudo nixos-install --option extra-experimental-features "nix-command flakes" --root /mnt --flake "$root#$host"
