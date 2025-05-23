import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
      appBar: AppBar(title: const Text('Solicitudes de Reserva')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: filtroEstado,
              items: const [
                DropdownMenuItem(value: 'todas', child: Text('Todas')),
                DropdownMenuItem(value: 'pendiente', child: Text('Pendientes')),
                DropdownMenuItem(value: 'aprobado', child: Text('Aprobadas')),
                DropdownMenuItem(value: 'rechazado', child: Text('Rechazadas')),
              ],
              onChanged: (value) {
                setState(() {
                  filtroEstado = value!;
                });
              },
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
                  return const Center(child: Text('No hay solicitudes.'));
                }
                final reservas =
                    snapshot.data!.docs.where((doc) {
                      if (filtroEstado == 'todas') return true;
                      final data = doc.data() as Map<String, dynamic>;
                      return data['estado'] == filtroEstado;
                    }).toList();
                if (reservas.isEmpty) {
                  return const Center(
                    child: Text('No hay solicitudes para este filtro.'),
                  );
                }
                return ListView.builder(
                  itemCount: reservas.length,
                  itemBuilder: (context, index) {
                    final reserva = reservas[index];
                    final data = reserva.data() as Map<String, dynamic>;
                    final estado = data['estado'] ?? 'pendiente';
                    final observacion = data['observacion'] ?? '';
                    return Card(
                      margin: const EdgeInsets.all(8),
                      child: ListTile(
                        title: Text(
                          'Alumno: ${data['nombre_completo'] ?? 'Desconocido'}',
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Laboratorio: ${data['lab'] ?? ''}'),
                            Text('Fecha: ${data['fecha'] ?? ''}'),
                            Text('Estado: $estado'),
                            if (observacion.isNotEmpty)
                              Text('Observación: $observacion'),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.check,
                                color: Colors.green,
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
                              icon: const Icon(Icons.close, color: Colors.red),
                              onPressed:
                                  estado == 'pendiente'
                                      ? () => _actualizarEstado(
                                        context,
                                        reserva.id,
                                        'rechazado',
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
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Solicitud $nuevoEstado')));
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
                onPressed: () async {
                  await FirebaseFirestore.instance
                      .collection('reservas')
                      .doc(id)
                      .update({'observacion': controller.text});
                  // Mostrar el SnackBar ANTES de cerrar el diálogo
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Observación guardada')),
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
