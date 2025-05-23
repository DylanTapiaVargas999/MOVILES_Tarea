import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/reserva_model.dart';

class ReservaViewModel extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  Future<bool> crearReserva(Reserva reserva) async {
    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      await FirebaseFirestore.instance.collection('reservas').add(reserva.toJson());
      _successMessage = 'Reserva creada exitosamente';
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Error al crear la reserva';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void limpiarMensajes() {
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }
}