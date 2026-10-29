#!/usr/bin/env bash
# Partition, format (LUKS) and mount a disk with disko. DESTROYS the disk.
# Usage: scripts/partition.sh /dev/nvme0n1
set -euo pipefail

if [ $# -ne 1 ]; then
  echo "usage: $0 <device>" >&2
  exit 1
fi
device=$1
root=$(cd "$(dirname "$0")/.." && pwd)

lsblk "$device"
read -r -p "Wipe $device? Type 'yes': " answer
[ "$answer" = yes ] || exit 1

sudo nix --extra-experimental-features "nix-command flakes" run github:nix-community/disko -- \
  --mode destroy,format,mount \
  "$root/modules/nixos/core/disk-config.nix" \
  --argstr device "$device"
