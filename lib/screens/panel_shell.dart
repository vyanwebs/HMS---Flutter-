import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/panel_navigation_controller.dart';
import '../utils/enums.dart';
import 'admin/admin_dashboard.dart';
import 'doctor/doctor_dashboard.dart';
import 'laboratory/lab_dashboard.dart';
import 'nurse/nurse_dashboard.dart';
import 'patient/patient_dashboard.dart';
import 'pharmacy/pharmacy_dashboard.dart';
import 'reception/reception_dashboard.dart';

class PanelShell extends StatelessWidget {
  PanelShell({super.key});

  final navController = Get.find<PanelNavigationController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final panel = navController.activePanel.value;

      if (panel == null) {
        return const Scaffold(
          body: Center(child: Text('No panel selected')),
        );
      }

      switch (panel) {
        case UserPanel.doctor:
          return const DoctorDashboard();
        case UserPanel.reception:
          return const ReceptionDashboard();
        case UserPanel.nurse:
          return const NurseDashboard();
        case UserPanel.pharmacy:
          return const PharmacyDashboard();
        case UserPanel.laboratory:
          return const LabDashboard();
        case UserPanel.admin:
          return const AdminDashboard();
        case UserPanel.patient:
          return const PatientDashboard();
        default:
          return const Scaffold(
            body: Center(child: Text('Panel not implemented')),
          );
      }
    });
  }
}
