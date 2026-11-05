import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_medicent_v3/features/auth/models/usuario_model.dart';
import 'package:mobile_medicent_v3/features/tomas/models/toma_model.dart';
import 'package:mobile_medicent_v3/features/tomas/services/tomas_service.dart';

class TomasScreen extends StatefulWidget {
  final UsuarioModel usuario;

  const TomasScreen({
    super.key,
    required this.usuario,
  });

  @override
  State<TomasScreen> createState() => _TomasScreenState();
}

class _TomasScreenState extends State<TomasScreen> {
  final TomasService _tomasService = TomasService();
  List<TomaModel> _tomas = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarTomas();
  }

  // Consulta el cronograma desde Flask
  Future<void> _cargarTomas() async {
    setState(() {
      _cargando = true;
    });

    final lista = await _tomasService.obtenerTomasPaciente(widget.usuario.id);

    if (mounted) {
      setState(() {
        _tomas = lista;
        _cargando = false;
      });
    }
  }

  // Acción de confirmar la toma
  Future<void> _marcarToma(TomaModel toma) async {
    final exito = await _tomasService.marcarTomaComoTomada(toma.id);

    if (!mounted) return;

    if (exito) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✓ ¡Dosis de ${toma.medicamentoNombre} confirmada!'),
          backgroundColor: const Color(0xFF0D9488),
        ),
      );
      // Recargar la lista para reflejar el nuevo estado
      _cargarTomas();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al registrar la toma. Revisa tu conexión.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Mis Tomas de Medicamentos'),
        backgroundColor: const Color(0xFF0D9488),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refrescar',
            onPressed: _cargarTomas,
          ),
        ],
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : _tomas.isEmpty
              ? _buildEstadoVacio()
              : _buildListaTomas(),
    );
  }

  // Vista cuando no hay tomas registradas
  Widget _buildEstadoVacio() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFCCFBF1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_outline_rounded,
                size: 64,
                color: Color(0xFF0F766E),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              '¡Estás al día!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'No tienes tomas pendientes en este momento.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _cargarTomas,
              icon: const Icon(Icons.refresh),
              label: const Text('Actualizar Cronograma'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0D9488),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Lista de tarjetas de tomas
  Widget _buildListaTomas() {
    return ListView.separated(
      padding: const EdgeInsets.all(16.0),
      itemCount: _tomas.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final toma = _tomas[index];
        final bool tomada = toma.estaTomada;
        final horaFormateada = DateFormat('hh:mm a • dd/MM').format(toma.fechaHoraProgramada);

        return Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: tomada ? const Color(0xFF86EFAC) : const Color(0xFFCBD5E1),
              width: tomada ? 1.5 : 1,
            ),
          ),
          color: tomada ? const Color(0xFFF0FDF4) : Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Ícono del medicamento
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: tomada ? const Color(0xFFDCFCE7) : const Color(0xFFE0F2FE),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    tomada ? Icons.check_circle_rounded : Icons.medication_rounded,
                    color: tomada ? const Color(0xFF16A34A) : const Color(0xFF0284C7),
                    size: 28,
                  ),
                ),
                const SizedBox(width: 14),

                // Información de la dosis y hora
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        toma.medicamentoNombre,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF0F172A),
                          decoration: tomada ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Dosis: ${toma.dosis}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF475569),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(Icons.access_time_rounded, size: 14, color: Color(0xFF64748B)),
                          const SizedBox(width: 4),
                          Text(
                            horaFormateada,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Botón de acción
                if (tomada)
                  const Chip(
                    label: Text(
                      'Tomada',
                      style: TextStyle(color: Color(0xFF166534), fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                    backgroundColor: Color(0xFFDCFCE7),
                    visualDensity: VisualDensity.compact,
                  )
                else
                  ElevatedButton(
                    onPressed: () => _marcarToma(toma),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0D9488),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Tomar',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}