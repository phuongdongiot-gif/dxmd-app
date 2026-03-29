#!/bin/bash
# Script tự động tải Flutter SDK và Build Web trên nền tảng Vercel

echo "Installing Flutter..."
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"

echo "Checking Flutter version..."
flutter --version

echo "Building Flutter Web..."
flutter build web --release --web-renderer canvaskit

echo "Build complete! Vercel will serve the build/web directory."
