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
      return web;
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCeo59act9M4WL8leXx_L5ACs9M_IT8FMQ',
    appId: '1:1090709913179:web:036806f316e4ec77f2097e',
    messagingSenderId: '1090709913179',
    projectId: 'kayracrm2026',
    authDomain: 'kayracrm2026.firebaseapp.com',
    storageBucket: 'kayracrm2026.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA5jmv-ZC-8C2rF97hMs4pCbK_OttOl-zY',
    appId: '1:1090709913179:android:1357f3b10a79cf81f2097e',
    messagingSenderId: '1090709913179',
    projectId: 'kayracrm2026',
    storageBucket: 'kayracrm2026.firebasestorage.app',
  );

}