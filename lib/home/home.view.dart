import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Tela principal do aplicativo.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomePage'),
        
        leading: const Icon(Icons.person),
        actions: [
          IconButton(
            onPressed: () {
              Get.back(); // Volta para a tela anterior.
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: _body(), // Chama o método _body para construir o corpo da tela.
    );
  }

  /// Método que constrói o corpo da tela.
Widget _body() {
    return Center(
      child: Text(
        'Bem-vindo! Você conseguiu logar.',
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}