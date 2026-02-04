import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/doctor_dashboard_controllers.dart';
import '../../controllers/panel_navigation_controller.dart';
import '../../helper_resposive_class/responsive_layout.dart';
import '../../models/patient_model.dart';
import '../../screens/doctor/patient_details.dart';
import '../../utils/date_formatter.dart';
import '../../utils/enums.dart';
import '../../utils/text.dart';

class ScheduleView extends StatelessWidget {
  ScheduleView({super.key});

  final doctorDashboardControllers = Get.find<DoctorDashboardControllers>();
  final navController = Get.find<PanelNavigationController>();

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: desktopView(),
      tablet: desktopView(),
      desktop: desktopView(),
    );
  }

  Widget desktopView() {
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
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 300),
            child: Column(
              children: [
                _header(),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView(
                    children: doctorDashboardControllers.schedules.map((item) => _scheduleItem(item, constraints)).toList(),
                  ),
                ),
              ],
            ),
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
            "Today's Schedule",
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

  // ================= ITEM =================

  Widget _scheduleItem(
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
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              _avatar(item.image, isMobile),
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
                      item.currentAdmissionType,
                      fontSize: 12,
                      color: const Color(0xFF718096),
                    ),
                  ],
                ),
              ),
      
              // ================= RIGHT =================
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AppText(
                    timeFromDateTime(item.registeredAt),
                    fontSize: 12,
                    color: const Color(0xFF718096),
                  ),
                  const SizedBox(height: 4),
                  _statusBadge(item.currentAdmissionStatus),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= AVATAR =================

  Widget _avatar(String image, bool isMobile) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFF718096)),
        image: DecorationImage(
          image: AssetImage(image),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  // ================= STATUS BADGE =================

  Widget _statusBadge(String status) {
    final color = _statusColor(status);

    return Container(
      constraints: const BoxConstraints(minWidth: 70),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: AppText(
        status,
        textAlign: TextAlign.center,
        fontSize: 11,
        color: color,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return const Color(0xFF48BB78);
      case 'pending':
        return const Color(0xFFED8936);
      case 'cancelled':
        return const Color(0xFFF56565);
      default:
        return const Color(0xFF718096);
    }
  }
}
