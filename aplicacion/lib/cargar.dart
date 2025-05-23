import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> uploadJsonToFirestore() async {
  // Carga el archivo JSON desde los assets
  final String jsonString = await rootBundle.loadString('json/base.json');
  final Map<String, dynamic> jsonData = json.decode(jsonString);

  // Accede a la colección 'usuarios' y sube cada documento
  final usuarios = jsonData['usuarios'] as Map<String, dynamic>;

  for (final entry in usuarios.entries) {
    final docId = entry.key;
    final data = Map<String, dynamic>.from(entry.value);
    await FirebaseFirestore.instance.collection('usuarios').doc(docId).set(data);
  }

  print('Datos cargados en Firestore exitosamente');
}
