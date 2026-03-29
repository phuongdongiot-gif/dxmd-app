#!/bin/bash
# Script tự động tải Flutter SDK và Build Web trên nền tảng Vercel

echo "Installing Flutter (Shallow Clone)..."
# Sử dụng --depth 1 để tải bản nhẹ nhất và nhanh nhất, giúp Vercel không bị lỗi đầy bộ nhớ
git clone https://github.com/flutter/flutter.git -b stable --depth 1
export PATH="$PATH:`pwd`/flutter/bin"

echo "Checking Flutter version..."
flutter --version

echo "Building Flutter Web..."
flutter build web --release --web-renderer canvaskit

echo "Build complete! Vercel will serve the build/web directory."
