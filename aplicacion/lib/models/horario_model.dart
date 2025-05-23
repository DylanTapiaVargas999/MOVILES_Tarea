class Horario {
  final String fecha;
  final String horaInicio;
  final String horaFin;
  final String estado;
  final String? curso;
  final String? profesor;
  final String? lab;
  final String? dia;

  Horario({
    required this.fecha,
    required this.horaInicio,
    required this.horaFin,
    required this.estado,
    this.curso,
    this.profesor,
    this.lab,
    this.dia,
  });

  factory Horario.fromJson(Map<String, dynamic> json) {
    return Horario(
      fecha: json['fecha'] ?? '',
      horaInicio: json['hora_inicio'] ?? '',
      horaFin: json['hora_fin'] ?? '',
      estado: json['estado'] ?? '',
      curso: json['curso'],
      profesor: json['profesor'],
      lab: json['lab'],
      dia: json['dia'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fecha': fecha,
      'hora_inicio': horaInicio,
      'hora_fin': horaFin,
      'estado': estado,
      'curso': curso,
      'profesor': profesor,
      'lab': lab,
      'dia': dia,
    };
  }
}
