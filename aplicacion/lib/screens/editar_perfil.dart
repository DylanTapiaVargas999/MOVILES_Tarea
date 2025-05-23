import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/alumno_model.dart';
import '../wiewmodels/perfil_viewmodel.dart';

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
            appBar: AppBar(title: const Text('Editar Perfil')),
            body: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: widget.alumno.codigo,
                      decoration: const InputDecoration(labelText: 'Código'),
                      enabled: false,
                    ),
                    TextFormField(
                      controller: nombreController,
                      decoration: const InputDecoration(labelText: 'Nombre'),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'El nombre es obligatorio';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: apellidoController,
                      decoration: const InputDecoration(labelText: 'Apellido'),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'El apellido es obligatorio';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: cicloController,
                      decoration: const InputDecoration(labelText: 'Ciclo'),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'El ciclo es obligatorio';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: viewModel.isLoading
                          ? null
                          : () async {
                              if (_formKey.currentState!.validate()) {
                                final alumnoEditado = widget.alumno.copyWith(
                                  nombre: nombreController.text.trim(),
                                  apellido: apellidoController.text.trim(),
                                  ciclo: cicloController.text.trim(),
                                );
                                final exito = await viewModel.editarPerfil(alumnoEditado);
                                if (exito) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Perfil actualizado correctamente')),
                                  );
                                  Navigator.pop(context);
                                } else if (viewModel.errorMessage != null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(viewModel.errorMessage!)),
                                  );
                                }
                              }
                            },
                      child: viewModel.isLoading
                          ? const CircularProgressIndicator()
                          : const Text('Guardar cambios'),
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