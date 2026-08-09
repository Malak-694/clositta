# Clositta

An integrated platform combining Fast Fashion & Custom Tailoring

Clositta uniquely combines three core value propositions:

Fast Fashion Marketplace – Browse & purchase ready-made items
Custom Tailoring Network – Connect with vetted tailors for bespoke clothing
AI-powered Intelligence – Personalized design generation & outfit recommendation

## Features


<!-- TODO: Add the app's core, user-facing features here, e.g.:
- Digital wardrobe / closet catalog
- Outfit planning and recommendations
- Browse or shop for clothing items
-->
Customers features : 
- Browse fast fashion and search by image
- Get AI-generated outfits , daily recommendations from your digital closet and completing outfit 
- upload post for tailoring

Tailor features :
- browse requests
- submit offers 
- Chat with customers 
- upload his works in portfolio

Seller features :
- manage his products 
- track orders 
- show analysis 
## Tech Stack

| Category | Package(s) |
|---|---|
| Framework | Flutter (Dart SDK ^3.9.2) |
| State management | `flutter_bloc`, `bloc` |
| Networking | `dio`, `retrofit`, `pretty_dio_logger`, `socket_io_client` |
| Auth & Backend | `firebase_core`, `firebase_messaging`, `google_sign_in` |
| Storage | `shared_preferences`, `flutter_secure_storage` |
| Maps & Location | `google_maps_flutter` |
| Media | `image_picker`, `vision_gallery_saver`, `flutter_svg` |
| Code generation | `build_runner`, `freezed`, `json_serializable`, `retrofit_generator` |
| Dependency Injection | `get_it` |
| Testing | `flutter_test`, `bloc_test`, `mocktail`, `network_image_mock` |

## Project Structure

```
clositta/
├── android/        # Android platform code
├── ios/            # iOS platform code
├── linux/          # Linux platform code
├── macos/          # macOS platform code
├── windows/        # Windows platform code
├── web/            # Web platform code
├── lib/            # Main Dart/Flutter application source
├── assets/         # Images, fonts, and other static assets
├── test/           # Unit and widget tests
├── notes/          # Project notes/docs
├── pubspec.yaml    # Project metadata and dependencies
└── firebase.json   # Firebase configuration
```

## Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (Dart SDK `^3.9.2` or compatible)
- Android Studio / Xcode (for mobile builds) or a configured platform toolchain
- A Firebase project (for `firebase_core` / `firebase_messaging`) with `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) added to the respective platform folders
- A Google Maps API key configured for `google_maps_flutter`

## Testing

```bash
flutter test
```

