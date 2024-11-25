import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RankingScreen extends StatelessWidget {
  const RankingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ranking de Doações'),
        backgroundColor: const Color(0xFF006400), // Verde escuro
      ),
      backgroundColor: const Color(0xFF006400), // Fundo verde escuro
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('doacoes').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar doações.'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Nenhuma doação encontrada.'));
          }

          final doacoes = snapshot.data!.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return {
              'nome': data['nome'] ?? 'Anônimo',
              'campanha': data['campanha'] ?? 'N/A',
              'oQueVaiDoar': data['oQueVaiDoar'] ?? 'N/A',
              'sexo': data['sexo'] ?? 'N/A',
              'dataNascimento': data['dataNascimento'] ?? 'N/A',
              'cpf': data['cpf'] ?? 'N/A',
              'telefone': data['telefone'] ?? 'N/A',
            };
          }).toList();

          return ListView.builder(
            itemCount: doacoes.length,
            itemBuilder: (context, index) {
              final doacao = doacoes[index];

              return AnimatedOpacity(
                opacity: 1.0, // Aplica a animação de opacidade
                duration: Duration(milliseconds: 500 * (index + 1)),
                child: Card(
                  color: const Color(0xFF00FF7F), // Verde claro
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nome: ${doacao['nome']}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Campanha: ${doacao['campanha']}',
                          style: const TextStyle(color: Colors.black),
                        ),
                        Text(
                          'O que vai doar: ${doacao['oQueVaiDoar']}',
                          style: const TextStyle(color: Colors.black),
                        ),
                        Text(
                          'Sexo: ${doacao['sexo']}',
                          style: const TextStyle(color: Colors.black),
                        ),
                        Text(
                          'Data de Nascimento: ${doacao['dataNascimento']}',
                          style: const TextStyle(color: Colors.black),
                        ),
                        Text(
                          'CPF: ${doacao['cpf']}',
                          style: const TextStyle(color: Colors.black),
                        ),
                        Text(
                          'Telefone: ${doacao['telefone']}',
                          style: const TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
