# Golden Bible

Golden Bible is a lightweight, offline-capable Flutter Bible app focused on daily devotionals and a clean reading experience. It bundles two English translations (KJV and BBE), a 365-day devotional set, read-aloud support, and a robust notification system so you never miss your daily verse.

## Key Features

- **Full Offline Bible**: KJV and BBE translations included in `assets/json/` for instant, offline access.
- **Daily Verse & Devotional**: A deterministic "Verse of the Day" plus a short devotional and prayer for every day of the year.
- **Scheduled Notifications**: 365 pre-scheduled notifications (one per day) with configurable reminder time and a test notification feature.
- **Bookmarks, Highlights & Notes**: Save verses, highlight passages with custom colors, and attach notes — all persisted locally via SharedPreferences.
- **Search**: Fast, debounced search across the selected translation with paginated results.
- **Read Aloud (TTS)**: Text-to-speech support with a draggable mini-player that expands to a full play screen. Supports pause/resume, playback speed control, and verse-by-verse progression.
- **Verse Sharing**: Share any verse with a single tap using the native platform share sheet.
- **Theming**: Light and dark themes with a warm, gold-accented brand palette; theme and text preferences are persisted.
- **Custom Page Transitions**: Smooth fade, slide-left, and slide-up animations for screen navigation.
- **Responsive Navigation**: Bottom-nav shell with Home, Bible, Search, and Saved — deep-links from notifications route to the Home card.

## Architecture

Golden Bible uses a **Provider + ChangeNotifier** architecture with **go_router** for declarative navigation.

### State Management

| Provider | Responsibility |
|---|---|
| `BibleProvider` | Bible data loading, active book/chapter state, text size & weight preferences |
| `DevotionalProvider` | Loads and provides daily devotional content |
| `SavedProvider` | Manages bookmarks, highlights, and notes via `SaveService` |
| `ThemeProvider` | Light/dark theme switching, persisted to SharedPreferences |
| `NotificationProvider` | Notification enable/disable, scheduled time, test notifications |
| `TtsProvider` | Text-to-speech playback state, speed, play/pause/next/prev |

### Navigation

- **go_router** with `StatefulShellRoute.indexedStack` for bottom-nav tab persistence
- Nested routes for Bible → Chapters → Verse hierarchy
- Custom page transitions (fade, slide-left, slide-up) via `CustomTransitionPage`

### Persistence

All user data is stored locally using **SharedPreferences**:

- Text size and font weight preferences
- Theme selection (light/dark)
- Notification settings (enabled, hour, minute)
- Bookmarks, highlights, and notes (serialized as JSON)

## Project Structure

```
lib/
├── main.dart                    # App entry, provider wiring, notification setup
├── core/
│   ├── managers/
│   │   └── color_manager.dart   # App-wide color constants and highlight palette
│   ├── models/
│   │   ├── bible.dart           # Bible, Book, Chapter data models
│   │   ├── devotion.dart        # Devotional, Verse data models
│   │   ├── home_option.dart     # Home screen option tile model
│   │   └── save.dart            # Bookmark, Highlight, Notes models
│   ├── router/
│   │   ├── app_router.dart      # GoRouter configuration and shell scaffold
│   │   ├── route_names.dart     # Route path constants
│   │   └── transitions.dart     # Reusable page transition builders
│   └── theme/
│       └── app_theme.dart       # Light and dark ThemeData definitions
├── providers/
│   ├── bible_provider.dart      # Bible state and preferences
│   ├── devotional_provider.dart # Devotional loading
│   ├── notification_provider.dart # Notification scheduling
│   ├── saved_provider.dart      # Bookmarks, highlights, notes CRUD
│   ├── theme_provider.dart      # Theme toggling
│   └── tts_provider.dart        # TTS playback state
├── services/
│   ├── devotional_service.dart  # Loads devotional JSON, picks daily devotional
│   ├── load_bible.dart          # Loads KJV/BBE JSON into typed models
│   ├── notification_service.dart # Local notification initialization & scheduling
│   ├── save_service.dart        # SharedPreferences CRUD for saved items
│   └── tts_service.dart         # FlutterTTS singleton wrapper
└── ui/
    ├── bible/
    │   ├── bible.dart           # Book list screen (Old/New Testament tabs)
    │   ├── chapters.dart        # Chapter grid for a selected book
    │   ├── play.dart            # Full TTS play screen with controls
    │   └── verse.dart           # Verse reading screen with options menu
    ├── home/
    │   └── home.dart            # Home screen with verse of the day & devotional
    ├── saved/
    │   └── saved.dart           # Saved screen (bookmarks, highlights, notes tabs)
    ├── search/
    │   └── search.dart          # Search with debounced input & paginated results
    ├── settings/
    │   └── settings.dart        # Settings screen (notifications, theme, text prefs)
    ├── splash/
    │   └── splash.dart          # Animated splash screen
    └── widgets/
        ├── addnote_textformfield.dart # Note input bottom sheet
        ├── auto_close_widget.dart     # Auto-dismissing toast banner
        ├── devotional_card.dart       # Daily devotional display card
        ├── draggable_playsheet.dart   # Mini-player → full player drag sheet
        ├── highlight_pill.dart        # Color picker pill for verse highlighting
        ├── home_option.dart           # Home screen action tile
        ├── option_widget.dart         # Verse options (highlight, bookmark, note, share)
        └── theme_switch.dart          # Light/dark mode toggle switch
```

## Dependencies

| Package | Purpose |
|---|---|
| `provider` | State management via ChangeNotifier |
| `go_router` | Declarative routing with shell navigation |
| `shared_preferences` | Local key-value persistence |
| `flutter_local_notifications` | Scheduled daily notifications |
| `timezone` / `flutter_timezone` | Accurate timezone-aware scheduling |
| `flutter_tts` | Text-to-speech engine |
| `share_plus` | Native platform share sheet |
| `flutter_material_design_icons` | Extended Material Design icon set |

## Getting Started (Development)

1. Install Flutter SDK (stable channel, ^3.9.0).
2. Clone the repository and from the project root:

```bash
flutter pub get
flutter run
```

## Build

```bash
# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release
```

## Notes & Next Steps

- Android 13+ requires `POST_NOTIFICATIONS` permission (the app prompts at runtime).
- Notification scheduling is deterministic and survives device restarts; changing the daily reminder time will reschedule the 365 notifications.
- The TTS engine uses the device's native speech synthesizer — quality varies by platform.
- Highlights support 5 colors (yellow, green, blue, pink, orange) with more planned.
