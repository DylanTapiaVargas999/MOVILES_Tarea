import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../wiewmodels/horarios.viewmodel.dart';

class SeleccionarReservaScreen extends StatelessWidget {
  const SeleccionarReservaScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
              final horario = horariosDeHoy[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(horario['Curso'] ?? 'Sin curso'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Profesor: ${horario['Profesor'] ?? 'Desconocido'}'),
                      Text('Hora: ${horario['hora_inicio'] ?? ''} - ${horario['hora_fin'] ?? ''}'),
                      if (horario['lab'] != null) Text('Laboratorio: ${horario['lab']}'),
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