import 'package:authentication/controllers/loginController.dart';
import 'package:authentication/login/googleLogin.button.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final LoginController _loginController = LoginController();

  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<Offset> _buttonSlideAnimation;

  void _login() {
    if (_formKey.currentState!.validate()) {
      _loginController.emailInput.text = _emailController.text;
      _loginController.passwordInput.text = _passwordController.text;
      _loginController.tryToLogin(context);
    }
  }

  @override
  void initState() {
    super.initState();

    // Configurações da animação
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _slideAnimation = Tween<Offset>(begin: Offset(0, 0.5), end: Offset(0, 0)).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _buttonSlideAnimation = Tween<Offset>(begin: Offset(0, 0.5), end: Offset(0, 0)).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF006400), // Fundo verde escuro
      appBar: AppBar(
        title: const Text('Legião do Bem'),
        backgroundColor: const Color(0xFF006400), // Verde escuro
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AnimatedOpacity(
                  opacity: _opacityAnimation.value,
                  duration: Duration(seconds: 1),
                  child: Text(
                    'Login',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          color: const Color(0xFF00FF7F), // Verde claro
                          fontSize: 30,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 24),
                AnimatedSlide(
                  offset: _slideAnimation.value,
                  duration: Duration(seconds: 1),
                  child: TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: const TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: const Color(0xFF006400), // Verde claro
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    style: const TextStyle(color: Colors.black),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira seu email';
                      } else if (!value.contains('@')) {
                        return 'Por favor, insira um email válido';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 16),
                AnimatedSlide(
                  offset: _slideAnimation.value,
                  duration: Duration(seconds: 1),
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      labelStyle: const TextStyle(color: Colors.white),
                      filled: true,
                      fillColor: const Color(0xFF006400), // Verde claro
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    style: const TextStyle(color: Colors.black),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira sua senha';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 24),
                AnimatedSlide(
                  offset: _buttonSlideAnimation.value,
                  duration: Duration(seconds: 1),
                  child: ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: const Color(0xFF00FF7F), // Verde claro
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Confirma', style: TextStyle(fontSize: 18)),
                  ),
                ),
                const SizedBox(height: 16),
                const Divider(color: Color.fromARGB(255, 156, 19, 88)),
                const SizedBox(height: 16),
                GoogleLoginButton(
                  controller: _loginController, // Passa o controlador para o botão Google
                  onPressed: () => _loginController.tryToLoginWithGoogle(context), // Passa o contexto para o login com Google
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
