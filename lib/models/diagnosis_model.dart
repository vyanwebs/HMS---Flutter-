class DiagnosisModel {
  final String id;
  final List<DiagnosisItem> diagnoses;
  final DateTime diagnosedAt;

  DiagnosisModel({
    required this.id,
    required this.diagnoses,
    required this.diagnosedAt,
  });

  factory DiagnosisModel.fromJson(Map<String, dynamic> json) {
    return DiagnosisModel(
      id: json['_id'],
      diagnoses: (json['diagnoses'] as List)
          .map((e) => DiagnosisItem.fromJson(e))
          .toList(),
      diagnosedAt: DateTime.parse(json['diagnosedAt']),
    );
  }
}

class DiagnosisItem {
  final String id;
  final String name;

  DiagnosisItem({
    required this.id,
    required this.name,
  });

  factory DiagnosisItem.fromJson(Map<String, dynamic> json) {
    return DiagnosisItem(
      id: json['_id'],
      name: json['name'],
    );
  }
}
