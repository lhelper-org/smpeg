#!/bin/bash

# Script to apply all Debian patches listed in debian/patches/series
# Usage: ./apply_patches.sh

set -e  # Exit on error

PATCH_DIR="debian/patches"
SERIES_FILE="$PATCH_DIR/series"

# Check if series file exists
if [ ! -f "$SERIES_FILE" ]; then
    echo "Error: Series file not found at $SERIES_FILE"
    exit 1
fi

# Count total patches
TOTAL_PATCHES=$(grep -v "^#" "$SERIES_FILE" | grep -v "^$" | wc -l)
echo "Found $TOTAL_PATCHES patches to apply"

# Apply each patch in order
COUNTER=0
while read -r patch; do
    # Skip comments and empty lines
    if [[ "$patch" =~ ^#.*$ || -z "$patch" ]]; then
        continue
    fi
    
    COUNTER=$((COUNTER + 1))
    PATCH_PATH="$PATCH_DIR/$patch"
    
    echo "[$COUNTER/$TOTAL_PATCHES] Applying patch: $patch"
    
    if [ ! -f "$PATCH_PATH" ]; then
        echo "  Warning: Patch file not found at $PATCH_PATH"
        continue
    fi
    
    # Apply the patch with -p1 (standard for Debian patches)
    if patch -p1 < "$PATCH_PATH"; then
        echo "  Successfully applied patch: $patch"
    else
        echo "  Failed to apply patch: $patch"
        exit 1
    fi
    
done < "$SERIES_FILE"

echo "All patches applied successfully!"
exit 0
