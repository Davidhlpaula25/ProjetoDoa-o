import 'package:authentication/controllers/loginController.dart';
import 'package:flutter/material.dart';

/// Um botão personalizado para login com Google.
class GoogleLoginButton extends StatelessWidget {
  
  final LoginController controller;
  /// Callback a ser executado quando o botão for pressionado.
  final VoidCallback onPressed;

  const GoogleLoginButton({super.key, required this.controller, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF00FF7F), // Verde claro
        padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.g_mobiledata, color: Colors.black), // Ícone com cor preta
          SizedBox(width: 8), 
          Text('Entrar com Google', style: TextStyle(color: Colors.black)),
        ],
      ),
    );
  }
}
