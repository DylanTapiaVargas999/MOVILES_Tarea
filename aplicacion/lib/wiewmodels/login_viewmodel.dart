import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginViewModel extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  String? _codigoAlumno; // <-- Agrega esto

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get codigoAlumno => _codigoAlumno; // <-- Getter

  Future<bool> login(String codigo, String contrasena) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    // CASO ESPECIAL: correos soporte y admin
    final correo = codigo.trim().toLowerCase();
    if ((correo == 'soporte@upt.pe' && contrasena == 'soporte123') ||
        (correo == 'elanchipa@upt.pe' && contrasena == 'admin123')) {
      _codigoAlumno = correo;
      _isLoading = false;
      notifyListeners();
      return true;
    }

    try {
      final query =
          await FirebaseFirestore.instance
              .collection('datos_alumno')
              .where('codigo', isEqualTo: codigo.trim())
              .where('contrasena', isEqualTo: contrasena)
              .get();

      if (query.docs.isNotEmpty) {
        _codigoAlumno = codigo.trim();
        _isLoading = false;
        notifyListeners();
        return true; // Login exitoso
      } else {
        _errorMessage = 'Código o contraseña incorrectos';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Error al iniciar sesión';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
