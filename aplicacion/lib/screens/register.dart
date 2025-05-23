import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../wiewmodels/register_viewmodel.dart';
import '../models/alumno_model.dart';

// Colores institucionales
const azulOscuro = Color(0xFF003366);
const rojoIntenso = Color(0xFFCC0000);
const grisClaro = Color(0xFFD9D9D9);
const amarilloDorado = Color(0xFFFFCC00);

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
      backgroundColor: grisClaro,
      appBar: AppBar(
        title: const Text('Registrarse'),
        backgroundColor: azulOscuro,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
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
                      'Crea tu cuenta',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: azulOscuro,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 28),
                    TextFormField(
                      controller: codigoController,
                      decoration: InputDecoration(
                        labelText: 'Código',
                        prefixIcon: Icon(
                          Icons.person_outline,
                          color: azulOscuro,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: azulOscuro, width: 1.2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: grisClaro, width: 1.2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: azulOscuro, width: 2),
                        ),
                        filled: true,
                        fillColor: grisClaro.withOpacity(0.3),
                      ),
                      validator:
                          (value) =>
                              value == null || value.isEmpty
                                  ? 'Ingrese su código'
                                  : null,
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
                          borderSide: BorderSide(color: azulOscuro, width: 1.2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: grisClaro, width: 1.2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: azulOscuro, width: 2),
                        ),
                        filled: true,
                        fillColor: grisClaro.withOpacity(0.3),
                      ),
                      validator:
                          (value) =>
                              value == null || value.isEmpty
                                  ? 'Ingrese su nombre'
                                  : null,
                    ),
                    const SizedBox(height: 18),
                    TextFormField(
                      controller: apellidoController,
                      decoration: InputDecoration(
                        labelText: 'Apellido',
                        prefixIcon: Icon(Icons.badge, color: azulOscuro),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: azulOscuro, width: 1.2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: grisClaro, width: 1.2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: azulOscuro, width: 2),
                        ),
                        filled: true,
                        fillColor: grisClaro.withOpacity(0.3),
                      ),
                      validator:
                          (value) =>
                              value == null || value.isEmpty
                                  ? 'Ingrese su apellido'
                                  : null,
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
                          borderSide: BorderSide(color: azulOscuro, width: 1.2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: grisClaro, width: 1.2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: azulOscuro, width: 2),
                        ),
                        filled: true,
                        fillColor: grisClaro.withOpacity(0.3),
                      ),
                      validator:
                          (value) =>
                              value == null || value.isEmpty
                                  ? 'Ingrese su ciclo'
                                  : null,
                    ),
                    const SizedBox(height: 18),
                    TextFormField(
                      controller: contrasenaController,
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        prefixIcon: Icon(Icons.lock_outline, color: azulOscuro),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: azulOscuro, width: 1.2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: grisClaro, width: 1.2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: azulOscuro, width: 2),
                        ),
                        filled: true,
                        fillColor: grisClaro.withOpacity(0.3),
                      ),
                      obscureText: true,
                      validator:
                          (value) =>
                              value == null || value.isEmpty
                                  ? 'Ingrese su contraseña'
                                  : null,
                    ),
                    const SizedBox(height: 20),
                    if (registerViewModel.errorMessage != null)
                      Text(
                        registerViewModel.errorMessage!,
                        style: TextStyle(
                          color: rojoIntenso,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    if (registerViewModel.successMessage != null)
                      Text(
                        registerViewModel.successMessage!,
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    const SizedBox(height: 20),
                    registerViewModel.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              backgroundColor: azulOscuro,
                              foregroundColor: Colors.white,
                              textStyle: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                final alumno = Alumno(
                                  codigo: codigoController.text,
                                  nombre: nombreController.text,
                                  apellido: apellidoController.text,
                                  ciclo: cicloController.text,
                                  contrasena: contrasenaController.text,
                                );
                                bool success = await registerViewModel
                                    .registerAlumno(alumno);
                                if (success) {
                                  Navigator.pop(context); // Regresa al login
                                }
                              }
                            },
                            child: const Text('Registrarse'),
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
  }
}
