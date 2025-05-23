import 'package:aplicacion/wiewmodels/formulario_reserva_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/reserva_model.dart';

class ReservaScreen extends StatefulWidget {
  const ReservaScreen({super.key});

  @override
  State<ReservaScreen> createState() => _ReservaScreenState();
}

class _ReservaScreenState extends State<ReservaScreen> {
  final _formKey = GlobalKey<FormState>();
  final codigoController = TextEditingController();
  final nombreCompletoController = TextEditingController();
  final fechaController = TextEditingController();
  final cicloController = TextEditingController();
  final cursoController = TextEditingController();
  final temaController = TextEditingController();
  final labController = TextEditingController();
  final horaInicioController = TextEditingController();
  final horaFinController = TextEditingController();

  @override
  void dispose() {
    codigoController.dispose();
    nombreCompletoController.dispose();
    fechaController.dispose();
    cicloController.dispose();
    cursoController.dispose();
    temaController.dispose();
    labController.dispose();
    horaInicioController.dispose();
    horaFinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ReservaViewModel(),
      child: Consumer<ReservaViewModel>(
        builder: (context, reservaViewModel, _) {
          return Scaffold(
            appBar: AppBar(title: const Text('Reservar Aula')),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      controller: codigoController,
                      decoration: const InputDecoration(labelText: 'Código'),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Ingrese su código' : null,
                    ),
                    TextFormField(
                      controller: nombreCompletoController,
                      decoration: const InputDecoration(labelText: 'Nombre Completo'),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Ingrese su nombre completo' : null,
                    ),
                    TextFormField(
                      controller: fechaController,
                      decoration: const InputDecoration(labelText: 'Fecha'),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Ingrese la fecha' : null,
                    ),
                    TextFormField(
                      controller: cicloController,
                      decoration: const InputDecoration(labelText: 'Ciclo'),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Ingrese el ciclo' : null,
                    ),
                    TextFormField(
                      controller: cursoController,
                      decoration: const InputDecoration(labelText: 'Curso'),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Ingrese el curso' : null,
                    ),
                    TextFormField(
                      controller: temaController,
                      decoration: const InputDecoration(labelText: 'Tema'),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Ingrese el tema' : null,
                    ),
                    TextFormField(
                      controller: labController,
                      decoration: const InputDecoration(labelText: 'Laboratorio'),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Ingrese el laboratorio' : null,
                    ),
                    TextFormField(
                      controller: horaInicioController,
                      decoration: const InputDecoration(labelText: 'Hora de Inicio'),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Ingrese la hora de inicio' : null,
                    ),
                    TextFormField(
                      controller: horaFinController,
                      decoration: const InputDecoration(labelText: 'Hora de Fin'),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Ingrese la hora de fin' : null,
                    ),
                    const SizedBox(height: 20),
                    if (reservaViewModel.errorMessage != null)
                      Text(
                        reservaViewModel.errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    if (reservaViewModel.successMessage != null)
                      Text(
                        reservaViewModel.successMessage!,
                        style: const TextStyle(color: Colors.green),
                      ),
                    const SizedBox(height: 20),
                    reservaViewModel.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                final reserva = Reserva(
                                  id: '', // El id lo asigna Firestore
                                  codigo: codigoController.text,
                                  nombreCompleto: nombreCompletoController.text,
                                  fecha: fechaController.text,
                                  ciclo: cicloController.text,
                                  curso: cursoController.text,
                                  tema: temaController.text,
                                  lab: labController.text,
                                  horaInicio: horaInicioController.text,
                                  horaFin: horaFinController.text,
                                );
                                await reservaViewModel.crearReserva(reserva);
                              }
                            },
                            child: const Text('Reservar'),
                          ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}