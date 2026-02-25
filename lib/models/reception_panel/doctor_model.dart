class Doctor {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String department;
  final String experience;
  final String staffStatus;
  final String staffId;
  final String? avatarUrl;

  Doctor({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.department,
    required this.experience,
    required this.staffStatus,
    required this.staffId,
    this.avatarUrl,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      department: json['department'] ?? '',
      experience: json['experience'] ?? '0 years',
      staffStatus: json['staffStatus'] ?? 'ACTIVE',
      staffId: json['staffId'] ?? '',
      avatarUrl: json['avatar'] != null ? json['avatar']['url'] : null,
    );
  }
}