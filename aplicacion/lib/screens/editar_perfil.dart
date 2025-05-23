import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/alumno_model.dart';
import '../wiewmodels/perfil_viewmodel.dart';

// Colores institucionales
const azulOscuro = Color(0xFF003366);
const rojoIntenso = Color(0xFFCC0000);
const grisClaro = Color(0xFFD9D9D9);
const amarilloDorado = Color(0xFFFFCC00);

class EditarPerfilScreen extends StatefulWidget {
  final Alumno alumno;
  const EditarPerfilScreen({Key? key, required this.alumno}) : super(key: key);

  @override
  State<EditarPerfilScreen> createState() => _EditarPerfilScreenState();
}

class _EditarPerfilScreenState extends State<EditarPerfilScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nombreController;
  late TextEditingController apellidoController;
  late TextEditingController cicloController;

  @override
  void initState() {
    super.initState();
    nombreController = TextEditingController(text: widget.alumno.nombre);
    apellidoController = TextEditingController(text: widget.alumno.apellido);
    cicloController = TextEditingController(text: widget.alumno.ciclo);
  }

  @override
  void dispose() {
    nombreController.dispose();
    apellidoController.dispose();
    cicloController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PerfilViewModel(),
      child: Consumer<PerfilViewModel>(
        builder: (context, viewModel, _) {
          return Scaffold(
            backgroundColor: grisClaro,
            appBar: AppBar(
              title: const Text('Editar Perfil'),
              backgroundColor: azulOscuro,
              foregroundColor: Colors.white,
            ),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 16,
                  ),
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
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Editar Perfil',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: azulOscuro,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 28),
                          TextFormField(
                            initialValue: widget.alumno.codigo,
                            decoration: InputDecoration(
                              labelText: 'Código',
                              prefixIcon: Icon(
                                Icons.person_outline,
                                color: azulOscuro,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: azulOscuro,
                                  width: 1.2,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: grisClaro,
                                  width: 1.2,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: azulOscuro,
                                  width: 2,
                                ),
                              ),
                              filled: true,
                              fillColor: grisClaro.withOpacity(0.3),
                            ),
                            enabled: false,
                          ),
                          const SizedBox(height: 18),
                          TextFormField(
                            controller: nombreController,
                            decoration: InputDecoration(
                              labelText: 'Nombre',
                              prefixIcon: Icon(
                                Icons.badge_outlined,
                                color: azulOscuro,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: azulOscuro,
                                  width: 1.2,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: grisClaro,
                                  width: 1.2,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: azulOscuro,
                                  width: 2,
                                ),
                              ),
                              filled: true,
                              fillColor: grisClaro.withOpacity(0.3),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'El nombre es obligatorio';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 18),
                          TextFormField(
                            controller: apellidoController,
                            decoration: InputDecoration(
                              labelText: 'Apellido',
                              prefixIcon: Icon(Icons.badge, color: azulOscuro),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: azulOscuro,
                                  width: 1.2,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: grisClaro,
                                  width: 1.2,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: azulOscuro,
                                  width: 2,
                                ),
                              ),
                              filled: true,
                              fillColor: grisClaro.withOpacity(0.3),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'El apellido es obligatorio';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 18),
                          TextFormField(
                            controller: cicloController,
                            decoration: InputDecoration(
                              labelText: 'Ciclo',
                              prefixIcon: Icon(
                                Icons.school_outlined,
                                color: azulOscuro,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: azulOscuro,
                                  width: 1.2,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: grisClaro,
                                  width: 1.2,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: azulOscuro,
                                  width: 2,
                                ),
                              ),
                              filled: true,
                              fillColor: grisClaro.withOpacity(0.3),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'El ciclo es obligatorio';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),
                          if (viewModel.errorMessage != null)
                            Text(
                              viewModel.errorMessage!,
                              style: TextStyle(
                                color: rojoIntenso,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
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
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                              ),
                              onPressed:
                                  viewModel.isLoading
                                      ? null
                                      : () async {
                                        if (_formKey.currentState!.validate()) {
                                          final alumnoEditado = widget.alumno
                                              .copyWith(
                                                nombre:
                                                    nombreController.text
                                                        .trim(),
                                                apellido:
                                                    apellidoController.text
                                                        .trim(),
                                                ciclo:
                                                    cicloController.text.trim(),
                                              );
                                          final exito = await viewModel
                                              .editarPerfil(alumnoEditado);
                                          if (exito) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  'Perfil actualizado correctamente',
                                                ),
                                              ),
                                            );
                                            Navigator.pop(context);
                                          } else if (viewModel.errorMessage !=
                                              null) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  viewModel.errorMessage!,
                                                ),
                                              ),
                                            );
                                          }
                                        }
                                      },
                              child:
                                  viewModel.isLoading
                                      ? const CircularProgressIndicator()
                                      : const Text('Guardar cambios'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
