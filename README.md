# Flutter Range Indicator

A robust, dynamic range visualization application built with Flutter. This project was developed as a solution to a specific developer assignment, demonstrating clean architecture, reactive state management, and custom UI rendering.

## 📋 Assignment Overview

The goal was to build a Flutter screen consisting of a numeric **TextField** and a dynamic **Bar Widget** that visually plots the input value against multiple reference ranges fetched from an API.

**Key Requirements Met:**
*   ✅ **Reactive State Management**: Used `Provider` (ChangeNotifier) to manage state, used for business logic updates.
*   ✅ **Clean Architecture**: strict separation of Business Logic (Providers), Data (Models/Services), and UI (Screens/Widgets).
*   ✅ **API Integration**: Fetches range metadata from a secured external API with Bearer token authentication.
*   ✅ **Dynamic Rendering**: The `RangeBar` widget automatically adjusts section widths, colors, and labels based on the API response.
*   ✅ **Error Handling**: Gracefully handles network failures, timeouts, and empty states with a retry mechanism.
*   ✅ **Input Validation**: Supports decimal inputs and enforces logical limits (e.g., < 10,000).

## 🚀 Features

*   **Dynamic Range Bar**: A custom-painted widget (`CustomPainter`) that draws range segments, labels, and a triangular indicator with absolute precision.
*   **Smart Input Handling**:
    *   Accepts decimal values (e.g., `10.56`).
    *   Updates the visualization in real-time.
    *   Hides the indicator when input is empty.
*   **Polished User Experience**:
    *   **Splash Screen**: Custom branded launch screen that pre-loads data.
    *   **Loading States**: Clear visual feedback during data fetching.
    *   **Exit Confirmation**: Prevents accidental app closure via back button or logout.
*   **Robust Error Views**: Specific messaging for internet connection issues vs. general errors.

## 🛠️ Tech Stack

*   **Flutter**: UI Toolkit (v3.5.4+)
*   **Provider**: State Management
*   **Http**: API Networking
*   **Cupertino Icons**: iOS-style assets

## 📂 Project Structure

```
lib/
├── main.dart               # App entry point
├── models/
│   └── range_model.dart    # Data model for parsing API JSON
├── providers/
│   └── range_provider.dart # State management and business logic
├── services/
│   └── range_api_service.dart # API calls and error handling
├── screens/
│   ├── splash_screen.dart  # Initial loading screen
│   └── range_screen.dart   # Main UI with input and visualization
└── widgets/
    └── range_bar.dart      # CustomPainter widget for the range bar
```

## 🏃‍♂️ How to Run

1.  **Clone the repository**:
    ```bash
    git clone <repository-url>
    ```
2.  **Install dependencies**:
    ```bash
    flutter pub get
    ```
3.  **Run the app**:
    ```bash
    flutter run
    ```

## 📸 Visuals

The application features a clean, modern UI with:
*   **Splash Screen**: Black background with logo.
*   **Main Screen**: Clean white interface with card-based layout.
*   **Range Bar**: Color-coded segments with precise value indicators.

---
