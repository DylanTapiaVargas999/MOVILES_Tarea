import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/alumno_model.dart';

class PerfilViewModel extends ChangeNotifier {
  Alumno? _alumno;
  bool _isLoading = false;
  String? _errorMessage;

  Alumno? get alumno => _alumno;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> cargarPerfil(String codigo) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final query = await FirebaseFirestore.instance
          .collection('datos_alumno')
          .where('codigo', isEqualTo: codigo.trim())
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        final data = query.docs.first.data();
        _alumno = Alumno.fromJson(data, query.docs.first.id);
      } else {
        _errorMessage = 'No se encontró el perfil del estudiante';
      }
    } catch (e) {
      _errorMessage = 'Error al cargar el perfil';
    }

    _isLoading = false;
    notifyListeners();
  }

  void limpiar() {
    _alumno = null;
    _errorMessage = null;
    notifyListeners();
  }
}