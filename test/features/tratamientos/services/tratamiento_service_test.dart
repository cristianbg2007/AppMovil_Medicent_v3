import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_medicent_v3/features/tratamientos/services/tratamiento_service.dart';

void main() {
  group('Pruebas Unitarias de TratamientoService (TDD)', () {
    late TratamientoService tratamientoService;

    setUp(() {
      tratamientoService = TratamientoService();
    });

    test('Debe deserializar correctamente una lista de tratamientos desde JSON', () {
      // 1. Arrange: Simulamos la respuesta de Flask en GET /api/tratamientos/paciente/<id>
      final listaJson = [
        {
          'id': 10,
          'paciente_id': 1,
          'medicamento_id': 2,
          'medicamento_nombre': 'Amoxicilina 500mg',
          'dosis': '1 cápsula',
          'frecuencia_horas': 8,
          'fecha_inicio': '2026-11-06',
          'fecha_fin': '2026-11-12',
          'hora_inicial': '08:00:00',
        },
      ];

      // 2. Act
      final tratamientos = tratamientoService.parsearListaTratamientos(listaJson);

      // 3. Assert
      expect(tratamientos.length, equals(1));
      expect(tratamientos[0].medicamentoNombre, equals('Amoxicilina 500mg'));
      expect(tratamientos[0].frecuenciaHoras, equals(8));
    });
  });
}
