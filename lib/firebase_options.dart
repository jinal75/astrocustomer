import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    // ignore: missing_enum_constant_in_switch
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;

      default:
        return android;
    }
  }


  static const FirebaseOptions android = FirebaseOptions(
    apiKey: "AIzaSyCL2Vv10Z-k960HsZdPOlZ8j9uNSPon05s",
    authDomain: "astromt-51ef0.firebaseapp.com",
    projectId: "astromt-51ef0",
    storageBucket: "astromt-51ef0.appspot.com",
    messagingSenderId: "598447156670",
    appId: "1:598447156670:android:c55abe688317021b395def",
    //measurementId: "G-KBPRBBZRYC",
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: "AIzaSyAhpubggK1PVSLzh6qrV832obakTjtTkNs",
    authDomain: "astroguru-75d26.firebaseapp.com",
    projectId: "astroguru-75d26",
    storageBucket: "astroguru-75d26.appspot.com",
    messagingSenderId: "665794319149",
    appId: "1:665794319149:ios:ac01bea76103ccf108b9a4",
    androidClientId:'665794319149-02oh4re817htjn9jv6j6jcv8m7priiri.apps.googleusercontent.com',
    iosClientId:'665794319149-3mni5ojukktfr9riv3gg90uahj7e5k6b.apps.googleusercontent.com',
    iosBundleId: 'com.os.AstroGuru.app',
    //measurementId: "G-KBPRBBZRYC",
  );
}
