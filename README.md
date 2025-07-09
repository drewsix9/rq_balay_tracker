# RQ Balay Tracker

A Flutter application for tracking electricity and water consumption with billing features.

---

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Architecture](#architecture)
- [Tech Stack](#tech-stack)
- [Directory Structure](#directory-structure)
- [Setup Instructions](#setup-instructions)
- [Usage](#usage)
- [Screenshots](#screenshots)
- [Contributing](#contributing)
- [License](#license)
- [Support](#support)

---

## Overview

**RQ Balay Tracker** is a modern Flutter application designed to help users monitor and manage their electricity and water consumption. The app provides detailed billing history, interactive consumption charts, and supports both mobile and tablet devices with a responsive UI. It leverages Firebase for authentication, notifications, and data management, ensuring a secure and seamless experience.

---

## Features

- **User Authentication**
  - Secure login with support for biometric authentication (Face ID, Fingerprint)
- **Bill Tracking & History**
  - View, filter, and analyze past electricity and water bills
- **Consumption Charts**
  - Interactive charts for electricity and water usage (powered by [fl_chart](https://pub.dev/packages/fl_chart))
- **Responsive Design**
  - Optimized layouts for both mobile and tablet devices
- **Shimmer Loading States**
  - Smooth loading placeholders for data fetching
- **Firebase Integration**
  - Authentication, Firestore, and FCM (push notifications)
- **Modern UI/UX**
  - Clean, accessible, and user-friendly interface

---

## Architecture

The project follows a **feature-based architecture** with a clear separation of concerns:

- **Data Layer**: Handles data sources, models, and repositories
- **Domain Layer**: Contains business logic, entities, and use cases
- **Presentation Layer**: UI widgets, screens, and view models/providers
- **Core**: Shared utilities, services, themes, and reusable widgets

This structure ensures maintainability, scalability, and testability.

---

## Tech Stack

- **Flutter** (UI framework)
- **Provider** (state management)
- **Firebase** (authentication, Firestore, FCM)
- **fl_chart** (charts and graphs)
- **Shimmer** (loading placeholders)

---

## Directory Structure

```
lib/
  core/
    config/           # App configuration
    global/           # Global models (e.g., current user)
    logger/           # Logging utilities
    model/            # Shared models
    providers/        # Shared providers
    services/         # Shared services (API, device info, etc.)
    theme/            # App colors, gradients, text styles
    usecases/         # Shared use cases
    utils/            # Utility functions/helpers
    widgets/          # Reusable widgets (buttons, inputs, etc.)
  features/
    auth/
      data/           # Data sources, models, repositories
      domain/         # Entities, repositories, use cases
      presentation/   # Screens, widgets (login, etc.)
    bills/
      data/           # Bill models, services
      presentation/   # Bill screens, shimmers, widgets
    charts/
      model/          # Chart models
      view/           # Chart screens, shimmers, widgets
      viewmodel/      # Chart view models
    landing_page/
      model/          # Landing page models
      view/           # Landing page screens, widgets, shimmers
      viewmodel/      # Landing page view models
    profile/
      presentation/   # Profile screens, widgets, shimmers
      viewmodel/      # Profile view models
```

---

## Setup Instructions

### 1. Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (latest stable)
- [Dart](https://dart.dev/get-dart)
- [Firebase CLI](https://firebase.google.com/docs/cli) (for Firebase setup)

### 2. Clone the Repository

```bash
git clone https://github.com/your-username/rq_balay_tracker.git
cd rq_balay_tracker
```

### 3. Install Dependencies

```bash
flutter pub get
```

### 4. Firebase Configuration

- Create a Firebase project at [Firebase Console](https://console.firebase.google.com/)
- Add Android/iOS apps to your Firebase project
- Download `google-services.json` (Android) and/or `GoogleService-Info.plist` (iOS) and place them in the appropriate directories:
  - `android/app/google-services.json`
  - `ios/Runner/GoogleService-Info.plist`
- Update `lib/firebase_options.dart` using the [FlutterFire CLI](https://firebase.flutter.dev/docs/cli/)

### 5. Run the App

```bash
flutter run
```

---

## Usage

- **Login**: Authenticate using email/password or biometrics (if enabled)
- **View Bills**: Navigate to the Bills screen to see your billing history and details
- **Analyze Consumption**: Use the Charts section to view electricity and water usage trends
- **Responsive UI**: The app adapts to both mobile and tablet layouts automatically
- **Notifications**: Receive push notifications for important updates (ensure notification permissions are granted)

---

## Screenshots

Screenshots of the app are available in the repository:

- `mobile_01.png`, `mobile_02.png`, ...
- `tablet_10_inch_01.png`, `tablet_7_inch_01.png`, ...

---

## Contributing

We welcome contributions! Please follow these guidelines:

### Code Style

- Use `snake_case` for file names
- Use `camelCase` for variables and methods
- Use `PascalCase` for class names
- Follow the [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Keep lines under 80 characters when possible

### Workflow

- Fork the repository and create a feature branch
- Write clear, descriptive commit messages
- Ensure your code passes all tests and lints
- Submit a pull request with a detailed description

### Testing

- Write unit tests for business logic and services
- Add widget tests for UI components
- Use mocks for external dependencies
- Run tests with:
  ```bash
  flutter test
  ```

---

## License

[PLACEHOLDER: Add your license information here]

---

## Support

[PLACEHOLDER: Add your support contact or issue tracker link here]
