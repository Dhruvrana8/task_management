# Task Management App 📝

A modern, cross-platform task management application built with Flutter that helps you organize and track your tasks efficiently. This app features a clean, intuitive interface with support for creating, editing, completing, and deleting tasks.

## ✨ Features

- **Task Management**
  - ✅ Create new tasks with title and description
  - ✏️ Edit existing tasks
  - 🎯 Mark tasks as complete or pending
  - 🗑️ Delete tasks
- **Smart Organization**

  - 📋 Separate views for pending and completed tasks
  - 🔄 Pull-to-refresh functionality
  - ♾️ Infinite scroll with pagination
  - 📊 Real-time task status updates

- **User Experience**
  - 🎨 Clean, modern UI with custom color scheme
  - 📱 Cross-platform support (iOS, Android, Web, Windows, macOS, Linux)
  - ⚡ Fast and responsive interface
  - 🔤 Google Fonts integration for beautiful typography
  - 📝 Character counter for task descriptions (500 character limit)

## 🏗️ Architecture

This Flutter app follows a clean architecture pattern with:

- **Screens**: Organized by feature (HomeScreen, AddNewTask, EditTask)
- **Components**: Reusable UI components (TaskCard, CustomButton)
- **Models**: Data models for API responses
- **Constants**: Centralized colors and strings
- **Environment Configuration**: Secure API configuration using `.env` files

## 🔗 Backend

This app connects to a Django REST Framework backend. The backend repository can be found here:
👉 [todo_app_django_rest_framework](https://github.com/Dhruvrana8/todo_app_django_rest_framework)

## 📋 Prerequisites

Before you begin, ensure you have the following installed:

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (>=3.4.3 <4.0.0)
- [Dart SDK](https://dart.dev/get-dart) (comes with Flutter)
- An IDE (VS Code, Android Studio, or IntelliJ IDEA)
- A device or emulator to run the app

## 🚀 Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/Dhruvrana8/task_management.git
cd task_management
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Configure Environment Variables

Create a `.env` file in the root directory of the project:

```bash
touch .env
```

Add your API base URL to the `.env` file:

```env
API_BASE_URL=http://your-api-url.com/api
```

> **Note**: Replace `http://your-api-url.com/api` with your actual Django backend URL. For local development, this might be `http://localhost:8000/api` or `http://10.0.2.2:8000/api` for Android emulator.

### 4. Run the App

```bash
flutter run
```

To run on a specific platform:

```bash
# iOS
flutter run -d ios

# Android
flutter run -d android

# Web
flutter run -d chrome

# Windows
flutter run -d windows

# macOS
flutter run -d macos

# Linux
flutter run -d linux
```

## 📁 Project Structure

```
lib/
├── main.dart                          # App entry point
├── NavigatorObserver.dart             # Navigation observer
├── constants/
│   ├── colors.dart                    # Color definitions
│   └── strings.dart                   # App-wide strings
└── screens/
    ├── HomeScreen/
    │   ├── home_screen.dart           # Main task list screen
    │   ├── components/
    │   │   └── TaskCard.dart          # Task card widget
    │   ├── task_response.dart         # API response models
    │   ├── strings.dart               # Screen-specific strings
    │   └── urls.dart                  # API endpoints
    ├── AddNewTask/
    │   ├── add_new_task.dart          # Create task screen
    │   ├── strings.dart               # Screen-specific strings
    │   └── urls.dart                  # API endpoints
    ├── EditTask/
    │   ├── edit_task.dart             # Edit task screen
    │   ├── components/
    │   │   └── Custombutton.dart      # Custom button widget
    │   ├── strings.dart               # Screen-specific strings
    │   └── urls.dart                  # API endpoints
    └── SplashScreen/
        ├── splash_screen.dart         # Splash screen
        └── strings.dart               # Screen-specific strings
```

## 🔌 API Integration

The app communicates with the Django REST Framework backend using the following endpoints:

### Get Tasks (Paginated)

```
GET /api/tasks/?page={page_number}&status_code={INCOMPLETE|COMPLETED}
```

### Create Task

```
POST /api/tasks/
Body: {
  "task_title": "string",
  "task_description": "string"
}
```

### Get Single Task

```
GET /api/tasks/?id={task_id}
```

### Update Task

```
PUT /api/tasks/
Body: {
  "id": number,
  "task_title": "string",           // Optional
  "task_description": "string",     // Optional
  "is_completed": boolean,          // Optional
  "is_deleted": boolean             // Optional
}
```

## 📦 Dependencies

- **flutter**: SDK for building the app
- **cupertino_icons** (^1.0.6): iOS-style icons
- **google_fonts** (6.2.1): Custom fonts from Google Fonts
- **flutter_dotenv** (5.1.0): Environment variable management
- **http**: HTTP client for API calls (implicit dependency)

## 🎨 Customization

### Colors

The app uses a custom color scheme defined in `lib/constants/colors.dart`. You can modify these colors to match your brand:

```dart
class CustomColors {
  static const primary = Color(0xFF...);
  static const secondary = Color(0xFF...);
  // ... other colors
}
```

### Strings

All user-facing strings are centralized in the `strings.dart` files, making it easy to:

- Update text throughout the app
- Add internationalization (i18n) support in the future

## 🧪 Testing

Run tests using:

```bash
flutter test
```

## 🔨 Building for Production

### Android

```bash
flutter build apk --release
# or for app bundle
flutter build appbundle --release
```

### iOS

```bash
flutter build ios --release
```

### Web

```bash
flutter build web --release
```

### Desktop

```bash
# Windows
flutter build windows --release

# macOS
flutter build macos --release

# Linux
flutter build linux --release
```

## 🐛 Troubleshooting

### Common Issues

1. **API Connection Failed**

   - Verify your `.env` file exists and contains the correct `API_BASE_URL`
   - Ensure the backend server is running
   - For Android emulator, use `10.0.2.2` instead of `localhost`

2. **Dependencies Not Found**

   - Run `flutter pub get` to install all dependencies
   - Try `flutter clean` followed by `flutter pub get`

3. **Build Errors**
   - Ensure you're using Flutter SDK >=3.4.3
   - Run `flutter doctor` to check for any issues

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes:

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

## 👤 Author

**Dhruv Rana**

- GitHub: [@Dhruvrana8](https://github.com/Dhruvrana8)

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Django REST Framework for the robust backend
- Google Fonts for beautiful typography

## 📞 Support

If you have any questions or run into issues, please:

- Open an issue in this repository
- Check the [Flutter documentation](https://flutter.dev/docs)
- Review the [backend repository](https://github.com/Dhruvrana8/todo_app_django_rest_framework)

---

Made with ❤️ using Flutter
