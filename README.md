// Dodoo – iOS App

Dodoo is an iOS application for browsing stores, exploring menus, applying coupons, and placing orders with in‑app checkout. It supports location‑aware store discovery, wallet info, order rating, and a WhatsApp fallback for manual ordering when menus are unavailable.

This repository contains the iOS client written in Swift using UIKit and a lightweight networking layer on top of Alamofire.

## Features
- Browse categories and stores
- View store details, delivery time, and images
- Explore items grouped by category
- Add/remove items to a cart with live totals
- Apply coupons (by city and by store)
- Search stores and fetch stores by latitude/longitude
- Manage addresses (add/update/delete)
- Place and track orders, update order status
- View wallet information
- Cashfree payment token integration (sandbox/production)
- Rate orders
- WhatsApp fallback for ordering when a menu is unavailable

## Requirements
- Xcode 14 or later
- iOS 12.0 or later (project uses runtime checks for iOS 15+ APIs)
- Swift 5.x

## Getting Started

### 1) Clone
```bash
