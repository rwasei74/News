# News App

A Flutter news reader with category browsing, source filters, dark and light themes, and Arabic/English support.

## Features

- Browse the latest headlines by category: General, Business, Sports, Technology, Science, Health, and Entertainment.
- Filter a category by its available news source.
- Search recent articles by keyword.
- Open the original article in the device browser.
- Pull to refresh and load more headlines while scrolling.
- Cached article images with a graceful fallback when an image is unavailable.
- Light and dark themes, plus English and Arabic app interfaces.

## Tech stack

- [Flutter](https://flutter.dev/)
- [NewsAPI](https://newsapi.org/) for headlines, sources, and search
- [Dio](https://pub.dev/packages/dio) for network requests
- [cached_network_image](https://pub.dev/packages/cached_network_image) for article images
- [url_launcher](https://pub.dev/packages/url_launcher) for opening publisher links

## Getting started

### 1. Install dependencies

```bash
flutter pub get
```

### 2. Add your NewsAPI key

Create a local `api_keys.json` file in the project root. It is already ignored by Git and will never be committed.

```json
{
  "NEWS_API_KEY": "your-newsapi-key"
}
```

You can copy `api_keys.example.json` as a starting point.

### 3. Run the app

From the command line:

```bash
flutter run --dart-define-from-file=api_keys.json
```

The project also contains a ready-to-use `News App (development)` run configuration for Android Studio and VS Code. Choose it once, then use the normal Run button.

## Project structure

```text
lib/
├── models/       # Article and source data models
├── screens/      # Splash, home, category, and search screens
├── services/     # NewsAPI client built with Dio
├── utils/        # Theme, routes, localization, colors, and assets
└── widgets/      # Reusable UI components
```

## NewsAPI notes

The app uses the following NewsAPI endpoints:

- `top-headlines` for a category or one selected source
- `top-headlines/sources` for the source filter
- `everything` for keyword search

NewsAPI returns article metadata and the publisher URL; the full article opens on the publisher's website. The free Developer plan is intended for development and testing, so review NewsAPI's plan terms before publishing a production app.

## Security

Never commit an API key. `api_keys.json` is deliberately excluded by `.gitignore`; commit only `api_keys.example.json`.
