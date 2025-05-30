// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAOKUR2LpUQEo_xbmZFQqHbjXJ_6_1kSxg',
    appId: '1:505502783602:web:fca00afd6c34d8e3c70aeb',
    messagingSenderId: '505502783602',
    projectId: 'hand2heart-88c02',
    authDomain: 'hand2heart-88c02.firebaseapp.com',
    storageBucket: 'hand2heart-88c02.firebasestorage.app',
    measurementId: 'G-P0D472BQ2L',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDDWlhSIM1JZIDNX43uDAzygIlkaNbcs6M',
    appId: '1:505502783602:android:6398346ecf27ed47c70aeb',
    messagingSenderId: '505502783602',
    projectId: 'hand2heart-88c02',
    storageBucket: 'hand2heart-88c02.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDftFIN8avMcscMRqbg_n3wnvmW5MsP4tg',
    appId: '1:505502783602:ios:b3c0a26d9943580bc70aeb',
    messagingSenderId: '505502783602',
    projectId: 'hand2heart-88c02',
    storageBucket: 'hand2heart-88c02.firebasestorage.app',
    iosBundleId: 'com.example.hand2HeartMobile',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDftFIN8avMcscMRqbg_n3wnvmW5MsP4tg',
    appId: '1:505502783602:ios:b3c0a26d9943580bc70aeb',
    messagingSenderId: '505502783602',
    projectId: 'hand2heart-88c02',
    storageBucket: 'hand2heart-88c02.firebasestorage.app',
    iosBundleId: 'com.example.hand2HeartMobile',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAOKUR2LpUQEo_xbmZFQqHbjXJ_6_1kSxg',
    appId: '1:505502783602:web:e74dd4735ca44656c70aeb',
    messagingSenderId: '505502783602',
    projectId: 'hand2heart-88c02',
    authDomain: 'hand2heart-88c02.firebaseapp.com',
    storageBucket: 'hand2heart-88c02.firebasestorage.app',
    measurementId: 'G-9025PPRRTS',
  );
}
