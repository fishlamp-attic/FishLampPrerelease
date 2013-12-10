#!/bin/sh

#  install-headers.sh
#  FishLampCore
#
#  Created by Mike Fullerton on 8/10/13.
#  Copyright (c) 2013 Mike Fullerton. All rights reserved.

BUILT_PRODUCTS_DIR="$1"
PRODUCT_NAME="$2"
PROJECT_DIR="$3"

# echo "$PRODUCT_NAME"
# echo "$PROJECT_DIR"
# echo "$BUILT_PRODUCTS_DIR"

dest="$BUILT_PRODUCTS_DIR/$PRODUCT_NAME"

# echo "$dest"

if [ -d "$dest" ]; then
    rm -R "$dest"
fi

mkdir -p "$dest"

function copyHeadersInDir() {
    dir="$1"
    if [ -d "$dir" ]; then
        cd "$1"
        files=`find . -name "*.h"`

        for file in $files; do
            filename=`basename "$file"`
            destpath="$dest/$filename"
            echo "copied $file to $destpath"
            cp "$file" "$destpath"
        done
    fi
}

copyHeadersInDir "$PROJECT_DIR/Classes"
copyHeadersInDir "$PROJECT_DIR/../Classes"
