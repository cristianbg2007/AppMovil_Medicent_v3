import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:mobile_medicent_v3/core/api/api_client.dart';
import 'package:mobile_medicent_v3/core/api/api_endpoints.dart';
import 'package:mobile_medicent_v3/features/auth/models/usuario_model.dart';
import 'package:mobile_medicent_v3/features/auth/services/auth_service.dart';

class CuidadorService {
  final AuthService _authService;

  CuidadorService({AuthService? authService})
      : _authService = authService ?? AuthService();

  // Convierte lista JSON en lista de UsuarioModel
  List<UsuarioModel> parsearPacientes(List<dynamic> listaJson) {
    return listaJson
        .map((item) => UsuarioModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  // Asigna un paciente a un cuidador en Flask: POST /api/auth/asignar-paciente
  Future<bool> asignarPaciente({required int cuidadorId, required int pacienteId}) async {
    try {
      final token = await _authService.obtenerToken();
      final respuesta = await ApiClient.post(
        ApiEndpoints.asignarPaciente,
        {
          'cuidador_id': cuidadorId,
          'paciente_id': pacienteId,
        },
        token: token,
      );
      return respuesta.statusCode == 201;
    } catch (e) {
      debugPrint('Error al asignar paciente: $e');
      return false;
    }
  }
}