import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class ApiEndpoints {
  // Configuración de la URL base según la plataforma
  static String get baseUrl {
    if (kIsWeb) {
      // En navegador Web (Chrome)
      return 'http://127.0.0.1:5000/api';
    } else if (Platform.isAndroid) {
      // En emulador Android oficial
      return 'http://10.0.2.2:5000/api';
    } else {
      // En simulador iOS o Windows desktop
      return 'http://127.0.0.1:5000/api';
    }
  }

  // 1. Verificación de salud del Backend
  static String get estado => '$baseUrl/estado';
  static String get estadoDb => '$baseUrl/estado-db';

  // 2. Módulo de Autenticación
  static String get login => '$baseUrl/auth/login';
  static String get registro => '$baseUrl/auth/registro';
  static String get asignarPaciente => '$baseUrl/auth/asignar-paciente';

  // 3. Módulo de Medicamentos
  static String get medicamentos => '$baseUrl/medicamentos';

  // 4. Módulo de Tratamientos
  static String get tratamientos => '$baseUrl/tratamientos';
  static String tratamientosPaciente(int pacienteId) => '$baseUrl/tratamientos/paciente/$pacienteId';

  // 5. Módulo de Tomas
  static String get tomas => '$baseUrl/tomas';
  static String tomasPaciente(int pacienteId) => '$baseUrl/tomas/paciente/$pacienteId';
  static String marcarToma(int tomaId) => '$baseUrl/tomas/$tomaId';
}
