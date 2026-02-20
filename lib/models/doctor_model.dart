class DoctorModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String staffId;
  final bool isAvailableToday;

  DoctorModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.staffId,
    required this.isAvailableToday,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json["_id"],
      name: json["name"],
      email: json["email"],
      phone: json["phone"],
      staffId: json["staffId"],
      isAvailableToday: json["isAvailableToday"] ?? false,
    );
  }
}