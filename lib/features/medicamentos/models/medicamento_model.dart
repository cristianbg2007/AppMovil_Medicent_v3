class MedicamentoModel {
  final int id;
  final String nombre;
  final String descripcion;
  final String formaFarmaceutica;

  MedicamentoModel({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.formaFarmaceutica,
  });

  // Deserializar desde JSON de Flask
  factory MedicamentoModel.fromJson(Map<String, dynamic> json) {
    return MedicamentoModel(
      id: json['id'] != null ? int.tryParse(json['id'].toString()) ?? 0 : 0,
      nombre: json['nombre'] as String? ?? '',
      descripcion: json['descripcion'] as String? ?? '',
      formaFarmaceutica: json['forma_farmaceutica'] as String? ?? '',
    );
  }

  // Serializar a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'forma_farmaceutica': formaFarmaceutica,
    };
  }
}