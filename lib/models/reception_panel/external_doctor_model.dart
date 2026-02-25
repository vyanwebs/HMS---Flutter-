class ExternalDoctor {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String department;
  final String experience;

  ExternalDoctor({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.department,
    required this.experience,
  });

  factory ExternalDoctor.fromJson(Map<String, dynamic> json) {
    return ExternalDoctor(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      department: json['department'] ?? '',
      experience: json['experience'] ?? '0 years',
    );
  }
}