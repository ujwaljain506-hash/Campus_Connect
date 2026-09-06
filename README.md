# Campus Connect

A full-stack college app built with Flutter and Firebase, designed to help students stay connected, share knowledge, and access campus updates in real time.

## Features

- **Authentication** — Secure login and signup with Firebase Auth
- **Notice Board** — Real-time college announcements with push notifications (FCM)
- **Social Feed** — Post updates, share images, and like posts
- **Study Hub** — Upload and access study notes (PDF), ask doubts in the forum
- **User Profile** — View your profile and post history

## Tech Stack

| Layer | Technology |
|---|---|
| Frontend | Flutter (Dart) |
| Authentication | Firebase Auth |
| Database | Cloud Firestore (real-time) |
| File Storage | Cloudinary |
| Push Notifications | Firebase Cloud Messaging |
| State Management | setState + StreamBuilder |
| Version Control | Git + GitHub |

## Architecture

The app follows a **service layer architecture**:
- `lib/models/` — Data models (Notice, Post, StudyResource, Question)
- `lib/services/` — Business logic (AuthService, FirestoreService, StorageService)
- `lib/screens/` — UI screens organized by feature
- `lib/main.dart` — App entry point with Firebase initialization

## Setup

1. Clone the repo
2. Run `flutter pub get`
3. Add your `google-services.json` (see `google-services.json.example`)
4. Configure Firebase project with Auth, Firestore, and FCM enabled
5. Run `flutter run`

## Screenshots

*Coming soon*

## Developer

**Ujwal Jain**
Second-year CS student at APSIT, Thane
GitHub: [@ujwaljain506-hash](https://github.com/ujwaljain506-hash)
