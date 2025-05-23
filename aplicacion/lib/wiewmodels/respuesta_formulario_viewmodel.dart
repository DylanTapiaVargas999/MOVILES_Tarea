import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/reserva_model.dart';

class RespuestaFormularioViewModel extends ChangeNotifier {
  final String codigoAlumno;
  List<Reserva> _reservas = [];

  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  RespuestaFormularioViewModel({required this.codigoAlumno});

  List<Reserva> get reservas => _reservas;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  Future<void> cargarReservas() async {
    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('reservas')
          .where('codigo', isEqualTo: codigoAlumno)
          .get();
      _reservas = snapshot.docs
          .map((doc) => Reserva.fromJson(doc.data(), doc.id))
          .toList();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Error al cargar las reservas';
      _isLoading = false;
      notifyListeners();
    }
  }

  List<Reserva> get reservasPendientes =>
      _reservas.where((r) => r.estado == 'pendiente').toList();

  List<Reserva> get reservasConfirmadas =>
      _reservas.where((r) => r.estado == 'confirmado').toList();

  void limpiarMensajes() {
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }
}