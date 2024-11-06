import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CadastroScreen extends StatefulWidget {
  @override
  _CadastroScreenState createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _showList = false;

  Future<void> _registerUser() async {
    final String name = _nameController.text;
    final String email = _emailController.text;
    final String password = _passwordController.text;

    if (name.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
      try {
        // Adicionar os dados do usuário no Firestore
        await _firestore.collection('cadastro').add({
          'name': name,
          'email': email,
          'password': password,
          'createdAt': FieldValue.serverTimestamp(), // Adiciona um timestamp para o registro
        });

        // Exibir mensagem de sucesso
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cadastro realizado com sucesso!')),
        );

        // Limpar os campos do formulário
        _nameController.clear();
        _emailController.clear();
        _passwordController.clear();
      } catch (e) {
        // Exibir mensagem de erro
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao cadastrar usuário: $e')),
        );
      }
    } else {
      // Exibir mensagem de aviso se algum campo estiver vazio
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, preencha todos os campos')),
      );
    }
  }

  Future<void> _deleteUser(String docId) async {
    try {
      // Deleta o documento com o ID especificado na coleção 'cadastro'
      await _firestore.collection('cadastro').doc(docId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cadastro deletado com sucesso!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao deletar usuário: $e')),
      );
    }
  }

  Stream<QuerySnapshot> _listarCadastros() {
    return _firestore.collection('cadastro').orderBy('createdAt').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nome'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _registerUser,
              child: Text('Cadastrar'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _showList = !_showList;
                });
              },
              child: Text(_showList ? 'Ocultar Cadastros' : 'Listar Cadastros'),
            ),
            SizedBox(height: 20),
            if (_showList)
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _listarCadastros(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }

                    if (snapshot.hasError) {
                      return Text('Erro: ${snapshot.error}');
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Text('Nenhum cadastro encontrado');
                    }

                    return ListView(
                      children: snapshot.data!.docs.map((doc) {
                        return ListTile(
                          title: Text(doc['name']),
                          subtitle: Text(doc['email']),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => _deleteUser(doc.id),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
