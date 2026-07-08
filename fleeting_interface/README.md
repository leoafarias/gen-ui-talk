# Fleeting Interface

SuperDeck presentation app for "The Fleeting Interface".

## Getting Started

Use the FVM-pinned Flutter SDK when working in this app:

```sh
fvm flutter pub get
fvm dart run superdeck_cli:main build
fvm flutter run -d chrome \
  --dart-define=FIREBASE_WEB_API_KEY=<web-api-key> \
  --dart-define=FIREBASE_APP_CHECK_SITE_KEY=<app-check-site-key>
```

For macOS runs, pass `FIREBASE_APPLE_API_KEY` instead of
`FIREBASE_WEB_API_KEY`. Non-sensitive Firebase IDs default to the
`superdeck-dev` project from `firebase.json` and can be overridden with
additional `--dart-define` values in `lib/firebase_options.dart`.

`superdeck build` writes generated runtime output into `.superdeck/`, which is
intentionally ignored except for `.superdeck/.gitkeep`.

For active deck development, run `fvm dart run superdeck_cli:main build --watch`
in one terminal and `fvm flutter run` in another. Direct `.app` launches load
the bundled `.superdeck` output from the last `superdeck build`, so rebuild
before launching the app outside the project tree.
