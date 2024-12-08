
import 'package:authentication/controllers/loginController.dart';
import 'package:flutter/material.dart';

// Este botão, quando pressionado, chama o método `tryToLogin` do controlador fornecido.
class LoginButton extends StatelessWidget {
  
  final LoginController controller;

  const LoginButton({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        controller.tryToLogin();
      },
      child: const Text('Entrar'),
    );
  }
}
