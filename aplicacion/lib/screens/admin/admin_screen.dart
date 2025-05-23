import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

// Colores institucionales
const azulOscuro = Color(0xFF003366);
const rojoIntenso = Color(0xFFCC0000);
const grisClaro = Color(0xFFD9D9D9);
const verdeAprobado = Color(0xFF4CAF50);

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  DateTime selectedDate = DateTime.now();
  String filtro = 'diario'; // 'diario' o 'mensual'
  int _openChart = -1; // -1: ninguno, 0: barras, 1: pastel

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grisClaro,
      appBar: AppBar(
        title: const Text('Panel de Administrador'),
        backgroundColor: azulOscuro,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: () {
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil('/login', (route) => false);
            },
          ),
        ],
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection('reservas').get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final docs = snapshot.data!.docs;
          final filteredDocs = _filtrarPorFecha(docs);
          final total = filteredDocs.length;
          final estados = _contarPorEstado(filteredDocs);
          final labs = _contarPorLab(filteredDocs);

          return ListView(
            padding: const EdgeInsets.all(12),
            children: [
              // Filtros SIEMPRE visibles
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildFiltrosFecha(context),
                ),
              ),
              const SizedBox(height: 12),

              // Resumen SIEMPRE visible
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildResumen(total),
                ),
              ),
              const SizedBox(height: 12),

              // Botón y gráfico de barras
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 2,
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.bar_chart, color: Colors.deepPurple),
                      title: const Text(
                        'Gráfico de Barras por Estado',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          _openChart == 0
                              ? Icons.expand_less
                              : Icons.expand_more,
                          color: Colors.deepPurple,
                        ),
                        onPressed: () {
                          setState(() {
                            _openChart = _openChart == 0 ? -1 : 0;
                          });
                        },
                      ),
                    ),
                    if (_openChart == 0)
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: _buildBarraEstados(estados),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Botón y gráfico de pastel
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 2,
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.pie_chart, color: Colors.teal),
                      title: const Text(
                        'Gráfico de Pastel por Laboratorio',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          _openChart == 1
                              ? Icons.expand_less
                              : Icons.expand_more,
                          color: Colors.teal,
                        ),
                        onPressed: () {
                          setState(() {
                            _openChart = _openChart == 1 ? -1 : 1;
                          });
                        },
                      ),
                    ),
                    if (_openChart == 1)
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: _buildPieLabs(labs),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Historial SIEMPRE visible
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildHistorial(filteredDocs),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ----------------- WIDGETS DE SECCIÓN -----------------

  Widget _buildFiltrosFecha(BuildContext context) {
    return Row(
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
        const SizedBox(width: 12),
        TextButton.icon(
          icon: const Icon(Icons.calendar_today, color: azulOscuro),
          label: Text(
            filtro == 'diario'
                ? DateFormat('yyyy-MM-dd').format(selectedDate)
                : DateFormat('yyyy-MM').format(selectedDate),
            style: const TextStyle(
              color: azulOscuro,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: selectedDate,
              firstDate: DateTime(2023),
              lastDate: DateTime.now(),
            );
            if (picked != null) setState(() => selectedDate = picked);
          },
        ),
      ],
    );
  }

  Widget _buildResumen(int total) {
    return Center(
      child: Text(
        'Total de reservas: $total',
        style: const TextStyle(
          fontSize: 18,
          color: azulOscuro,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildBarraEstados(Map<String, int> estados) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Reservas por estado',
          style: TextStyle(
            fontSize: 16,
            color: azulOscuro,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 180,
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
                              color: _colorEstado(e.value.key),
                              width: 30,
                              borderRadius: BorderRadius.circular(4),
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
                    getTitlesWidget: (double value, TitleMeta meta) {
                      final keys = estados.keys.toList();
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          keys[value.toInt()],
                          style: const TextStyle(color: azulOscuro),
                        ),
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
      ],
    );
  }

  Widget _buildPieLabs(Map<String, int> labs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Reservas por laboratorio',
          style: TextStyle(
            fontSize: 16,
            color: azulOscuro,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 180,
          child: PieChart(
            PieChartData(
              sections:
                  labs.entries
                      .map(
                        (e) => PieChartSectionData(
                          value: e.value.toDouble(),
                          title: '${e.key}\n${e.value}',
                          color:
                              Colors.primaries[labs.keys.toList().indexOf(
                                    e.key,
                                  ) %
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
      ],
    );
  }

  Widget _buildHistorial(List<QueryDocumentSnapshot> filteredDocs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Historial de reservas',
          style: TextStyle(
            fontSize: 16,
            color: azulOscuro,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: filteredDocs.length,
          separatorBuilder: (_, __) => const SizedBox(height: 6),
          itemBuilder: (context, i) {
            final data = filteredDocs[i].data() as Map<String, dynamic>;
            return Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              child: ListTile(
                title: Text(
                  'Alumno: ${data['nombre_completo'] ?? data['alumno'] ?? ''}',
                  style: const TextStyle(
                    color: azulOscuro,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  'Lab: ${data['lab'] ?? ''} | Estado: ${data['estado'] ?? ''}\n'
                  'Fecha: ${data['fecha'] != null ? data['fecha'] : ''}',
                  style: const TextStyle(color: Colors.black87),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.info_outline, color: azulOscuro),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder:
                          (_) => AlertDialog(
                            title: const Text('Observaciones e Incidencias'),
                            content: Text(
                              data['observacion'] ?? 'Sin observaciones',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
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
    );
  }

  // ----------------- FUNCIONES DE PROCESAMIENTO -----------------

  List<QueryDocumentSnapshot> _filtrarPorFecha(
    List<QueryDocumentSnapshot> docs,
  ) {
    return docs.where((doc) {
      final data = doc.data() as Map<String, dynamic>;
      final fechaRaw = data['fecha'];
      DateTime? date;
      if (fechaRaw is Timestamp) {
        date = fechaRaw.toDate();
      } else if (fechaRaw is String) {
        try {
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
  }

  Map<String, int> _contarPorEstado(List<QueryDocumentSnapshot> docs) {
    final estados = {'pendiente': 0, 'aprobado': 0, 'rechazado': 0};
    for (var doc in docs) {
      final data = doc.data() as Map<String, dynamic>;
      final estado = data['estado'] ?? 'pendiente';
      estados[estado] = (estados[estado] ?? 0) + 1;
    }
    return estados;
  }

  Map<String, int> _contarPorLab(List<QueryDocumentSnapshot> docs) {
    final labs = <String, int>{};
    for (var doc in docs) {
      final data = doc.data() as Map<String, dynamic>;
      final lab = data['lab'] ?? 'Desconocido';
      labs[lab] = (labs[lab] ?? 0) + 1;
    }
    return labs;
  }

  Color _colorEstado(String estado) {
    switch (estado) {
      case 'aprobado':
        return verdeAprobado;
      case 'rechazado':
        return rojoIntenso;
      default:
        return Colors.amber[700]!;
    }
  }
}
