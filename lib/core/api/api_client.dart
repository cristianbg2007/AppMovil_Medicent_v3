import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  // Construye los encabezados HTTP inyectando el token JWT si existe
  static Map<String, String> headers({String? token}) {
    final Map<String, String> map = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (token != null && token.isNotEmpty) {
      map['Authorization'] = 'Bearer $token';
    }
    return map;
  }

  // Petición GET
  static Future<http.Response> get(String url, {String? token}) async {
    return await http.get(
      Uri.parse(url),
      headers: headers(token: token),
    );
  }

  // Petición POST
  static Future<http.Response> post(String url, Map<String, dynamic> body, {String? token}) async {
    return await http.post(
      Uri.parse(url),
      headers: headers(token: token),
      body: jsonEncode(body),
    );
  }

  // Petición PATCH
  static Future<http.Response> patch(String url, Map<String, dynamic> body, {String? token}) async {
    return await http.patch(
      Uri.parse(url),
      headers: headers(token: token),
      body: jsonEncode(body),
    );
  }
}
