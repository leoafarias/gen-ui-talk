import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Firebase configuration for the deck demos.
///
/// Sensitive values are supplied at build/run time with `--dart-define`.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        return apple;
      case TargetPlatform.macOS:
        return apple;
      case TargetPlatform.android:
        throw _unsupportedPlatform('android');
      case TargetPlatform.windows:
        throw _unsupportedPlatform('windows');
      case TargetPlatform.linux:
        throw _unsupportedPlatform('linux');
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static FirebaseOptions get web {
    _checkRequired(
      platform: 'web',
      values: {'FIREBASE_WEB_API_KEY': _webApiKey},
    );

    return const FirebaseOptions(
      apiKey: _webApiKey,
      appId: _webAppId,
      messagingSenderId: _messagingSenderId,
      projectId: _projectId,
      authDomain: _webAuthDomain,
      storageBucket: _storageBucket,
      measurementId: _webMeasurementId,
    );
  }

  static FirebaseOptions get apple {
    _checkRequired(
      platform: 'Apple',
      values: {'FIREBASE_APPLE_API_KEY': _appleApiKey},
    );

    return const FirebaseOptions(
      apiKey: _appleApiKey,
      appId: _appleAppId,
      messagingSenderId: _messagingSenderId,
      projectId: _projectId,
      storageBucket: _storageBucket,
      iosBundleId: _appleBundleId,
    );
  }

  static UnsupportedError _unsupportedPlatform(String platform) {
    return UnsupportedError(
      'DefaultFirebaseOptions have not been configured for $platform.',
    );
  }

  static void _checkRequired({
    required String platform,
    required Map<String, String> values,
  }) {
    final missing = values.entries
        .where((entry) => entry.value.isEmpty)
        .map((entry) => entry.key)
        .join(', ');
    if (missing.isEmpty) return;

    throw UnsupportedError(
      'Firebase $platform options are missing: $missing. '
      'Pass them with --dart-define.',
    );
  }

  static const _projectId = String.fromEnvironment(
    'FIREBASE_PROJECT_ID',
    defaultValue: 'superdeck-dev',
  );
  static const _messagingSenderId = String.fromEnvironment(
    'FIREBASE_MESSAGING_SENDER_ID',
    defaultValue: '707852212779',
  );
  static const _storageBucket = String.fromEnvironment(
    'FIREBASE_STORAGE_BUCKET',
    defaultValue: 'superdeck-dev.firebasestorage.app',
  );

  static const _webApiKey = String.fromEnvironment('FIREBASE_WEB_API_KEY');
  static const _webAppId = String.fromEnvironment(
    'FIREBASE_WEB_APP_ID',
    defaultValue: '1:707852212779:web:5e20b55f98005b0736a86e',
  );
  static const _webAuthDomain = String.fromEnvironment(
    'FIREBASE_WEB_AUTH_DOMAIN',
    defaultValue: 'superdeck-dev.firebaseapp.com',
  );
  static const _webMeasurementId = String.fromEnvironment(
    'FIREBASE_WEB_MEASUREMENT_ID',
    defaultValue: 'G-8MX14K6P7N',
  );

  static const _appleApiKey = String.fromEnvironment('FIREBASE_APPLE_API_KEY');
  static const _appleAppId = String.fromEnvironment(
    'FIREBASE_APPLE_APP_ID',
    defaultValue: '1:707852212779:ios:49990cab66e8dc4f36a86e',
  );
  static const _appleBundleId = String.fromEnvironment(
    'FIREBASE_APPLE_BUNDLE_ID',
    defaultValue: 'com.example.fleetingInterface',
  );
}
