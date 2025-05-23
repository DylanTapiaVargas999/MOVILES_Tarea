import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../wiewmodels/perfil_viewmodel.dart';

// Ahora el PerfilScreen recibe el código del alumno y usa el ViewModel para cargar los datos
class PerfilScreen extends StatelessWidget {
  final String codigoAlumno;

  const PerfilScreen({super.key, required this.codigoAlumno});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PerfilViewModel()..cargarPerfil(codigoAlumno),
      child: Consumer<PerfilViewModel>(
        builder: (context, perfilViewModel, _) {
          if (perfilViewModel.isLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (perfilViewModel.errorMessage != null) {
            return Scaffold(
              appBar: AppBar(title: const Text('Perfil del Estudiante')),
              body: Center(child: Text(perfilViewModel.errorMessage!)),
            );
          }
          final alumno = perfilViewModel.alumno;
          if (alumno == null) {
            return Scaffold(
              appBar: AppBar(title: const Text('Perfil del Estudiante')),
              body: const Center(child: Text('No se encontraron datos del estudiante')),
            );
          }
          return Scaffold(
            appBar: AppBar(title: const Text('Perfil del Estudiante')),
            body: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Código: ${alumno.codigo}', style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 12),
                  Text('Nombre: ${alumno.nombre}', style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 12),
                  Text('Apellido: ${alumno.apellido}', style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 12),
                  Text('Ciclo: ${alumno.ciclo}', style: const TextStyle(fontSize: 18)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}