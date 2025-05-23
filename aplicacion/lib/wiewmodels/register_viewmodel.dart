import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/alumno_model.dart';

class RegisterViewModel extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  Future<bool> registerAlumno(Alumno alumno) async {
    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      final query = await FirebaseFirestore.instance
          .collection('datos_alumno') // Cambiado aquí
          .where('codigo', isEqualTo: alumno.codigo.trim())
          .get();

      if (query.docs.isNotEmpty) {
        _errorMessage = 'El código ya está registrado';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      await FirebaseFirestore.instance
          .collection('datos_alumno') // Cambiado aquí
          .add(alumno.toJson());

      _successMessage = 'Registro exitoso';
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Error al registrar usuario';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void clearMessages() {
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }
}