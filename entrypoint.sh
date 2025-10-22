#!/bin/bash
set -e

ROOT="${1:-.}"
EXCLUDE_DOTFILES="${2:-false}"

# Check for tree
if ! command -v tree &> /dev/null; then
    echo "Error: 'tree' command not found. Please install it on this system."
    exit 1
fi

ROOT=$(realpath "$ROOT")

echo "Generating recursive HTML directory listings from: $ROOT"
echo "Exclude dotfiles: $EXCLUDE_DOTFILES"

# Build find command dynamically
if [[ "$EXCLUDE_DOTFILES" == "true" ]]; then
    # Exclude hidden directories (starting with .)
    FIND_CMD=(find "$ROOT" -type d -name ".*" -prune -o -type d -print)
else
    FIND_CMD=(find "$ROOT" -type d -print)
fi

# Run find and process each directory
"${FIND_CMD[@]}" | while read -r DIR; do
    TITLE="Directory listing of: $(realpath "$DIR")"
    echo "Processing: $DIR"

    if [[ "$EXCLUDE_DOTFILES" == "true" ]]; then
        IGNORE_PATTERN='index.html|.*'
    else
        IGNORE_PATTERN='index.html'
    fi

    tree -H '.' \
         -L 1 \
         --noreport \
         --dirsfirst \
         -T "$TITLE" \
         -s -D \
         --charset utf-8 \
         -I "$IGNORE_PATTERN" \
         -o "$DIR/index.html" \
         "$DIR"
done

echo "All directory listings generated successfully."
