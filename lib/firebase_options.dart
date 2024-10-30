import 'package:firebase_core/firebase_core.dart';

/// Classe que fornece as opções de configuração do Firebase para a plataforma atual.
class DefaultFirebaseOptions {
  /// Retorna as opções de configuração do Firebase para a plataforma atual.
  static FirebaseOptions get currentPlatform {
    return const FirebaseOptions(
      apiKey: "AIzaSyBRlsb6_YxPzSwsIe3uDY00gIQav4DCAJc",
      authDomain: "loginapp-19d7e.firebaseapp.com",
      projectId: "loginapp-19d7e",
      storageBucket: "loginapp-19d7e.appspot.com",
      messagingSenderId: "753775895492",
      appId: "1:753775895492:android:a3e2f6433150e35e5bba91",
    );
  }
}
