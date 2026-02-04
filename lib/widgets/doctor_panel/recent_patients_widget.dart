import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/doctor_dashboard_controllers.dart';
import '../../controllers/panel_navigation_controller.dart';
import '../../models/recent_patient_model.dart';
import '../../models/patient_model.dart';
import '../../screens/doctor/patient_details.dart';
import '../../utils/constants.dart';
import '../../utils/enums.dart';
import '../../utils/images.dart';
import '../../utils/text.dart';

class RecentPatientsView extends StatelessWidget {
  RecentPatientsView({super.key});

  final doctorDashboardControllers = Get.find<DoctorDashboardControllers>();
  final navController = Get.find<PanelNavigationController>();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(constraints.maxWidth < 450 ? 14 : 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _header(),
              const SizedBox(height: 12),
              _patientsList(constraints),
            ],
          ),
        );
      },
    );
  }

  // ================= HEADER =================

  Widget _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Expanded(
          child: AppText(
            'Recent Patients',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3748),
          ),
        ),
        TextButton(
          onPressed:() => navController.changeMenu(DoctorPanelMenu.assignedPatients),
          child: const AppText(
            'View All',
            fontSize: 14,
            color: Color(0xFF2383E2),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // ================= LIST =================

  Widget _patientsList(BoxConstraints constraints) {
    double maxHeight;

    if (constraints.maxWidth < 450) {
      maxHeight = 160;
    } else if (constraints.maxWidth < 900) {
      maxHeight = 200;
    } else {
      maxHeight = 240;
    }

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: Obx(
        () => ListView.builder(
          itemCount: doctorDashboardControllers.patients.length,
          itemBuilder: (_, index) {
            return _patientItem(
              doctorDashboardControllers.patients[index],
              constraints,
            );
          },
        ),
      ),
    );
  }

  // ================= ITEM =================

  Widget _patientItem(
    PatientModel item,
    BoxConstraints constraints,
  ) {
    bool isMobile = constraints.maxWidth < 450;

    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: () {
          navController.rememberCurrentMenu();
          Get.to(() => PatientDetails(patient: item));
        },
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // _patientAvatar(item, isMobile),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.greyText),
                  image: const DecorationImage(
                    image: AssetImage(userImage),
                    fit: BoxFit.cover
                  )
                ),
              ),
              const SizedBox(width: 12),
      
              // ================= LEFT =================
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      item.name,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF2D3748),
                    ),
                    const SizedBox(height: 4),
                    AppText(
                      item.admissionReason,
                      fontSize: 12,
                      color: const Color(0xFF718096),
                    ),
                    const SizedBox(height: 2),
                    AppText(
                      item.timeAgo,
                      fontSize: 12,
                      color: const Color(0xFF718096),
                    ),
                  ],
                ),
              ),
      
              // ================= STATUS =================
              _statusBadge(item.currentHealthCondition ?? "N/A"),
            ],
          ),
        ),
      ),
    );
  }

  // ================= AVATAR =================

  // Widget _patientAvatar(RecentPatientModel patient, bool isMobile) {
  //   final size = isMobile ? 36.0 : 40.0;

  //   return Container(
  //     width: size,
  //     height: size,
  //     decoration: BoxDecoration(
  //       shape: BoxShape.circle,
  //       border: Border.all(color: const Color(0xFFCBD5E0)),
  //       color: const Color(0xFFE2E8F0),
  //     ),
  //     child: ClipOval(
  //       child: patient.avatar!.googleDriveLink != null
  //           ? Image.network(
  //               patient.avatar!.googleDriveLink ?? "",
  //               fit: BoxFit.cover,
  //               errorBuilder: (_, __, ___) =>
  //                   _initialsAvatar(patient, size),
  //             )
  //           : _initialsAvatar(patient, size),
  //     ),
  //   );
  // }

  Widget _initialsAvatar(PatientModel patient, double size) {
    return Container(
      color: const Color(0xFF2383E2),
      alignment: Alignment.center,
      child: Text(
        patient.initials,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: size * 0.45,
        ),
      ),
    );
  }

  // ================= STATUS BADGE =================

  Widget _statusBadge(String status) {
    final statusConfig = _healthStatusConfig(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: statusConfig.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        statusConfig.label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: statusConfig.color,
        ),
      ),
    );
  }

  HealthStatusConfig _healthStatusConfig(String status) {
    switch (status.toLowerCase()) {
      case 'critical':
        return const HealthStatusConfig(
          label: 'Critical',
          color: Color(0xFFE53E3E), // Red
        );

      case 'serious':
        return const HealthStatusConfig(
          label: 'Serious',
          color: Color(0xFFDD6B20), // Orange
        );

      case 'moderate':
        return const HealthStatusConfig(
          label: 'Moderate',
          color: Color(0xFFD69E2E), // Yellow
        );

      case 'mild':
        return const HealthStatusConfig(
          label: 'Mild',
          color: Color(0xFF3182CE), // Blue
        );

      case 'stable':
      default:
        return const HealthStatusConfig(
          label: 'Stable',
          color: Color(0xFF38A169), // Green
        );
    }
  }
}

class HealthStatusConfig {
  final String label;
  final Color color;

  const HealthStatusConfig({
    required this.label,
    required this.color,
  });
}
