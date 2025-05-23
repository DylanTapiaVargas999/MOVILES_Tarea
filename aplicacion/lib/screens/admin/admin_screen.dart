import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  DateTime selectedDate = DateTime.now();
  String filtro = 'diario'; // 'diario' o 'mensual'

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Panel de Administrador')),
      body: Column(
        children: [
          // SECCIÓN 1: Filtros de fecha
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownButton<String>(
                  value: filtro,
                  items: const [
                    DropdownMenuItem(value: 'diario', child: Text('Diario')),
                    DropdownMenuItem(value: 'mensual', child: Text('Mensual')),
                  ],
                  onChanged: (v) => setState(() => filtro = v!),
                ),
                TextButton(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2023),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) setState(() => selectedDate = picked);
                  },
                  child: Text(
                    filtro == 'diario'
                        ? DateFormat('yyyy-MM-dd').format(selectedDate)
                        : DateFormat('yyyy-MM').format(selectedDate),
                  ),
                ),
              ],
            ),
          ),
          // SECCIÓN 2: Reportes y gráficos
          Expanded(
            child: FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance.collection('reservas').get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final docs = snapshot.data!.docs;
                // Filtrar por fecha
                final filteredDocs =
                    docs.where((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      final fechaRaw = data['fecha'];
                      DateTime? date;
                      if (fechaRaw is Timestamp) {
                        date = fechaRaw.toDate();
                      } else if (fechaRaw is String) {
                        try {
                          // Cambia aquí el formato a dd/MM/yyyy
                          date = DateFormat('dd/MM/yyyy').parse(fechaRaw);
                        } catch (_) {
                          return false;
                        }
                      } else {
                        return false;
                      }
                      if (filtro == 'diario') {
                        return date.year == selectedDate.year &&
                            date.month == selectedDate.month &&
                            date.day == selectedDate.day;
                      } else {
                        return date.year == selectedDate.year &&
                            date.month == selectedDate.month;
                      }
                    }).toList();

                final total = filteredDocs.length;
                final estados = {'pendiente': 0, 'aprobado': 0, 'rechazado': 0};
                final labs = <String, int>{};
                for (var doc in filteredDocs) {
                  final data = doc.data() as Map<String, dynamic>;
                  final estado = data['estado'] ?? 'pendiente';
                  estados[estado] = (estados[estado] ?? 0) + 1;
                  final lab = data['lab'] ?? 'Desconocido';
                  labs[lab] = (labs[lab] ?? 0) + 1;
                }

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Reporte resumen
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Total de reservas: $total',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                      // Gráfico de barras por estado
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Reservas por estado',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      SizedBox(
                        height: 200,
                        child: BarChart(
                          BarChartData(
                            alignment: BarChartAlignment.spaceAround,
                            barGroups:
                                estados.entries
                                    .toList()
                                    .asMap()
                                    .entries
                                    .map(
                                      (e) => BarChartGroupData(
                                        x: e.key,
                                        barRods: [
                                          BarChartRodData(
                                            toY: e.value.value.toDouble(),
                                            color: Colors.blue,
                                            width: 30,
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                        ],
                                        showingTooltipIndicators: [0],
                                      ),
                                    )
                                    .toList(),
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: true),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (
                                    double value,
                                    TitleMeta meta,
                                  ) {
                                    final keys = estados.keys.toList();
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(keys[value.toInt()]),
                                    );
                                  },
                                ),
                              ),
                              rightTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              topTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                            ),
                            borderData: FlBorderData(show: false),
                            gridData: FlGridData(show: false),
                          ),
                        ),
                      ),
                      // Gráfico de pastel por laboratorio
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Reservas por laboratorio',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      SizedBox(
                        height: 200,
                        child: PieChart(
                          PieChartData(
                            sections:
                                labs.entries
                                    .map(
                                      (e) => PieChartSectionData(
                                        value: e.value.toDouble(),
                                        title: '${e.key}\n${e.value}',
                                        color:
                                            Colors.primaries[labs.keys
                                                    .toList()
                                                    .indexOf(e.key) %
                                                Colors.primaries.length],
                                        radius: 60,
                                        titleStyle: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                    .toList(),
                            sectionsSpace: 2,
                            centerSpaceRadius: 30,
                          ),
                        ),
                      ),
                      // SECCIÓN 3: Historial de reservas y observaciones
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Historial de reservas',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filteredDocs.length,
                        itemBuilder: (context, i) {
                          final data =
                              filteredDocs[i].data() as Map<String, dynamic>;
                          return Card(
                            child: ListTile(
                              title: Text('Alumno: ${data['alumno'] ?? ''}'),
                              subtitle: Text(
                                'Lab: ${data['lab'] ?? ''} | Estado: ${data['estado'] ?? ''}\n'
                                'Fecha: ${data['fecha'] != null ? data['fecha'] : ''}',
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.info_outline),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder:
                                        (_) => AlertDialog(
                                          title: const Text(
                                            'Observaciones e Incidencias',
                                          ),
                                          content: Text(
                                            data['observacion'] ??
                                                'Sin observaciones',
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed:
                                                  () => Navigator.pop(context),
                                              child: const Text('Cerrar'),
                                            ),
                                          ],
                                        ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
