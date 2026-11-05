import 'package:flutter/material.dart';
import 'package:mobile_medicent_v3/features/auth/models/usuario_model.dart';
import 'package:mobile_medicent_v3/features/cuidador/services/cuidador_service.dart';
import 'package:mobile_medicent_v3/features/tomas/screens/tomas_screen.dart';

class PacientesAsignadosScreen extends StatefulWidget {
  final UsuarioModel cuidador;

  const PacientesAsignadosScreen({
    super.key,
    required this.cuidador,
  });

  @override
  State<PacientesAsignadosScreen> createState() => _PacientesAsignadosScreenState();
}

class _PacientesAsignadosScreenState extends State<PacientesAsignadosScreen> {
  final CuidadorService _cuidadorService = CuidadorService();

  // Pacientes de demostración vinculados en la base de datos (según seed.sql)
  List<UsuarioModel> _pacientes = [
    UsuarioModel(
      id: 2,
      nombre: 'Carlos Paciente Pérez',
      correo: 'carlos@medicent.com',
      rol: 'paciente',
    ),
    UsuarioModel(
      id: 4,
      nombre: 'María Paciente López',
      correo: 'maria@medicent.com',
      rol: 'paciente',
    ),
  ];

  // Diálogo para asignar un nuevo paciente por ID
  void _mostrarDialogoAsignarPaciente() {
    final pacienteIdController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          title: const Text('Vincular Paciente a mi Cargo', style: TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Ingresa el número de identificación (ID) del paciente registrado en Medicent para supervisar su adherencia farmacológica.',
                style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: pacienteIdController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'ID del Paciente (ej: 1)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.badge_outlined),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                final id = int.tryParse(pacienteIdController.text.trim());
                if (id != null) {
                  Navigator.of(ctx).pop();
                  final exito = await _cuidadorService.asignarPaciente(
                    cuidadorId: widget.cuidador.id,
                    pacienteId: id,
                  );

                  if (!mounted) return;

                  if (exito) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('✓ Paciente #$id asignado exitosamente'),
                        backgroundColor: const Color(0xFF0D9488),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Error o la asignación ya existía en la base de datos.'),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                foregroundColor: Colors.white,
              ),
              child: const Text('Asignar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Pacientes Asignados'),
        backgroundColor: const Color(0xFF2563EB),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _mostrarDialogoAsignarPaciente,
        backgroundColor: const Color(0xFF2563EB),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.person_add_rounded),
        label: const Text('Asignar Paciente'),
      ),
      body: _pacientes.isEmpty
          ? const Center(child: Text('No tienes pacientes a tu cargo actualmente.'))
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
              itemCount: _pacientes.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final p = _pacientes[index];

                return Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      // Al presionar el paciente, el cuidador supervisa sus tomas
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => TomasScreen(usuario: p),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: const Color(0xFFDBEAFE),
                            child: const Icon(Icons.person_rounded, color: Color(0xFF1E40AF), size: 28),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  p.nombre,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  p.correo,
                                  style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Color(0xFF94A3B8)),
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