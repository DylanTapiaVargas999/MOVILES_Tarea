class Alumno {
  final String? id;
  final String codigo;
  final String nombre;
  final String apellido;
  final String ciclo;
  final String contrasena;

  Alumno({
    this.id,
    required this.codigo,
    required this.nombre,
    required this.apellido,
    required this.ciclo,
    required this.contrasena,
  });

  factory Alumno.fromJson(Map<String, dynamic> json, [String? id]) {
    return Alumno(
      id: id,
      codigo: json['codigo'] ?? '',
      nombre: json['nombre'] ?? '',
      apellido: json['apellido'] ?? '',
      ciclo: json['ciclo'] ?? '',
      contrasena: json['contrasena'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'codigo': codigo,
      'nombre': nombre,
      'apellido': apellido,
      'ciclo': ciclo,
      'contrasena': contrasena,
    };
  }
}
