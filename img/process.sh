#!/bin/bash

# Image processing script
# Requirements:
#   sudo apt install imagemagick webp jpegoptim optipng

# Usage:
#   ./process_images.sh /path/to/input

INDIR=$1
if [ -z "$INDIR" ]; then
  echo "Usage: $0 <input_directory>"
  exit 1
fi

# Output directories
OUT_PNG="o/png"
OUT_WEBP="o/webp"
mkdir -p "$OUT_PNG" "$OUT_WEBP"

# Target sizes
SIZES=("64x64" "128x128" "256x256" "512x512" "1024x1024")

# Loop over image files
for INPUT in "$INDIR"/*.{jpg,jpeg,png}; do
  [ -e "$INPUT" ] || continue
  NAME=$(basename "$INPUT" | cut -f 1 -d '.')
  echo "🔧 Processing: $NAME"

  for SIZE in "${SIZES[@]}"; do
    # Temporary PNG path
    OUT_PNG_PATH="${OUT_PNG}/${NAME}_${SIZE}.png"
    OUT_WEBP_PATH="${OUT_WEBP}/${NAME}_${SIZE}.webp"

    # --- 1️⃣ Resize (preserve aspect ratio, fill smaller side)
    convert "$INPUT" -resize "$SIZE" -strip "$OUT_PNG_PATH"

    # --- 2️⃣ Optimize PNG ---
    optipng -o7 -quiet "$OUT_PNG_PATH"

    # --- 3️⃣ Optimize JPEG (if source was JPG) ---
    if [[ "$INPUT" == *.jpg || "$INPUT" == *.jpeg ]]; then
      jpegoptim --strip-all --max=85 --quiet "$OUT_PNG_PATH" 2>/dev/null
    fi

    # --- 4️⃣ Convert & optimize to WebP ---
    cwebp -q 80 "$OUT_PNG_PATH" -o "$OUT_WEBP_PATH" >/dev/null 2>&1
  done
done

echo "✅ Done!"
echo "Optimized PNGs: $OUT_PNG"
echo "Optimized WebPs: $OUT_WEBP"
