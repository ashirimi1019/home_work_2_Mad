# Message Board App - Homework 02

A Flutter application for CSC 4360 - Mobile App Development featuring Firebase Authentication and Cloud Firestore real-time messaging.

## Features

- **Firebase Authentication**: User registration and login with email/password
- **Cloud Firestore**: Real-time message storage and synchronization
- **Multiple Message Boards**: General Chat, Homework Help, and Announcements
- **User Profiles**: View and edit user information
- **Settings**: Change password and logout functionality
- **Real-time Messaging**: Messages update instantly across devices
- **Material Design UI**: Clean and modern interface

## Setup Instructions

### 1. Install Dependencies
```bash
flutter pub get
```

### 2. Firebase Setup
This project assumes Firebase is already configured with `firebase_options.dart`. If not:
```bash
flutterfire configure
```

### 3. Run the App
```bash
flutter run
```

## Project Structure

```
lib/
├── main.dart                          # App entry point
├── models/                            # Data models
├── services/                          # Firebase services
├── screens/                           # UI screens
└── widgets/                           # Reusable widgets
```

## Usage

1. **Register** a new account or **Login** with existing credentials
2. **Select a message board** from the home screen
3. **Send messages** that update in real-time
4. **Access Profile and Settings** from the navigation drawer

## Assignment Requirements

✅ Splash Screen  
✅ Firebase Authentication & Cloud Firestore  
✅ User Registration & Login  
✅ Message Boards List  
✅ Real-time Chat with timestamps  
✅ Navigation Drawer  
✅ Profile Management  
✅ Settings & Logout

For detailed documentation, see comments in the code files.
