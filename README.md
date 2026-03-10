<p align="center">
  <img src="https://user-images.githubusercontent.com/81110391/147370133-d47f05be-7df2-4ffc-89a5-ec258100e7be.png" width="120" alt="Gurme App Icon"/>
</p>

<h1 align="center">Gurme</h1>

<p align="center">
  A modern iOS food ordering app with real-time cart management, favorites, and smooth onboarding — built with UIKit, MVVM + Coordinator architecture, and Clean Architecture principles.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Platform-iOS%2015.0+-blue?logo=apple&logoColor=white" alt="Platform"/>
  <img src="https://img.shields.io/badge/Swift-5.9-orange?logo=swift&logoColor=white" alt="Swift"/>
  <img src="https://img.shields.io/badge/UIKit-Programmatic-purple" alt="UIKit"/>
  <img src="https://img.shields.io/badge/Architecture-MVVM%20+%20Coordinator-green" alt="Architecture"/>
  <img src="https://img.shields.io/badge/SPM-Dependencies-red" alt="SPM"/>
</p>

---

## Screenshots

<!-- Replace with your own screenshots -->

| Splash | OnBoarding | Login | Home |
|:------:|:----------:|:-----:|:----:|
| [Insert Screenshot] | [Insert Screenshot] | [Insert Screenshot] | [Insert Screenshot] |

| Food Detail | Favorites | Cart | Profile |
|:-----------:|:---------:|:----:|:-------:|
| [Insert Screenshot] | [Insert Screenshot] | [Insert Screenshot] | [Insert Screenshot] |

---

## Demo

https://user-images.githubusercontent.com/81110391/194160692-9c966232-5d52-4545-bf89-2ee2f5cd288e.mp4

---

## Features

- **Animated Splash** — Lottie-powered burger animation as the app entry point
- **OnBoarding Flow** — Horizontal swipeable cards shown only on first launch (persisted via UserDefaults)
- **Firebase Authentication** — Login & Register with email/password; optional skip-login flow
- **Home & Search** — Browse all foods with real-time search filtering via `UISearchController`
- **Food Detail** — Star rating, description, prep time, quantity selector, and add-to-cart
- **Favorites** — Toggle favorites from anywhere; stored locally with observer-based reactivity
- **Cart Management** — Add/remove items, live total calculation, order confirmation with animation
- **Profile** — User info, settings menu, app version display, and logout

---

## Architecture

The project follows **MVVM + Coordinator** with a **Clean Architecture** layer separation:

```
Gurme/
├── Application/          # AppDelegate, SceneDelegate, AppCoordinator
├── Domain/
│   ├── Entities/         # Core business models (Food, SliderItem)
│   └── Interfaces/       # Repository protocols
├── Data/
│   ├── Network/          # NetworkService (URLSession + async/await), DTOs
│   └── Repositories/     # Concrete repository implementations
└── Presentation/
    ├── Common/           # Base Coordinator protocol, Extensions, Components
    ├── Features/         # Auth, Home, Cart, Favorites, FoodDetail, Profile, etc.
    └── TabBar/           # TabBarController & TabBarCoordinator
```

**Key patterns:**
- **Coordinator** — Each feature has its own coordinator managing navigation; child coordinators are composed by a parent `AppCoordinator`
- **ViewModel ↔ ViewController** communication via delegate protocols
- **Repository pattern** with protocol-based dependency injection
- **Observer pattern** for `FavoritesRepository` state propagation
- **Diffable Data Source** for modern, performant collection views

### Navigation Flow

```
AppCoordinator
├── SplashScreen (Lottie, 3s)
├── OnBoardingFlow (first launch only)
├── AuthCoordinator
│   ├── WelcomeVC
│   ├── LoginVC
│   └── RegisterVC
└── TabBarCoordinator
    ├── HomeCoordinator       → HomeVC → FoodDetailCoordinator
    ├── FavoritesCoordinator  → FavoritesVC
    ├── CartCoordinator       → CartVC
    └── ProfileCoordinator    → ProfileVC
```

---

## Tech Stack

| Category | Technology |
|----------|-----------|
| **Language** | Swift 5.9 |
| **UI Framework** | UIKit (Programmatic + Storyboard hybrid) |
| **Networking** | URLSession (async/await) with custom `NetworkService` |
| **Authentication** | Firebase Auth |
| **Image Loading** | Kingfisher |
| **Animations** | Lottie |
| **HTTP Client** | Alamofire |
| **Analytics** | Firebase Analytics |
| **Package Manager** | Swift Package Manager |

---

## API

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/tumYemekleriGetir.php` | GET | Fetch all foods |
| `/sepeteYemekEkle.php` | POST | Add item to cart |
| `/sepettekiYemekleriGetir.php` | POST | Get cart items |
| `/sepettenYemekSil.php` | POST | Remove item from cart |

Base URL: `http://kasimadalan.pe.hu/yemekler`
Image CDN: `http://kasimadalan.pe.hu/yemekler/resimler/`

---

## Requirements

- **iOS** 15.0+
- **Xcode** 14.0+
- **Swift** 5.9+

---

## Getting Started

```bash
# 1. Clone the repository
git clone https://github.com/[your-username]/Gurme.git
cd Gurme

# 2. Open the project in Xcode
open Gurme.xcodeproj

# 3. Resolve Swift Package Manager dependencies
# Xcode will auto-fetch packages on first open.
# If not: File → Packages → Resolve Package Versions

# 4. Build & Run
# Select a simulator (iPhone 14 recommended) and press ⌘R
```

> **Note:** Firebase has been disabled for direct push access. If you want to enable Firebase Auth, add your own `GoogleService-Info.plist`.

---

## Project Structure

```
Gurme/
├── Application/
│   ├── AppDelegate.swift            # Firebase initialization
│   ├── SceneDelegate.swift          # Window setup, AppCoordinator entry
│   └── AppCoordinator.swift         # Root coordinator (splash → auth → tabs)
├── Domain/
│   ├── Entities/
│   │   └── Food.swift               # Food, SliderItem models
│   └── Interfaces/                  # Repository protocols
├── Data/
│   ├── Network/
│   │   ├── NetworkService.swift     # Generic async/await networking layer
│   │   └── DTOs/                    # API response models
│   └── Repositories/
│       ├── CartRepository.swift     # Cart API operations
│       ├── FavoritesRepository.swift# Local favorites (UserDefaults + observer)
│       └── FoodRepository.swift     # Food fetch operations
├── Presentation/
│   ├── Common/
│   │   ├── Base/Coordinator.swift   # Coordinator protocol
│   │   ├── Extensions/              # AlertShowable, etc.
│   │   └── Components/              # Reusable UI components
│   ├── Features/
│   │   ├── Auth/                    # Welcome, Login, Register
│   │   ├── Cart/                    # Cart management
│   │   ├── Favorites/               # Favorites list
│   │   ├── FoodDetail/              # Food detail & add-to-cart
│   │   ├── Home/                    # Food browsing & search
│   │   ├── OnBoarding/              # First-launch onboarding
│   │   ├── Profile/                 # User profile & settings
│   │   └── Splash/                  # Animated splash screen
│   └── TabBar/                      # Tab bar setup & coordination
└── Resources/
    ├── Assets.xcassets/             # Colors, icons, images
    ├── *.json                       # Lottie animation files
    └── GoogleService-Info.plist     # Firebase config
```

---

## License

```
MIT
```

---

## Contact

- 📬 Reach me at m.emrekocakk@gmail.com.
- 📌 You may also want to check out the following: [medium]

<h3 align="left">Connect with me:</h3>
<p align="left">
<a href="https://www.linkedin.com/in/kocakemre/" target="blank"><img align="center" src="https://raw.githubusercontent.com/rahuldkjain/github-profile-readme-generator/master/src/images/icons/Social/linked-in-alt.svg" alt="kocakemre" height="30" width="40" /></a>

[linkedin]: https://www.linkedin.com/in/kocakemre/
[medium]: https://medium.com/@kocakemre

---

<p align="center">
  If you find this project useful, consider giving it a ⭐
</p>
 
