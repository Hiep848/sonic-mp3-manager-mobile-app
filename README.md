# Sonic: Personal Audio Journal

**Sonic** is a modern mobile application designed to verify the concept of a "Personal Audio Journal". It allows users to capture their daily thoughts, moments, and feelings through voice recordings, organized with rich metadata like moods, hashtags, and albums.

> **Note**: This project is currently in the **Mock Prototype** phase. Data persistence and authentication are simulated locally to demonstrate the UI/UX flows.

## ✨ Features

### 🎙️ Journaling
-   **Audio Feed**: Browse your timeline of audio memories.
-   **Upload/Record**: Create new entries with:
    -   Title & Description.
    -   Date selection.
    -   **Mood tracking** (Happy, Sad, Neutral, etc.).
    -   **Hashtags** for organization.
    -   **Photo attachments**.
    -   **Album assignment**.
-   **Playback**: Quick audio preview and detailed playback view.

### 🗂️ Organization
-   **Albums**: Group related entries (e.g., "Travel 2024", "Daily Thoughts").
-   **Search**: Filter entries by keywords or tags.

### ⚙️ Settings & Customization
-   **Localization**: Fully localized in **English** and **Vietnamese**.
-   **Theme**: Optimized for readability with a clean, modern UI (Manrope font).
-   **Account**: Profile management and secure logout flows.

## 🛠️ Technology Stack

This project uses a robust, scalable architecture suitable for production apps:

-   **Framework**: [Flutter](https://flutter.dev/) (>=3.0.0)
-   **Language**: Dart
-   **State Management**: [Riverpod v2](https://riverpod.dev/) (+ Hooks & Generators)
-   **Routing**: [GoRouter](https://pub.dev/packages/go_router)
-   **Networking**: [Dio](https://pub.dev/packages/dio)
-   **Data Class/Immutable**: [Freezed](https://pub.dev/packages/freezed) & [JsonSerializable](https://pub.dev/packages/json_serializable)
-   **Localization**: `flutter_localizations` & `intl`

## 🚀 Getting Started

Follow these steps to set up and run the project locally.

### Prerequisites
-   [Flutter SDK](https://docs.flutter.dev/get-started/install) installed and configured.
-   An IDE (VS Code or Android Studio) with Flutter plugins.

### Installation

1.  **Clone the repository**:
    ```bash
    git clone https://github.com/Hiep848/sonic-mp3-manager-mobile-app.git
    cd sonic-mp3-manager-mobile-app
    ```

2.  **Install dependencies**:
    ```bash
    flutter pub get
    ```

3.  **Generate Code**:
    This project uses code generation for Riverpod, Freezed, and JSON serialization. Run this command to generate the necessary files (`*.g.dart`, `*.freezed.dart`):
    ```bash
    dart run build_runner build --delete-conflicting-outputs 
    ```

4.  **Generate Localization**:
    Generate the localization delegates from the ARB files:
    ```bash
    flutter gen-l10n
    ```

5.  **Run the App**:
    ```bash
    flutter run
    ```

## 📂 Project Structure

The project follows a **Feature-First** architecture:

```
lib/
├── l10n/                   # Localization files (ARB & generated)
├── src/
│   ├── app.dart            # App entry point & global config
│   ├── core/               # Shared utilities (Theme, Constants, Routing)
│   └── features/           # Feature modules
│       ├── auth/           # Login, Register
│       ├── diary/          # Feed, Detail, Upload, Albums (Main Feature)
│       └── home/           # Navigation Shell
└── main.dart               # Bootstrap
```

## 🗺️ Roadmap / Future Work

-   [ ] **Backend Integration**: Replace mock repositories with real API endpoints.
-   [ ] **Real Recording**: Implement actual microphone recording logic (currently simulates file picking).
-   [ ] **Cloud Sync**: Sync entries across devices.
-   [ ] **Editing**: Allow modification of existing journal entries.
-   [ ] **Dark Mode**: Complete the dark theme implementation.

---
*Created by Tran Dai Hiep*
