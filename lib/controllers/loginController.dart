// ignore: file_names
// ignore: file_names
// ignore: file_names
// ignore: file_names
// ignore: file_names
// ignore: file_names
// ignore: file_names
// ignore: file_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../home/home.view.dart'; // Importe o HomeScreen

// Classe que representa um usuário local com email e senha.
class LocalUser {
  final String email;
  final String password;

  LocalUser(this.email, this.password);
}

/// Controlador responsável pela lógica de login.
class LoginController extends GetxController {
  /// Controladores de texto para os campos de email e senha.
  TextEditingController emailInput = TextEditingController();
  TextEditingController passwordInput = TextEditingController();

  /// Lista reativa de usuários locais.
  final RxList<LocalUser> userList = RxList<LocalUser>();
  /// Indicador reativo de carregamento.
  final RxBool loading = false.obs;

  /// Instância do GoogleSignIn para login com Google.
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: '753775895492-rtu6ac7sgqidsuv65fo5cqulfhbh3i48.apps.googleusercontent.com',
  );

  String? userName = "";
  String? userEmail = "";
  String? imageUrl = "";

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    _fetchUsersFromFirestore();
  }

  /// Busca usuários cadastrados no Firestore e adiciona à lista local.
  void _fetchUsersFromFirestore() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('cadastro').get();
      for (var doc in snapshot.docs) {
        userList.add(LocalUser(doc['email'], doc['password']));
      }
    // ignore: empty_catches
    } catch (e) {
    }
  }

  /// Tenta realizar o login usando a lista local de usuários.
  void tryToLogin(BuildContext context) async {
    _fetchUsersFromFirestore(); // Certifique-se de que os usuários mais recentes são buscados
    for (var user in userList) {
      if (emailInput.text == user.email && passwordInput.text == user.password) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
        _showSuccessMessage(context, "Logado com sucesso!");
        return;
      }
    }
    _showError(context);
  }

  /// Tenta realizar o login usando o Google.
  Future<void> tryToLoginWithGoogle(BuildContext context) async {
    loading.value = true;
    final result = await _googleLogin();
    loading.value = false;

    if (result) {
      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
      // ignore: use_build_context_synchronously
      _showSuccessMessage(context, "Logado com sucesso!");
    } else {
      // ignore: use_build_context_synchronously
      _showError(context);
    }
  }

  Future<bool> _googleLogin() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        userName = googleUser.displayName;
        userEmail = googleUser.email;
        imageUrl = googleUser.photoUrl;
        return true;
      } else {
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
      }
      return false;
    }
  }

  /// Exibe mensagem de erro
  void _showError(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('ERRO AO ENTRAR: Email ou senha incorretos'),
        backgroundColor: Colors.red,
      ),
    );
  }

  /// Exibe uma mensagem de sucesso.
  void _showSuccessMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }
}
