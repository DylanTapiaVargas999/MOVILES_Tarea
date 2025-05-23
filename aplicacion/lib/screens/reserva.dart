import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../wiewmodels/horarios.viewmodel.dart';

class SeleccionarReservaScreen extends StatelessWidget {
  const SeleccionarReservaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Llama a cargarHorarios solo una vez cuando se construye la pantalla
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

          for (var h in horariosDeHoy) {
            print('Horario: $h');
          }

          if (horariosDeHoy.isEmpty) {
            return const Center(child: Text('No hay horarios para hoy.'));
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
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Laboratorio: $laboratorio',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      ...listaHorarios.map(
                        (h) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                h['Curso'] ?? 'Sin curso',
                                style: const TextStyle(fontSize: 16),
                              ),
                              Text(
                                'Profesor: ${h['Profesor'] ?? 'Desconocido'}',
                              ),
                              Text(
                                'Hora: ${h['hora_inicio'] ?? ''} - ${h['hora_fin'] ?? ''}',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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
