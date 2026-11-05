class TratamientoModel {
  final int id;
  final int pacienteId;
  final int medicamentoId;
  final String medicamentoNombre;
  final String dosis;
  final int frecuenciaHoras;
  final String fechaInicio;
  final String fechaFin;
  final String horaInicial;

  TratamientoModel({
    required this.id,
    required this.pacienteId,
    required this.medicamentoId,
    required this.medicamentoNombre,
    required this.dosis,
    required this.frecuenciaHoras,
    required this.fechaInicio,
    required this.fechaFin,
    required this.horaInicial,
  });

  // Deserializar desde JSON del Backend Flask
  factory TratamientoModel.fromJson(Map<String, dynamic> json) {
    return TratamientoModel(
      id: json['id'] != null ? int.tryParse(json['id'].toString()) ?? 0 : 0,
      pacienteId: json['paciente_id'] != null
          ? int.tryParse(json['paciente_id'].toString()) ?? 0
          : 0,
      medicamentoId: json['medicamento_id'] != null
          ? int.tryParse(json['medicamento_id'].toString()) ?? 0
          : 0,
      medicamentoNombre: json['medicamento_nombre'] as String? ?? 'Medicamento',
      dosis: json['dosis'] as String? ?? '',
      frecuenciaHoras: json['frecuencia_horas'] != null
          ? int.tryParse(json['frecuencia_horas'].toString()) ?? 8
          : 8,
      fechaInicio: json['fecha_inicio'] as String? ?? '',
      fechaFin: json['fecha_fin'] as String? ?? '',
      horaInicial: json['hora_inicial'] as String? ?? '08:00:00',
    );
  }

  // Serializar a JSON para enviar en POST /api/tratamientos
  Map<String, dynamic> toJson() {
    return {
      'paciente_id': pacienteId,
      'medicamento_id': medicamentoId,
      'dosis': dosis,
      'frecuencia_horas': frecuenciaHoras,
      'fecha_inicio': fechaInicio,
      'fecha_fin': fechaFin,
      'hora_inicial': horaInicial,
    };
  }
}