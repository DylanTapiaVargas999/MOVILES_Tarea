import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../wiewmodels/respuesta_formulario_viewmodel.dart';
import '../models/reserva_model.dart';

class RespuestaFormularioScreen extends StatelessWidget {
  final String codigoAlumno;

  const RespuestaFormularioScreen({Key? key, required this.codigoAlumno}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                return ListTile(
                  title: Text(reserva.nombreCompleto),
                  subtitle: Text(
                    'Curso: ${reserva.curso}\n'
                    'Fecha: ${reserva.fecha}\n'
                    'Estado: ${reserva.estado}',
                  ),
                  trailing: Icon(
                    reserva.estado == 'pendiente'
                        ? Icons.hourglass_empty
                        : Icons.check_circle,
                    color: reserva.estado == 'pendiente'
                        ? Colors.orange
                        : Colors.green,
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