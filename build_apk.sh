#!/bin/bash

# Balay RQ APK & App Bundle Builder Script
# This script builds APKs and App Bundles with custom naming including version information

echo "🚀 Balay RQ APK & App Bundle Builder"
echo "===================================="

# Get current version from pubspec.yaml
VERSION=$(grep "version:" pubspec.yaml | sed 's/version: //')
VERSION_NAME=$(echo $VERSION | cut -d'+' -f1)
VERSION_CODE=$(echo $VERSION | cut -d'+' -f2)

echo "📱 Current Version: $VERSION_NAME+$VERSION_CODE"
echo ""

# Function to build APK
build_apk() {
    local build_type=$1
    local output_name=$2
    
    echo "🔨 Building $build_type APK..."
    
    # Clean previous builds
    flutter clean
    
    # Get dependencies
    flutter pub get
    
    # Build APK
    flutter build apk --$build_type
    
    # Move and rename APK
    local source_path="build/app/outputs/flutter-apk/app-$build_type.apk"
    local target_path="build/app/outputs/flutter-apk/$output_name.apk"

    
    if [ -f "$source_path" ]; then
        mv "$source_path" "$target_path"
        echo "✅ $build_type APK built successfully: $output_name.apk"
        echo "📁 Location: $target_path"
        # Install APK on device
        echo "🔄 Installing $output_name.apk on device..."
        adb install -r "$target_path"
    else
        echo "❌ Failed to build $build_type APK"
        return 1
    fi
    
    echo ""
}

# Function to build App Bundle
build_app_bundle() {
    local build_type=$1
    local output_name=$2
    
    echo "📦 Building $build_type App Bundle..."
    
    # Clean previous builds
    flutter clean
    
    # Get dependencies
    flutter pub get
    
    # Build App Bundle
    flutter build appbundle --$build_type
    
    # Move and rename App Bundle
    local source_path="build/app/outputs/bundle/${build_type}/app-${build_type}.aab"
    local target_path="build/app/outputs/bundle/${build_type}/$output_name.aab"

    
    if [ -f "$source_path" ]; then
        mv "$source_path" "$target_path"
        echo "✅ $build_type App Bundle built successfully: $output_name.aab"
        echo "📁 Location: $target_path"
    else
        echo "❌ Failed to build $build_type App Bundle"
        return 1
    fi
    
    echo ""
}

# Build options
echo "Select build type:"
echo "1) Release APK (Signed)"
echo "2) Debug APK (Unsigned)"
echo "3) Release App Bundle (Signed)"
echo "4) Debug App Bundle (Unsigned)"
echo "5) Both APKs (Release & Debug)"
echo "6) Both App Bundles (Release & Debug)"
echo "7) Release APK + Release App Bundle"
echo "8) All (APKs + App Bundles)"
echo ""

read -p "Enter your choice (1-8): " choice

case $choice in
    1)
        build_apk "release" "balay-rq-v$VERSION_NAME-$VERSION_CODE"
        ;;
    2)
        build_apk "debug" "balay-rq-debug-v$VERSION_NAME-$VERSION_CODE"
        ;;
    3)
        build_app_bundle "release" "balay-rq-v$VERSION_NAME-$VERSION_CODE"
        ;;
    4)
        build_app_bundle "debug" "balay-rq-debug-v$VERSION_NAME-$VERSION_CODE"
        ;;
    5)
        build_apk "release" "balay-rq-v$VERSION_NAME-$VERSION_CODE"
        build_apk "debug" "balay-rq-debug-v$VERSION_NAME-$VERSION_CODE"
        ;;
    6)
        build_app_bundle "release" "balay-rq-v$VERSION_NAME-$VERSION_CODE"
        build_app_bundle "debug" "balay-rq-debug-v$VERSION_NAME-$VERSION_CODE"
        ;;
    7)
        build_apk "release" "balay-rq-v$VERSION_NAME-$VERSION_CODE"
        build_app_bundle "release" "balay-rq-v$VERSION_NAME-$VERSION_CODE"
        ;;
    8)
        build_apk "release" "balay-rq-v$VERSION_NAME-$VERSION_CODE"
        build_apk "debug" "balay-rq-debug-v$VERSION_NAME-$VERSION_CODE"
        build_app_bundle "release" "balay-rq-v$VERSION_NAME-$VERSION_CODE"
        build_app_bundle "debug" "balay-rq-debug-v$VERSION_NAME-$VERSION_CODE"
        ;;
    *)
        echo "❌ Invalid choice. Exiting..."
        exit 1
        ;;
esac

echo "🎉 Build process completed!"
echo ""
echo "📋 Summary:"
echo "- Version Name: $VERSION_NAME"
echo "- Version Code: $VERSION_CODE"
echo "- APK(s) location: build/app/outputs/flutter-apk/"
echo "- App Bundle(s) location: build/app/outputs/bundle/" 