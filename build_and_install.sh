#!/bin/bash

set -x  # Print each command before executing it

echo "Building Flutter APK in release mode..."
flutter build apk --release

echo "Installing APK to connected device using adb..."
adb install -r "build/app/outputs/flutter-apk/app-release.apk"

echo "Renaming APK to balay-rq.apk..."
mv "build/app/outputs/flutter-apk/app-release.apk" "build/app/outputs/flutter-apk/balay-rq.apk"

echo "APK built, installed, and renamed to balay-rq.apk." 