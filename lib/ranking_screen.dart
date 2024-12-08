import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
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

          // Criando um mapa para contar as doações por campanha
          Map<String, int> doacoesPorCampanha = {};

          for (var doc in snapshot.data!.docs) {
            final data = doc.data() as Map<String, dynamic>;
            final campanha = data['campanha'] ?? 'N/A';
            doacoesPorCampanha[campanha] =
                (doacoesPorCampanha[campanha] ?? 0) + 1;
          }

          // Total de doações
          // ignore: avoid_types_as_parameter_names
          int totalDoacoes = doacoesPorCampanha.values.fold(0, (sum, count) => sum + count);

          // Preparando os dados para o gráfico de pizza
          List<PieChartSectionData> pieChartData = doacoesPorCampanha.entries.map((entry) {
            final double percentage = (entry.value / totalDoacoes) * 100;
            return PieChartSectionData(
              value: percentage,
              title: '${entry.key}\n(${percentage.toStringAsFixed(1)}%)', // Nome da campanha e percentual
              color: _getColorForIndex(doacoesPorCampanha.keys.toList().indexOf(entry.key)),
              radius: 50,
              titleStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            );
          }).toList();

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Gráfico de Pizza
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: pieChartData.isEmpty
                      ? const Center(child: Text('Sem dados para o gráfico'))
                      : SizedBox(
                          height: 250, // Altura fixa para o gráfico
                          child: PieChart(
                            PieChartData(
                              sections: pieChartData,
                              borderData: FlBorderData(show: false),
                              sectionsSpace: 2,
                              centerSpaceRadius: 40,
                            ),
                          ),
                        ),
                ),
                // Lista de doações
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: snapshot.data!.docs.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;

                      return GestureDetector(
                        onTap: () {
                          // Ao clicar, mostrar um modal com mais detalhes ou uma ação
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Detalhes da Doação'),
                                content: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('Nome: ${data['nome'] ?? 'Anônimo'}'),
                                    Text('Campanha: ${data['campanha'] ?? 'N/A'}'),
                                    Text('O que vai doar: ${data['oQueVaiDoar'] ?? 'N/A'}'),
                                    Text('Sexo: ${data['sexo'] ?? 'N/A'}'),
                                    Text('Data de Nascimento: ${data['dataNascimento'] ?? 'N/A'}'),
                                    Text('CPF: ${data['cpf'] ?? 'N/A'}'),
                                    Text('Telefone: ${data['telefone'] ?? 'N/A'}'),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Fechar'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Card(
                          color: const Color(0xFF00FF7F), // Verde claro
                          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Nome: ${data['nome'] ?? 'Anônimo'}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text('Campanha: ${data['campanha'] ?? 'N/A'}'),
                                Text('O que vai doar: ${data['oQueVaiDoar'] ?? 'N/A'}'),
                                Text('Sexo: ${data['sexo'] ?? 'N/A'}'),
                                Text('Data de Nascimento: ${data['dataNascimento'] ?? 'N/A'}'),
                                Text('CPF: ${data['cpf'] ?? 'N/A'}'),
                                Text('Telefone: ${data['telefone'] ?? 'N/A'}'),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Ação de doação iniciada!')),
          );
        },
        backgroundColor: const Color(0xFF006400),
        child: const Icon(Icons.add), // Verde escuro
      ),
    );
  }

  // Função para retornar as cores específicas para as campanhas
  Color _getColorForIndex(int index) {
    switch (index % 3) {
      case 0:
        return Colors.blue; // Azul
      case 1:
        return Colors.red; // Vermelho
      case 2:
        return Colors.lightGreen; // Verde claro
      default:
        return Colors.blue; // Azul por padrão
    }
  }
}
