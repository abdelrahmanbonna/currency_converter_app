# Currency Converter App

A modern Flutter application for real-time currency conversion with historical data support.

## Features

- Real-time currency conversion
- Historical exchange rates
- Support for multiple currencies
- Clean architecture with BLoC pattern
- Comprehensive test coverage

## Prerequisites

Before you begin, ensure you have met the following requirements:

### Installing Flutter

1. Download Flutter SDK from [Flutter's official website](https://flutter.dev/docs/get-started/install)
2. Extract the downloaded archive to a desired location (e.g., `C:\src\flutter` on Windows)
3. Add Flutter to your PATH:
   - Windows: Add `C:\src\flutter\bin` to your PATH environment variable
   - macOS/Linux: Add `export PATH="$PATH:[PATH_TO_FLUTTER]/flutter/bin"` to your shell profile

4. Verify installation:
```bash
flutter doctor
```
Address any issues reported by `flutter doctor` before proceeding.

### Additional Requirements

- Git for version control
- A supported IDE (VS Code, Android Studio, or IntelliJ)
- For iOS development: Xcode (Mac only)
- For Android development: Android Studio and Android SDK

## Getting Started

1. Clone the repository:
```bash
git clone https://github.com/abdelrahmanbonna/currency_converter_app.git
cd currency_converter_app
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## Running Tests

The project includes comprehensive unit tests for both Data and Domain layers.

### Running All Tests
```bash
flutter test
```

### Running Specific Test Files
```bash
# Run Data layer tests
flutter test test/Features/CurrencyConverter/Data/DataSources/currency_converter_remote_data_source_test.dart

# Run Domain layer tests
flutter test test/Features/CurrencyConverter/Domain/UseCases/get_convert_rate_use_case_test.dart
```

### Generating Mock Files
If you modify any test files that use mocks, regenerate them using:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## Project Structure

```
lib/
├── Core/                  # Core functionality and configurations
├── Features/             
│   └── CurrencyConverter/ # Main feature
│       ├── Data/         # Data layer (API, models)
│       ├── Domain/       # Business logic
│       └── Presentation/ # UI components
test/
├── Features/
│   └── CurrencyConverter/
│       ├── Data/         # Data layer tests
│       └── Domain/       # Domain layer tests
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.
