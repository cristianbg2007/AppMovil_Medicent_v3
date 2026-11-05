import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:mobile_medicent_v3/core/api/api_client.dart';
import 'package:mobile_medicent_v3/core/api/api_endpoints.dart';
import 'package:mobile_medicent_v3/features/auth/services/auth_service.dart';
import 'package:mobile_medicent_v3/features/medicamentos/models/medicamento_model.dart';

class MedicamentoService {
  final AuthService _authService;

  MedicamentoService({AuthService? authService})
      : _authService = authService ?? AuthService();

  // Función pura para convertir una lista JSON a lista de objetos MedicamentoModel
  List<MedicamentoModel> parsearListaMedicamentos(List<dynamic> listaJson) {
    return listaJson
        .map((item) => MedicamentoModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  // Consulta el catálogo de medicamentos desde Flask: GET /api/medicamentos
  Future<List<MedicamentoModel>> obtenerMedicamentos() async {
    try {
      final token = await _authService.obtenerToken();
      final url = ApiEndpoints.medicamentos;

      final respuesta = await ApiClient.get(url, token: token);

      if (respuesta.statusCode == 200) {
        final dynamic datos = jsonDecode(respuesta.body);
        if (datos is List) {
          return parsearListaMedicamentos(datos);
        } else if (datos is Map && datos['medicamentos'] is List) {
          return parsearListaMedicamentos(datos['medicamentos']);
        }
      }
      return [];
    } catch (e) {
      debugPrint('Error al obtener medicamentos: $e');
      return [];
    }
  }
}