import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Colores institucionales
const azulOscuro = Color(0xFF003366);
const rojoIntenso = Color(0xFFCC0000);
const grisClaro = Color(0xFFD9D9D9);
const amarilloDorado = Color(0xFFFFCC00);

class HorariosScreen extends StatelessWidget {
  const HorariosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grisClaro,
      appBar: AppBar(
        title: const Text('Horarios'),
        backgroundColor: azulOscuro,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('horarios').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(
                  color: rojoIntenso,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }
          final docs = snapshot.data?.docs ?? [];
          if (docs.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.schedule, color: azulOscuro, size: 60),
                  SizedBox(height: 12),
                  Text(
                    'No hay horarios disponibles',
                    style: TextStyle(
                      color: azulOscuro,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final laboratorio = data['laboratorio'] ?? '';
              final dia = data['dia'] ?? '';
              final horarios = (data['horarios'] as List<dynamic>? ?? []);

              return Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                elevation: 4,
                margin: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: ExpansionTile(
                  title: Text(
                    '$laboratorio - $dia',
                    style: const TextStyle(
                      color: azulOscuro,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  children:
                      horarios.map<Widget>((h) {
                        return Column(
                          children: [
                            ListTile(
                              leading: const Icon(
                                Icons.class_,
                                color: azulOscuro,
                              ),
                              title: Text(
                                h['Curso'] ?? '',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.access_time,
                                        size: 18,
                                        color: azulOscuro,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Hora: ${h['hora_inicio']} - ${h['hora_fin']}',
                                        style: const TextStyle(
                                          color: azulOscuro,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.person,
                                        size: 18,
                                        color: azulOscuro,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Profesor: ${h['Profesor'] ?? ''}',
                                        style: const TextStyle(
                                          color: azulOscuro,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const Divider(indent: 16, endIndent: 16, height: 1),
                          ],
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
