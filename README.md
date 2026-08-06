# Golden Bible

**Golden Bible** is a daily-devotional Bible app built with Flutter. It combines a full in-app Bible reader (KJV and BBE translations), a daily "Verse of the Day" + devotional experience, and 365 pre-scheduled daily notifications so you never miss your morning devotion — even if the app is closed.

---

## Table of Contents

- [App Flow Overview](#app-flow-overview)
- [Screens & Features](#screens--features)
  - [1. Splash Screen](#1-splash-screen)
  - [2. Home Screen](#2-home-screen)
  - [3. Daily Devotional Card (Swipe-Flip)](#3-daily-devotional-card-swipe-flip)
  - [4. Bible Screen (Books)](#4-bible-screen-books)
  - [5. Chapters Screen](#5-chapters-screen)
  - [6. Verse Reading Screen](#6-verse-reading-screen)
  - [7. Search Screen](#7-search-screen)
  - [8. Saved Screen (Bookmarks / Highlights / Notes)](#8-saved-screen-bookmarks--highlights--notes)
  - [9. Settings Screen (Notifications)](#9-settings-screen-notifications)
- [Daily Notifications System](#daily-notifications-system)
- [Theming](#theming)
- [App Identity & Icons](#app-identity--icons)
- [Architecture](#architecture)
- [Tech Stack](#tech-stack)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
- [Building](#building)
- [Validation](#validation)

---

## App Flow Overview

```
Splash (3s) ──► Home ──► (bottom nav) Bible / Search / Saved
                  │
                  ├──► Daily Devotional Card (swipe to flip)
                  ├──► Read / Search / Saved / Notes quick options
                  └──► Settings (person icon, top-right)
```

Cold-start from a notification tap skips the normal home flow and routes directly to **Home** so the day's verse is right in front of you.

---

## Screens & Features

### 1. Splash Screen

- Shows the **Golden Bible logo** (`assets/pngs/appicon.png`) with the app name for 3 seconds.
- Awaits `NotificationService.ready` so notification init is guaranteed to finish before routing.
- **Cold-start routing**: if the app was launched by tapping a notification, it routes straight to **Home**; otherwise it proceeds to the normal flow.
- Startup is fast — `runApp` runs immediately and notification setup happens in the background (`unawaited`), so the splash renders instantly.

### 2. Home Screen

- **Date header** — dynamic weekday + date (e.g. "THURSDAY, AUG 6").
- **Greeting** — time-aware "Good Morning / Good Afternoon / Good Evening".
- **Person icon** (top-right) → opens **Settings**.
- **Verse of the Day** — large italic quote plus the verse reference, driven by a deterministic `verseForDate(dayOfYear % 365)` selection so the home card always matches the day's notification.
- **Quick options row** (all navigate for real):
  - **Read** → Bible books screen
  - **Search** → Search screen
  - **Saved** → Saved screen (Bookmarks tab)
  - **Notes** → Saved screen with the **Notes tab open** directly
- **Daily Devotional** card (see below).

### 3. Daily Devotional Card (Swipe-Flip)

A custom `DevotionalCard` widget that flips in 3D between two faces:

- **Front — "TODAY'S MESSAGE"**: devotional title + body with a gold header band.
- **Back — "PRAYER"**: the day's verse reference + the prayer, on a lighter-gold header.
- **Swipe left or right** (drag) to flip; the card follows your finger, and a quick fling or dragging past halfway completes the flip.
- Perspective projection (`Matrix4` rotationY) gives a true 3D page-flip feel.
- **Swipe hint** label at the bottom ("Swipe for prayer" / "Swipe for message").

### 4. Bible Screen (Books)

- Tabs for **Old Testament** (39 books) and **New Testament** (27 books).
- Each book row shows the abbreviation, full name, and chapter count.
- **Theme switch** toggle in the app bar.
- Tap a book → Chapters screen.

### 5. Chapters Screen

- Centered book title + chapter count in the app bar.
- A **5-column grid of chapter numbers** — tap any chapter to read it.

### 6. Verse Reading Screen

- **Chapter pager** — swipe between chapters, or use the floating next/previous arrows; the app bar shows "Book N" for the current chapter.
- **Translation switcher** — dropdown to toggle between **KJV** and **BBE** (verse numbers stay aligned across translations).
- **Text Settings** popup menu:
  - **Font Size** slider (10–30).
  - **Font Weight** — Light / Regular / Bold / Extra Bold.
  - All preferences are persisted via `SharedPreferences`.
- **Theme toggle** in the popup menu (Light/Dark).
- **Verse options** — tap any verse to reveal the action row:
  - **Bookmark** — saves the verse with a confirmation sheet ("Verse bookmarked successfully").
  - **Add Note** — bottom-sheet text field to attach a note to the verse.
  - **Highlight** / **Share** buttons are part of the option row.
- Reading position and displayed chapter are kept in sync with the active book/translation.

### 7. Search Screen

- **Live search** with a 300ms debounce across the entire active translation (all 66 books).
- Shows "Searching..." indicator while typing.
- **Result count** header ("N results found for "..."") and **pagination** (Previous / Next + page numbers, 10 results per page).
- Each result tile shows the reference (e.g. "Genesis 1:3"), the Testament, and the verse text in the Times font.

### 8. Saved Screen (Bookmarks / Highlights / Notes)

A tabbed screen with three tabs:

- **Bookmarks** — bookmarked verses with reference, quoted text, and "Added on" date.
- **Highlights** — highlighted verses (reference + quoted text + date).
- **Notes** — personal notes with reference and "Added on" date.
- Empty states ("Bookmark is empty." / "Highlights is empty." / "Notes is empty.") when nothing is saved yet.
- The **Notes** home option deep-links here with the Notes tab already selected (`initialTab` route extra).

### 9. Settings Screen (Notifications)

- **Daily Devotional Notifications** section:
  - **Daily Reminder** switch (On/Off) — enables or cancels all scheduled notifications.
  - **Notification Time** tile — opens a themed time picker; changes reschedule all 365 notifications.
  - Shows the current time via `MaterialLocalizations`.
- **Send test notification** card — immediately shows today's verse so you can preview the notification without waiting.

---

## Daily Notifications System

- **365 notifications scheduled up front** — one for each of the next 365 days, using `zonedSchedule` with `inexactAllowWhileIdle`. Delivery depends only on the OS AlarmManager, never on the app being open.
- **Verse baked into each notification** — the body contains the verse text + reference (truncated to 140 chars).
- **Tap → Home** — tapping a notification navigates to the Home screen via `go_router`.
- **Survives reboots & updates** — `ScheduledNotificationReceiver` and `ScheduledNotificationBootReceiver` are registered in the manifest; `RECEIVE_BOOT_COMPLETED` permission is set.
- **Android 13+** — `POST_NOTIFICATIONS` runtime permission is requested on init.
- **Fast normal launches** — `ensureScheduled()` skips rescheduling when ≥ 30 alarms are already pending; full rescheduling runs in parallel batches of 20.
- **Persistence** — enabled state and time (default **7:00 AM**, **on**) are stored in `SharedPreferences`; changing them reschedules/cancels via `NotificationProvider`.
- **Deterministic verse selection** — `DevotionalService.verseForDate(date)` uses `dayOfYear % 365` so the Home card and the day's notification always show the same devotion.

---

## Theming

- **Light** and **Dark** themes defined in `AppTheme`, both built around a **gold** brand palette (`#C9A34A` primary, `#D5BA71` primary1) over warm off-white / black surfaces.
- Toggle from the **Bible screen** app bar or the **Verse screen** menu.
- Theme choice is persisted (`light_theme` pref).
- **Smooth theme animation** — `MaterialApp.router` uses a 600ms `easeInOutCubic` theme switch.

---

## App Identity & Icons

- **App renamed to "Golden Bible"** on Android (`android:label`) and iOS (`CFBundleDisplayName` / `CFBundleName`).
- **Android launcher icon** — real app icon with legacy mipmaps plus an **adaptive icon** (foreground drawable + black background via `mipmap-anydpi-v26/ic_launcher.xml`).
- **iOS AppIcon** — full `AppIcon.appiconset` replaced with the branded icon.
- **Notification icon** — uses `assets/pngs/appicon.png`, copied to `res/drawable/ic_notification.png` and referenced by the plugin (`AndroidInitializationSettings('ic_notification')`) so notifications no longer fall back to the Flutter default.

---

## Architecture

The app uses a clean **Provider + ChangeNotifier** architecture with a `go_router` shell.

**Providers** (registered in `main.dart` via `MultiProvider`):

| Provider | Responsibility |
|---|---|
| `BibleProvider` | Loads KJV + BBE translations, active translation, text size/weight, verse options, search + pagination |
| `DevotionalProvider` | Loads the devotional JSON and exposes today's `Devotion` |
| `ThemeProvider` | Light/dark theme state + persistence |
| `SavedProvider` | Bookmarks, highlights, notes (via `SaveService`) |
| `NotificationProvider` | Notification enabled/time state + persistence, triggers scheduling/cancelling |

**Services**:

- `NotificationService` — singleton; init (timezone + channel + tap routing + cold-start detection), `ensureScheduled`, `scheduleDailyDevotionals`, `cancelAll`, `sendTestNotification`, and a `ready` Completer used by the splash screen.
- `DevotionalService` — loads `devotional.json` and provides deterministic `verseForDate()`.
- `DataService` (`load_bible.dart`) — loads the KJV/BBE JSON translations.
- `SaveService` — persists bookmarks/highlights/notes to `SharedPreferences`.

**Router** (`app_router.dart`) — `StatefulShellRoute.indexedStack` with four bottom-nav branches (Home, Bible, Search, Saved), plus Splash and Settings routes.

---

## Tech Stack

- **Flutter / Dart** (SDK ^3.9.0)
- **go_router** ^17.2.3 — routing & navigation shell
- **provider** ^6.1.5+1 — state management
- **shared_preferences** ^2.5.5 — local persistence
- **flutter_local_notifications** ^20.1.0 — daily notifications (named-parameter API; pinned to 20.1.0 for Dart 3.9 compatibility)
- **timezone** ^0.10.1 + **flutter_timezone** ^5.1.0 — local-timezone-aware scheduling
- **flutter_material_design_icons** ^3.1.0 — icons
- Data: bundled JSON (`assets/json/en_kjv.json`, `en_bbe.json`, `devotional.json`), custom Times font, custom gold color palette.

---

## Project Structure

```
lib/
├── main.dart                       # App entry, MultiProvider, router, notification setup
├── core/
│   ├── managers/                   # ColorManager (brand palette), ImageManager (assets)
│   ├── models/                     # bible, devotion, home_option, match, save
│   ├── router/                     # app_router.dart, route_names.dart
│   └── theme/                      # AppTheme (light/dark)
├── providers/                      # bible, devotional, notification, saved, theme
├── services/                       # notification, devotional, load_bible, save
└── ui/
    ├── splash/                     # SplashScreen
    ├── home/                       # HomeScreen
    ├── bible/                      # BibleScreen (books), ChaptersScreen, VerseScreen
    ├── search/                     # SearchScreen
    ├── saved/                      # SavedScreen (bookmarks/highlights/notes)
    ├── settings/                   # SettingsScreen (notifications)
    └── widgets/                    # devotional_card, home_option, option_widget,
                                    # theme_switch, addnote_textformfield, auto_close_widget
assets/
├── json/                           # en_kjv.json, en_bbe.json, devotional.json
├── pngs/                           # appicon.png
└── fonts/                          # times.ttf
```

---

## Getting Started

```bash
flutter pub get
flutter run
```

> Note: `flutter_local_notifications` 20.1.0 requires **Gradle core-library desugaring**, already enabled in `android/app/build.gradle.kts` (with `desugar_jdk_libs 2.1.4`).

## Building

```bash
flutter build apk --debug      # debug APK
flutter build apk --release    # release APK
flutter build ios              # iOS (on macOS)
```

## Validation

- `flutter analyze` — clean (one pre-existing `info` about the deprecated `MdiIcons.twitter` on the home screen).
- `flutter test` — widget test suite passes.
- `flutter build apk --debug` — builds successfully.
