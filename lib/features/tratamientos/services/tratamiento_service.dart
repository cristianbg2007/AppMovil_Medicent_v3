import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:mobile_medicent_v3/core/api/api_client.dart';
import 'package:mobile_medicent_v3/core/api/api_endpoints.dart';
import 'package:mobile_medicent_v3/features/auth/services/auth_service.dart';
import 'package:mobile_medicent_v3/features/tratamientos/models/tratamiento_model.dart';

class TratamientoService {
  final AuthService _authService;

  TratamientoService({AuthService? authService})
      : _authService = authService ?? AuthService();

  // Función pura para convertir lista JSON a lista de TratamientoModel
  List<TratamientoModel> parsearListaTratamientos(List<dynamic> listaJson) {
    return listaJson
        .map((item) => TratamientoModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  // Consulta los tratamientos del paciente: GET /api/tratamientos/paciente/<id>
  Future<List<TratamientoModel>> obtenerTratamientosPaciente(int pacienteId) async {
    try {
      final token = await _authService.obtenerToken();
      final url = ApiEndpoints.tratamientosPaciente(pacienteId);

      final respuesta = await ApiClient.get(url, token: token);

      if (respuesta.statusCode == 200) {
        final dynamic datos = jsonDecode(respuesta.body);
        if (datos is List) {
          return parsearListaTratamientos(datos);
        } else if (datos is Map && datos['tratamientos'] is List) {
          return parsearListaTratamientos(datos['tratamientos']);
        }
      }
      return [];
    } catch (e) {
      debugPrint('Error al obtener tratamientos: $e');
      return [];
    }
  }

  // Registra un nuevo tratamiento en Flask: POST /api/tratamientos
  Future<bool> crearTratamiento(TratamientoModel tratamiento) async {
    try {
      final token = await _authService.obtenerToken();
      final url = ApiEndpoints.tratamientos;

      final respuesta = await ApiClient.post(
        url,
        tratamiento.toJson(),
        token: token,
      );

      return respuesta.statusCode == 201;
    } catch (e) {
      debugPrint('Error al crear tratamiento: $e');
      return false;
    }
  }
}