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
echo "Exclude dotfiles: $EXCLUDE_DOTFILES (always excluding .git)"

# Build find command dynamically
if [[ "$EXCLUDE_DOTFILES" == "true" ]]; then
    # Exclude .git and all hidden directories
    FIND_CMD=(find "$ROOT" \
        \( -name ".git" -o -name ".*" \) -type d -prune -o \
        -type d -print)
else
    # Only exclude .git
    FIND_CMD=(find "$ROOT" \
        -name ".git" -type d -prune -o \
        -type d -print)
fi

# Run find and process each directory
"${FIND_CMD[@]}" | while read -r DIR; do
    # Get path relative to root
    REL_PATH=$(realpath --relative-to="$ROOT" "$DIR")
    [[ "$REL_PATH" == "." ]] && REL_PATH=""  # root folder shows as /
    TITLE="Directory listing of: /$REL_PATH"

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
