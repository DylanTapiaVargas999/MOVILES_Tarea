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
      final query =
          await FirebaseFirestore.instance.collection('horarios').get();

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

  /// Retorna los horarios del laboratorio solo para el día actual.
  List<Map<String, dynamic>> obtenerHorariosDeHoy() {
    const dia = [
      'Lunes',
      'Martes',
      'Miércoles',
      'Jueves',
      'Viernes',
      'Sábado',
      'Domingo',
    ];
    final hoy = DateTime.now();
    final nombreDia = dia[hoy.weekday - 1];

    // DEBUG: imprime los valores para comparar
    print('Hoy es: $nombreDia');
    print('Horarios:');
    for (var h in _horarios) {
      print(h['dia']);
    }

    return _horarios.where((horario) => horario['dia'] == nombreDia).toList();
  }
}
