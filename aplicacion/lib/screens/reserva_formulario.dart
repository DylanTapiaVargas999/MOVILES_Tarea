import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/alumno_model.dart';

// Colores institucionales
const azulOscuro = Color(0xFF003366);
const rojoIntenso = Color(0xFFCC0000);
const grisClaro = Color(0xFFD9D9D9);
const amarilloDorado = Color(0xFFFFCC00);

class ReservaFormulario extends StatefulWidget {
  final Alumno alumno;
  final String lab;
  final String horaInicio;
  final String horaFin;

  const ReservaFormulario({
    Key? key,
    required this.alumno,
    required this.lab,
    required this.horaInicio,
    required this.horaFin,
  }) : super(key: key);

  @override
  State<ReservaFormulario> createState() => _ReservaFormularioState();
}

class _ReservaFormularioState extends State<ReservaFormulario> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController cicloController;
  late TextEditingController codigoController;
  late TextEditingController cursoController;
  late TextEditingController fechaController;
  late TextEditingController horaInicioController;
  late TextEditingController horaFinController;
  late TextEditingController labController;
  late TextEditingController nombreCompletoController;

  final String estado = 'pendiente'; // Campo oculto

  @override
  void initState() {
    super.initState();
    cicloController = TextEditingController(text: widget.alumno.ciclo);
    codigoController = TextEditingController(text: widget.alumno.codigo);
    cursoController = TextEditingController();
    fechaController = TextEditingController(
      text:
          "${DateTime.now().day.toString().padLeft(2, '0')}/${DateTime.now().month.toString().padLeft(2, '0')}/${DateTime.now().year}",
    );
    horaInicioController = TextEditingController(text: widget.horaInicio);
    horaFinController = TextEditingController(text: widget.horaFin);
    labController = TextEditingController(text: widget.lab);
    nombreCompletoController = TextEditingController(
      text: '${widget.alumno.nombre} ${widget.alumno.apellido}',
    );
  }

  @override
  void dispose() {
    cicloController.dispose();
    codigoController.dispose();
    cursoController.dispose();
    fechaController.dispose();
    horaInicioController.dispose();
    horaFinController.dispose();
    labController.dispose();
    nombreCompletoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grisClaro,
      appBar: AppBar(
        title: const Text('Formulario de Reserva'),
        backgroundColor: azulOscuro,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
            child: Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: azulOscuro.withOpacity(0.08),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Reserva de Laboratorio',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: azulOscuro,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildReadOnlyField(cicloController, 'Ciclo', Icons.school),
                    const SizedBox(height: 12),
                    _buildReadOnlyField(
                      codigoController,
                      'Código',
                      Icons.badge,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: cursoController,
                      decoration: InputDecoration(
                        labelText: 'Curso',
                        prefixIcon: const Icon(Icons.book, color: azulOscuro),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: azulOscuro,
                            width: 1.2,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: grisClaro, width: 1.2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: azulOscuro,
                            width: 2,
                          ),
                        ),
                        filled: true,
                        fillColor: grisClaro.withOpacity(0.3),
                      ),
                      validator:
                          (value) =>
                              value == null || value.isEmpty
                                  ? 'Ingrese el curso'
                                  : null,
                    ),
                    const SizedBox(height: 12),
                    _buildReadOnlyField(
                      fechaController,
                      'Fecha',
                      Icons.calendar_today,
                    ),
                    const SizedBox(height: 12),
                    _buildTimeField(
                      horaInicioController,
                      'Hora Inicio',
                      Icons.access_time,
                    ),
                    const SizedBox(height: 12),
                    _buildTimeField(
                      horaFinController,
                      'Hora Fin',
                      Icons.access_time,
                    ),
                    const SizedBox(height: 12),
                    _buildReadOnlyField(
                      labController,
                      'Laboratorio',
                      Icons.computer,
                    ),
                    const SizedBox(height: 12),
                    _buildReadOnlyField(
                      nombreCompletoController,
                      'Nombre Completo',
                      Icons.person,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: azulOscuro,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          textStyle: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        icon: const Icon(Icons.save),
                        label: const Text('Reservar'),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            final reservaData = {
                              'ciclo': cicloController.text,
                              'codigo': codigoController.text,
                              'curso': cursoController.text,
                              'fecha': fechaController.text,
                              'hora_inicio': horaInicioController.text,
                              'hora_fin': horaFinController.text,
                              'lab': labController.text,
                              'nombre_completo': nombreCompletoController.text,
                              'estado': estado,
                            };

                            try {
                              await FirebaseFirestore.instance
                                  .collection('reservas')
                                  .add(reservaData);

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Reserva guardada correctamente',
                                  ),
                                  backgroundColor: azulOscuro,
                                ),
                              );
                              Navigator.of(context).pop();
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Error al guardar la reserva'),
                                  backgroundColor: rojoIntenso,
                                ),
                              );
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReadOnlyField(
    TextEditingController controller,
    String label,
    IconData icon,
  ) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: azulOscuro),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: azulOscuro, width: 1.2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: grisClaro, width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: azulOscuro, width: 2),
        ),
        filled: true,
        fillColor: grisClaro.withOpacity(0.3),
      ),
      readOnly: true,
      enabled: false,
    );
  }

  Widget _buildTimeField(
    TextEditingController controller,
    String label,
    IconData icon,
  ) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: azulOscuro),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: azulOscuro, width: 1.2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: grisClaro, width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: azulOscuro, width: 2),
        ),
        filled: true,
        fillColor: grisClaro.withOpacity(0.3),
      ),
      readOnly: true,
      onTap: () async {
        FocusScope.of(context).requestFocus(FocusNode());
        TimeOfDay? picked = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        if (picked != null) {
          controller.text =
              "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}";
        }
      },
    );
  }
}
