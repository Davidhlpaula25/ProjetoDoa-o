import 'package:authentication/controllers/loginController.dart';
import 'package:authentication/login/googleLogin.button.dart';
import 'package:flutter/material.dart';

/// Tela de login do aplicativo.
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  /// Chave global para o formulário de login.
  final _formKey = GlobalKey<FormState>();
  /// Controlador de texto para o campo de email.
  final TextEditingController _emailController = TextEditingController();
  /// Controlador de texto para o campo de senha.
  final TextEditingController _passwordController = TextEditingController();
  /// Instância do controlador de login.
  final LoginController _loginController = LoginController();

  /// Método para tentar realizar o login.
  void _login() {
    if (_formKey.currentState!.validate()) {
      _loginController.emailInput.text = _emailController.text;
      _loginController.passwordInput.text = _passwordController.text;
      _loginController.tryToLogin(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text('Legião do Bem'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Login',
                  style: TextStyle(fontSize: 32, color: Colors.white),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: const TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Colors.grey[800],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira seu email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    labelStyle: const TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Colors.grey[800],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira sua senha';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 13, 35, 133),
                    padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Confirma'),
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
