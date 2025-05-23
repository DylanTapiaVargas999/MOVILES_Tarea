import 'package:aplicacion/screens/reserva_formulario.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../wiewmodels/horarios.viewmodel.dart';
import '../wiewmodels/perfil_viewmodel.dart';
import '../wiewmodels/login_viewmodel.dart';

// Colores institucionales
const azulOscuro = Color(0xFF003366);
const rojoIntenso = Color(0xFFCC0000);
const grisClaro = Color(0xFFD9D9D9);
const verdeLibre = Color(0xFF4CAF50);

class SeleccionarReservaScreen extends StatelessWidget {
  const SeleccionarReservaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HorariosViewModel>(context, listen: false).cargarHorarios();
    });

    return Scaffold(
      backgroundColor: grisClaro,
      appBar: AppBar(
        title: const Text('Horarios de Laboratorio de Hoy'),
        backgroundColor: azulOscuro,
        foregroundColor: Colors.white,
      ),
      body: Consumer<HorariosViewModel>(
        builder: (context, horariosVM, child) {
          if (horariosVM.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (horariosVM.errorMessage != null) {
            return Center(
              child: Text(
                horariosVM.errorMessage!,
                style: const TextStyle(
                  color: rojoIntenso,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }

          final horariosDeHoy = horariosVM.obtenerHorariosDeHoy();

          if (horariosDeHoy.isEmpty) {
            return const Center(
              child: Text(
                'No hay horarios para hoy.',
                style: TextStyle(
                  color: azulOscuro,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: horariosDeHoy.length,
            itemBuilder: (context, index) {
              final horarioDoc = horariosDeHoy[index];
              final laboratorio =
                  horarioDoc['laboratorio'] ?? 'Sin laboratorio';
              final listaHorarios =
                  horarioDoc['horarios'] as List<dynamic>? ?? [];

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
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
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
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: azulOscuro,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 90,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              ..._buildBloques(context, 8, 0, 7), // 8:00 a 13:50
              Container(width: 12),
              ..._buildBloques(context, 14, 10, 10), // 14:10 a 21:40
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (horarioSeleccionado != null)
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: grisClaro,
              border: Border.all(color: azulOscuro, width: 1.5),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: azulOscuro.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if ((horarioSeleccionado!['Curso'] ?? '').isNotEmpty) ...[
                  Text(
                    horarioSeleccionado!['Curso'] ?? 'Sin curso',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: azulOscuro,
                    ),
                  ),
                  Text(
                    'Profesor: ${horarioSeleccionado!['Profesor'] ?? 'Desconocido'}',
                    style: const TextStyle(color: azulOscuro),
                  ),
                  Text(
                    'Hora: ${horarioSeleccionado!['hora_inicio'] ?? ''} - ${horarioSeleccionado!['hora_fin'] ?? ''}',
                    style: const TextStyle(color: azulOscuro),
                  ),
                ] else
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Hora libre',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: verdeLibre,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: azulOscuro,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () async {
                          final loginVM = Provider.of<LoginViewModel>(
                            context,
                            listen: false,
                          );
                          final codigoAlumno = loginVM.codigoAlumno;

                          if (codigoAlumno == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'No se encontró el código del estudiante',
                                ),
                              ),
                            );
                            return;
                          }

                          final perfilVM = Provider.of<PerfilViewModel>(
                            context,
                            listen: false,
                          );
                          await perfilVM.cargarPerfil(codigoAlumno);

                          final alumno = perfilVM.alumno;
                          if (alumno == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'No se encontró el perfil del estudiante',
                                ),
                              ),
                            );
                            return;
                          }

                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder:
                                  (context) => ReservaFormulario(
                                    alumno: alumno,
                                    lab: widget.laboratorio,
                                    horaInicio:
                                        horarioSeleccionado!['hora_inicio'],
                                    horaFin: horarioSeleccionado!['hora_fin'],
                                  ),
                            ),
                          );
                        },
                        child: const Text('Reservar'),
                      ),
                    ],
                  ),
              ],
            ),
          ),
      ],
    );
  }

  List<Widget> _buildBloques(
    BuildContext context,
    int startHour,
    int startMinute,
    int count,
  ) {
    return List.generate(count, (i) {
      final startMinutes = startHour * 60 + startMinute + i * 50;
      final endMinutes = startMinutes + 50;
      final blockStart = TimeOfDay(
        hour: startMinutes ~/ 60,
        minute: startMinutes % 60,
      );
      final blockEnd = TimeOfDay(
        hour: endMinutes ~/ 60,
        minute: endMinutes % 60,
      );

      final ocupado = widget.listaHorarios.any((h) {
        final inicio = h['hora_inicio'] ?? '';
        final fin = h['hora_fin'] ?? '';
        if (inicio.isEmpty || fin.isEmpty) return false;
        final inicioParts = inicio.split(':').map(int.parse).toList();
        final finParts = fin.split(':').map(int.parse).toList();
        final inicioTime = TimeOfDay(
          hour: inicioParts[0],
          minute: inicioParts[1],
        );
        final finTime = TimeOfDay(hour: finParts[0], minute: finParts[1]);
        return (blockStart.hour * 60 + blockStart.minute) <
                (finTime.hour * 60 + finTime.minute) &&
            (blockEnd.hour * 60 + blockEnd.minute) >
                (inicioTime.hour * 60 + inicioTime.minute);
      });

      final horarioOcupado =
          ocupado
              ? widget.listaHorarios.firstWhere((h) {
                final inicio = h['hora_inicio'] ?? '';
                final fin = h['hora_fin'] ?? '';
                if (inicio.isEmpty || fin.isEmpty) return false;
                final inicioParts = inicio.split(':').map(int.parse).toList();
                final finParts = fin.split(':').map(int.parse).toList();
                final inicioTime = TimeOfDay(
                  hour: inicioParts[0],
                  minute: inicioParts[1],
                );
                final finTime = TimeOfDay(
                  hour: finParts[0],
                  minute: finParts[1],
                );
                return (blockStart.hour * 60 + blockStart.minute) <
                        (finTime.hour * 60 + finTime.minute) &&
                    (blockEnd.hour * 60 + blockEnd.minute) >
                        (inicioTime.hour * 60 + inicioTime.minute);
              }, orElse: () => null)
              : null;

      final isSelected =
          horarioSeleccionado != null &&
          horarioSeleccionado!['hora_inicio'] ==
              "${blockStart.hour.toString().padLeft(2, '0')}:${blockStart.minute.toString().padLeft(2, '0')}" &&
          horarioSeleccionado!['hora_fin'] ==
              "${blockEnd.hour.toString().padLeft(2, '0')}:${blockEnd.minute.toString().padLeft(2, '0')}";

      return GestureDetector(
        onTap: () {
          setState(() {
            horarioSeleccionado =
                horarioOcupado ??
                {
                  'Curso': '',
                  'Profesor': '',
                  'hora_inicio':
                      "${blockStart.hour.toString().padLeft(2, '0')}:${blockStart.minute.toString().padLeft(2, '0')}",
                  'hora_fin':
                      "${blockEnd.hour.toString().padLeft(2, '0')}:${blockEnd.minute.toString().padLeft(2, '0')}",
                };
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: 85,
          margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 4),
          decoration: BoxDecoration(
            color:
                ocupado
                    ? rojoIntenso.withOpacity(0.7)
                    : verdeLibre.withOpacity(0.7),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? azulOscuro : Colors.transparent,
              width: 2,
            ),
            boxShadow:
                isSelected
                    ? [
                      BoxShadow(
                        color: azulOscuro.withOpacity(0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                    : [],
          ),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                ocupado ? Icons.lock : Icons.lock_open,
                color: ocupado ? Colors.white : azulOscuro,
                size: 22,
              ),
              const SizedBox(height: 2),
              Text(
                "${blockStart.hour.toString().padLeft(2, '0')}:${blockStart.minute.toString().padLeft(2, '0')}\n"
                "${blockEnd.hour.toString().padLeft(2, '0')}:${blockEnd.minute.toString().padLeft(2, '0')}",
                style: TextStyle(
                  fontSize: 12,
                  color: ocupado ? Colors.white : azulOscuro,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    });
  }
}
