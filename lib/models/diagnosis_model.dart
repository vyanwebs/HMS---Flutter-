class DiagnosisModel {
  final String id;
  final List<DiagnosisItem> diagnoses;
  final DateTime? diagnosedAt;

  DiagnosisModel({
    required this.id,
    required this.diagnoses,
    required this.diagnosedAt,
  });

  factory DiagnosisModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return DiagnosisModel.empty();
    }

    return DiagnosisModel(
      id: json['_id']?.toString() ?? '',
      diagnoses: (json['diagnoses'] as List?)
              ?.map((e) => DiagnosisItem.fromJson(e))
              .toList() ??
          [],
      diagnosedAt: json['diagnosedAt'] != null
          ? DateTime.tryParse(json['diagnosedAt'])
          : null,
    );
  }

  factory DiagnosisModel.empty() {
    return DiagnosisModel(
      id: '',
      diagnoses: [],
      diagnosedAt: null,
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

  factory DiagnosisItem.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return DiagnosisItem(id: '', name: '');
    }

    return DiagnosisItem(
      id: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
    );
  }
}