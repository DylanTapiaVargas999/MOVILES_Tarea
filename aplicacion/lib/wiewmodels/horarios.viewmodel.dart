import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HorariosViewModel extends ChangeNotifier {
  List<Map<String, dynamic>> _horarios = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Map<String, dynamic>> get horarios => _horarios;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> cargarHorarios() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final query = await FirebaseFirestore.instance
          .collection('horarios')
          .get();

      _horarios = query.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      _errorMessage = 'Error al cargar los horarios';
    }

    _isLoading = false;
    notifyListeners();
  }

  void limpiar() {
    _horarios = [];
    _errorMessage = null;
    notifyListeners();
  }
}