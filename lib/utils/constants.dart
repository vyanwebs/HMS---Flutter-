import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = 'DocNex.care HMS';
  static const String appTagline = 'A system that never sleeps, 24x7 available';
  static const String appVersion = 'v4.1 | HIPAA Compliant';

  static const double cardRadius = 12.0;
  static const double buttonRadius = 8.0;
}

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF2383E2); // Updated to match doctor color
  static const Color secondary = Color(0xFFED8936);
  static const Color background = Color(0xFFF7FAFC);
  static const Color cardBackground = Colors.white;
  static const Color border = Color(0xFFE2E8F0);
  static const Color solitude = Color(0xffEAF8FF);
  static const Color sushi = Color(0xff7EA839);

  // Text Colors
  static const Color textPrimary = Color(0xFF2D3748);
  static const Color textSecondary = Color(0xFF718096);
  static const Color textTertiary = Color(0xFFA0AEC0);
  static const Color greyText = Color(0xFF676767);

  // Status Colors
  static const Color success = Color(0xFF38A169);
  static const Color warning = Color(0xFFED8936);
  static const Color error = Color(0xFFF56565);
  static const Color info = Color(0xFF4299E1);

  // Module Colors
  static const Color externalDoctor = Color(0xFF1A365D);
  static const Color reception = Color(0xFF276749);
  static const Color doctor = Color(0xFF2383E2); // Updated to #2383E2
  static const Color nurses = Color(0xFFD69E2E);
  static const Color pharmacy = Color(0xFFC53030);
  static const Color laboratory = Color(0xFF319795);
  static const Color insurance = Color(0xFF805AD5);
  static const Color diagnostics = Color(0xFFDD6B20);
  static const Color dialysis = Color(0xFF3182CE);
  static const Color patient = Color(0xFF38A169);
  static const Color admin = Color(0xFF4A5568);
}

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String mainDashboard = '/mainDashboard';
  static const String doctorDashboard = '/doctorDashboard';
  static const String receptionDashboard = '/receptionDashboard';
  static const String opdIpdAppointments = '/doctor/opdIpdAppointments';
  static const String ePrescriptions = '/doctor/ePrescriptions';
  static const String patientHistory = '/doctor/patientHistory';
  static const String labTestRequest = '/doctor/labTestRequest';
  static const String telecommunication = '/doctor/telecommunication';
  static const String ipdManagement = '/doctor/ipdManagement';
  static const String dischargeSummary = '/doctor/dischargeSummary';
  static const String doctorSettings = '/doctor/settings';
}