import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Placeholder Firebase configuration.
///
/// Replace this file by running `flutterfire configure` before using Firebase
/// in a real environment.
class DefaultFirebaseOptions {
  const DefaultFirebaseOptions._();

  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions has not been configured for web. '
        'Run `flutterfire configure` to generate lib/firebase_options.dart.',
      );
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        throw UnsupportedError(
          'DefaultFirebaseOptions has not been configured for Android. '
          'Run `flutterfire configure` to generate lib/firebase_options.dart.',
        );
      case TargetPlatform.iOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions has not been configured for iOS. '
          'Run `flutterfire configure` to generate lib/firebase_options.dart.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions has not been configured for macOS. '
          'Run `flutterfire configure` to generate lib/firebase_options.dart.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions has not been configured for Windows. '
          'Run `flutterfire configure` to generate lib/firebase_options.dart.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions has not been configured for Linux. '
          'Run `flutterfire configure` to generate lib/firebase_options.dart.',
        );
      case TargetPlatform.fuchsia:
        throw UnsupportedError(
          'DefaultFirebaseOptions has not been configured for Fuchsia. '
          'Run `flutterfire configure` to generate lib/firebase_options.dart.',
        );
    }
  }
}
