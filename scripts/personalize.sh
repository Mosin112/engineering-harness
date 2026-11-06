#!/usr/bin/env bash
# Replace the placeholders with your details before the first commit.
# Usage: scripts/personalize.sh <github-username> "<Your Name>"
set -euo pipefail

if [ "$#" -ne 2 ]; then
  echo "usage: $0 <github-username> \"<Your Name>\"" >&2
  exit 1
fi
user=$1
name=$2
cd "$(dirname "${BASH_SOURCE[0]}")/.."

files=$(grep -rlE 'YOUR-GITHUB-USERNAME|YOUR NAME' \
  --exclude-dir=.git --exclude=personalize.sh --exclude=validate.sh . || true)

for f in $files; do
  sed -i.bak "s/YOUR-GITHUB-USERNAME/${user}/g; s/YOUR NAME/${name}/g" "$f"
  rm -f "$f.bak"
done
echo "Personalized: ${files:-nothing to change}"
