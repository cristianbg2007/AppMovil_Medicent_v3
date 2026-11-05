import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_medicent_v3/features/medicamentos/services/medicamento_service.dart';

void main() {
  group('Pruebas Unitarias de MedicamentoService (TDD)', () {
    late MedicamentoService medicamentoService;

    setUp(() {
      medicamentoService = MedicamentoService();
    });

    test('Debe deserializar correctamente una lista de medicamentos desde JSON', () {
      // 1. Arrange: Simulamos lo que responde Flask en GET /api/medicamentos
      final listaJson = [
        {
          'id': 1,
          'nombre': 'Losartán 50mg',
          'descripcion': 'Antihipertensivo',
          'forma_farmaceutica': 'Tabletas',
        },
        {
          'id': 2,
          'nombre': 'Amoxicilina 500mg',
          'descripcion': 'Antibiótico',
          'forma_farmaceutica': 'Cápsulas',
        },
      ];

      // 2. Act
      final medicamentos = medicamentoService.parsearListaMedicamentos(listaJson);

      // 3. Assert
      expect(medicamentos.length, equals(2));
      expect(medicamentos[0].nombre, equals('Losartán 50mg'));
      expect(medicamentos[1].formaFarmaceutica, equals('Cápsulas'));
    });
  });
}