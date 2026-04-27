import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

/// Values from [android/app/google-services.json] (Android client).
/// For iOS, run `dart pub global activate flutterfire_cli` then `flutterfire configure`.
class DefaultFirebaseOptions {
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB7X3-qFtnnxAxC7n9gFQ0RCFo9ccFteZ8',
    appId: '1:213521842713:android:50fb6df3bbffef6ede2088',
    messagingSenderId: '213521842713',
    projectId: 'marketplace-2be74',
    storageBucket: 'marketplace-2be74.firebasestorage.app',
  );
}
