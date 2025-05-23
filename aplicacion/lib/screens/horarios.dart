import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HorariosScreen extends StatelessWidget {
  const HorariosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Horarios')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('horarios').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final docs = snapshot.data?.docs ?? [];
          if (docs.isEmpty) {
            return const Center(child: Text('No hay horarios disponibles'));
          }
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final laboratorio = data['laboratorio'] ?? '';
              final dia = data['dia'] ?? '';
              final horarios = (data['horarios'] as List<dynamic>? ?? []);

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ExpansionTile(
                  title: Text('$laboratorio - $dia'),
                  children: horarios.map<Widget>((h) {
                    return ListTile(
                      title: Text(h['Curso'] ?? ''),
                      subtitle: Text(
                        'Hora: ${h['hora_inicio']} - ${h['hora_fin']}\n'
                        'Profesor: ${h['Profesor'] ?? ''}',
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}