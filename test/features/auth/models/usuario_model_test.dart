import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_medicent_v3/features/auth/models/usuario_model.dart';

void main() {
  group('Pruebas Unitarias de UsuarioModel (TDD)', () {
    test('Debe instanciar correctamente un UsuarioModel desde JSON con token', () {
      // 1. Arrange (Datos simulados que devuelve el backend Flask en /api/auth/login)
      final jsonBackend = {
        'id': 1,
        'nombre': 'Carlos',
        'correo': 'carlos@medicent.com',
        'rol': 'paciente',
        'token': 'jwt_simulado_12345'
      };

      // 2. Act
      final usuario = UsuarioModel.fromJson(jsonBackend);

      // 3. Assert
      expect(usuario.id, equals(1));
      expect(usuario.nombre, equals('Carlos'));
      expect(usuario.correo, equals('carlos@medicent.com'));
      expect(usuario.rol, equals('paciente'));
      expect(usuario.token, equals('jwt_simulado_12345'));
    });

    test('Debe serializar UsuarioModel a JSON correctamente', () {
      // 1. Arrange
      final usuario = UsuarioModel(
        id: 2,
        nombre: 'Dra. Maria',
        correo: 'maria@medicent.com',
        rol: 'cuidador',
      );

      // 2. Act
      final jsonResult = usuario.toJson();

      // 3. Assert
      expect(jsonResult['id'], equals(2));
      expect(jsonResult['nombre'], equals('Dra. Maria'));
      expect(jsonResult['correo'], equals('maria@medicent.com'));
      expect(jsonResult['rol'], equals('cuidador'));
      expect(jsonResult.containsKey('token'), isFalse);
    });
  });
}