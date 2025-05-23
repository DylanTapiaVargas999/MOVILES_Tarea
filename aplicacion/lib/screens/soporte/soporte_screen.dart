import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SoporteScreen extends StatelessWidget {
  const SoporteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Soporte')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            // Ejemplo: crear un ticket de soporte en Firestore
            await FirebaseFirestore.instance.collection('soporte_tickets').add({
              'mensaje': 'Ejemplo de mensaje de soporte',
              'fecha': Timestamp.now(),
              'estado': 'abierto',
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Ticket de soporte enviado')),
            );
          },
          child: const Text('Enviar ticket de prueba'),
        ),
      ),
    );
  }
}
