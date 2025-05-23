import 'package:flutter/material.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Panel de Administrador')),
      body: const Center(child: Text('Bienvenido al panel de administración')),
    );
  }
}
