import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile_medicent_v3/core/api/api_client.dart';
import 'package:mobile_medicent_v3/core/api/api_endpoints.dart';
import 'package:mobile_medicent_v3/features/auth/models/usuario_model.dart';

class AuthService {
  final FlutterSecureStorage _storage;

  // Claves para almacenar en el llavero seguro del dispositivo
  static const String _keyToken = 'jwt_token';
  static const String _keyUsuario = 'usuario_datos';

  AuthService({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  // Guarda el token y los datos del usuario logueado en almacenamiento seguro
  Future<void> guardarSesion(UsuarioModel usuario) async {
    try {
      if (usuario.token != null) {
        await _storage.write(key: _keyToken, value: usuario.token);
      }
      await _storage.write(key: _keyUsuario, value: jsonEncode(usuario.toJson()));
    } catch (e) {
      // En Web Chrome el storage nativo no siempre está disponible, pero permitimos continuar
      print('Aviso storage: $e');
    }
  }

  // Obtiene el token JWT actual
  Future<String?> obtenerToken() async {
    return await _storage.read(key: _keyToken);
  }

  // Verifica si hay una sesión activa con token
  Future<bool> estaAutenticado() async {
    final token = await obtenerToken();
    return token != null && token.isNotEmpty;
  }

  // Iniciar Sesión consumiendo el endpoint POST /api/auth/login de Flask
  Future<UsuarioModel?> login(String correo, String contrasena) async {
    try {
      final respuesta = await ApiClient.post(
        ApiEndpoints.login,
        {
          'correo': correo,
          'contrasena': contrasena,
        },
      );

      if (respuesta.statusCode == 200) {
        final Map<String, dynamic> datos = jsonDecode(respuesta.body);
        print('Respuesta exitosa de Flask: $datos');
        final usuario = UsuarioModel.fromJson(datos, correoFallback: correo);
        print('Usuario parseado -> Nombre: "${usuario.nombre}", Rol: "${usuario.rol}", Correo: "${usuario.correo}"');
        await guardarSesion(usuario);
        return usuario;
      }
      print('Status code no es 200: ${respuesta.statusCode} - ${respuesta.body}');
      return null;
    } catch (e) {
      print('Error en login: $e');
      return null;
    }
  }

  // Registrar un nuevo usuario consumiendo POST /api/auth/registro
  Future<bool> registro({
    required String nombre,
    required String correo,
    required String contrasena,
    required String rol,
  }) async {
    try {
      final respuesta = await ApiClient.post(
        ApiEndpoints.registro,
        {
          'nombre': nombre,
          'correo': correo,
          'contrasena': contrasena,
          'rol': rol,
        },
      );
      return respuesta.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  // Cerrar sesión limpiando el almacenamiento seguro
  Future<void> logout() async {
    await _storage.delete(key: _keyToken);
    await _storage.delete(key: _keyUsuario);
  }
}