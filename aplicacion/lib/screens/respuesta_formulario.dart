import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../wiewmodels/respuesta_formulario_viewmodel.dart';
import '../wiewmodels/login_viewmodel.dart';
import '../models/reserva_model.dart';

// Colores institucionales
const azulOscuro = Color(0xFF003366);
const rojoIntenso = Color(0xFFCC0000);
const grisClaro = Color(0xFFD9D9D9);
const amarilloDorado = Color(0xFFFFCC00);

class RespuestaFormularioScreen extends StatelessWidget {
  const RespuestaFormularioScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final codigoAlumno =
        Provider.of<LoginViewModel>(context, listen: false).codigoAlumno;

    if (codigoAlumno == null || codigoAlumno.isEmpty) {
      return Scaffold(
        backgroundColor: grisClaro,
        appBar: AppBar(
          title: const Text('Mis Reservas'),
          backgroundColor: azulOscuro,
          foregroundColor: Colors.white,
        ),
        body: const Center(child: Text('No se encontró el código del alumno')),
      );
    }

    return ChangeNotifierProvider(
      create:
          (_) =>
              RespuestaFormularioViewModel(codigoAlumno: codigoAlumno)
                ..cargarReservas(),
      child: Scaffold(
        backgroundColor: grisClaro,
        appBar: AppBar(
          title: const Text('Mis Reservas'),
          backgroundColor: azulOscuro,
          foregroundColor: Colors.white,
        ),
        body: Consumer<RespuestaFormularioViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (viewModel.errorMessage != null) {
              return Center(
                child: Text(
                  viewModel.errorMessage!,
                  style: const TextStyle(
                    color: rojoIntenso,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }
            if (viewModel.reservas.isEmpty) {
              return const Center(
                child: Text(
                  'No tienes reservas registradas.',
                  style: TextStyle(
                    color: azulOscuro,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: viewModel.reservas.length,
              itemBuilder: (context, index) {
                final reserva = viewModel.reservas[index];

                IconData icono;
                Color colorIcono;

                if (reserva.estado == 'rechazado') {
                  icono = Icons.close;
                  colorIcono = rojoIntenso;
                } else if (reserva.estado == 'pendiente') {
                  icono = Icons.remove;
                  colorIcono = grisClaro;
                } else if (reserva.estado == 'confirmado') {
                  icono = Icons.check_circle;
                  colorIcono = Colors.green;
                } else {
                  icono = Icons.help_outline;
                  colorIcono = grisClaro;
                }

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    title: Text(
                      reserva.nombreCompleto,
                      style: TextStyle(
                        color: azulOscuro,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Text(
                      'Curso: ${reserva.curso}\n'
                      'Fecha: ${reserva.fecha}\n'
                      'Estado: ${reserva.estado}',
                      style: TextStyle(
                        color: azulOscuro.withOpacity(0.8),
                        fontSize: 15,
                      ),
                    ),
                    trailing: Icon(icono, color: colorIcono, size: 32),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
