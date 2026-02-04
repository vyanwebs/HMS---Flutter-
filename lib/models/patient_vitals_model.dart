class PatientVitalsModel {
  final double pulse;
  final double temperature;
  final double spo2;
  final double respirationRate;
  final double weight;
  final int bpHigh;
  final int bpLow;
  final String notes;
  final DateTime recordedAt;

  PatientVitalsModel({
    required this.pulse,
    required this.temperature,
    required this.spo2,
    required this.respirationRate,
    required this.weight,
    required this.bpHigh,
    required this.bpLow,
    required this.notes,
    required this.recordedAt,
  });

  factory PatientVitalsModel.fromJson(Map<String, dynamic> json) {
    final bp = json['bp'] ?? {};
    return PatientVitalsModel(
      pulse: (json['pulse'] ?? 0).toDouble(),
      temperature: (json['temperature'] ?? 0).toDouble(),
      spo2: (json['spo2'] ?? 0).toDouble(),
      respirationRate: (json['respirationRate'] ?? 0).toDouble(),
      weight: (json['weight'] ?? 0).toDouble(),
      bpHigh: bp['high'] ?? 0,
      bpLow: bp['low'] ?? 0,
      notes: json['notes'] ?? '',
      recordedAt: DateTime.parse(json['recordedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pulse': pulse,
      'temperature': temperature,
      'spo2': spo2,
      'respirationRate': respirationRate,
      'weight': weight,
      'bp': {
        'high': bpHigh,
        'low': bpLow,
      },
      'notes': notes,
      'recordedAt': recordedAt.toIso8601String(),
    };
  }

  factory PatientVitalsModel.empty() {
    return PatientVitalsModel(
      pulse: 0,
      temperature: 0,
      spo2: 0,
      respirationRate: 0,
      weight: 0,
      bpHigh: 0,
      bpLow: 0,
      notes: '',
      recordedAt: DateTime.now(),
    );
  }
}
