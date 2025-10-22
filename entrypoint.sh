#!/bin/bash
set -e

DIR="${1:-.}"

# Ensure tree exists
if ! command -v tree &> /dev/null; then
    echo "❌ Error: 'tree' command not found. Please install it on this system."
    exit 1
fi

# Resolve full path for clarity in title
FULLDIR=$(realpath "$DIR")
TITLE="Directory listing of: $FULLDIR"

echo "Generating recursive HTML directory listing for: $FULLDIR"

tree -H '.' \
     -L 999 \
     --noreport \
     --dirsfirst \
     -T "$TITLE" \
     -s -D \
     --charset utf-8 \
     -I 'index.html' \
     -o "$DIR/index.html" \
     "$DIR"

echo "Directory listing generated at: $DIR/index.html"
