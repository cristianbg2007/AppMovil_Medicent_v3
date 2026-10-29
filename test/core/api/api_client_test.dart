import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_medicent_v3/core/api/api_client.dart';

void main() {
  group('Pruebas Unitarias de ApiClient (TDD)', () {
    test('Debe generar encabezados JSON estándar sin token', () {
      // 1. Arrange & Act (Construir encabezados por defecto)
      final headers = ApiClient.headers();

      // 2. Assert (Verificar que envíe JSON)
      expect(headers['Content-Type'], equals('application/json'));
      expect(headers['Accept'], equals('application/json'));
      expect(headers.containsKey('Authorization'), isFalse);
    });

    test('Debe inyectar el encabezado Authorization cuando se proporciona un token JWT', () {
      // 1. Arrange
      const tokenFalso = 'token_jwt_de_prueba_12345';

      // 2. Act
      final headers = ApiClient.headers(token: tokenFalso);

      // 3. Assert (Verificar formato estándar Bearer)
      expect(headers['Authorization'], equals('Bearer $tokenFalso'));
      expect(headers['Content-Type'], equals('application/json'));
    });
  });
}
