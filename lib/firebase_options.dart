// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAeMV3Tl4MfFeq4lTBttmEZca4HbXd6fRs',
    appId: '1:331162971037:android:8045e61ab0c850223e9d74',
    messagingSenderId: '331162971037',
    projectId: 'avianicare-1ac52',
    storageBucket: 'avianicare-1ac52.appspot.com',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCV7h6oPnFWARLMIUmtKnmx4V3QrFsAMtU',
    appId: '1:331162971037:web:d7f5e44b8735e1af3e9d74',
    messagingSenderId: '331162971037',
    projectId: 'avianicare-1ac52',
    authDomain: 'avianicare-1ac52.firebaseapp.com',
    storageBucket: 'avianicare-1ac52.appspot.com',
    measurementId: 'G-B7KHMVSR23',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDPnb2ThSrtMqeJ-ois8qJYYO1rX9Pntp8',
    appId: '1:331162971037:ios:25c1fbffe1692c393e9d74',
    messagingSenderId: '331162971037',
    projectId: 'avianicare-1ac52',
    storageBucket: 'avianicare-1ac52.appspot.com',
    iosBundleId: 'com.inilabs.shopking',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDPnb2ThSrtMqeJ-ois8qJYYO1rX9Pntp8',
    appId: '1:331162971037:ios:25c1fbffe1692c393e9d74',
    messagingSenderId: '331162971037',
    projectId: 'avianicare-1ac52',
    storageBucket: 'avianicare-1ac52.appspot.com',
    iosBundleId: 'com.inilabs.shopking',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCV7h6oPnFWARLMIUmtKnmx4V3QrFsAMtU',
    appId: '1:331162971037:web:001f736626a96a813e9d74',
    messagingSenderId: '331162971037',
    projectId: 'avianicare-1ac52',
    authDomain: 'avianicare-1ac52.firebaseapp.com',
    storageBucket: 'avianicare-1ac52.appspot.com',
    measurementId: 'G-9RLWWW496K',
  );

}