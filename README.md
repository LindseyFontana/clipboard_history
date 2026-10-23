# clipboard_history

A Flutter plugin to capture and maintain a history of items copied to the
system clipboard, with native persistence (Android and iOS).

> **Note:** this project was created for study purposes. The Android
> implementation is functional; the iOS implementation is **not yet complete**.

## Features

- Reads the current clipboard text.
- Maintains a persisted, duplicate-free history.
- Allows listing, clearing, and removing items from the history.
- Allows copying a history item back to the clipboard.

All reading and persistence logic lives in **native** code (Kotlin/Swift),
exposed to Dart through a single `MethodChannel`.

| Platform | Clipboard read | Persistence |
|---|---|---|
| Android | `ClipboardManager` | `SharedPreferences` (JSON array) |

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  clipboard_history:
    path: ../clipboard_history
```

## API

| Method | Return | Description |
|---|---|---|
| `captureClipboard()` | `Future<List<String>>` | Reads the clipboard; if not empty, adds it to the history and returns the updated list. |
| `getHistory()` | `Future<List<String>>` | Returns the persisted history (most recent first). |
| `deleteItem(String item)` | `Future<List<String>>` | Removes the item from the history and returns the updated list. |
| `addToClipboard(String item)` | `Future<bool>` | Copies the item to the system clipboard. |
| `clearHistory()` | `Future<bool>` | Clears the entire history. |

## Example

See the demo app in [`example/lib/main.dart`](example/lib/main.dart)
and [`example/lib/home_screen.dart`](example/lib/home_screen.dart).

## Limitations

| Platform | Notes |
|---|---|
| Android | Reading is allowed when the app is in the **foreground**. Since Android 10 (API 29), apps in the **background** can only read if they are the default IME/assistant. Since reading happens when the app **opens**, we are in the foreground and it works normally. |
| iOS | No special permission required. Starting with iOS 16, the system shows the "pasted from another app" notice; the one-time read on open triggers the system's default prompt. |
