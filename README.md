# 🏆 Salman Quiz App

<p align="center">
  <img src="assets/images/logo.png" alt="Salman Quiz App Logo" width="120" height="120" />
</p>

<p align="center">
  <strong>A feature-rich, cross-platform Quiz Application built with Flutter & Firebase</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter" alt="Flutter" />
  <img src="https://img.shields.io/badge/Dart-%3E%3D3.0-0175C2?logo=dart" alt="Dart" />
  <img src="https://img.shields.io/badge/Firebase-Backend-FFCA28?logo=firebase" alt="Firebase" />
  <img src="https://img.shields.io/badge/Provider-State%20Management-purple" alt="Provider" />
  <img src="https://img.shields.io/badge/Version-2.0.0-brightgreen" alt="Version" />
  <img src="https://img.shields.io/badge/License-Private-red" alt="License" />
</p>

---

## 📋 Table of Contents

- [About the Project](#-about-the-project)
- [Key Features](#-key-features)
- [Tech Stack](#-tech-stack)
- [Architecture & Design Patterns](#-architecture--design-patterns)
- [Project Structure](#-project-structure)
- [Firebase Database Schema](#-firebase-database-schema)
- [State Management](#-state-management)
- [Responsive Design](#-responsive-design)
- [Screenshots](#-screenshots)
- [Prerequisites](#-prerequisites)
- [Installation & Setup](#-installation--setup)
- [Running the App](#-running-the-app)
- [Building for Production](#-building-for-production)
- [Dependencies](#-dependencies)
- [Contributing](#-contributing)
- [Resources](#-resources)

---

## 📖 About the Project

**Salman Quiz App** is a full-featured quiz application designed for educational environments such as schools, colleges, and coaching institutes. The app supports two distinct user roles — **Faculty** (quiz creators) and **Students** (quiz participants) — enabling a complete quiz lifecycle from creation to evaluation.

Faculty members can create quizzes with multiple-choice questions, assign difficulty levels, set custom time limits, delete quizzes, and review student performance. Students can browse available quizzes from their assigned teachers, participate in timed quizzes, and track their scores — all in real time via Firebase. Once a student completes a quiz, it is automatically hidden from their available quizzes.

The application is built with **Flutter** for cross-platform support (Android, iOS, Web, Windows, macOS, Linux) and uses **Firebase** (Authentication + Cloud Firestore) as its serverless backend.

---

## ✨ Key Features

### 👨‍🏫 Faculty Module
| Feature | Description |
|---|---|
| **Create Quiz** | Create quizzes with a title, description, custom time limit, multiple MCQ questions, and difficulty level (Easy / Medium / Difficult) |
| **Set Quiz Timer** | Faculty can set a custom duration (in minutes) for each quiz — students must finish within this time |
| **My Quizzes** | View all quizzes created by the logged-in faculty with timer display, shown as cards in a list or responsive grid |
| **Delete Quiz** | Permanently delete any quiz along with all its questions from Firestore via a confirmation dialog |
| **Add Questions** | Dynamically add questions with 4 options each via an alert dialog; preview and delete questions before submission |
| **Student Scores** | View all registered students and drill into their individual quiz scores and results |
| **Profile Management** | Faculty must complete their profile (experience, qualification, about) before creating quizzes |
| **Delete Account** | Permanently delete the faculty account along with all quizzes, questions, and user data from Firebase |
| **Navigation Drawer** | Quick access to My Quiz, Create Quiz, My Profile, Student's Score, About Us, Privacy Policy, Terms & Conditions, Share App, and Delete Account |

### 👨‍🎓 Student Module
| Feature | Description |
|---|---|
| **Browse Teachers** | View a list of all registered faculty members with their name, about, and experience |
| **Quizzes per Teacher** | Tap on a faculty card to see all available (unattempted) quizzes offered by that teacher |
| **Hide Attempted Quizzes** | Quizzes already completed by the student are automatically hidden from the list |
| **All Completed Message** | Shows "🎉 All Quizzes Completed!" when a student has finished all quizzes from a faculty |
| **Start Quiz** | Participate in a quiz with a live countdown timer (set by faculty) and paginated question view |
| **Faculty-Set Timer** | Each quiz uses the time limit set by the faculty; auto-submission when time runs out |
| **Check Scores** | Review past quiz results with detailed score breakdowns in a responsive grid layout |
| **Instruction Dialog** | Pre-quiz instruction dialog with rules before starting the quiz |
| **Profile Management** | Students must complete their profile (qualification, about) before participating |

### 🔐 Authentication & Security
| Feature | Description |
|---|---|
| **Email/Password Auth** | Secure registration and login powered by Firebase Authentication |
| **Role-Based Access** | Toggle switch during registration to select Student or Faculty role; role determines UI and permissions |
| **Auto-Login** | Splash screen checks saved profile data and auto-navigates to the correct home screen |
| **Error Handling** | User-friendly toast messages and switch-case error handling for all Firebase auth exceptions |

### 🎨 UI / UX
| Feature | Description |
|---|---|
| **Animated Splash Screen** | Fade-transition splash screen with app branding and loading indicator |
| **Gradient Backgrounds** | Vibrant multi-color linear gradients on login and registration pages |
| **Responsive Layout** | Adaptive layouts for Mobile, Tablet, and Desktop using a custom `ResponsiveWidget` |
| **Desktop Optimized** | Quiz screen constrained to max 700px width on desktop; scores grid adapts (1/2/3 columns) |
| **Material Design** | Cards, floating action buttons, elevated buttons, and clean typography |
| **URL Launcher** | Opens Privacy Policy and Terms & Conditions in external browser |

---

## 🛠 Tech Stack

| Layer | Technology |
|---|---|
| **Framework** | Flutter 3.x (Dart ≥ 3.0) |
| **Backend / Database** | Firebase (Cloud Firestore) |
| **Authentication** | Firebase Authentication (Email/Password) |
| **State Management** | Provider (ChangeNotifier pattern) |
| **Target Platforms** | Android, iOS, Web, Windows, macOS, Linux |

---

## 🏗 Architecture & Design Patterns

The project follows a **feature-based modular architecture** with clear separation of concerns:

```
┌─────────────────────────────────────────────────────────┐
│                     Presentation Layer                  │
│   ┌─────────────┐  ┌──────────────┐  ┌───────────────┐  │
│   │  Faculty UI  │  │  Student UI  │  │  Shared UI    │  │
│   │  - mainScreen│  │  - mainScreen│  │  - Login      │  │
│   │  - createQuiz│  │  - startQuiz │  │  - Register   │  │
│   │  - showQuiz  │  │  - checkScore│  │  - Splash     │  │
│   │  - results   │  │  - teachers  │  │  - Profile    │  │
│   └──────┬───────┘  └──────┬───────┘  └───────┬───────┘  │
│          │                 │                  │          │
├──────────┼─────────────────┼──────────────────┼──────────┤
│          └─────────────────┼──────────────────┘          │
│                     State Layer (Provider)                │
│   ┌──────────────────┐  ┌──────────────────────────────┐ │
│   │ CreateQuizProvider│  │ Student Providers             │ │
│   │ LoginPageProvider │  │  - StudentProvider            │ │
│   │ RegisterProvider  │  │  - StartQuizProvider          │ │
│   │ ProfileProvider   │  │  - TimerCountDownProvider     │ │
│   │                   │  │  - SnapshotProvider           │ │
│   └────────┬──────────┘  └──────────────┬───────────────┘ │
│            └────────────────────────────┘                 │
├──────────────────────────────────────────────────────────┤
│                     Data Layer (Firebase)                 │
│   ┌────────────────────┐  ┌────────────────────────────┐ │
│   │ Firebase Auth      │  │ Cloud Firestore            │ │
│   │ - signIn           │  │ - users collection         │ │
│   │ - createUser       │  │ - questions sub-collection │ │
│   │ - currentUser      │  │ - answers sub-collection   │ │
│   │ - deleteUser       │  │                            │ │
│   └────────────────────┘  └────────────────────────────┘ │
└──────────────────────────────────────────────────────────┘
```

### Design Principles
- **Modular file organization** — Each widget, button, text field, and dialog is in its own dedicated file
- **Reusable Widgets** — Common UI components (AppBar, Drawer Header, Toast, Alert Dialogs, Profile Section) are shared across modules
- **Provider Pattern** — All mutable state is managed via `ChangeNotifier` providers
- **Real-time Data** — Firestore `StreamBuilder` for live UI updates without manual refreshing
- **Responsive Design** — Custom `ResponsiveWidget` class with breakpoints at 700px and 1000px

---

## 📁 Project Structure

```
lib/
├── main.dart                          # App entry point, Firebase init, MultiProvider setup
│
├── Splash Screen/
│   └── splashScreen.dart              # Animated splash with auto-login routing
│
├── loginPage/
│   ├── mainScreen.dart                # Login UI with gradient background
│   ├── textFields.dart                # Email & Password text fields
│   ├── submitButton.dart              # Login logic with Firebase Auth
│   └── notUserSignup.dart             # "Not a user? Sign Up" navigation link
│
├── registerPage/
│   ├── mainScreen.dart                # Registration UI with gradient background
│   ├── textFields.dart                # Name, Email, Password text fields
│   ├── toggleButtons.dart             # Student / Faculty role toggle switch
│   ├── submitButton.dart              # Registration logic with Firebase Auth + Firestore
│   ├── termsandCondition.dart         # Terms & Conditions checkbox/link
│   └── alreadyUserLogin.dart          # "Already a user? Login" navigation link
│
├── Faculty/
│   ├── mainScreen.dart                # Faculty home — AppBar, Drawer, Floating Button, Quiz List
│   ├── createQuiz/
│   │   ├── mainScreen.dart            # Create Quiz form (title, description, duration, difficulty)
│   │   ├── textFieldWidgets.dart      # Quiz title, description & duration text fields
│   │   ├── toggleButtonForDifficultyLevel.dart  # Easy/Medium/Difficult toggle
│   │   ├── listView.dart              # Preview list of added questions
│   │   ├── submitQuizButton.dart      # Submit quiz to Firestore (with duration)
│   │   └── alertDialogAddQuestions/   # Dialog to add questions with 4 options
│   ├── showQuiz/
│   │   ├── mainScreen.dart            # Display all quizzes via StreamBuilder
│   │   ├── quizDataCard.dart          # Individual quiz card with timer display
│   │   └── alertDialog/
│   │       ├── alertDialog.dart       # Quiz detail dialog with Delete button
│   │       ├── alertDialogTitle.dart   # Quiz title, description, difficulty, duration
│   │       ├── alertDialogContent.dart # Quiz questions preview
│   │       └── deleteQuiz.dart        # Delete quiz with confirmation dialog
│   ├── Students Result/
│   │   ├── mainPage.dart              # List all students with scores
│   │   ├── checkScoreList.dart        # Student score list item
│   │   └── dialogBoxResult.dart       # Detailed result dialog per student
│   ├── floatingButton/
│   │   └── floatingButtonCreateQuiz.dart  # FAB to navigate to Create Quiz
│   └── navigationDrawer/
│       ├── drawerMain.dart            # Drawer wrapper with Delete Account option
│       ├── drawerBody.dart            # Drawer items (My Quiz, Create, Profile, Scores, etc.)
│       └── deleteAccount.dart         # Permanent account deletion with 2-step confirmation
│
├── Student/
│   ├── mainScreen.dart                # Student home — AppBar, Drawer, Teacher List
│   ├── assignedTeachers/
│   │   ├── teachersAssigned.dart      # Fetch and display all faculty members
│   │   └── cardView.dart              # Faculty info card with tap-to-view quizzes
│   ├── quizOfEachTeacher/
│   │   ├── quizFromEachFaculty.dart   # List unattempted quizzes (filters completed ones)
│   │   └── showQuizForStudent.dart    # Quiz detail card with timer display
│   ├── InstructionDialog/
│   │   ├── dialogMain.dart            # Pre-quiz instruction dialog
│   │   ├── dialogContent.dart         # Instruction text content
│   │   └── dialogAction.dart          # Start / Cancel — uses faculty-set timer
│   ├── startQuiz/
│   │   ├── mainPage.dart              # Quiz screen with timer + PageView (desktop constrained)
│   │   ├── PageView/                  # Paginated question view with options
│   │   └── resultScreen/             # Post-quiz result display
│   ├── checkScores/
│   │   ├── checkScores.dart           # Responsive grid (1/2/3 columns) of past scores
│   │   ├── scoresList.dart            # Individual score card
│   │   └── dialogBox.dart             # Score detail dialog
│   └── navigationDrawer/
│       └── drawerMain.dart            # Student navigation drawer
│
├── providers/
│   ├── loginPageProvider.dart         # Manages login form state (email, password)
│   ├── RegisterPageProvider.dart      # Manages registration form state + role toggle
│   ├── createQuizProvider.dart        # Manages quiz creation state (title, desc, duration, questions, difficulty)
│   └── studentProviders/
│       ├── studentProvider.dart       # Stores selected faculty/quiz info + quiz duration
│       ├── startQuizProvider.dart     # Manages quiz-in-progress state
│       ├── timerCountDownProvider.dart # Countdown timer with periodic tick
│       └── studentSnapshotProvider.dart # Holds Firestore stream snapshot reference
│
├── constants/
│   └── constantString.dart            # App-wide string constants (image paths, URLs, about text)
│
├── reusableWidgets/
│   ├── Responsive.dart                # ResponsiveWidget class + screen size utilities
│   ├── appBar.dart                    # Shared AppBar configurations
│   ├── createColor.dart               # Hex-to-Color utility function
│   ├── drawerHeading.dart             # Drawer header with user info (null-safe image)
│   ├── switchCaseLoginError.dart      # Firebase error code → toast message mapping
│   ├── toastWidget.dart               # Short & long FlutterToast wrappers
│   ├── alertDialogs/                  # Reusable alert dialog widgets
│   ├── profileSection/               # Profile page UI + provider + data fetching
│   └── topBar/                        # Desktop/large-screen top navigation bars
│
└── aboutPage/
    └── mainPage.dart                  # About Us page with app description
```

---

## 🗄 Firebase Database Schema

### Cloud Firestore Structure

```
Firestore Root
│
└── users (collection)
    │
    ├── {user_email} (document)
    │   ├── name: String
    │   ├── userType: String              ("0" = Student, "1" = Faculty)
    │   ├── about: String
    │   ├── experience: String
    │   ├── qualification: String
    │   ├── contact: String
    │   ├── attempt: Number               (quiz count for faculty)
    │   │
    │   ├── questions (sub-collection)     ← Faculty only
    │   │   └── {quiz_id} (document)
    │   │       ├── Quiz Title: String
    │   │       ├── Quiz Description: String
    │   │       ├── Total Questions: Number
    │   │       ├── Difficulty: String     ("Easy" / "Medium" / "Difficult")
    │   │       ├── Quiz Duration: Number  (minutes, set by faculty)
    │   │       │
    │   │       └── {quiz_id} (sub-collection)
    │   │           └── {question_number} (document)
    │   │               ├── Question: String
    │   │               ├── Answer1: String   (correct answer)
    │   │               ├── Answer2: String
    │   │               ├── Answer3: String
    │   │               └── Answer4: String
    │   │
    │   └── answers (sub-collection)       ← Student only
    │       └── {answer_doc_id} (document)
    │           ├── Faculty Email: String
    │           ├── Faculty Name: String
    │           ├── Quiz Title: String
    │           ├── Quiz ID: String
    │           ├── Score: String
    │           ├── Total Questions: String
    │           └── Quiz Description: String
```

### Firebase Authentication
- **Method**: Email / Password
- **User mapping**: The authenticated email is used as the Firestore document ID under the `users` collection

---

## 🔄 State Management

The app uses the **Provider** package with the `ChangeNotifier` pattern. Eight providers are registered globally via `MultiProvider` in `main.dart`:

| Provider | Purpose |
|---|---|
| `RegisterPageProvider` | Manages registration form fields and Student/Faculty role toggle |
| `LoginPageProvider` | Manages login form fields (email, password) |
| `CreateQuizProvider` | Manages quiz creation — title, description, duration, difficulty, and the list of questions with options |
| `StudentProvider` | Stores the currently selected faculty email, quiz ID, quiz duration, and quiz metadata for navigation |
| `ProfilePageProvider` | Manages user profile data (name, email, about, experience, qualification, contact, userType) |
| `StartQuizProvider` | Manages the active quiz state during participation |
| `TimerProvider` | Countdown timer with `Timer.periodic` — starts, ticks every second, and supports cancellation |
| `SnapshotProvider` | Holds the Firestore `StreamSnapshot` reference for the active quiz questions |

---

## 📱 Responsive Design

The app uses a custom `ResponsiveWidget` class with three breakpoints:

| Screen Size | Width | Layout |
|---|---|---|
| **Small** (Mobile) | < 700px | `ListView`, full-width forms, mobile AppBar with drawer |
| **Medium** (Tablet) | 700px – 1000px | `GridView` with 2 columns, half-width forms |
| **Large** (Desktop) | > 1000px | `GridView` with 3 columns, half-width forms, top navigation bar |

Additional responsive enhancements:
- **Quiz Screen**: Constrained to max 700px width on desktop for better readability
- **Scores Grid**: 1 column (mobile) / 2 columns (tablet) / 3 columns (desktop)
- **Font Scaling**: Dynamic font sizes via `setSize()` utility based on screen width

---

## 📸 Screenshots

<p align="center">
  <img src="https://user-images.githubusercontent.com/38547258/212751157-c4ba983c-3f94-4929-ab35-df947a3ead8f.jpg" width="200" />
  <img src="https://user-images.githubusercontent.com/38547258/212751207-77e73b83-1210-4c9e-9a0a-ad36184e59c6.jpg" width="200" />
  <img src="https://user-images.githubusercontent.com/38547258/212751235-4a440582-d173-469e-8392-2efcc7f72758.jpg" width="200" />
  <img src="https://user-images.githubusercontent.com/38547258/212751243-c8c08eda-68f3-4d8f-bf28-cfbc697bf5b3.jpg" width="200" />
</p>

<p align="center">
  <img src="https://user-images.githubusercontent.com/38547258/212751259-05b43052-9c2e-468a-a0dd-09be8d02716d.jpg" width="200" />
  <img src="https://user-images.githubusercontent.com/38547258/212751266-dc88b0af-f198-49a4-9534-7e2cd62444a7.jpg" width="200" />
  <img src="https://user-images.githubusercontent.com/38547258/212751279-7d30018b-eae8-47fe-aef6-91532cdcf014.jpg" width="200" />
  <img src="https://user-images.githubusercontent.com/38547258/212751289-c4f1880d-be09-403a-b063-c43f21d3f839.jpg" width="200" />
</p>

---

## ✅ Prerequisites

Before running this project, ensure you have the following installed:

| Tool | Version | Download |
|---|---|---|
| **Flutter SDK** | 3.x or higher | [flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install) |
| **Dart SDK** | ≥ 3.0.0 | Bundled with Flutter |
| **Android Studio / VS Code** | Latest | [developer.android.com/studio](https://developer.android.com/studio) |
| **Firebase CLI** | Latest | [firebase.google.com/docs/cli](https://firebase.google.com/docs/cli) |
| **Git** | Latest | [git-scm.com](https://git-scm.com/) |

---

## 🚀 Installation & Setup

### 1. Clone the Repository

```bash
git clone https://github.com/SALMAN-MAREDIA/quiz_app_flutter.git
cd quiz_app_flutter
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Firebase Configuration

This project uses Firebase as its backend. You need to set up your own Firebase project:

1. Go to [Firebase Console](https://console.firebase.google.com/) and create a new project
2. Enable **Email/Password** authentication under **Authentication → Sign-in Method**
3. Create a **Cloud Firestore** database in production or test mode
4. Register your app platforms (Android, iOS, Web) in Firebase:

   **For Android:**
   - Download `google-services.json` and place it in `android/app/`

   **For iOS:**
   - Download `GoogleService-Info.plist` and place it in `ios/Runner/`

   **For Web:**
   - The Firebase web config is set in `lib/main.dart` inside the `kIsWeb` block

5. Run the FlutterFire CLI (recommended):
   ```bash
   dart pub global activate flutterfire_cli
   flutterfire configure
   ```

### 4. Firestore Security Rules (Recommended)

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.token.email == userId;
      
      match /{subcollection}/{document=**} {
        allow read: if request.auth != null;
        allow write: if request.auth != null;
      }
    }
  }
}
```

---

## ▶️ Running the App

### Android / iOS

```bash
flutter run
```

### Web

```bash
flutter run -d chrome
```

### Windows

```bash
flutter run -d windows
```

### Specific Device

```bash
# List connected devices
flutter devices

# Run on a specific device
flutter run -d <device_id>
```

---

## 📦 Building for Production

### Android APK

```bash
flutter build apk --release
```

### Android App Bundle

```bash
flutter build appbundle --release
```

### Web

```bash
flutter build web --release
```

### Windows

```bash
flutter build windows --release
```

The build output will be in the `build/` directory.

---

## 📚 Dependencies

### Production Dependencies

| Package | Version | Purpose |
|---|---|---|
| `flutter` | SDK | Core framework |
| `provider` | ^6.1.5 | State management (ChangeNotifier pattern) |
| `firebase_core` | ^3.6.0 | Firebase initialization |
| `firebase_auth` | ^5.7.0 | Email/Password authentication |
| `cloud_firestore` | ^5.4.0 | NoSQL real-time database |
| `fluttertoast` | ^9.0.0 | Cross-platform toast notifications |
| `shared_preferences` | ^2.2.3 | Local key-value storage |
| `font_awesome_flutter` | ^10.7.0 | FontAwesome icon library |
| `toggle_switch` | ^2.3.0 | Animated toggle switch widget |
| `share_plus` | ^7.2.2 | Native share dialog |
| `path_provider` | ^2.1.3 | File system path access |
| `screenshot` | ^3.0.0 | Widget screenshot capture |
| `url_launcher` | ^6.1.14 | Open URLs in external browser |
| `animated_splash_screen` | ^1.3.0 | Animated splash screen |

### Dev Dependencies

| Package | Version | Purpose |
|---|---|---|
| `flutter_test` | SDK | Unit & widget testing framework |
| `flutter_lints` | ^6.0.0 | Recommended Dart lint rules |

---

## 🤝 Contributing

Contributions are welcome! Follow these steps:

1. **Fork** the repository
2. **Create** a feature branch:
   ```bash
   git checkout -b feature/your-feature-name
   ```
3. **Commit** your changes:
   ```bash
   git commit -m "Add: short description of change"
   ```
4. **Push** to the branch:
   ```bash
   git push origin feature/your-feature-name
   ```
5. **Open** a Pull Request

### Contribution Guidelines
- Follow the existing modular file structure (one widget per file)
- Use the Provider pattern for state management
- Ensure responsive layouts work across all breakpoints
- Write descriptive commit messages

---

## 📄 Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Dart Packages (pub.dev)](https://pub.dev/)
- [Firebase Documentation](https://firebase.google.com/docs)
- [Provider Package](https://pub.dev/packages/provider)
- [Cloud Firestore Guide](https://firebase.google.com/docs/firestore)
- [Firebase Authentication Guide](https://firebase.google.com/docs/auth)

---

## 👨‍💻 Author

**Salman Maredia** — [@SALMAN-MAREDIA](https://github.com/SALMAN-MAREDIA)

---

<p align="center">
  Made with ❤️ using Flutter & Firebase
</p>
