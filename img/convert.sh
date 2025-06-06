#!/bin/bash

# Original image
INPUT="bremontix.png"
NAME=$(basename "$INPUT" | cut -f 1 -d '.')

echo $NAME

# List of sizes (WIDTHxHEIGHT)
SIZES=("64x64" "128x128" "256x256" "512x512" "1024x1024")

# Output directory
OUTDIR="resized"
mkdir -p "$OUTDIR"

# Loop through sizes and generate images
for SIZE in "${SIZES[@]}"; do
    echo "$OUTDIR/${NAME}_${SIZE}.png"
    convert "$INPUT" -resize "$SIZE" "$OUTDIR/${NAME}_${SIZE}.png"
done

