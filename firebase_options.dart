import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyAhzY2VyYdtrUobKSkiphzd7C9-mmmSo7Q',
    appId: '1:849743192229:web:f4d603731f26e6070a6d4c',
    messagingSenderId: '849743192229',
    projectId: 'food-app-e44ab',
    authDomain: 'food-app-e44ab.firebaseapp.com',
    storageBucket: 'food-app-e44ab.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAyRU4l4Ce-RxuKY-a6T6yEE2VeYZdZ9MA',
    appId: '1:849743192229:android:3a3e6110a5d6c6ba0a6d4c',
    messagingSenderId: '849743192229',
    projectId: 'food-app-e44ab',
    storageBucket: 'food-app-e44ab.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAcRPh8SRemMweFadM30jkHahYhRy5GD4w',
    appId: '1:849743192229:ios:169f71511dff27990a6d4c',
    messagingSenderId: '849743192229',
    projectId: 'food-app-e44ab',
    storageBucket: 'food-app-e44ab.appspot.com',
    iosBundleId: 'com.example.foodApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAcRPh8SRemMweFadM30jkHahYhRy5GD4w',
    appId: '1:849743192229:ios:169f71511dff27990a6d4c',
    messagingSenderId: '849743192229',
    projectId: 'food-app-e44ab',
    storageBucket: 'food-app-e44ab.appspot.com',
    iosBundleId: 'com.example.foodApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAhzY2VyYdtrUobKSkiphzd7C9-mmmSo7Q',
    appId: '1:849743192229:web:34714cd463ca24e80a6d4c',
    messagingSenderId: '849743192229',
    projectId: 'food-app-e44ab',
    authDomain: 'food-app-e44ab.firebaseapp.com',
    storageBucket: 'food-app-e44ab.appspot.com',
  );
}
