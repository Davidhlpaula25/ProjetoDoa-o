import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  _CadastroScreenState createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> with TickerProviderStateMixin {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _cepController = TextEditingController();
  final TextEditingController _ruaController = TextEditingController();
  final TextEditingController _bairroController = TextEditingController();
  final TextEditingController _cidadeController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isListVisible = false; // Controle de visibilidade da lista.

  Future<void> _buscarEnderecoPorCEP(String cep) async {
    if (cep.isEmpty) return;
    try {
      final response = await http.get(Uri.parse('https://viacep.com.br/ws/$cep/json/'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (!data.containsKey('erro')) {
          setState(() {
            _ruaController.text = data['logradouro'] ?? '';
            _bairroController.text = data['bairro'] ?? '';
            _cidadeController.text = data['localidade'] ?? '';
          });
        } else {
          _mostrarMensagem('CEP inválido ou não encontrado.');
        }
      } else {
        throw Exception('Erro ao buscar CEP');
      }
    } catch (e) {
      _mostrarMensagem('Erro ao buscar CEP: $e');
    }
  }

  Future<void> _registerUser() async {
    if (_formKey.currentState!.validate()) {
      final Map<String, dynamic> userData = {
        'name': _nameController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
        'cep': _cepController.text,
        'rua': _ruaController.text,
        'bairro': _bairroController.text,
        'cidade': _cidadeController.text,
        'createdAt': FieldValue.serverTimestamp(),
      };

      try {
        await _firestore.collection('cadastro').add(userData);
        _mostrarMensagem('Cadastro realizado com sucesso!');
        _limparCampos();
      } catch (e) {
        _mostrarMensagem('Erro ao cadastrar usuário: $e');
      }
    }
  }

  Future<void> _deleteUser(String docId) async {
    try {
      await _firestore.collection('cadastro').doc(docId).delete();
      _mostrarMensagem('Cadastro deletado com sucesso!');
    } catch (e) {
      _mostrarMensagem('Erro ao deletar usuário: $e');
    }
  }

  void _mostrarMensagem(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mensagem)));
  }

  void _limparCampos() {
    _nameController.clear();
    _emailController.clear();
    _passwordController.clear();
    _cepController.clear();
    _ruaController.clear();
    _bairroController.clear();
    _cidadeController.clear();
  }

  Stream<QuerySnapshot> _listarCadastros() {
    return _firestore.collection('cadastro').orderBy('createdAt').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF006400),
      appBar: AppBar(
        title: const Text('Cadastro'),
        backgroundColor: const Color(0xFF006400),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Crie sua conta',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: const Color(0xFF00FF7F),
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildTextField('Nome', _nameController),
                    const SizedBox(height: 10),
                    _buildTextField('Email', _emailController,
                        keyboardType: TextInputType.emailAddress, validator: _validarEmail),
                    const SizedBox(height: 10),
                    _buildTextField('Senha', _passwordController, obscureText: true),
                    const SizedBox(height: 10),
                    _buildTextField('CEP', _cepController,
                        keyboardType: TextInputType.number,
                        onFieldSubmitted: (_) => _buscarEnderecoPorCEP(_cepController.text)),
                    const SizedBox(height: 10),
                    _buildTextField('Rua', _ruaController, readOnly: true),
                    const SizedBox(height: 10),
                    _buildTextField('Bairro', _bairroController, readOnly: true),
                    const SizedBox(height: 10),
                    _buildTextField('Cidade', _cidadeController, readOnly: true),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _registerUser,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: const Color(0xFF00FF7F),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Cadastrar', style: TextStyle(fontSize: 18)),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _isListVisible = !_isListVisible;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.amber,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(_isListVisible ? 'Ocultar Cadastros' : 'Listar Cadastros'),
                    ),
                    if (_isListVisible)
                      StreamBuilder<QuerySnapshot>(
                        stream: _listarCadastros(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          if (snapshot.hasError) {
                            return Text(
                              'Erro ao carregar cadastros: ${snapshot.error}',
                              style: const TextStyle(color: Colors.red),
                            );
                          }
                          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                            return const Text(
                              'Nenhum cadastro encontrado.',
                              style: TextStyle(color: Colors.white),
                            );
                          }
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              final doc = snapshot.data!.docs[index];
                              final data = doc.data() as Map<String, dynamic>;
                              return ListTile(
                                title: Text(
                                  data['name'] ?? 'Sem nome',
                                  style: const TextStyle(color: Colors.white),
                                ),
                                subtitle: Text(
                                  data['email'] ?? 'Sem email',
                                  style: const TextStyle(color: Colors.white70),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _deleteUser(doc.id),
                                ),
                              );
                            },
                          );
                        },
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    bool readOnly = false,
    String? Function(String?)? validator,
    void Function(String)? onFieldSubmitted,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white),
        border: const OutlineInputBorder(),
      ),
      keyboardType: keyboardType,
      obscureText: obscureText,
      readOnly: readOnly,
      style: const TextStyle(color: Colors.white),
      validator: validator,
      onFieldSubmitted: onFieldSubmitted,
    );
  }

  String? _validarEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira seu email';
    } else if (!value.contains('@')) {
      return 'Por favor, insira um email válido';
    }
    return null;
  }
}
