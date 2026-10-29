import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_medicent_v3/core/api/api_endpoints.dart';

void main() {
  group('Pruebas Unitarias de ApiEndpoints (TDD)', () {
    test('Las rutas de autenticación deben tener la estructura correcta', () {
      // 1. Arrange (Preparar datos)
      final baseUrl = ApiEndpoints.baseUrl;

      // 2. Act & Assert (Verificar que las URLs apunten a los endpoints del Backend)
      expect(ApiEndpoints.login, equals('$baseUrl/auth/login'));
      expect(ApiEndpoints.registro, equals('$baseUrl/auth/registro'));
      expect(ApiEndpoints.asignarPaciente, equals('$baseUrl/auth/asignar-paciente'));
    });

    test('Las rutas parametrizadas deben inyectar los IDs correctamente', () {
      // 1. Arrange
      const pacienteId = 5;
      const tomaId = 12;

      // 2. Act & Assert
      expect(
        ApiEndpoints.tratamientosPaciente(pacienteId),
        contains('/tratamientos/paciente/5'),
      );
      expect(
        ApiEndpoints.tomasPaciente(pacienteId),
        contains('/tomas/paciente/5'),
      );
      expect(
        ApiEndpoints.marcarToma(tomaId),
        contains('/tomas/12'),
      );
    });
  });
}
