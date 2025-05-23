import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Colores institucionales
const azulOscuro = Color(0xFF003366);
const rojoIntenso = Color(0xFFCC0000);
const grisClaro = Color(0xFFD9D9D9);
const verdeAprobado = Color(0xFF4CAF50);

class SoporteScreen extends StatefulWidget {
  const SoporteScreen({super.key});

  @override
  State<SoporteScreen> createState() => _SoporteScreenState();
}

class _SoporteScreenState extends State<SoporteScreen> {
  String filtroEstado = 'todas';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grisClaro,
      appBar: AppBar(
        title: const Text('Solicitudes de Reserva'),
        backgroundColor: azulOscuro,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false, // Quita el botón de retroceso
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: () {
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil('/login', (route) => false);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: azulOscuro.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: DropdownButton<String>(
                  value: filtroEstado,
                  underline: const SizedBox(),
                  isExpanded: true,
                  items: const [
                    DropdownMenuItem(value: 'todas', child: Text('Todas')),
                    DropdownMenuItem(
                      value: 'pendiente',
                      child: Text('Pendientes'),
                    ),
                    DropdownMenuItem(
                      value: 'aprobado',
                      child: Text('Aprobadas'),
                    ),
                    DropdownMenuItem(
                      value: 'rechazado',
                      child: Text('Rechazadas'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      filtroEstado = value!;
                    });
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('reservas').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      'No hay solicitudes.',
                      style: TextStyle(
                        color: azulOscuro,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }
                final reservas =
                    snapshot.data!.docs.where((doc) {
                      if (filtroEstado == 'todas') return true;
                      final data = doc.data() as Map<String, dynamic>;
                      return data['estado'] == filtroEstado;
                    }).toList();
                if (reservas.isEmpty) {
                  return const Center(
                    child: Text(
                      'No hay solicitudes para este filtro.',
                      style: TextStyle(
                        color: azulOscuro,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: reservas.length,
                  itemBuilder: (context, index) {
                    final reserva = reservas[index];
                    final data = reserva.data() as Map<String, dynamic>;
                    final estado = data['estado'] ?? 'pendiente';
                    final observacion = data['observacion'] ?? '';
                    Color estadoColor;
                    IconData estadoIcon;
                    if (estado == 'aprobado') {
                      estadoColor = verdeAprobado;
                      estadoIcon = Icons.check_circle;
                    } else if (estado == 'rechazado') {
                      estadoColor = rojoIntenso;
                      estadoIcon = Icons.cancel;
                    } else {
                      estadoColor = Colors.amber[700]!;
                      estadoIcon = Icons.hourglass_top;
                    }
                    return Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: ListTile(
                        leading: Icon(estadoIcon, color: estadoColor, size: 32),
                        title: Text(
                          'Alumno: ${data['nombre_completo'] ?? 'Desconocido'}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: azulOscuro,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Laboratorio: ${data['lab'] ?? ''}',
                              style: const TextStyle(color: azulOscuro),
                            ),
                            Text(
                              'Fecha: ${data['fecha'] ?? ''}',
                              style: const TextStyle(color: azulOscuro),
                            ),
                            Text(
                              'Estado: $estado',
                              style: TextStyle(
                                color: estadoColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (observacion.isNotEmpty)
                              Text(
                                'Observación: $observacion',
                                style: const TextStyle(color: Colors.black87),
                              ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.check,
                                color: verdeAprobado,
                              ),
                              onPressed:
                                  estado == 'pendiente'
                                      ? () => _actualizarEstado(
                                        context,
                                        reserva.id,
                                        'aprobado',
                                      )
                                      : null,
                              tooltip: 'Aprobar',
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, color: rojoIntenso),
                              onPressed:
                                  estado == 'pendiente'
                                      ? () => _mostrarDialogoObservacion(
                                        context,
                                        reserva.id,
                                      )
                                      : null,
                              tooltip: 'Rechazar',
                            ),
                          ],
                        ),
                        onTap:
                            () => _mostrarResumenObservacion(
                              context,
                              reserva.id,
                              data,
                            ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _actualizarEstado(
    BuildContext context,
    String id,
    String nuevoEstado, {
    String observacion = '',
  }) async {
    await FirebaseFirestore.instance.collection('reservas').doc(id).update({
      'estado': nuevoEstado,
      if (observacion.isNotEmpty) 'observacion': observacion,
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Solicitud $nuevoEstado'),
        backgroundColor:
            nuevoEstado == 'aprobado' ? verdeAprobado : rojoIntenso,
      ),
    );
  }

  void _mostrarDialogoObservacion(BuildContext context, String id) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Rechazar solicitud'),
            content: TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Observación',
                hintText: 'Motivo del rechazo',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: rojoIntenso,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  _actualizarEstado(
                    context,
                    id,
                    'rechazado',
                    observacion: controller.text,
                  );
                  Navigator.pop(context);
                },
                child: const Text('Rechazar'),
              ),
            ],
          ),
    );
  }

  void _mostrarResumenObservacion(
    BuildContext context,
    String id,
    Map<String, dynamic> data,
  ) {
    final controller = TextEditingController(text: data['observacion'] ?? '');
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Detalle de Solicitud'),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Text('Alumno: ${data['nombre_completo'] ?? 'Desconocido'}'),
                  Text('Laboratorio: ${data['lab'] ?? ''}'),
                  Text('Fecha: ${data['fecha'] ?? ''}'),
                  Text('Estado: ${data['estado'] ?? 'pendiente'}'),
                  const SizedBox(height: 16),
                  TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      labelText: 'Observación',
                      hintText: 'Agregar o editar observación',
                    ),
                    maxLines: 2,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cerrar'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: azulOscuro,
                  foregroundColor: Colors.white,
                ),
                onPressed: () async {
                  await FirebaseFirestore.instance
                      .collection('reservas')
                      .doc(id)
                      .update({'observacion': controller.text});
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Observación guardada'),
                      backgroundColor: azulOscuro,
                    ),
                  );
                  Navigator.pop(context);
                },
                child: const Text('Guardar Observación'),
              ),
            ],
          ),
    );
  }
}
