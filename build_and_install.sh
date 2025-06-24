#!/bin/bash

# Build the Flutter APK in release mode
flutter build apk --release

# Install the APK to a connected device
adb install -r "build/app/outputs/flutter-apk/app-release.apk"

# Rename the APK to balay-rq.apk
mv "build/app/outputs/flutter-apk/app-release.apk" "build/app/outputs/flutter-apk/balay-rq.apk"

echo "APK built, installed, and renamed to balay-rq.apk." 