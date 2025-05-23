import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../wiewmodels/login_viewmodel.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController codigoController = TextEditingController();
  final TextEditingController contrasenaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loginViewModel = Provider.of<LoginViewModel>(context);

    // Colores institucionales
    const azulOscuro = Color(0xFF003366);
    const rojoIntenso = Color(0xFFCC0000);
    const grisClaro = Color(0xFFD9D9D9);
    const amarilloDorado = Color(0xFFFFCC00);

    return Scaffold(
      backgroundColor: grisClaro,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo de la universidad
                Container(
                  height: 100,
                  margin: const EdgeInsets.only(bottom: 24),
                  child: Image.asset(
                    'assets/upt_logo.png', // Cambia por la ruta de tu logo
                    fit: BoxFit.contain,
                  ),
                ),
                Container(
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
                      children: [
                        Text(
                          'Bienvenido',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: azulOscuro,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Accede con tu cuenta institucional',
                          style: TextStyle(
                            fontSize: 15,
                            color: azulOscuro.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 28),
                        TextFormField(
                          controller: codigoController,
                          decoration: InputDecoration(
                            labelText: 'Código de alumno',
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
                          validator:
                              (value) =>
                                  value == null || value.isEmpty
                                      ? 'Ingrese su código'
                                      : null,
                        ),
                        const SizedBox(height: 18),
                        TextFormField(
                          controller: contrasenaController,
                          decoration: InputDecoration(
                            labelText: 'Contraseña',
                            prefixIcon: Icon(
                              Icons.lock_outline,
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
                          obscureText: true,
                          validator:
                              (value) =>
                                  value == null || value.isEmpty
                                      ? 'Ingrese su contraseña'
                                      : null,
                        ),
                        const SizedBox(height: 18),
                        if (loginViewModel.errorMessage != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              loginViewModel.errorMessage!,
                              style: TextStyle(
                                color: rojoIntenso,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              backgroundColor: azulOscuro,
                              elevation: 0,
                              foregroundColor: Colors.white,
                              textStyle: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed:
                                loginViewModel.isLoading
                                    ? null
                                    : () async {
                                      if (_formKey.currentState!.validate()) {
                                        bool success = await loginViewModel
                                            .login(
                                              codigoController.text,
                                              contrasenaController.text,
                                            );
                                        if (success) {
                                          final correo =
                                              codigoController.text
                                                  .trim()
                                                  .toLowerCase();
                                          if (correo == 'soporte@upt.pe') {
                                            Navigator.pushReplacementNamed(
                                              context,
                                              '/soporte',
                                            );
                                          } else if (correo ==
                                              'elanchipa@upt.pe') {
                                            Navigator.pushReplacementNamed(
                                              context,
                                              '/admin',
                                            );
                                          } else {
                                            Navigator.pushReplacementNamed(
                                              context,
                                              '/home',
                                            );
                                          }
                                        }
                                      }
                                    },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.login,
                                  size: 22,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 10),
                                const Text('Iniciar Sesión'),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "¿No tienes cuenta?",
                              style: TextStyle(fontSize: 14),
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor: amarilloDorado,
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onPressed:
                                  loginViewModel.isLoading
                                      ? null
                                      : () {
                                        Navigator.pushNamed(
                                          context,
                                          '/register',
                                        );
                                      },
                              child: const Text('Registrarse'),
                            ),
                          ],
                        ),
                        if (loginViewModel.isLoading)
                          const Padding(
                            padding: EdgeInsets.only(top: 18),
                            child: CircularProgressIndicator(),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
