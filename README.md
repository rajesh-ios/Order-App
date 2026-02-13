# Dodoo – Order App

<p align="center">
  <strong>iOS app for browsing stores, exploring menus, applying coupons, and placing orders with in-app checkout.</strong>
</p>

Dodoo is a full-featured iOS ordering application built with **Swift** and **UIKit**. It supports location-aware store discovery, wallet management, order tracking, multiple payment options (Razorpay, Cashfree), and a WhatsApp fallback for manual ordering when menus are unavailable.

---

## Features

| Category | Features |
|----------|----------|
| **Stores & discovery** | Browse categories and stores • Search stores • Location-based store discovery (latitude/longitude) • View store details, delivery time, and images |
| **Menu & cart** | Explore items grouped by category • Add/remove items to cart with live totals • Apply coupons (by city and by store) |
| **Orders** | Place and track orders • Update order status • Order summary and details • Rate orders |
| **Account** | Manage addresses (add/update/delete) • View wallet information • Account details and profile |
| **Payments** | Razorpay integration • Cashfree payment token (sandbox/production) |
| **Other** | Push notifications (Firebase) • Facebook & Google Sign-In • WhatsApp fallback when menu is unavailable • Hot deals |

---

## Tech stack

- **Language:** Swift 5.x  
- **UI:** UIKit, Storyboards  
- **Min. iOS:** 12.4  
- **Architecture:** MVC  
- **Networking:** Alamofire  
- **Key dependencies:** R.swift, SwiftyJSON, ObjectMapper, Kingfisher, SwiftMessages, Cosmos (ratings), Google Maps & Place Picker, Firebase (Core, Messaging), Facebook SDK, Google Sign-In, Razorpay, Cashfree PG  

The app uses a lightweight networking layer on top of Alamofire and includes a **Service Extension** for rich push notifications.

---

## Requirements

- **Xcode** 14 or later  
- **iOS** 12.4 or later (project uses runtime checks for iOS 15+ APIs where needed)  
- **CocoaPods** (for dependencies)  
- **Apple Developer account** (for running on device and push notifications)

---

## Getting started

### 1. Clone the repository

```bash
git clone https://github.com/YOUR_USERNAME/Order-App.git
cd Order-App
```

### 2. Install dependencies

```bash
cd dodoo
pod install
```

### 3. Open the workspace

Open **`Dodoo.xcworkspace`** in Xcode (do not use the `.xcodeproj` when using CocoaPods):

```bash
open Dodoo.xcworkspace
```

### 4. Configuration

Before running the app, configure the following (use your own keys for production):

- **Firebase:** Add your `GoogleService-Info.plist` from the [Firebase Console](https://console.firebase.google.com/) (or replace the existing one with your project’s config).
- **Google Maps / Places:** Set your API keys in `AppDelegate.swift` (e.g. `GMSPlacesClient.provideAPIKey`, `GMSServices.provideAPIKey`) and ensure the Google Maps SDK is enabled in Google Cloud.
- **Google Sign-In:** Update the client ID in `AppDelegate.swift` and in the project’s URL schemes to match your OAuth client.
- **Facebook Login:** Update `FacebookAppID` and URL schemes in `Info.plist` to match your Facebook App.

Select the **Dodoo** scheme, choose a simulator or device, and run (⌘R).

---

## Project structure

```
Order App/
├── README.md                 # This file
└── dodoo/
    ├── Podfile               # CocoaPods dependencies
    ├── Dodoo.xcworkspace     # Open this in Xcode
    ├── Dodoo.xcodeproj
    └── Dodoo/
        ├── AppDelegate/
        ├── API/              # Networking, endpoints, constants
        ├── MVC/              # ViewControllers, Views, Modals
        ├── Cells/            # TableView & CollectionView cells
        ├── CommonFunctions/  # Utilities, location, validation
        ├── DataSource/
        ├── Extensions/
        ├── Libraries/
        ├── RGenerated/       # R.swift generated resources
        └── Resources/        # Assets, storyboards, plists
```

---

## Version

- **App version:** 3.3 (build 32)  
- **Bundle ID:** `com.iosapp.dodoo`

---

## License

See the repository’s license file (if present) for terms of use.

---

<p align="center">
  Built with Swift and UIKit • Dodoo Order App
</p>
