#!/bin/bash
set -e

ROOT="${1:-.}"
EXCLUDE_DOTFILES="${2:-true}"
SHOW_LAST_MODIFIED="${3:-false}"

# Check for tree
if ! command -v tree &> /dev/null; then
    echo "Error: 'tree' command not found. Please install it on this system."
    exit 1
fi

ROOT=$(realpath "$ROOT")

echo "Generating recursive HTML directory listings from: $ROOT"
echo "Exclude dotfiles: $EXCLUDE_DOTFILES (always excluding .git)"
echo "Show last modified dates: $SHOW_LAST_MODIFIED"

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

    # Build ignore pattern
    if [[ "$EXCLUDE_DOTFILES" == "true" ]]; then
        IGNORE_PATTERN='index.html|.*'
    else
        IGNORE_PATTERN='index.html'
    fi

    # Decide tree options
    TREE_OPTS=(-H '.' -L 1 --noreport --dirsfirst -T "$TITLE" --charset utf-8 -I "$IGNORE_PATTERN" -o "$DIR/index.html" "$DIR")
    [[ "$SHOW_LAST_MODIFIED" == "true" ]] && TREE_OPTS+=(-s -D)

    tree "${TREE_OPTS[@]}"
done

echo "All directory listings generated successfully."
