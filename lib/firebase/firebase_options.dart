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
    apiKey: 'AIzaSyAMWgXXCTJSOWRITJnA4aaIo1DZMEcbtkY',
    appId: '1:387727179417:web:28f4b80af24ed25ca8c208',
    messagingSenderId: '387727179417',
    projectId: 'mealtodolist',
    authDomain: 'mealtodolist.firebaseapp.com',
    databaseURL: 'https://mealtodolist-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'mealtodolist.appspot.com',
    measurementId: 'G-8C4GWPK6ZM',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDLd7Xay-nWknxhcDO5mGLOm9kEDjQVfMI',
    appId: '1:387727179417:android:afa11de250a23b29a8c208',
    messagingSenderId: '387727179417',
    projectId: 'mealtodolist',
    databaseURL: 'https://mealtodolist-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'mealtodolist.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD2hAHUybYYcMe9p-QwpLwdBshz5QL3i_Y',
    appId: '1:387727179417:ios:7c50e2073d3030dda8c208',
    messagingSenderId: '387727179417',
    projectId: 'mealtodolist',
    databaseURL: 'https://mealtodolist-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'mealtodolist.appspot.com',
    iosClientId: '387727179417-ce1f700a7ar16vs5mnf9nu7rtmvv9a29.apps.googleusercontent.com',
    iosBundleId: 'com.example.flutterproject',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD2hAHUybYYcMe9p-QwpLwdBshz5QL3i_Y',
    appId: '1:387727179417:ios:a8e549715c508671a8c208',
    messagingSenderId: '387727179417',
    projectId: 'mealtodolist',
    databaseURL: 'https://mealtodolist-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'mealtodolist.appspot.com',
    iosClientId: '387727179417-n9la9dv07au8j4dais39ih4787t97qmn.apps.googleusercontent.com',
    iosBundleId: 'com.example.flutterproject.RunnerTests',
  );
}
