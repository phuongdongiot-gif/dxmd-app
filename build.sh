#!/bin/bash
# Script tự động tải Flutter SDK và Build Web trên nền tảng Vercel
set -e # Báo lỗi và dừng script ngay nếu có 1 lệnh thất bại

echo "Installing Flutter (Shallow Clone)..."
git clone https://github.com/flutter/flutter.git -b stable --depth 1
export PATH="$PATH:$(pwd)/flutter/bin"

echo "Checking Flutter version..."
flutter --version

echo "Building Flutter Web..."
flutter build web --release --web-renderer canvaskit

echo "Organizing Output Directory for Vercel..."
rm -rf public
cp -r build/web public

echo "Build complete! Vercel will serve the 'public' directory."
