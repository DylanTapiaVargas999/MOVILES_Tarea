import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../wiewmodels/respuesta_formulario_viewmodel.dart';
import '../wiewmodels/login_viewmodel.dart'; // Importa el LoginViewModel
import '../models/reserva_model.dart';

class RespuestaFormularioScreen extends StatelessWidget {
  const RespuestaFormularioScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Obtén el código del alumno desde el Provider
    final codigoAlumno = Provider.of<LoginViewModel>(context, listen: false).codigoAlumno;

    // Si no hay código, muestra un mensaje de error
    if (codigoAlumno == null || codigoAlumno.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('Mis Reservas')),
        body: Center(child: Text('No se encontró el código del alumno')),
      );
    }

    return ChangeNotifierProvider(
      create: (_) => RespuestaFormularioViewModel(codigoAlumno: codigoAlumno)..cargarReservas(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Mis Reservas'),
        ),
        body: Consumer<RespuestaFormularioViewModel>(
          builder: (context, viewModel, child) {
            if (viewModel.isLoading) {
              return Center(child: CircularProgressIndicator());
            }
            if (viewModel.errorMessage != null) {
              return Center(child: Text(viewModel.errorMessage!));
            }
            if (viewModel.reservas.isEmpty) {
              return Center(child: Text('No tienes reservas registradas.'));
            }
            return ListView.builder(
              itemCount: viewModel.reservas.length,
              itemBuilder: (context, index) {
                final reserva = viewModel.reservas[index];

                IconData icono;
                Color colorIcono;

                if (reserva.estado == 'rechazado') {
                  icono = Icons.close;
                  colorIcono = Colors.red;
                } else if (reserva.estado == 'pendiente') {
                  icono = Icons.remove;
                  colorIcono = Colors.grey;
                } else if (reserva.estado == 'confirmado') {
                  icono = Icons.check_circle;
                  colorIcono = Colors.green;
                } else {
                  icono = Icons.help_outline;
                  colorIcono = Colors.grey;
                }

                return ListTile(
                  title: Text(reserva.nombreCompleto),
                  subtitle: Text(
                    'Curso: ${reserva.curso}\n'
                    'Fecha: ${reserva.fecha}\n'
                    'Estado: ${reserva.estado}',
                  ),
                  trailing: Icon(
                    icono,
                    color: colorIcono,
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