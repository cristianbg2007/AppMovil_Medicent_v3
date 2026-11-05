import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_medicent_v3/features/tomas/services/tomas_service.dart';
import 'package:mobile_medicent_v3/features/tomas/models/toma_model.dart';

void main() {
  group('Pruebas Unitarias de TomasService (TDD)', () {
    late TomasService tomasService;

    setUp(() {
      tomasService = TomasService();
    });

    test('Debe deserializar correctamente una lista de tomas en formato JSON', () {
      // 1. Arrange: Simulamos la lista que responde Flask
      final listaJson = [
        {
          'id': 1,
          'tratamiento_id': 10,
          'medicamento_nombre': 'Paracetamol 500mg',
          'dosis': '1 tableta',
          'fecha_hora_programada': '2026-11-06T08:00:00',
          'estado': 'pendiente',
        },
        {
          'id': 2,
          'tratamiento_id': 10,
          'medicamento_nombre': 'Paracetamol 500mg',
          'dosis': '1 tableta',
          'fecha_hora_programada': '2026-11-06T16:00:00',
          'estado': 'tomada',
        },
      ];

      // 2. Act
      final tomas = tomasService.parsearListaTomas(listaJson);

      // 3. Assert
      expect(tomas.length, equals(2));
      expect(tomas[0].medicamentoNombre, equals('Paracetamol 500mg'));
      expect(tomas[0].estaTomada, isFalse);
      expect(tomas[1].estaTomada, isTrue);
    });
  });
}