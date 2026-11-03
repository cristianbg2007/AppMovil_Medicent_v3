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
  factory UsuarioModel.fromJson(Map<String, dynamic> json) {
    return UsuarioModel(
      id: json['id'] as int,
      nombre: json['nombre'] as String? ?? '',
      correo: json['correo'] as String? ?? '',
      rol: json['rol'] as String? ?? '',
      token: json['token'] as String?,
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