import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../wiewmodels/horarios.viewmodel.dart';

class SeleccionarReservaScreen extends StatelessWidget {
  const SeleccionarReservaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HorariosViewModel>(context, listen: false).cargarHorarios();
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Horarios de Laboratorio de Hoy')),
      body: Consumer<HorariosViewModel>(
        builder: (context, horariosVM, child) {
          if (horariosVM.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (horariosVM.errorMessage != null) {
            return Center(child: Text(horariosVM.errorMessage!));
          }

          final horariosDeHoy = horariosVM.obtenerHorariosDeHoy();

          if (horariosDeHoy.isEmpty) {
            return const Center(child: Text('No hay horarios para hoy.'));
          }

          return ListView.builder(
            itemCount: horariosDeHoy.length,
            itemBuilder: (context, index) {
              final horarioDoc = horariosDeHoy[index];
              final laboratorio = horarioDoc['laboratorio'] ?? 'Sin laboratorio';
              final listaHorarios = horarioDoc['horarios'] as List<dynamic>? ?? [];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _LaboratorioHorarios(
                    laboratorio: laboratorio,
                    listaHorarios: listaHorarios,
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

class _LaboratorioHorarios extends StatefulWidget {
  final String laboratorio;
  final List<dynamic> listaHorarios;

  const _LaboratorioHorarios({
    required this.laboratorio,
    required this.listaHorarios,
    Key? key,
  }) : super(key: key);

  @override
  State<_LaboratorioHorarios> createState() => _LaboratorioHorariosState();
}

class _LaboratorioHorariosState extends State<_LaboratorioHorarios> {
  Map<String, dynamic>? horarioSeleccionado;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Laboratorio: ${widget.laboratorio}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 80,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              // Bloques de 8:00 a 13:50
              ...List.generate(7, (i) {
                final startMinutes = 8 * 60 + i * 50;
                final endMinutes = startMinutes + 50;
                final blockStart = TimeOfDay(hour: startMinutes ~/ 60, minute: startMinutes % 60);
                final blockEnd = TimeOfDay(hour: endMinutes ~/ 60, minute: endMinutes % 60);

                final ocupado = widget.listaHorarios.any((h) {
                  final inicio = h['hora_inicio'] ?? '';
                  final fin = h['hora_fin'] ?? '';
                  if (inicio.isEmpty || fin.isEmpty) return false;
                  final inicioParts = inicio.split(':').map(int.parse).toList();
                  final finParts = fin.split(':').map(int.parse).toList();
                  final inicioTime = TimeOfDay(hour: inicioParts[0], minute: inicioParts[1]);
                  final finTime = TimeOfDay(hour: finParts[0], minute: finParts[1]);
                  return (blockStart.hour * 60 + blockStart.minute) < (finTime.hour * 60 + finTime.minute) &&
                      (blockEnd.hour * 60 + blockEnd.minute) > (inicioTime.hour * 60 + inicioTime.minute);
                });

                final horarioOcupado = ocupado
                    ? widget.listaHorarios.firstWhere((h) {
                        final inicio = h['hora_inicio'] ?? '';
                        final fin = h['hora_fin'] ?? '';
                        if (inicio.isEmpty || fin.isEmpty) return false;
                        final inicioParts = inicio.split(':').map(int.parse).toList();
                        final finParts = fin.split(':').map(int.parse).toList();
                        final inicioTime = TimeOfDay(hour: inicioParts[0], minute: inicioParts[1]);
                        final finTime = TimeOfDay(hour: finParts[0], minute: finParts[1]);
                        return (blockStart.hour * 60 + blockStart.minute) < (finTime.hour * 60 + finTime.minute) &&
                            (blockEnd.hour * 60 + blockEnd.minute) > (inicioTime.hour * 60 + inicioTime.minute);
                      }, orElse: () => null)
                    : null;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      horarioSeleccionado = horarioOcupado ?? {
                        'Curso': '',
                        'Profesor': '',
                        'hora_inicio': "${blockStart.hour.toString().padLeft(2, '0')}:${blockStart.minute.toString().padLeft(2, '0')}",
                        'hora_fin': "${blockEnd.hour.toString().padLeft(2, '0')}:${blockEnd.minute.toString().padLeft(2, '0')}",
                      };
                    });
                  },
                  child: Container(
                    width: 80,
                    margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                    decoration: BoxDecoration(
                      color: ocupado ? Colors.red[300] : Colors.green[200],
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.black12),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "${blockStart.hour.toString().padLeft(2, '0')}:${blockStart.minute.toString().padLeft(2, '0')} - "
                      "${blockEnd.hour.toString().padLeft(2, '0')}:${blockEnd.minute.toString().padLeft(2, '0')}",
                      style: const TextStyle(fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }),
              Container(width: 12),
              // Bloques de 14:10 a 21:40
              ...List.generate(10, (i) {
                final startMinutes = 14 * 60 + 10 + i * 50;
                final endMinutes = startMinutes + 50;
                final blockStart = TimeOfDay(hour: startMinutes ~/ 60, minute: startMinutes % 60);
                final blockEnd = TimeOfDay(hour: endMinutes ~/ 60, minute: endMinutes % 60);

                final ocupado = widget.listaHorarios.any((h) {
                  final inicio = h['hora_inicio'] ?? '';
                  final fin = h['hora_fin'] ?? '';
                  if (inicio.isEmpty || fin.isEmpty) return false;
                  final inicioParts = inicio.split(':').map(int.parse).toList();
                  final finParts = fin.split(':').map(int.parse).toList();
                  final inicioTime = TimeOfDay(hour: inicioParts[0], minute: inicioParts[1]);
                  final finTime = TimeOfDay(hour: finParts[0], minute: finParts[1]);
                  return (blockStart.hour * 60 + blockStart.minute) < (finTime.hour * 60 + finTime.minute) &&
                      (blockEnd.hour * 60 + blockEnd.minute) > (inicioTime.hour * 60 + inicioTime.minute);
                });

                final horarioOcupado = ocupado
                    ? widget.listaHorarios.firstWhere((h) {
                        final inicio = h['hora_inicio'] ?? '';
                        final fin = h['hora_fin'] ?? '';
                        if (inicio.isEmpty || fin.isEmpty) return false;
                        final inicioParts = inicio.split(':').map(int.parse).toList();
                        final finParts = fin.split(':').map(int.parse).toList();
                        final inicioTime = TimeOfDay(hour: inicioParts[0], minute: inicioParts[1]);
                        final finTime = TimeOfDay(hour: finParts[0], minute: finParts[1]);
                        return (blockStart.hour * 60 + blockStart.minute) < (finTime.hour * 60 + finTime.minute) &&
                            (blockEnd.hour * 60 + blockEnd.minute) > (inicioTime.hour * 60 + inicioTime.minute);
                      }, orElse: () => null)
                    : null;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      horarioSeleccionado = horarioOcupado ?? {
                        'Curso': '',
                        'Profesor': '',
                        'hora_inicio': "${blockStart.hour.toString().padLeft(2, '0')}:${blockStart.minute.toString().padLeft(2, '0')}",
                        'hora_fin': "${blockEnd.hour.toString().padLeft(2, '0')}:${blockEnd.minute.toString().padLeft(2, '0')}",
                      };
                    });
                  },
                  child: Container(
                    width: 80,
                    margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                    decoration: BoxDecoration(
                      color: ocupado ? Colors.red[300] : Colors.green[200],
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.black12),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "${blockStart.hour.toString().padLeft(2, '0')}:${blockStart.minute.toString().padLeft(2, '0')} - "
                      "${blockEnd.hour.toString().padLeft(2, '0')}:${blockEnd.minute.toString().padLeft(2, '0')}",
                      style: const TextStyle(fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (horarioSeleccionado != null)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.red),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if ((horarioSeleccionado!['Curso'] ?? '').isNotEmpty)
                  ...[
                    Text(horarioSeleccionado!['Curso'] ?? 'Sin curso', style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text('Profesor: ${horarioSeleccionado!['Profesor'] ?? 'Desconocido'}'),
                    Text('Hora: ${horarioSeleccionado!['hora_inicio'] ?? ''} - ${horarioSeleccionado!['hora_fin'] ?? ''}'),
                  ]
                else
                  const Text('Hora libre', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
              ],
            ),
          ),
      ],
    );
  }
}
