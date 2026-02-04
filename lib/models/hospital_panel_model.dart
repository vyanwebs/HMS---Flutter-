import '../utils/enums.dart';

class HospitalPanel {
  final String title;
  final String image;
  final int totalRegistrations;
  final int rating;
  final UserPanel panel;

  HospitalPanel({
    required this.title,
    required this.image,
    required this.totalRegistrations,
    required this.rating,
    required this.panel,
  });
}