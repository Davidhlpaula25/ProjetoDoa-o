import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'cadastro_screen.dart'; // Importe a nova tela de cadastro
import 'firebase_options.dart';
import 'home/home.view.dart'; // Importe a tela principal
import 'login/login.view.dart'; // Importe a tela de login

// Função principal que inicializa o aplicativo
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Garantir que os bindings do Flutter sejam iniciados antes de tudo
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Inicializar o Firebase com opções específicas
  );
  runApp(MyApp()); // Executor do app
}

// Classe principal do app
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bem vindo Legião do Bem',
      theme: ThemeData.dark(),
      initialRoute: '/', // Ajustado para a tela inicial
      routes: {
        '/': (context) => Main(), // Tela inicial
        '/login': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
        '/cadastro': (context) => CadastroScreen(), // Adiciona a rota para a tela de cadastro
      },
    );
  }
}

// Tela principal
class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 52, 53, 53),
      appBar: AppBar(
        title: const Text('Bem vindo Legião do Bem'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Sua doação pode mudar vidas.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              child: const Text('Clique aqui para contribuir.'),
            ),
            const SizedBox(height: 40),
            const Text(
              'Novo aqui?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/cadastro');
              },
              child: const Text('Cadastre-se ou faça login'),
            ),
          ],
        ),
      ),
    );
  }
}
