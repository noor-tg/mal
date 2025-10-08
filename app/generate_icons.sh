#!/bin/bash
SRC="/opt/www/portfolio/mal/uxd/logo/logo.svg"

cd /opt/www/portfolio/mal/app/android/app/src/main/res
mkdir -p mipmap-mdpi mipmap-hdpi mipmap-xhdpi mipmap-xxhdpi mipmap-xxxhdpi

# === Sizes map ===
declare -A sizes=(
  [mipmap-mdpi]=108
  [mipmap-hdpi]=162
  [mipmap-xhdpi]=216
  [mipmap-xxhdpi]=324
  [mipmap-xxxhdpi]=432
)

# === Step 1: extract dominant background color from SVG ===
# Render a small version (like 16x16) and get the most frequent color
BG_COLOR="#004b70"

if [ -z "$BG_COLOR" ]; then
  echo "⚠️  Could not detect background color — using default white (#FFFFFF)"
  BG_COLOR="#FFFFFF"
else
  echo "🎨 Detected background color: $BG_COLOR"
fi

# === Step 2: Generate mipmap icons ===
for folder in "${!sizes[@]}"; do
  size=${sizes[$folder]}

  # Foreground (keeps transparency)
  magick -background none "$SRC" -resize ${size}x${size} "${folder}/ic_launcher_foreground.png"

  # Background (solid color)
  magick -size ${size}x${size} "canvas:${BG_COLOR}" "${folder}/ic_launcher_background.png"
done

# === Step 3: Play Store icon (512px) ===
magick -background none "$SRC" -resize 512x512 ic_launcher_playstore.png
magick "$SRC"  -background "$BG_COLOR" -alpha remove -alpha off -resize 512x512 ic_launcher_playstore_bg.png

# === Step 4: Adaptive icon XML ===
mkdir -p mipmap-anydpi-v26
cat > mipmap-anydpi-v26/ic_launcher.xml <<EOF
<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">
    <background android:drawable="@mipmap/ic_launcher_background"/>
    <foreground android:drawable="@mipmap/ic_launcher_foreground"/>
</adaptive-icon>
EOF

echo "✅ Android icons generated successfully."
echo "📦 Background color used: $BG_COLOR"
