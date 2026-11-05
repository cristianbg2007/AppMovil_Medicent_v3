import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_medicent_v3/features/tratamientos/models/tratamiento_model.dart';

void main() {
  group('Pruebas Unitarias de TratamientoModel (TDD)', () {
    test('Debe instanciar correctamente un TratamientoModel desde JSON de Flask', () {
      // 1. Arrange: JSON que responde Flask en GET /api/tratamientos/paciente/<id>
      final jsonFlask = {
        'id': 10,
        'paciente_id': 1,
        'medicamento_id': 2,
        'medicamento_nombre': 'Amoxicilina 500mg',
        'dosis': '1 cápsula',
        'frecuencia_horas': 8,
        'fecha_inicio': '2026-11-06',
        'fecha_fin': '2026-11-12',
        'hora_inicial': '08:00:00',
      };

      // 2. Act
      final tratamiento = TratamientoModel.fromJson(jsonFlask);

      // 3. Assert
      expect(tratamiento.id, equals(10));
      expect(tratamiento.pacienteId, equals(1));
      expect(tratamiento.medicamentoId, equals(2));
      expect(tratamiento.medicamentoNombre, equals('Amoxicilina 500mg'));
      expect(tratamiento.dosis, equals('1 cápsula'));
      expect(tratamiento.frecuenciaHoras, equals(8));
      expect(tratamiento.fechaInicio, equals('2026-11-06'));
      expect(tratamiento.fechaFin, equals('2026-11-12'));
      expect(tratamiento.horaInicial, equals('08:00:00'));
    });

    test('Debe serializar TratamientoModel a JSON para POST /api/tratamientos', () {
      // 1. Arrange
      final nuevoTratamiento = TratamientoModel(
        id: 0,
        pacienteId: 1,
        medicamentoId: 2,
        medicamentoNombre: 'Amoxicilina 500mg',
        dosis: '1 cápsula',
        frecuenciaHoras: 8,
        fechaInicio: '2026-11-06',
        fechaFin: '2026-11-12',
        horaInicial: '08:00:00',
      );

      // 2. Act
      final jsonResult = nuevoTratamiento.toJson();

      // 3. Assert
      expect(jsonResult['paciente_id'], equals(1));
      expect(jsonResult['medicamento_id'], equals(2));
      expect(jsonResult['frecuencia_horas'], equals(8));
      expect(jsonResult['hora_inicial'], equals('08:00:00'));
    });
  });
}
