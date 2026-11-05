import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_medicent_v3/features/tomas/models/toma_model.dart';

void main() {
  group('Pruebas Unitarias de TomaModel (TDD)', () {
    test('Debe instanciar correctamente una TomaModel desde JSON de Flask', () {
      // 1. Arrange: Datos que devuelve Flask en GET /api/tomas/paciente/<id>
      final jsonFlask = {
        'id': 101,
        'tratamiento_id': 12,
        'medicamento_nombre': 'Ibuprofeno 400mg',
        'dosis': '1 cápsula',
        'fecha_hora_programada': '2026-11-06T08:00:00',
        'fecha_hora_toma': null,
        'estado': 'pendiente',
      };

      // 2. Act
      final toma = TomaModel.fromJson(jsonFlask);

      // 3. Assert: Verificar que los campos se mapeen con exactitud
      expect(toma.id, equals(101));
      expect(toma.tratamientoId, equals(12));
      expect(toma.medicamentoNombre, equals('Ibuprofeno 400mg'));
      expect(toma.dosis, equals('1 cápsula'));
      expect(toma.fechaHoraProgramada, equals(DateTime.parse('2026-11-06T08:00:00')));
      expect(toma.fechaHoraToma, isNull);
      expect(toma.estado, equals('pendiente'));
      expect(toma.estaTomada, isFalse);
    });

    test('Debe detectar correctamente si la toma ya fue tomada', () {
      // 1. Arrange
      final tomaTomada = TomaModel(
        id: 102,
        tratamientoId: 12,
        medicamentoNombre: 'Loratadina 10mg',
        dosis: '1 tableta',
        fechaHoraProgramada: DateTime.now(),
        fechaHoraToma: DateTime.now(),
        estado: 'tomada',
      );

      // 2. Assert
      expect(tomaTomada.estaTomada, isTrue);
    });
  });
}