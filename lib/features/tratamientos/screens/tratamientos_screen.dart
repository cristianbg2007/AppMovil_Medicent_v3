import 'package:flutter/material.dart';
import 'package:mobile_medicent_v3/features/auth/models/usuario_model.dart';
import 'package:mobile_medicent_v3/features/medicamentos/models/medicamento_model.dart';
import 'package:mobile_medicent_v3/features/medicamentos/services/medicamento_service.dart';
import 'package:mobile_medicent_v3/features/tratamientos/models/tratamiento_model.dart';
import 'package:mobile_medicent_v3/features/tratamientos/services/tratamiento_service.dart';

class TratamientosScreen extends StatefulWidget {
  final UsuarioModel usuario;

  const TratamientosScreen({
    super.key,
    required this.usuario,
  });

  @override
  State<TratamientosScreen> createState() => _TratamientosScreenState();
}

class _TratamientosScreenState extends State<TratamientosScreen> {
  final TratamientoService _tratamientoService = TratamientoService();
  final MedicamentoService _medicamentoService = MedicamentoService();

  List<TratamientoModel> _tratamientos = [];
  List<MedicamentoModel> _medicamentosDisponibles = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  // Carga simultánea de tratamientos y catálogo de fármacos
  Future<void> _cargarDatos() async {
    setState(() {
      _cargando = true;
    });

    final tratamientosFuture = _tratamientoService.obtenerTratamientosPaciente(widget.usuario.id);
    final medicamentosFuture = _medicamentoService.obtenerMedicamentos();

    final resultados = await Future.wait([tratamientosFuture, medicamentosFuture]);

    if (mounted) {
      setState(() {
        _tratamientos = resultados[0] as List<TratamientoModel>;
        _medicamentosDisponibles = resultados[1] as List<MedicamentoModel>;
        _cargando = false;
      });
    }
  }

  // Diálogo modal para prescribir un nuevo tratamiento
  void _mostrarDialogoNuevoTratamiento() {
    final formKey = GlobalKey<FormState>();
    int? medicamentoSeleccionadoId;
    final dosisController = TextEditingController(text: '1 tableta');
    final frecuenciaController = TextEditingController(text: '8');
    final fechaInicioController = TextEditingController(text: DateTime.now().toIso8601String().split('T')[0]);
    final fechaFinController = TextEditingController(
      text: DateTime.now().add(const Duration(days: 7)).toIso8601String().split('T')[0],
    );
    final horaInicialController = TextEditingController(text: '08:00:00');

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              title: const Text('Prescribir Tratamiento', style: TextStyle(fontWeight: FontWeight.bold)),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Selector de Medicamento
                      DropdownButtonFormField<int>(
                        decoration: const InputDecoration(
                          labelText: 'Medicamento',
                          border: OutlineInputBorder(),
                        ),
                        items: _medicamentosDisponibles.map((med) {
                          return DropdownMenuItem<int>(
                            value: med.id,
                            child: Text(med.nombre),
                          );
                        }).toList(),
                        onChanged: (val) {
                          setModalState(() {
                            medicamentoSeleccionadoId = val;
                          });
                        },
                        validator: (val) => val == null ? 'Selecciona un fármaco' : null,
                      ),
                      const SizedBox(height: 12),

                      // Dosis
                      TextFormField(
                        controller: dosisController,
                        decoration: const InputDecoration(
                          labelText: 'Dosis (ej: 1 cápsula)',
                          border: OutlineInputBorder(),
                        ),
                        validator: (val) => val == null || val.isEmpty ? 'La dosis es requerida' : null,
                      ),
                      const SizedBox(height: 12),

                      // Frecuencia
                      TextFormField(
                        controller: frecuenciaController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Frecuencia (cada cuántas horas)',
                          border: OutlineInputBorder(),
                        ),
                        validator: (val) => val == null || val.isEmpty ? 'Ingresa las horas' : null,
                      ),
                      const SizedBox(height: 12),

                      // Rango de fechas
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: fechaInicioController,
                              decoration: const InputDecoration(
                                labelText: 'Fecha Inicio',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              controller: fechaFinController,
                              decoration: const InputDecoration(
                                labelText: 'Fecha Fin',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate() && medicamentoSeleccionadoId != null) {
                      final nuevo = TratamientoModel(
                        id: 0,
                        pacienteId: widget.usuario.id,
                        medicamentoId: medicamentoSeleccionadoId!,
                        medicamentoNombre: '',
                        dosis: dosisController.text.trim(),
                        frecuenciaHoras: int.tryParse(frecuenciaController.text.trim()) ?? 8,
                        fechaInicio: fechaInicioController.text.trim(),
                        fechaFin: fechaFinController.text.trim(),
                        horaInicial: horaInicialController.text.trim(),
                      );

                      Navigator.of(ctx).pop();

                      final exito = await _tratamientoService.crearTratamiento(nuevo);
                      if (!mounted) return;

                      if (exito) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('✓ Tratamiento creado y tomas programadas con éxito'),
                            backgroundColor: Color(0xFF0D9488),
                          ),
                        );
                        _cargarDatos();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Error al crear el tratamiento'),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D9488),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Guardar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Tratamientos Médicos'),
        backgroundColor: const Color(0xFF0D9488),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refrescar',
            onPressed: _cargarDatos,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _mostrarDialogoNuevoTratamiento,
        backgroundColor: const Color(0xFF0D9488),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Nuevo Tratamiento'),
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : _tratamientos.isEmpty
              ? _buildEstadoVacio()
              : _buildListaTratamientos(),
    );
  }

  Widget _buildEstadoVacio() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Color(0xFFEFF6FF),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.medical_services_outlined,
                size: 64,
                color: Color(0xFF2563EB),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'No hay tratamientos activos',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Presiona el botón "+ Nuevo Tratamiento" para prescribir un medicamento.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListaTratamientos() {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
      itemCount: _tratamientos.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final t = _tratamientos[index];

        return Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Color(0xFFE2E8F0)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.medication_rounded, color: Color(0xFF2563EB), size: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            t.medicamentoNombre,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          Text(
                            'Dosis: ${t.dosis} • Cada ${t.frecuenciaHoras} horas',
                            style: const TextStyle(fontSize: 13, color: Color(0xFF475569)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Vigencia: ${t.fechaInicio} al ${t.fechaFin}',
                      style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                    ),
                    const Chip(
                      label: Text('Activo', style: TextStyle(color: Color(0xFF166534), fontSize: 11, fontWeight: FontWeight.bold)),
                      backgroundColor: Color(0xFFDCFCE7),
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}