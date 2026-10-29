import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_medicent_v3/core/api/api_endpoints.dart';
import 'package:mobile_medicent_v3/core/api/api_client.dart';

void main() {
  runApp(const MedicentApp());
}

class MedicentApp extends StatelessWidget {
  const MedicentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medicent V3 Mobile',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0D9488)),
        useMaterial3: true,
      ),
      home: const EstadoBackendScreen(),
    );
  }
}

class EstadoBackendScreen extends StatefulWidget {
  const EstadoBackendScreen({super.key});

  @override
  State<EstadoBackendScreen> createState() => _EstadoBackendScreenState();
}

class _EstadoBackendScreenState extends State<EstadoBackendScreen> {
  String _resultado = 'Presiona el botón para verificar el Backend Flask';
  bool _cargando = false;
  bool _conectado = false;

  Future<void> _verificarConexion() async {
    setState(() {
      _cargando = true;
      _resultado = 'Conectando con ${ApiEndpoints.estado}...';
    });

    try {
      final respuesta = await ApiClient.get(ApiEndpoints.estado);
      if (respuesta.statusCode == 200) {
        final datos = jsonDecode(respuesta.body);
        setState(() {
          _conectado = true;
          _resultado = '¡Conexión Exitosa!\nEstado: ${datos["estado"]}';
        });
      } else {
        setState(() {
          _conectado = false;
          _resultado = 'Error HTTP ${respuesta.statusCode}: ${respuesta.body}';
        });
      }
    } catch (e) {
      setState(() {
        _conectado = false;
        _resultado = 'Error de Conexión:\n$e\n\n(Asegúrate de que Flask esté corriendo con "py run.py")';
      });
    } finally {
      setState(() {
        _cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medicent V3 • Día 1: Core API'),
        backgroundColor: const Color(0xFF0D9488),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _conectado ? Icons.check_circle_outline : Icons.cloud_sync_outlined,
                size: 80,
                color: _conectado ? Colors.teal : Colors.blueGrey,
              ),
              const SizedBox(height: 20),
              Text(
                'Verificación de Conectividad',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _conectado ? Colors.teal.shade50 : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: _conectado ? Colors.teal.shade300 : Colors.grey.shade300,
                  ),
                ),
                child: Text(
                  _resultado,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              const SizedBox(height: 28),
              _cargando
                  ? const CircularProgressIndicator()
                  : ElevatedButton.icon(
                      onPressed: _verificarConexion,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Probar Conexión con Flask'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0D9488),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
