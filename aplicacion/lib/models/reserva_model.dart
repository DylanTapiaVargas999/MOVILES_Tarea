class Reserva {
  final String id; // Usualmente el id de Firebase es String
  final String codigo;
  final String nombreCompleto;
  final String fecha;
  final String ciclo;
  final String curso;
  final String tema;
  final String lab;
  final String horaInicio;
  final String horaFin;

  Reserva({
    required this.id,
    required this.codigo,
    required this.nombreCompleto,
    required this.fecha,
    required this.ciclo,
    required this.curso,
    required this.tema,
    required this.lab,
    required this.horaInicio,
    required this.horaFin,
  });

  factory Reserva.fromJson(Map<String, dynamic> json, String id) {
    return Reserva(
      id: id,
      codigo: json['codigo'] ?? '',
      nombreCompleto: json['nombre_completo'] ?? '',
      fecha: json['fecha'] ?? '',
      ciclo: json['ciclo'] ?? '',
      curso: json['curso'] ?? '',
      tema: json['tema'] ?? '',
      lab: json['lab'] ?? '',
      horaInicio: json['hora_inicio'] ?? '',
      horaFin: json['hora_fin'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'codigo': codigo,
      'nombre_completo': nombreCompleto,
      'fecha': fecha,
      'ciclo': ciclo,
      'curso': curso,
      'tema': tema,
      'lab': lab,
      'hora_inicio': horaInicio,
      'hora_fin': horaFin,
    };
  }
}
