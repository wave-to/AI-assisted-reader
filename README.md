# AI Assisted Reader

An intelligent e-book reader forked from [Anx Reader](https://github.com/Anxcye/Anx-Reader) (v1.15.0, MIT), enhanced with AI-powered reading assistance and optimized page-turning gestures.

## Key Enhancements

### AI-Assisted Reading
- **Multi-provider AI chat** — Claude (Fable 5, Opus 4.8, Sonnet 4.6), DeepSeek, OpenAI, OpenRouter
- **Smart model discovery** — auto-fetches available models via API with built-in fallback lists
- **In-book AI panel** — split-screen or bottom-sheet chat while reading
- **Quick prompts** — summarize chapter, summarize book, generate mindmap, and custom user prompts
- **Tool integration** — mindmap visualization, bookshelf organization, auto-tagging
- **Streaming responses** — real-time token-by-token output with reasoning panel

### Optimized Page Turning
- **New gesture mode** (Type 6) — tap left/right zones to advance, center tap for menu, swipe left to go back
- **Swipe detection** — JavaScript-injected touch tracking inside the WebView for reliable gesture recognition
- **All 6 page-turn presets** — classic 3-zone, asymmetric, scroll, and custom 3×3 grid

### UI Refinements
- **Swiss Minimalism** design system for system UI
- **Paper & Ink** warm reading theme with `#F5F1E8` page background
- **AI Purple accent** (`#7C5CBF`) for all AI-related elements
- **Semi-transparent reading toolbar** with backdrop blur
- **44×44px touch targets** throughout the interface

## Design System

| Token | Light | Dark | Usage |
|-------|-------|------|-------|
| `--bg` | `#FAFAFA` | `#121212` | Scaffold background |
| `--surface` | `#FFFFFF` | `#1E1E1E` | Cards, containers |
| `--text-primary` | `#1A1A1A` | `#E8E8E8` | Headlines, body |
| `--accent` | `#2563EB` | `#60A5FA` | Primary accent |
| `--ai-purple` | `#7C5CBF` | `#9B8ECC` | AI elements |

Reading themes: **Minimal** (`#FFFFFF` / `#1A1A1A`) and **Paper & Ink** (`#F5F1E8` / `#2D2D2D`).

## Tech Stack

- **Flutter 3.41** with Dart 3.11
- **Riverpod** for state management
- **FlexColorScheme** for Material 3 theming
- **InAppWebView** for EPUB rendering (foliate-js)
- **LangChain.dart** for AI chat orchestration
- **Material Design 3** with Swiss Minimalism style

## Build

```bash
# Activate dev environment
source tools/activate.sh

# Get dependencies
cd app && flutter pub get

# Build release APK (split per ABI)
flutter build apk --release --split-per-abi
```

Output APKs:
- `app-arm64-v8a-release.apk` — most Android phones
- `app-armeabi-v7a-release.apk` — older 32-bit devices
- `app-x86_64-release.apk` — emulators

## Credits

Based on [Anx Reader](https://github.com/Anxcye/Anx-Reader) by Anxcye, licensed under MIT.

## License

MIT — see the original [LICENSE](./LICENSE) file.
