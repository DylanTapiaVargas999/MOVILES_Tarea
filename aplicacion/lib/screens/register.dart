import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../wiewmodels/register_viewmodel.dart';
import '../models/alumno_model.dart';

class RegisterScreen extends StatelessWidget {
  final TextEditingController codigoController = TextEditingController();
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController apellidoController = TextEditingController();
  final TextEditingController cicloController = TextEditingController();
  final TextEditingController contrasenaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final registerViewModel = Provider.of<RegisterViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Registrarse')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: codigoController,
                decoration: const InputDecoration(labelText: 'Código'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Ingrese su código' : null,
              ),
              TextFormField(
                controller: nombreController,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Ingrese su nombre' : null,
              ),
              TextFormField(
                controller: apellidoController,
                decoration: const InputDecoration(labelText: 'Apellido'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Ingrese su apellido' : null,
              ),
              TextFormField(
                controller: cicloController,
                decoration: const InputDecoration(labelText: 'Ciclo'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Ingrese su ciclo' : null,
              ),
              TextFormField(
                controller: contrasenaController,
                decoration: const InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Ingrese su contraseña' : null,
              ),
              const SizedBox(height: 20),
              if (registerViewModel.errorMessage != null)
                Text(
                  registerViewModel.errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              if (registerViewModel.successMessage != null)
                Text(
                  registerViewModel.successMessage!,
                  style: const TextStyle(color: Colors.green),
                ),
              const SizedBox(height: 20),
              registerViewModel.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final alumno = Alumno(
                            codigo: codigoController.text,
                            nombre: nombreController.text,
                            apellido: apellidoController.text,
                            ciclo: cicloController.text,
                            contrasena: contrasenaController.text,
                          );
                          bool success = await registerViewModel.registerAlumno(alumno);
                          if (success) {
                            Navigator.pop(context); // Regresa al login
                          }
                        }
                      },
                      child: const Text('Registrarse'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}