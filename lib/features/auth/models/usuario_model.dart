class UsuarioModel {
  final int id;
  final String nombre;
  final String correo;
  final String rol;
  final String? token;

  UsuarioModel({
    required this.id,
    required this.nombre,
    required this.correo,
    required this.rol,
    this.token,
  });

  // Traduce la respuesta JSON de Flask a un objeto de Flutter
  factory UsuarioModel.fromJson(Map<String, dynamic> json, {String? correoFallback}) {
    // Flask puede devolver el usuario anidado en 'usuario' o directamente en la raíz
    final Map<String, dynamic> data = (json['usuario'] is Map<String, dynamic>)
        ? json['usuario'] as Map<String, dynamic>
        : json;

    return UsuarioModel(
      id: data['id'] != null ? int.tryParse(data['id'].toString()) ?? 0 : 0,
      nombre: data['nombre'] as String? ?? '',
      correo: (data['correo'] as String?) ?? (correoFallback ?? ''),
      rol: (data['rol'] as String?)?.toLowerCase().trim() ?? '',
      token: (json['token'] ?? data['token']) as String?,
    );
  }

  // Serializar a JSON para enviar o almacenar localmente
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'correo': correo,
      'rol': rol,
      if (token != null) 'token': token,
    };
  }
}