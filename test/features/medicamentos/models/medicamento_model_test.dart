import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_medicent_v3/features/medicamentos/models/medicamento_model.dart';

void main() {
  group('Pruebas Unitarias de MedicamentoModel (TDD)', () {
    test('Debe instanciar correctamente un MedicamentoModel desde JSON de Flask', () {
      // 1. Arrange: JSON que devuelve Flask en GET /api/medicamentos
      final jsonFlask = {
        'id': 1,
        'nombre': 'Losartán 50mg',
        'descripcion': 'Antihipertensivo para control de presión arterial',
        'forma_farmaceutica': 'Tabletas',
      };

      // 2. Act
      final medicamento = MedicamentoModel.fromJson(jsonFlask);

      // 3. Assert
      expect(medicamento.id, equals(1));
      expect(medicamento.nombre, equals('Losartán 50mg'));
      expect(medicamento.descripcion, equals('Antihipertensivo para control de presión arterial'));
      expect(medicamento.formaFarmaceutica, equals('Tabletas'));
    });

    test('Debe soportar descripcion nula sin romperse', () {
      // 1. Arrange
      final jsonSinDesc = {
        'id': 2,
        'nombre': 'Omeprazol 20mg',
        'descripcion': null,
        'forma_farmaceutica': 'Cápsulas',
      };

      // 2. Act
      final medicamento = MedicamentoModel.fromJson(jsonSinDesc);

      // 3. Assert
      expect(medicamento.id, equals(2));
      expect(medicamento.descripcion, equals(''));
    });
  });
}