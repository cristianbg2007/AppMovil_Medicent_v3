class TomaModel {
  final int id;
  final int tratamientoId;
  final String medicamentoNombre;
  final String dosis;
  final DateTime fechaHoraProgramada;
  final DateTime? fechaHoraToma;
  final String estado; // 'pendiente', 'tomada', 'omitida', 'retrasada'

  TomaModel({
    required this.id,
    required this.tratamientoId,
    required this.medicamentoNombre,
    required this.dosis,
    required this.fechaHoraProgramada,
    this.fechaHoraToma,
    required this.estado,
  });

  // Getter auxiliar de conveniencia
  bool get estaTomada => estado.toLowerCase() == 'tomada';

  // Deserializar desde el JSON del Backend Flask
  factory TomaModel.fromJson(Map<String, dynamic> json) {
    return TomaModel(
      id: json['id'] != null ? int.tryParse(json['id'].toString()) ?? 0 : 0,
      tratamientoId: json['tratamiento_id'] != null
          ? int.tryParse(json['tratamiento_id'].toString()) ?? 0
          : 0,
      medicamentoNombre: json['medicamento_nombre'] as String? ?? 'Medicamento',
      dosis: json['dosis'] as String? ?? '',
      fechaHoraProgramada: json['fecha_hora_programada'] != null
          ? DateTime.tryParse(json['fecha_hora_programada'].toString()) ?? DateTime.now()
          : DateTime.now(),
      fechaHoraToma: json['fecha_hora_toma'] != null
          ? DateTime.tryParse(json['fecha_hora_toma'].toString())
          : null,
      estado: json['estado'] as String? ?? 'pendiente',
    );
  }

  // Serializar a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tratamiento_id': tratamientoId,
      'medicamento_nombre': medicamentoNombre,
      'dosis': dosis,
      'fecha_hora_programada': fechaHoraProgramada.toIso8601String(),
      'fecha_hora_toma': fechaHoraToma?.toIso8601String(),
      'estado': estado,
    };
  }

  // Permite clonar la toma actualizando solo el estado al marcarla como tomada
  TomaModel copyWith({
    String? estado,
    DateTime? fechaHoraToma,
  }) {
    return TomaModel(
      id: id,
      tratamientoId: tratamientoId,
      medicamentoNombre: medicamentoNombre,
      dosis: dosis,
      fechaHoraProgramada: fechaHoraProgramada,
      fechaHoraToma: fechaHoraToma ?? this.fechaHoraToma,
      estado: estado ?? this.estado,
    );
  }
}