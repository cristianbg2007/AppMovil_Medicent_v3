import 'package:flutter/material.dart';
import 'package:mobile_medicent_v3/features/auth/models/usuario_model.dart';
import 'package:mobile_medicent_v3/features/auth/services/auth_service.dart';
import 'package:mobile_medicent_v3/features/auth/screens/login_screen.dart';


class HomeScreen extends StatelessWidget {
  final UsuarioModel usuario;
  const HomeScreen({
    super.key,
    required this.usuario,
  });
  // Función para cerrar sesión limpiando el almacenamiento
  Future<void> _cerrarSesion(BuildContext context) async {
    final authService = AuthService();
    await authService.logout();
    if (!context.mounted) return;
    // Regresar al Login y limpiar el historial de navegación
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }
  @override
  Widget build(BuildContext context) {
    final bool esPaciente = usuario.rol == 'paciente';
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Medicent V3 • Inicio'),
        backgroundColor: const Color(0xFF0D9488),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Cerrar Sesión',
            onPressed: () => _cerrarSesion(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Tarjeta de Bienvenida con Datos del Usuario
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: const Color(0xFFCCFBF1),
                    child: Icon(
                      esPaciente ? Icons.person_rounded : Icons.medical_services_rounded,
                      size: 34,
                      color: const Color(0xFF0F766E),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '¡Hola, ${usuario.nombre}!',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Rol: ${usuario.rol.toUpperCase()}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: esPaciente ? const Color(0xFF0D9488) : const Color(0xFF2563EB),
                          ),
                        ),
                        Text(
                          usuario.correo,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Sección según el Rol
            Text(
              esPaciente ? 'Mis Accesos Rápidos' : 'Panel de Cuidador',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 12),
            if (esPaciente) ...[
              // Opciones para Paciente
              _buildActionCard(
                icon: Icons.alarm_on_rounded,
                color: const Color(0xFF0D9488),
                title: 'Mis Tomas de Hoy',
                subtitle: 'Revisa tus medicamentos programados y confirma tus dosis.',
                onTap: () {
                  // Conectaremos con tomas_hoy_screen en el siguiente paso
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Módulo de Tomas: en desarrollo')),
                  );
                },
              ),
              const SizedBox(height: 12),
              _buildActionCard(
                icon: Icons.medication_liquid_rounded,
                color: const Color(0xFF2563EB),
                title: 'Mis Tratamientos Activos',
                subtitle: 'Consulta tus recetas, frecuencias y dosis prescritas.',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Módulo de Tratamientos: en desarrollo')),
                  );
                },
              ),
            ] else ...[
              // Opciones para Cuidador
              _buildActionCard(
                icon: Icons.people_alt_rounded,
                color: const Color(0xFF2563EB),
                title: 'Pacientes Asignados',
                subtitle: 'Supervisa el cumplimiento y tomas de tus pacientes.',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Módulo Cuidador: en desarrollo')),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
  // Widget reutilizable para las tarjetas de acción
  Widget _buildActionCard({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Color(0xFF94A3B8)),
          ],
        ),
      ),
    );
  }
}