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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Iniciar Sesión'),
        automaticallyImplyLeading:
            false, // <-- Esto quita el botón de retroceso
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: codigoController,
                decoration: const InputDecoration(
                  labelText: 'Código de alumno',
                ),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Ingrese su código'
                            : null,
              ),
              TextFormField(
                controller: contrasenaController,
                decoration: const InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Ingrese su contraseña'
                            : null,
              ),
              const SizedBox(height: 20),
              if (loginViewModel.errorMessage != null)
                Text(
                  loginViewModel.errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed:
                          loginViewModel.isLoading
                              ? null
                              : () async {
                                if (_formKey.currentState!.validate()) {
                                  bool success = await loginViewModel.login(
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
                                    } else if (correo == 'elanchipa@upt.pe') {
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
                      child: const Text('Iniciar Sesión'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton(
                      onPressed:
                          loginViewModel.isLoading
                              ? null
                              : () {
                                Navigator.pushNamed(context, '/register');
                              },
                      child: const Text('Registrarse'),
                    ),
                  ),
                ],
              ),
              if (loginViewModel.isLoading)
                const Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
