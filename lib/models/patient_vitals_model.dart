class PatientVitalsModel {
  final String id;
  final double pulse;
  final double temperature;
  final double spo2;
  final double respirationRate;
  final double weight;
  final String bp;
  final String notes;
  final String bloodSugarLevel;
  final DateTime recordedAt;

  PatientVitalsModel({
    required this.id,
    required this.pulse,
    required this.temperature,
    required this.spo2,
    required this.respirationRate,
    required this.weight,
    required this.bp,
    required this.notes,
    required this.bloodSugarLevel,
    required this.recordedAt,
  });

  /// 🔒 SAFE PARSERS (private helpers)
  static double _toDouble(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0;
  }

  static String _toString(dynamic value) {
    if (value == null) return '';
    return value.toString();
  }

  static DateTime _toDate(dynamic value) {
    if (value == null) return DateTime.now();
    try {
      return DateTime.parse(value.toString());
    } catch (_) {
      return DateTime.now();
    }
  }

  /// ✅ SAFE fromJson (no crashes)
  factory PatientVitalsModel.fromJson(Map<String, dynamic> json) {
    return PatientVitalsModel(
      id: _toString(json['_id']),
      pulse: _toDouble(json['pulse']),
      temperature: _toDouble(json['temperature']),
      spo2: _toDouble(json['spo2']),
      respirationRate: _toDouble(json['respirationRate']),
      weight: _toDouble(json['weight']),
      bp: _toString(json['bp']),
      notes: _toString(json['notes']),
      bloodSugarLevel: _toString(json['bloodSugarLevel']),
      recordedAt: _toDate(json['recordedAt']),
    );
  }

  /// unchanged – safe to use everywhere
  Map<String, dynamic> toJson() {
    return {
      'pulse': pulse,
      'temperature': temperature,
      'spo2': spo2,
      'respirationRate': respirationRate,
      'weight': weight,
      'bp': bp,
      'notes': notes,
      'bloodSugarLevel': bloodSugarLevel,
      'recordedAt': recordedAt.toIso8601String(),
    };
  }

  /// fallback instance (keeps old usage intact)
  factory PatientVitalsModel.empty() {
    return PatientVitalsModel(
      id: '',
      pulse: 0,
      temperature: 0,
      spo2: 0,
      respirationRate: 0,
      weight: 0,
      bp: '',
      notes: '',
      bloodSugarLevel: '',
      recordedAt: DateTime.now(),
    );
  }
}
