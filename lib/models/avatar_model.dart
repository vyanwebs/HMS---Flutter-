import '../utils/images.dart';

class PatientAvatarModel {
  final String id;
  final String url;
  final String googleDriveLink;

  PatientAvatarModel({
    required this.id,
    required this.url,
    required this.googleDriveLink,
  });

  factory PatientAvatarModel.fromJson(Map<String, dynamic> json) {
    return PatientAvatarModel(
      id: json['_id'] ?? '',
      url: json['url'] ?? '',
      googleDriveLink: json['googleDriveLink'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'url': url,
      'googleDriveLink': googleDriveLink,
    };
  }

  factory PatientAvatarModel.empty() {
    return PatientAvatarModel(
      id: '',
      url: userImage,
      googleDriveLink: userImage,
    );
  }
}
