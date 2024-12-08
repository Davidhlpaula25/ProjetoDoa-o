import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

class CadastrarDoacoesScreen extends StatefulWidget {
  const CadastrarDoacoesScreen({super.key});

  @override
  _CadastrarDoacoesScreenState createState() =>
      _CadastrarDoacoesScreenState();
}

class _CadastrarDoacoesScreenState extends State<CadastrarDoacoesScreen> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _dataNascimentoController =
      TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _campoExtra1Controller = TextEditingController();
  final TextEditingController _campoExtra2Controller = TextEditingController();

  String? _campanhaSelecionada;
  String _sexoSelecionado = 'Masculino';

  final Map<String, int> _itensVistaSeBem = {
    'Roupas': 0,
    'Objetos Diversos': 0,
    'Calçados': 0,
    'Livros': 0,
    'Brinquedos': 0,
  };

  final Map<String, int> _itensFomeZero = {
    'Arroz': 0,
    'Feijão': 0,
    'Farinha de Trigo': 0,
    'Leite em Pó': 0,
    'Legumes Enlatados': 0,
    'Gelatina': 0,
    'Biscoitos': 0,
    'Açúcar': 0,
    'Chocolate': 0,
    'Óleo': 0,
    'Leite': 0,
  };

  bool _isButtonPressed = false;

  Future<void> _adicionarDoacao() async {
    final String nome = _nomeController.text;
    final String dataNascimento = _dataNascimentoController.text;
    final String cpf = _cpfController.text;
    final String telefone = _telefoneController.text;

    final Map<String, int> itensSelecionados = _campanhaSelecionada == 'Vista-se bem'
        ? _itensVistaSeBem
        : _campanhaSelecionada == 'Fome-zero'
            ? _itensFomeZero
            : {};

    await FirebaseFirestore.instance.collection('doacoes').add({
      'nome': nome,
      'campanha': _campanhaSelecionada ?? 'Nenhuma campanha selecionada',
      'oQueVaiDoar': itensSelecionados.toString(),
      'sexo': _sexoSelecionado,
      'dataNascimento': dataNascimento,
      'cpf': cpf,
      'telefone': telefone,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Doação cadastrada com sucesso!')),
    );

    _limparCampos();
  }

  void _limparCampos() {
    _nomeController.clear();
    _dataNascimentoController.clear();
    _cpfController.clear();
    _telefoneController.clear();
    _campoExtra1Controller.clear();
    _campoExtra2Controller.clear();
    setState(() {
      _campanhaSelecionada = null;
      _sexoSelecionado = 'Masculino';
      _itensVistaSeBem.updateAll((key, value) => 0);
      _itensFomeZero.updateAll((key, value) => 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar Doações'),
        backgroundColor: const Color(0xFF006400),
      ),
      backgroundColor: const Color(0xFF006400),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                  labelStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Color(0xFF006400),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _dataNascimentoController,
                decoration: const InputDecoration(
                  labelText: 'Data de Nascimento',
                  labelStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Color(0xFF006400),
                ),
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.datetime,
                inputFormatters: [
                  MaskedInputFormatter('##/##/####'), // Formato para data
                ],
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _cpfController,
                decoration: const InputDecoration(
                  labelText: 'CPF',
                  labelStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Color(0xFF006400),
                ),
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _telefoneController,
                decoration: const InputDecoration(
                  labelText: 'Telefone',
                  labelStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Color(0xFF006400),
                ),
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _sexoSelecionado,
                decoration: const InputDecoration(
                  labelText: 'Sexo',
                  labelStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Color(0xFF006400),
                ),
                style: const TextStyle(color: Colors.white),
                dropdownColor: const Color(0xFF006400),
                items: ['Masculino', 'Feminino', 'Outros'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: const TextStyle(color: Colors.white)),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _sexoSelecionado = newValue!;
                  });
                },
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _campanhaSelecionada,
                decoration: const InputDecoration(
                  labelText: 'Campanha',
                  labelStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Color(0xFF006400),
                ),
                style: const TextStyle(color: Colors.white),
                dropdownColor: const Color(0xFF006400),
                items: ['Vista-se bem', 'Fome-zero'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: const TextStyle(color: Colors.white)),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _campanhaSelecionada = newValue!;
                  });
                },
              ),
              const SizedBox(height: 10),
              if (_campanhaSelecionada == 'Vista-se bem') ...[
                _buildItensDoacao(_itensVistaSeBem),
              ],
              if (_campanhaSelecionada == 'Fome-zero') ...[
                _buildItensDoacao(_itensFomeZero),
              ],
              const SizedBox(height: 20),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  color: _isButtonPressed ? Colors.green : Colors.lightGreen,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isButtonPressed = !_isButtonPressed;
                    });
                    _adicionarDoacao();
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Cadastrar Doação',
                      style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItensDoacao(Map<String, int> itens) {
    return Column(
      children: itens.keys.map((item) {
        return AnimatedOpacity(
          opacity: 1.0,
          duration: const Duration(milliseconds: 500),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(item, style: const TextStyle(color: Colors.white)),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove, color: Colors.white),
                    onPressed: () {
                      setState(() {
                        if (itens[item]! > 0) {
                          itens[item] = itens[item]! - 1;
                        }
                      });
                    },
                  ),
                  Text(
                    itens[item]!.toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add, color: Colors.white),
                    onPressed: () {
                      setState(() {
                        itens[item] = itens[item]! + 1;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
