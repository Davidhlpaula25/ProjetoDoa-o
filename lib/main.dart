import 'package:authentication/home/cadastrar_doacoes_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'cadastro_screen.dart'; // Importe a nova tela de cadastro
import 'firebase_options.dart';
import 'home/home.view.dart'; // Importe a tela de perfil
import 'login/login.view.dart'; // Importe a tela de login
import 'ranking_screen.dart'; // Importe a nova tela de ranking

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Garantir que os bindings do Flutter sejam iniciados antes de tudo
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Inicializar o Firebase com opções específicas
  );
  runApp(const MyApp()); // Executor do app
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bem vindo Legião do Bem',
      theme: ThemeData(
        primaryColor: const Color(0xFF006400), // Verde escuro
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: const Color(0xFF00FF7F), // Verde claro
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      initialRoute: '/', // Ajustado para a tela inicial
      routes: {
        '/': (context) => const SplashScreen(), // Tela inicial
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/cadastro': (context) => const CadastroScreen(), // Adiciona a rota para a tela de cadastro
        '/cadastrar-doacoes': (context) => const CadastrarDoacoesScreen(), // Adiciona a rota para a tela de cadastro de doações
        '/main-screen': (context) => const MainScreen(), // Adiciona a rota para a tela principal
        '/ranking': (context) => const RankingScreen(), // Adiciona a rota para a tela de ranking
        // Adicione outras rotas conforme necessário
      },
    );
  }
}

// Tela de Splash com Animação
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation; // Certifique-se de que o tipo seja Animation<double>

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..forward();
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    Future.delayed(const Duration(seconds: 3), () {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, '/main-screen');
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF006400), // Verde escuro
      body: FadeTransition(
        opacity: _animation,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.favorite, size: 100, color: Colors.white),
              const SizedBox(height: 20),
              Text('Legião do Bem', style: Theme.of(context).textTheme.displayLarge),
            ],
          ),
        ),
      ),
    );
  }
}

// Tela principal
class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF006400), // Verde escuro
      appBar: AppBar(
        title: const Text('Bem vindo Legião do Bem'),
        backgroundColor: const Color(0xFF006400), // Verde escuro
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black, backgroundColor: const Color(0xFF00FF7F), // Cor do texto
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: const Icon(Icons.login, color: Colors.black), // Ícone de login
                label: const Text('Login'),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/cadastro');
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black, backgroundColor: const Color(0xFF00FF7F), // Cor do texto
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: const Icon(Icons.person_add, color: Colors.black), // Ícone de cadastro
                label: const Text('Cadastre-se'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}