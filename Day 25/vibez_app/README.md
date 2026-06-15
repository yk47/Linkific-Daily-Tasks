# Vibez - Social Media App with Real-time Chat

A full-featured social media application built with Flutter and Firebase. Share your vibez with the world through posts, connect with friends via real-time chat, and stay updated with notifications.

## 📱 Features

### Social Media Core
- **📝 Create Posts**: Share photos with captions
- **❤️ Like Posts**: Double-tap to show love
- **💬 Comments**: Engage with the community
- **👥 Follow System**: Follow/Unfollow users
- **📊 Profile Stats**: Track posts, followers, following
- **📰 News Feed**: Scroll through latest posts
- **🔔 Real-time Notifications**: Likes, comments, follows

### Chat Feature
- **💬 Real-time Messaging**: Instant message delivery
- **👤 Individual Chats**: Private conversations
- **👥 Group Chats**: Multi-person discussions
- **📸 Image Sharing**: Send photos in chat
- **✅ Message Status**: Sent/Delivered/Read indicators
- **↩️ Reply to Messages**: Context in conversations
- **🟢 Online Status**: See who's available

### User Features
- **🔐 Auth**: Email/password registration & login
- **👤 Profiles**: Customizable with photo & bio
- **🔍 User Search**: Find and connect with others
- **🎨 Beautiful UI**: Vibrant design with animations

## 🏗 Architecture

```
lib/
├── main.dart                        # App entry + MultiProvider
├── src/
│   ├── config/
│   │   ├── app_config.dart          # Firebase collections, limits
│   │   ├── router.dart              # All named routes
│   │   └── theme.dart               # Vibez brand theme (coral/salmon)
│   ├── models/
│   │   ├── user_model.dart          # User + follower counts
│   │   ├── post_model.dart          # Post + Comment models
│   │   ├── notification_model.dart  # Like/comment/follow alerts
│   │   ├── chat_model.dart          # Individual + group chats
│   │   └── message_model.dart       # Messages with status/replies
│   ├── services/
│   │   ├── firebase_service.dart    # Firebase init singleton
│   │   ├── auth_service.dart        # Auth CRUD + online status
│   │   ├── social_service.dart      # Posts/likes/comments/follows/notifs
│   │   └── chat_service.dart        # Chat/messaging CRUD
│   ├── providers/
│   │   ├── auth_provider.dart       # Auth state management
│   │   ├── social_provider.dart     # Feed, posts, likes, notifications
│   │   └── chat_provider.dart       # Chat list, messages
│   ├── screens/
│   │   ├── auth/                    # Splash, Login, Register
│   │   ├── feed/                    # Feed, Create Post, Post Detail
│   │   ├── chat/                    # Chat List, Chat Screen
│   │   ├── notifications/           # Notification list
│   │   ├── profile/                 # Profile with stats + posts grid
│   │   ├── users/                   # User discovery
│   │   └── home_shell.dart          # Bottom nav (Feed/Chat/Alerts/Profile)
│   └── widgets/
│       └── common_widgets.dart      # Avatar, Loading, Error, MessageBubble
```

## 🚀 Quick Start

### Firebase Setup
1. Create project at [Firebase Console](https://console.firebase.google.com)
2. Enable Email/Password Authentication
3. Create Firestore database & Storage
4. Add platform configs: `google-services.json`, `GoogleService-Info.plist`
5. Update `DefaultFirebaseOptions` in `lib/src/services/firebase_service.dart`

### Run
```bash
flutter pub get
flutter run
```

## 📸 Screens

| Screen | Description |
|--------|-------------|
| **Splash** | Animated Vibez logo → auto-login |
| **Feed** | Scrollable posts with likes/comments |
| **Create Post** | Photo picker + caption editor |
| **Post Detail** | Full post with comments thread |
| **Chat List** | All conversations + user search |
| **Chat Screen** | Real-time messaging with replies |
| **Notifications** | Like/comment/follow alerts |
| **Profile** | Stats grid + posts gallery + edit |

## 📄 Database Collections

| Collection | Purpose |
|------------|---------|
| `users` | User profiles + follower counts |
| `posts` | Posts with likes array, counts |
| `posts/{id}/comments` | Comment threads |
| `follows` | Follow relationships |
| `notifications` | Activity alerts |
| `chats` | Chat metadata |
| `chats/{id}/messages` | Message history |

## 🎨 Vibez Theme
- **Primary**: Coral Red (#FF6B6B)
- **Secondary**: Teal (#4ECDC4)
- **Accent**: Yellow (#FFE66D), Purple (#A78BFA)
- **Gradients**: Vibrant social media style

## 👥 Team
Full-stack Flutter + Firebase application built for the Linkific internship program.
- **Architect**: App structure & data flow
- **Backend**: Firebase services layer
- **Frontend**: All UI screens & navigation
- **Design**: Theme & component library