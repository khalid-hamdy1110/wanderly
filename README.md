# Wanderly

Discover destinations, plan trips, track budgets & expenses, and curate favorites – all in one Flutter application.

## Table of Contents
1. Overview
2. Features
3. Architecture
4. Tech Stack
5. Project Structure
6. Setup & Installation
7. Configuration (Environment / API Keys)
8. Development Workflow
9. Error Handling Strategy
10. Known Limitations / Future Improvements
11. Contribution Guidelines
12. License

---
## 1. Overview
Wanderly is a multi-platform Flutter app (Android, iOS, Web, Desktop) focused on travel exploration and personal trip management. Users can:
- Explore countries with brief contextual info
- Mark destinations as favorites
- Plan trips (dates, budget, notes, manual completion)
- Add and categorize expenses with basic currency conversion
- View profile stats & personalize preferences (username, preferred currency, travel interests)
- Persist data locally (ObjectBox) and integrate remote data sources (countries, weather, exchange rates)

---
## 2. Features
| Domain | Feature | Details |
|--------|---------|---------|
| Onboarding | Travel interests & preferences | Select username, currency, interests; stored locally. |
| Explore | Country browser & search | Filter via search + interests; destinations list; animated UI. |
| Favorites | Manage favorite destinations | Toggle & sort (Alphabetical / Recently added / Region). |
| Trips | Trip creation & editing | Dates, budget, currency, notes, manual completion toggle. |
| Expenses | Add/remove categorized expenses | Categories (Food, Transport, etc.), budget usage progress bar. |
| Profile | Aggregated stats | Total trips, countries explored, favorites count; preferences editing. |
| Error UX | Unified error widget | Retry button, friendly messages via `Failure` mapping. |
| Feedback | Snackbars | Success/error snackbars for main user actions. |
| Persistence | Local storage | ObjectBox for trips/expenses; shared preferences for settings. |
| DI | Injection container | Centralized dependency graph in `injection/`. |
| Theming/UI | Reusable widgets | `CustomText`, `CustomTextField`, filter pills, weather & budget components. |

---
## 3. Architecture
A layered, pragmatic Clean Architecture style:

- **Presentation Layer** (`features/**/presentation`, `core/ui`):
	- Widgets & Pages (Flutter UI)
	- State management via **Cubit** (from `flutter_bloc`) for each vertical (e.g., `ExploreCubit`, `FavoritesCubit`, `ProfileStatsCubit`, `TripExpensesCubit`).
	- Error display uses `AppErrorWidget` and snackbars.

- **Domain Layer** (`core/domain`, `features/**/domain`):
	- Entities (`Trip`, `Expense`, `Country`, `ExchangeRate`, etc.)
	- Use cases (e.g., `GetAllCountries`, `GetFavoriteCountries`, `ToggleFavoriteCountry`, `SetTravelInterests`, `GetExchangeRate`)
	- Pure Dart business rules – no Flutter dependencies.

- **Data Layer** (`core/data`, feature data folders):
	- Repository implementations (remote + local when applicable)
	- Models & mappers (e.g., `ExchangeRateModel`, ObjectBox persisted entities)
	- Data sources: REST APIs (Countries, Weather), local ObjectBox store, SharedPreferences.

- **Cross-cutting**:
	- `core/error`: Failure types (`ServerFailure`, `NetworkFailure`, `TimeoutFailure`, `UnknownFailure`, etc.) & friendly mapping.
	- `core/network/retry.dart`: Exponential backoff retry helper for transient failures.
	- Dependency Injection via **get_it** configured in `injection/injection.dart`.

Data flow (simplified):
UI → Cubit → UseCase → Repository → (Remote / Local) → Entity → Cubit → UI

State is immutable & Equatable-enabled for efficient rebuilds.

---
## 4. Tech Stack
- **Framework**: Flutter 3.x+
- **Language**: Dart
- **State Management**: Bloc/Cubit
- **DI**: get_it
- **Persistence**: ObjectBox (Trips, Expenses), SharedPreferences (Settings)
- **Networking**: `http` (or similar; adjust based on actual implementation)
- **Animation**: `flutter_animate`
- **Formatting / Lint**: `analysis_options.yaml`

---
## 5. Project Structure (High-level)
```
lib/
	main.dart
	core/
		constants/               # Static app constants (travel interests, etc.)
		data/                    # Data-layer shared pieces
		domain/                  # Core domain entities & base abstractions
		error/                   # Failure classes & mappers
		network/                 # Retry logic, networking helpers
		presentation/            # Shared cubits (settings, profile stats, exchange rate)
		route_config/            # AutoRoute definitions
		ui/                      # Reusable widgets (error widget, snackbars, text fields)
	features/
		01_onboarding/
		02_explore/
		03_favorites/
		04_my_trips/
		05_profile/
	injection/                # DI setup (register use cases, repositories, cubits)
assets/                     # Static assets (icons, etc.)
objectbox-model.json        # ObjectBox schema definition
```

---
## 6. Setup & Installation
### Prerequisites
- Flutter SDK (>= 3.10) installed & on PATH
- Dart SDK bundled with Flutter
- Android Studio / Xcode for platform builds
- (Optional) Node.js for web tooling (if experimenting with PWAs)

### Clone & Install
```bash
git clone https://github.com/your-org/wanderly.git
cd wanderly
flutter pub get
```

### Code Generation / ObjectBox
If ObjectBox or other generated code is out-of-date:
```bash
# Rebuild ObjectBox + any other builders
dart run build_runner build --delete-conflicting-outputs
```

### Running
```bash
# Android / iOS (attached device or emulator)
flutter run

# Web (Chrome)
flutter run -d chrome

# Windows / macOS / Linux (desktop)
flutter run -d windows  # or macos, linux
```

### Recommended VS Code Extensions
- Dart & Flutter
- Bloc
- Error Lens

---
## 7. Configuration (Environment / API Keys)
If remote APIs require keys (e.g., Weather, Exchange Rate):
Create a `.env` or use Dart-define flags:
```
# .env (example)
WEATHER_API_KEY=YOUR_KEY
EXCHANGE_API_KEY=YOUR_KEY
```
Then pass at run time:
```bash
flutter run --dart-define=WEATHER_API_KEY=YOUR_KEY --dart-define=EXCHANGE_API_KEY=YOUR_KEY
```
Add safe accessors (e.g., `const String.fromEnvironment('WEATHER_API_KEY')`).

If you do not yet have keys integrated, this section is a placeholder for future secure configuration.

---
## 8. Development Workflow
| Task | Command / Notes |
|------|-----------------|
| Fetch deps | `flutter pub get` |
| Rebuild generated code | `dart run build_runner build --delete-conflicting-outputs` |
| Run app | `flutter run` |
| Hot reload | `r` in terminal or IDE action |
| Analyze | `flutter analyze` |
| Format | `dart format .` |

Branch naming suggestion:
- `feat/short-description`
- `fix/issue-description`
- `chore/update-deps`

Commit convention (optional): Conventional Commits (`feat:`, `fix:`, `refactor:`, etc.).

---
## 9. Error Handling Strategy
Failures encapsulate domain & infrastructure errors:
- `NetworkFailure`, `TimeoutFailure`, `ServerFailure`, `CacheFailure`, `UnknownFailure`.
Mapped via `humanizeFailure(...)` for user-friendly messaging.

UI surfaces errors through:
- `AppErrorWidget` (retry button delegates back to Cubit load method)
- Snackbars for transient action feedback (success & failure)
- Soft-fail patterns (e.g., partial stats load while ignoring a favorites error)

Retry logic (`core/network/retry.dart`) provides exponential backoff for transient network issues.

---
## 10. Known Limitations / Future Improvements
| Area | Limitation | Potential Improvement |
|------|------------|-----------------------|
| Favorites sorting | "Recently added" relies on repository order (no timestamp) | Introduce `addedAt` metadata & explicit sort |
| Interest-country mapping | Static map (`interestCountryMap`) | Externalize to remote config or CMS; support localization |
| Error granularity | Some features still use raw strings (e.g., older states) | Migrate all to `Failure` objects consistently |
| Offline capability | Limited caching beyond local entities | Add offline-first sync layer, stale-while-revalidate strategy |
| Tests | Lack of automated unit/widget/integration tests | Add test suites for use cases, cubits, widgets |
| Accessibility | Basic text & colors only | Add semantic labels, contrast audit, larger text scaling |
| Performance | No memoization for expensive aggregations | Introduce caching for profile stats & heavy computations |
| Security | API keys manual passing | Use secure storage & CI/CD secret management |
| Analytics | No usage telemetry | Add optional analytics (opt-in) |

---
## 11. Contribution Guidelines
1. Fork & branch from `main`.
2. Keep changes focused; update related documentation.
3. Run `flutter analyze` and ensure no new warnings.
4. Include tests for new logic when possible.
5. Open a PR with a clear description & screenshots (UI changes).

Code Style:
- Prefer small Cubits per feature.
- Avoid duplicated UI logic; extract widgets.
- Keep domain pure (no Flutter imports).

---
## 12. License
Specify your license here (e.g., MIT). If proprietary/internal, state usage restrictions.

```
MIT License (example)
Copyright (c) 2025 Wanderly Authors
Permission is hereby granted...
```

---
## Appendix: Troubleshooting
| Issue | Possible Fix |
|-------|--------------|
| Build_runner hangs | Delete `build/` & rerun generation |
| Exchange rates show N/A | Confirm API key or endpoint availability |
| AppErrorWidget loops retry | Inspect Cubit for non-transient errors; disable auto retry |
| Incorrect currency conversion | Verify exchange rate direction & rounding |

---
Happy wandering! 🌍
