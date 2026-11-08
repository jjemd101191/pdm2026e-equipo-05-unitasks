// Configuración pública de las apps de Firebase del proyecto TaskU
// (`tasku-equipo-05`). Generada a partir de `firebase apps:sdkconfig`.
//
// Estos identificadores no son secretos: la seguridad de los datos está en
// `firestore.rules` y en las reglas de Firebase Auth. Se commitean para que
// el build web y el APK de GitHub Actions no necesiten archivos extra.

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
      // La app iOS todavía no está registrada en Firebase.
      default:
        throw UnsupportedError(
          'TaskU solo tiene configuración de Firebase para web y Android.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyD4seCM7vSHZAjBrxh03pthq_zkvAYqAVo',
    appId: '1:853880622302:web:f556d93dde8f1a7d58464f',
    messagingSenderId: '853880622302',
    projectId: 'tasku-equipo-05',
    authDomain: 'tasku-equipo-05.firebaseapp.com',
    storageBucket: 'tasku-equipo-05.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDA0rHAE81gChdxqDtDlzeMHMEQWSFJag8',
    appId: '1:853880622302:android:762c935843b49fcb58464f',
    messagingSenderId: '853880622302',
    projectId: 'tasku-equipo-05',
    storageBucket: 'tasku-equipo-05.firebasestorage.app',
  );
}
