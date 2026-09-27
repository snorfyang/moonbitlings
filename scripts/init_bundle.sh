#!/bin/sh
# Create an independent exercise workspace from a moonbitlings bundle.
set -eu

if [ "$#" -ne 1 ]; then
  echo "usage: ./init.sh DIRECTORY" >&2
  exit 2
fi

target=$1
if [ -e "$target" ] || [ -L "$target" ]; then
  echo "error: target already exists: $target" >&2
  exit 2
fi
parent=$(dirname "$target")
if [ ! -d "$parent" ]; then
  echo "error: parent directory does not exist: $parent" >&2
  exit 2
fi

bundle=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
staging=$(mktemp -d "$parent/.moonbitlings-init.XXXXXX")
trap 'rm -rf "$staging"' EXIT HUP INT TERM
cp -R "$bundle/exercises" "$staging/exercises"
cp -R "$bundle/templates" "$staging/templates"
cp -R "$bundle/guides" "$staging/guides"
cp "$bundle/moonbitlings" "$staging/moonbitlings"
cp "$bundle/README.md" "$staging/README.md"
mv "$staging" "$target"
trap - EXIT HUP INT TERM
echo "Created $target"
echo "Run: cd $target && ./moonbitlings"
