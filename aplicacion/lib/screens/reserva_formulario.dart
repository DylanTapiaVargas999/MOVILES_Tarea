import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/alumno_model.dart';

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
      text: "${DateTime.now().day.toString().padLeft(2, '0')}/${DateTime.now().month.toString().padLeft(2, '0')}/${DateTime.now().year}",
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
      appBar: AppBar(title: Text('Formulario de Reserva')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: cicloController,
                decoration: InputDecoration(labelText: 'Ciclo'),
                readOnly: true, // Bloqueado
                enabled: false, // Bloqueado
              ),
              TextFormField(
                controller: codigoController,
                decoration: InputDecoration(labelText: 'Código'),
                readOnly: true, // Bloqueado
                enabled: false, // Bloqueado
              ),
              TextFormField(
                controller: cursoController,
                decoration: InputDecoration(labelText: 'Curso'),
              ),
              TextFormField(
                controller: fechaController,
                decoration: InputDecoration(labelText: 'Fecha'),
                readOnly: true, // Bloqueado
                enabled: false, // Bloqueado
              ),
              TextFormField(
                controller: horaInicioController,
                decoration: InputDecoration(labelText: 'Hora Inicio'),
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  TimeOfDay? picked = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (picked != null) {
                    horaInicioController.text =
                        "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}";
                  }
                },
              ),
              TextFormField(
                controller: horaFinController,
                decoration: InputDecoration(labelText: 'Hora Fin'),
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  TimeOfDay? picked = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (picked != null) {
                    horaFinController.text =
                        "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}";
                  }
                },
              ),
              TextFormField(
                controller: labController,
                decoration: InputDecoration(labelText: 'Lab'),
                readOnly: true, // Bloqueado
                enabled: false, // Bloqueado
              ),
              TextFormField(
                controller: nombreCompletoController,
                decoration: InputDecoration(labelText: 'Nombre Completo'),
                readOnly: true, // Bloqueado
                enabled: false, // Bloqueado
              ),
              SizedBox(height: 20),
              ElevatedButton(
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
                      'estado': estado, // Campo oculto enviado como "pendiente"
                    };

                    try {
                      await FirebaseFirestore.instance
                          .collection('reservas')
                          .add(reservaData);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Reserva guardada correctamente')),
                      );
                      Navigator.of(context).pop(); // Regresa a la pantalla anterior
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error al guardar la reserva')),
                      );
                    }
                  }
                },
                child: Text('Reservar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}