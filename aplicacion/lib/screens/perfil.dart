import 'package:aplicacion/screens/editar_perfil.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../wiewmodels/perfil_viewmodel.dart';

// Colores institucionales
const azulOscuro = Color(0xFF003366);
const rojoIntenso = Color(0xFFCC0000);
const grisClaro = Color(0xFFD9D9D9);
const amarilloDorado = Color(0xFFFFCC00);

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
              backgroundColor: grisClaro, // Fondo institucional
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (perfilViewModel.errorMessage != null) {
            return Scaffold(
              backgroundColor: grisClaro,
              appBar: AppBar(
                title: const Text('Perfil del Estudiante'),
                backgroundColor: azulOscuro,
                foregroundColor: Colors.white,
              ),
              body: Center(
                child: Text(
                  perfilViewModel.errorMessage!,
                  style: const TextStyle(
                    color: rojoIntenso,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }
          final alumno = perfilViewModel.alumno;
          if (alumno == null) {
            return Scaffold(
              backgroundColor: grisClaro,
              appBar: AppBar(
                title: const Text('Perfil del Estudiante'),
                backgroundColor: azulOscuro,
                foregroundColor: Colors.white,
              ),
              body: const Center(
                child: Text('No se encontraron datos del estudiante'),
              ),
            );
          }
          return Scaffold(
            backgroundColor: grisClaro,
            appBar: AppBar(
              title: const Text('Perfil del Estudiante'),
              backgroundColor: azulOscuro,
              foregroundColor: Colors.white,
            ),
            body: Center(
              child: Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: azulOscuro.withOpacity(0.08),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Código: ${alumno.codigo}',
                      style: TextStyle(
                        fontSize: 18,
                        color: azulOscuro,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Nombre: ${alumno.nombre}',
                      style: TextStyle(fontSize: 18, color: azulOscuro),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Apellido: ${alumno.apellido}',
                      style: TextStyle(fontSize: 18, color: azulOscuro),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Ciclo: ${alumno.ciclo}',
                      style: TextStyle(fontSize: 18, color: azulOscuro),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: azulOscuro,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () async {
                          final actualizado = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => EditarPerfilScreen(alumno: alumno),
                            ),
                          );
                          if (actualizado == true) {
                            Provider.of<PerfilViewModel>(
                              context,
                              listen: false,
                            ).cargarPerfil(codigoAlumno);
                          }
                        },
                        child: const Text('Editar perfil'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
