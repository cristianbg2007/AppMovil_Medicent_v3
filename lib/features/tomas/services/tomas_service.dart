import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:mobile_medicent_v3/core/api/api_client.dart';
import 'package:mobile_medicent_v3/core/api/api_endpoints.dart';
import 'package:mobile_medicent_v3/features/auth/services/auth_service.dart';
import 'package:mobile_medicent_v3/features/tomas/models/toma_model.dart';

class TomasService {
  final AuthService _authService;

  TomasService({AuthService? authService})
      : _authService = authService ?? AuthService();

  // Función pura para convertir una lista JSON a lista de objetos TomaModel
  List<TomaModel> parsearListaTomas(List<dynamic> listaJson) {
    return listaJson
        .map((item) => TomaModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  // Consulta el cronograma de tomas del paciente desde Flask: GET /api/tomas/paciente/<id>
  Future<List<TomaModel>> obtenerTomasPaciente(int pacienteId) async {
    try {
      final token = await _authService.obtenerToken();
      final url = ApiEndpoints.tomasPaciente(pacienteId);

      final respuesta = await ApiClient.get(url, token: token);

      if (respuesta.statusCode == 200) {
        final dynamic datos = jsonDecode(respuesta.body);
        if (datos is List) {
          return parsearListaTomas(datos);
        } else if (datos is Map && datos['tomas'] is List) {
          return parsearListaTomas(datos['tomas']);
        }
      }
      return [];
    } catch (e) {
      debugPrint('Error al obtener tomas: $e');
      return [];
    }
  }

  // Marca una toma como realizada en la base de datos: PATCH /api/tomas/<toma_id>
  Future<bool> marcarTomaComoTomada(int tomaId) async {
    try {
      final token = await _authService.obtenerToken();
      final url = ApiEndpoints.marcarToma(tomaId);

      final respuesta = await ApiClient.patch(
        url,
        {'estado': 'tomada'},
        token: token,
      );

      return respuesta.statusCode == 200;
    } catch (e) {
      debugPrint('Error al marcar toma: $e');
      return false;
    }
  }
}