# ⚡ Supabase Flutter Auth & Chat App

A full-stack Flutter mobile application integrating **Supabase** as the backend — featuring multi-provider authentication, real-time chat, a personal notes manager, and user profile management. Built as a complete reference implementation for the Supabase + Flutter ecosystem.

---

## 📱 Screenshots & Features

| Screen | Features |
|--------|----------|
| **Login** | Email/password sign-in, Google OAuth, animated entrance |
| **Sign Up** | Name + email + password registration, profile auto-creation |
| **Home** | User profile display, notes CRUD, real-time note count badge |
| **Chat** | Real-time group messaging, message bubbles, auto-scroll |

---

## 🏗️ Architecture

```
supabase_auth_app/
├── lib/
│   ├── config/
│   │   └── supabase_config.dart        # Supabase URL & anon key
│   ├── models/
│   │   ├── message_model.dart          # Chat message entity
│   │   └── user_model.dart             # User profile entity
│   ├── routes/
│   │   └── app_routes.dart             # Named route definitions
│   ├── screens/
│   │   ├── login_screen.dart           # Auth: email/password + Google OAuth
│   │   ├── signup_screen.dart          # Registration + profile creation
│   │   ├── home_screen.dart            # Dashboard + Notes CRUD
│   │   └── chat_screen.dart            # Real-time group chat
│   ├── services/
│   │   ├── auth_service.dart           # Auth methods + AuthGate widget
│   │   ├── chat_service.dart           # Messages CRUD + real-time stream
│   │   └── note_service.dart           # Notes CRUD + real-time stream
│   ├── theme/
│   │   └── app_theme.dart              # Global colors, gradients, ThemeData
│   ├── widgets/
│   │   ├── custom_textfield.dart       # Animated, validated input field
│   │   └── message_bubble.dart         # Chat bubble (sent/received)
│   └── main.dart                       # Entry point + Supabase.initialize()
└── pubspec.yaml
```

**Pattern:** Service-Layer architecture — all Supabase calls live in dedicated service classes, screens only handle UI state.

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK `^3.11.5`
- Dart SDK `^3.11.5`
- A [Supabase](https://supabase.com) account (free tier works)

### 1. Clone the repository

```bash
git clone https://github.com/your-username/supabase_auth_app.git
cd supabase_auth_app
```

### 2. Create your Supabase project

1. Go to [supabase.com](https://supabase.com) → **New Project**
2. Note your **Project URL** and **anon/public API key** from *Settings → API*

### 3. Set up the database

Run the following SQL in your Supabase **SQL Editor**:

```sql
-- Profiles table
CREATE TABLE profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT NOT NULL,
  name TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Notes table
CREATE TABLE notes (
  id BIGSERIAL PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Messages table
CREATE TABLE messages (
  id BIGSERIAL PRIMARY KEY,
  sender_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,
  message TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
```

### 4. Enable Row Level Security

```sql
-- Profiles: users can only access their own profile
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Own profile" ON profiles FOR ALL
  USING (auth.uid() = id) WITH CHECK (auth.uid() = id);

-- Notes: users can only access their own notes
ALTER TABLE notes ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Own notes" ON notes FOR ALL
  USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);

-- Messages: all authenticated users can read; can only insert as themselves
ALTER TABLE messages ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Authenticated read" ON messages FOR SELECT
  USING (auth.role() = 'authenticated');
CREATE POLICY "Own insert" ON messages FOR INSERT
  WITH CHECK (auth.uid() = sender_id);
```

### 5. Configure credentials

Open `lib/config/supabase_config.dart` and replace the values:

```dart
class SupabaseConfig {
  static const String supabaseUrl = 'YOUR_SUPABASE_PROJECT_URL';
  static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
}
```

### 6. (Optional) Enable Google OAuth

1. In Supabase Dashboard → **Authentication → Providers → Google** → Enable
2. Add your Google OAuth Client ID and Secret
3. Set the redirect URL in Google Cloud Console:
   ```
   https://<your-project-ref>.supabase.co/auth/v1/callback
   ```
4. For Android deep link, ensure `io.supabase.flutter://login-callback` is registered in `AndroidManifest.xml`

### 7. Install dependencies & run

```bash
flutter pub get
flutter run
```

---

## 🔑 Authentication

The app supports three authentication methods via `AuthService`:

| Method | Code |
|--------|------|
| Email Sign-Up | `auth.signUp(email: email, password: password)` |
| Email Sign-In | `auth.signInWithPassword(email: email, password: password)` |
| Google OAuth | `auth.signInWithOAuth(OAuthProvider.google)` |
| Sign-Out | `auth.signOut()` |

### AuthGate

Session state is managed reactively — `AuthGate` wraps the app root and listens to `onAuthStateChange`. Any login/logout event automatically navigates to the correct screen without manual routing logic.

```dart
StreamBuilder<AuthState>(
  stream: Supabase.instance.client.auth.onAuthStateChange,
  builder: (context, snapshot) {
    final session = Supabase.instance.client.auth.currentSession;
    return session != null ? HomeScreen() : LoginScreen();
  },
)
```

---

## 🗄️ Database Operations

### Notes (Full CRUD)

```dart
// Create
await supabase.from('notes').insert({'title': title, 'user_id': userId});

// Read (real-time stream)
supabase.from('notes').stream(primaryKey: ['id']).order('created_at', ascending: false);

// Update
await supabase.from('notes').update({'title': newTitle}).eq('id', id);

// Delete
await supabase.from('notes').delete().eq('id', id);
```

### Messages (Real-Time Stream)

```dart
// Send
await supabase.from('messages').insert({'sender_id': userId, 'message': text});

// Stream (used in ChatScreen)
supabase.from('messages').stream(primaryKey: ['id']).order('created_at');
```

---

## ⚡ Real-Time Features

Real-time updates use Supabase's `.stream()` API backed by PostgreSQL logical replication over WebSockets. Both the chat and notes screens stay live without any polling.

```dart
StreamBuilder<List<Map<String, dynamic>>>(
  stream: _chatService.getMessagesStream(),
  builder: (context, snapshot) {
    final messages = snapshot.data ?? [];
    return ListView.builder(...);
  },
)
```

When a message is inserted by any user, all connected clients receive the update instantly and the UI rebuilds automatically.

---

## 🎨 Theme & Design

The app uses a **dark-mode-first** design system defined in `AppTheme`:

| Token | Color | Usage |
|-------|-------|-------|
| `background` | `#0A0E1A` | Scaffold background |
| `surface` | `#111827` | Cards, containers |
| `primary` | `#6366F1` | Indigo — buttons, accents |
| `primaryLight` | `#818CF8` | Secondary text, read receipts |
| `success` | `#10B981` | Online indicator |
| `error` | `#EF4444` | Validation, snackbars |

**Primary gradient:** `#6366F1 → #8B5CF6` (indigo to purple) used on buttons, avatars, and chat bubbles.

All screens use **fade + subtle upward slide** entrance animations (900ms, `Curves.easeOut`).

---

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  supabase_flutter: ^2.9.1   # Supabase client — auth, database, realtime
  get: ^4.7.2                 # GetX — available for future state management
  cupertino_icons: ^1.0.8

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^6.0.0
```

---

## 🗺️ Navigation

Named routes are defined in `AppRoutes`:

| Route | Screen |
|-------|--------|
| `/login` | `LoginScreen` |
| `/signup` | `SignupScreen` |
| `/home` | `HomeScreen` |
| `/chat` | `ChatScreen` |
| `*login-callback` | OAuth loading handler |

---

## 🔒 Security Notes

- The **anon key** is safe to include in client code — it is a publishable key by design
- Always enable **Row Level Security** on every table before going to production
- Never commit a **service role key** to version control
- For production, load credentials via `--dart-define` rather than hardcoding:
  ```bash
  flutter run --dart-define=SUPABASE_URL=https://... --dart-define=SUPABASE_ANON_KEY=...
  ```

---

## 📚 Learning Resources

| Resource | Link |
|----------|------|
| Supabase Flutter Docs | https://supabase.com/docs/guides/getting-started/flutter |
| supabase_flutter package | https://pub.dev/packages/supabase_flutter |
| Supabase Auth Docs | https://supabase.com/docs/guides/auth |
| Supabase Realtime Docs | https://supabase.com/docs/guides/realtime |
| Row Level Security Guide | https://supabase.com/docs/guides/database/postgres/row-level-security |

**Recommended YouTube searches:**
- `Supabase Flutter tutorial`
- `Supabase authentication Flutter`
- `Supabase database Flutter`
- `Flutter Supabase complete guide`

---

## 🚧 Known Limitations & TODOs

- [ ] Magic link / passwordless authentication not yet implemented
- [ ] Forgot password flow is a stub — wire up `auth.resetPasswordForEmail()`
- [ ] File/image attachments in chat not functional
- [ ] No offline support (Supabase does not provide built-in offline caching)
- [ ] Debug `print()` calls should be removed before production release
- [ ] Consider extracting profile DB calls into a dedicated `ProfileService`

---


