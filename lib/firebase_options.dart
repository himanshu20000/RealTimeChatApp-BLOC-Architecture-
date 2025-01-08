
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
    apiKey: 'AIzaSyD2vO7GQAXqw6vhWge7Pm0R5-I9UINIHu4',
    appId: '1:347670578887:web:4f5125c59931964a2be0e2',
    messagingSenderId: '347670578887',
    projectId: 'realtimechat-d2992',
    authDomain: 'realtimechat-d2992.firebaseapp.com',
    storageBucket: 'realtimechat-d2992.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDDMZ5yOt8fRYRnYkau1A2BnOprL1U4MjU',
    appId: '1:347670578887:android:f371c1064bc0632a2be0e2',
    messagingSenderId: '347670578887',
    projectId: 'realtimechat-d2992',
    storageBucket: 'realtimechat-d2992.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDxSgDmIvloTaOd6sbbvlemWzaZKpgciXI',
    appId: '1:347670578887:ios:a8bda9a51088bf4b2be0e2',
    messagingSenderId: '347670578887',
    projectId: 'realtimechat-d2992',
    storageBucket: 'realtimechat-d2992.firebasestorage.app',
    iosBundleId: 'com.example.chatappRealtime',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDxSgDmIvloTaOd6sbbvlemWzaZKpgciXI',
    appId: '1:347670578887:ios:a8bda9a51088bf4b2be0e2',
    messagingSenderId: '347670578887',
    projectId: 'realtimechat-d2992',
    storageBucket: 'realtimechat-d2992.firebasestorage.app',
    iosBundleId: 'com.example.chatappRealtime',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyD2vO7GQAXqw6vhWge7Pm0R5-I9UINIHu4',
    appId: '1:347670578887:web:7ce325ad6edc98c22be0e2',
    messagingSenderId: '347670578887',
    projectId: 'realtimechat-d2992',
    authDomain: 'realtimechat-d2992.firebaseapp.com',
    storageBucket: 'realtimechat-d2992.firebasestorage.app',
  );
}
