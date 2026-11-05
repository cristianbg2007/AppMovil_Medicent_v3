import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile_medicent_v3/features/auth/services/auth_service.dart';
import 'package:mobile_medicent_v3/features/auth/models/usuario_model.dart';

void main() {
  group('Pruebas Unitarias de AuthService (TDD)', () {
    late AuthService authService;
    late FlutterSecureStorage storageMock;

    setUp(() {
      // Configuramos el storage en memoria para no tocar el llavero del sistema
      FlutterSecureStorage.setMockInitialValues({});
      storageMock = const FlutterSecureStorage();
      authService = AuthService(storage: storageMock);
    });

    test('Debe guardar el token y retornar UsuarioModel cuando el login es simulado con éxito', () async {
      // 1. Arrange
      final usuarioEsperado = UsuarioModel(
        id: 1,
        nombre: 'Carlos',
        correo: 'carlos@medicent.com',
        rol: 'paciente',
        token: 'jwt_token_valido_xyz',
      );

      // 2. Act: Guardar sesión
      await authService.guardarSesion(usuarioEsperado);

      // 3. Assert: Verificar que el token quedó guardado en el storage
      final tokenGuardado = await authService.obtenerToken();
      final estaAutenticado = await authService.estaAutenticado();

      expect(tokenGuardado, equals('jwt_token_valido_xyz'));
      expect(estaAutenticado, isTrue);
    });

    test('Debe eliminar el token al cerrar sesión (logout)', () async {
      // 1. Arrange: Simulamos que había un token previo
      await storageMock.write(key: 'jwt_token', value: 'token_antiguo');

      // 2. Act: Cerrar sesión
      await authService.logout();

      // 3. Assert: El token ya no debe existir
      final token = await authService.obtenerToken();
      final estaAutenticado = await authService.estaAutenticado();

      expect(token, isNull);
      expect(estaAutenticado, isFalse);
    });
  });
}