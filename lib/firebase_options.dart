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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCaTCZJYDB5qqYwGbMZcQ1JEcNqjTw7IrA',
    appId: '1:263170429496:web:ffe391e485b2960581cccd',
    messagingSenderId: '263170429496',
    projectId: 'quanlybancaphe-eb429',
    authDomain: 'quanlybancaphe-eb429.firebaseapp.com',
    storageBucket: 'quanlybancaphe-eb429.appspot.com',
    measurementId: 'G-NJTVYKE1V8',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCLJk9mOm-EQIiZrLQTr8SllnMTAtDqwDA',
    appId: '1:664366100917:android:6b39c4f3a85e8e315ba9fc',
    messagingSenderId: '263170429496',
    projectId: 'quanlybancaphe-eb429',
    storageBucket: 'quanlybancaphe-eb429.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAP8ApUWUKS_sSpUCfAZGxkLBK_eC5F1W4',
    appId: '1:263170429496:ios:098cf4fb5026a38a81cccd',
    messagingSenderId: '263170429496',
    projectId: 'quanlybancaphe-eb429',
    storageBucket: 'quanlybancaphe-eb429.appspot.com',
    iosBundleId: 'com.example.highlandcoffeeapp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAP8ApUWUKS_sSpUCfAZGxkLBK_eC5F1W4',
    appId: '1:263170429496:ios:00794c70ace0003781cccd',
    messagingSenderId: '263170429496',
    projectId: 'quanlybancaphe-eb429',
    storageBucket: 'quanlybancaphe-eb429.appspot.com',
    iosBundleId: 'com.example.highlandcoffeeapp.RunnerTests',
  );
}