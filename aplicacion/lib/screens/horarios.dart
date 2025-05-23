import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Colores institucionales
const azulOscuro = Color(0xFF003366);
const rojoIntenso = Color(0xFFCC0000);
const grisClaro = Color(0xFFD9D9D9);
const amarilloDorado = Color(0xFFFFCC00);

const List<String> diasSemana = [
  'Lunes',
  'Martes',
  'Miércoles',
  'Jueves',
  'Viernes',
  'Sábado',
  'Domingo',
];

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

          // Agrupar por laboratorio
          final Map<String, Map<String, List<Map<String, dynamic>>>> agrupado =
              {};
          for (var doc in docs) {
            final data = doc.data() as Map<String, dynamic>;
            final lab = data['laboratorio'] ?? '';
            final dia = data['dia'] ?? '';
            final horarios =
                (data['horarios'] as List<dynamic>? ?? [])
                    .map((h) => Map<String, dynamic>.from(h))
                    .toList();

            agrupado.putIfAbsent(lab, () => {});
            agrupado[lab]!.putIfAbsent(dia, () => []);
            agrupado[lab]![dia]!.addAll(horarios);
          }

          return GridView.count(
            crossAxisCount: 2, // 2 columnas, así entran 4 en la pantalla (2x2)
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            childAspectRatio: 1, // cuadrado
            children:
                agrupado.entries.map((labEntry) {
                  final lab = labEntry.key;
                  final dias = labEntry.value;

                  return GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Colors.transparent,
                        isScrollControlled: true,
                        builder:
                            (_) => DraggableScrollableSheet(
                              initialChildSize: 0.65,
                              minChildSize: 0.4,
                              maxChildSize: 0.95,
                              expand: false,
                              builder:
                                  (context, scrollController) => Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(24),
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        // Barra superior personalizada
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            top: 16,
                                          ),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: azulOscuro,
                                              
                                              borderRadius:
                                                  const BorderRadius.vertical(
                                                    top: Radius.circular(24),
                                                  ),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 12,
                                            ),
                                            child: Row(
                                              children: [
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.arrow_back,
                                                    color: Colors.white,
                                                  ),
                                                  onPressed:
                                                      () =>
                                                          Navigator.of(
                                                            context,
                                                          ).pop(),
                                                  tooltip: 'Cerrar',
                                                ),
                                                const Icon(
                                                  Icons.computer,
                                                  color: Colors.white,
                                                  size: 28,
                                                ),
                                                const SizedBox(width: 12),
                                                Expanded(
                                                  child: Text(
                                                    lab,
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        // Contenido desplazable
                                        Expanded(
                                          child: SingleChildScrollView(
                                            controller: scrollController,
                                            child: Padding(
                                              padding: const EdgeInsets.all(
                                                20.0,
                                              ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  ...diasSemana
                                                      .where(
                                                        (dia) => dias
                                                            .containsKey(dia),
                                                      )
                                                      .map((dia) {
                                                        final horarios =
                                                            dias[dia]!;
                                                        return Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets.symmetric(
                                                                    vertical:
                                                                        8.0,
                                                                  ),
                                                              child: Text(
                                                                dia,
                                                                style: const TextStyle(
                                                                  color:
                                                                      azulOscuro,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 18,
                                                                ),
                                                              ),
                                                            ),
                                                            ...horarios.map(
                                                              (h) => Card(
                                                                color:
                                                                    grisClaro,
                                                                margin:
                                                                    const EdgeInsets.symmetric(
                                                                      vertical:
                                                                          4,
                                                                    ),
                                                                shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                        12,
                                                                      ),
                                                                ),
                                                                child: ListTile(
                                                                  leading: const Icon(
                                                                    Icons
                                                                        .class_,
                                                                    color:
                                                                        azulOscuro,
                                                                  ),
                                                                  title: Text(
                                                                    h['Curso'] ??
                                                                        '',
                                                                    style: const TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                  subtitle: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Row(
                                                                        children: [
                                                                          const Icon(
                                                                            Icons.access_time,
                                                                            size:
                                                                                18,
                                                                            color:
                                                                                azulOscuro,
                                                                          ),
                                                                          const SizedBox(
                                                                            width:
                                                                                4,
                                                                          ),
                                                                          Text(
                                                                            'Hora: ${h['hora_inicio']} - ${h['hora_fin']}',
                                                                            style: const TextStyle(
                                                                              color:
                                                                                  azulOscuro,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          const Icon(
                                                                            Icons.person,
                                                                            size:
                                                                                18,
                                                                            color:
                                                                                azulOscuro,
                                                                          ),
                                                                          const SizedBox(
                                                                            width:
                                                                                4,
                                                                          ),
                                                                          Text(
                                                                            'Profesor: ${h['Profesor'] ?? ''}',
                                                                            style: const TextStyle(
                                                                              color:
                                                                                  azulOscuro,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      })
                                                      .toList(),
                                                  const SizedBox(height: 12),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                            ),
                      );
                    },
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      color: Colors.white,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.computer, size: 36, color: azulOscuro),
                            const SizedBox(height: 10),
                            Text(
                              lab,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: azulOscuro,
                                letterSpacing: 1.1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
          );
        },
      ),
    );
  }
}
