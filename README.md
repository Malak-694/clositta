# Clositta (Chicora)

> A smart fashion & tailoring marketplace built with Flutter — connecting customers, tailors, and clothing/material sellers in one unified platform.

---

## 📱 Overview

**Clositta** is a multi-role Flutter mobile application that brings together three types of users under one roof:

- **Customers** — manage their digital wardrobe (closet), discover outfits with AI assistance, browse products, and commission tailors via a bidding system.
- **Tailors** — receive and respond to bidding requests, manage orders, showcase their portfolio, browse material products, and use AI to generate design images.
- **Sellers** — list and manage clothing or fabric/material products, fulfill orders, and track sales analytics.

---

## ✨ Features

### 👗 Customer
| Feature | Description |
|---|---|
| **Digital Closet** | Upload, organize, and manage wardrobe items |
| **AI Outfit Recommendations** | Get personalized outfit suggestions powered by AI |
| **AI Image Generation** | Generate clothing/outfit images from text prompts |
| **Complete the Outfit** | AI-powered tool to suggest missing outfit pieces |
| **Bidding System** | Post custom tailoring requests and receive bids from tailors |
| **E-Commerce** | Browse and purchase clothing from sellers |
| **Body Measurements** | Store and manage body measurements |
| **Real-time Chat** | Chat directly with tailors or sellers |
| **Notifications** | Real-time push notifications via Firebase |
| **Cart & Orders** | Add to cart and track order status with deep-link support |

### 🧵 Tailor
| Feature | Description |
|---|---|
| **Bidding Board** | View and submit bids on customer tailoring requests |
| **Active Orders** | Manage ongoing tailoring orders |
| **Portfolio** | Showcase previous work with images |
| **AI Image Generation** | Generate design inspiration images |
| **E-Commerce** | Browse clothing and material products |
| **Real-time Chat** | Communicate with customers |
| **Notifications** | Stay updated on new bids and messages |

### 🛍️ Seller
| Feature | Description |
|---|---|
| **Product Management** | Add, update, and remove product listings |
| **Orders Management** | View and manage incoming orders |
| **Sales Analytics** | Visual dashboard for tracking sales performance |
| **Profile** | Manage store profile |
| **Notifications** | Get notified of new customer orders |

### 🔐 Authentication
- Email / Password login & signup
- Google Sign-In
- Password recovery via email code
- Persistent login with secure token storage
- Role-based routing on app launch

---

## 🏗️ Architecture

The project follows a **Feature-First Clean Architecture** with BLoC for state management.

```
lib/
├── core/
│   ├── constants/        # App-wide constants
│   ├── di/               # Dependency injection (get_it)
│   ├── helper/           # Shared preferences, notifications, etc.
│   ├── models/           # Shared data models
│   ├── networking/       # Dio HTTP client, interceptors, Retrofit APIs
│   ├── router/           # Named route definitions & AppRouter
│   ├── theme/            # Light & dark themes
│   ├── tools/            # Utility functions
│   ├── utils/            # Helpers (formatters, validators, etc.)
│   └── widgets/          # Shared/reusable widgets
│
└── features/
    ├── auth/             # Login, signup, password recovery
    ├── chat/             # Real-time messaging (Socket.IO)
    ├── customer/
    │   ├── ai/           # AI outfit recommendations & image generation
    │   ├── biding/       # Customer bidding posts
    │   ├── closet/       # Digital wardrobe management
    │   ├── ecommerce/    # Product browsing & cart
    │   ├── measurements/ # Body measurements
    │   └── profile/      # Customer profile
    ├── ecommerce_multi/  # Shared cart & order logic
    ├── notifications/    # Push notification management
    ├── profile/          # Shared profile components
    ├── seller/
    │   ├── analysis/     # Sales analytics dashboard
    │   ├── orders/       # Order management
    │   ├── products/     # Product CRUD
    │   └── profile/      # Seller profile
    └── tailor/
        ├── ai/           # Tailor AI image generation
        ├── bidding_tailor/ # Tailor's bidding board
        ├── ecommerce/    # Product browsing for tailors
        ├── portfolio/    # Portfolio management
        └── profile/      # Tailor profile
```

---

## 🛠️ Tech Stack

| Category | Technology |
|---|---|
| **Framework** | Flutter (Dart) |
| **State Management** | Flutter BLoC / Cubit |
| **Dependency Injection** | get_it |
| **HTTP Client** | Dio + Retrofit |
| **Serialization** | json_serializable + freezed |
| **Real-time** | Socket.IO (`socket_io_client`) |
| **Push Notifications** | Firebase Cloud Messaging + `flutter_local_notifications` |
| **Backend Services** | Firebase (Core, Messaging) |
| **Authentication** | Google Sign-In, JWT (stored via `flutter_secure_storage`) |
| **Maps** | Google Maps Flutter |
| **Deep Links** | app_links |
| **Image Handling** | image_picker, vision_gallery_saver |
| **Navigation** | Named routes via AppRouter |
| **Responsive UI** | flutter_screenutil (design size: 412×917) |
| **Font** | Raleway (multiple weights) |
| **Icons** | Lucide Icons Flutter |
| **Logging** | logger, pretty_dio_logger |

---

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) `^3.x` (Dart SDK `^3.9.2`)
- [Firebase project](https://console.firebase.google.com/) configured for Android and/or iOS
- Google Maps API key (for maps features)
- A running backend server

### Setup

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd clositta
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   - Place your `google-services.json` in `android/app/`
   - Place your `GoogleService-Info.plist` in `ios/Runner/`
   - Update `lib/firebase_options.dart` with your Firebase project details

4. **Configure Google Maps** *(if applicable)*
   - Add your API key to `android/app/src/main/AndroidManifest.xml`
   - Add your API key to `ios/Runner/AppDelegate.swift`

5. **Generate code** (for Retrofit, Freezed, JSON serialization, and assets)
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

6. **Run the app**
   ```bash
   flutter run
   ```

---

## 🔧 Code Generation

This project uses code generation for:
- **Freezed** — immutable data classes & union types
- **json_serializable** — JSON parsing
- **Retrofit** — type-safe REST API clients
- **flutter_gen** — type-safe asset references

Regenerate when models or assets change:
```bash
dart run build_runner build --delete-conflicting-outputs
```

---

## 🎨 Theming

The app fully supports **Light and Dark modes**, toggled at runtime and persisted across sessions via `SharedPreferences`. Theme definitions live in `lib/core/theme/app_theme.dart`.

---

## 🔔 Notifications

Push notifications are powered by **Firebase Cloud Messaging (FCM)**. The device token is automatically sent to the backend on login. Local notification display is handled by `flutter_local_notifications`.

---

## 🔗 Deep Links

The app handles deep links with the scheme `app://clositta.com`. Currently, navigating to `/orders` via a deep link will redirect the user to the order view screen.

---

## 📁 Assets

```
assets/
└── images/
    ├── dress.png
    ├── recovery.png
    ├── password.png
    ├── email.png
    ├── lock.png
    ├── loading.gif
    └── logo-removebg.png   ← App launcher icon
```

---

## 📄 License

This project is private and not published to pub.dev.
