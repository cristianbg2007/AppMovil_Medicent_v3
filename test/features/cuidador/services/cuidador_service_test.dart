import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_medicent_v3/features/cuidador/services/cuidador_service.dart';

void main() {
  group('Pruebas Unitarias de CuidadorService (TDD)', () {
    late CuidadorService cuidadorService;

    setUp(() {
      cuidadorService = CuidadorService();
    });

    test('Debe deserializar correctamente una lista de pacientes asignados', () {
      // 1. Arrange: Lista simulada de pacientes a cargo
      final listaJson = [
        {
          'id': 1,
          'nombre': 'Carlos Paciente Pérez',
          'correo': 'carlos@medicent.com',
          'rol': 'paciente',
        },
        {
          'id': 2,
          'nombre': 'María Paciente López',
          'correo': 'maria@medicent.com',
          'rol': 'paciente',
        },
      ];

      // 2. Act
      final pacientes = cuidadorService.parsearPacientes(listaJson);

      // 3. Assert
      expect(pacientes.length, equals(2));
      expect(pacientes[0].nombre, equals('Carlos Paciente Pérez'));
      expect(pacientes[1].nombre, equals('María Paciente López'));
      expect(pacientes[0].rol, equals('paciente'));
    });
  });
}