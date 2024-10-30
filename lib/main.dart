import 'package:authentication/login/login.view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart'; 
//função principal que inicializa o aplicativo
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();     //garantir que os bindings do flutter sejam innicciados antes de tudo
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,    //inicializar o firebase com opçoes especificas
  );
  runApp(MyApp());     //executor do app
}
//classe principal do app
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bem vindo Legião do Bem',
      theme: ThemeData.dark(),
      home: Main(),
    );
  }
}
//tela principal
class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 52, 53, 53),
      appBar: AppBar(
        title: const Text('Bem vindo Legião do Bem'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          },
          child: const Text('Sua doação pode mudar vidas. Clique aqui para contribuir. '),
        ),
      ),
    );
  }
}
