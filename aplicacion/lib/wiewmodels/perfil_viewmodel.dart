import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/alumno_model.dart';

class PerfilViewModel extends ChangeNotifier {
  Alumno? _alumno;
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage; // Para mensajes de éxito

  Alumno? get alumno => _alumno;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

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

  Future<bool> editarPerfil(Alumno alumnoEditado) async {
    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      await FirebaseFirestore.instance
          .collection('datos_alumno')
          .doc(alumnoEditado.id)
          .update(alumnoEditado.toJson());

      _alumno = alumnoEditado;
      _successMessage = 'Perfil actualizado correctamente';
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Error al actualizar el perfil';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void limpiar() {
    _alumno = null;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }
}