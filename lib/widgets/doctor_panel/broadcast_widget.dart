import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/Doctor/doctor_dashboard_controllers.dart';
import '../../controllers/panel_navigation_controller.dart';
import '../../helper_resposive_class/responsive_layout.dart';
import '../../models/broadcast_model.dart';
import '../../utils/enums.dart';
import '../../utils/text.dart';

class BroadcastView extends StatelessWidget {
  BroadcastView({super.key});

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

  // =================Desktop View ============

  Widget desktopView() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
          const SizedBox(height: 16),
          _broadcastList(),
        ],
      ),
    );
  }

  // ================= HEADER =================

  Widget _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Expanded(
          child: AppText(
            'Broadcasting',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3748),
          ),
        ),
        TextButton(
          onPressed:() => navController.changeMenu(DoctorPanelMenu.broadcasting),
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

  Widget _broadcastList() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 300),
      child: Obx(
        () => SingleChildScrollView(
          child: Column(
            children: doctorDashboardControllers.broadcasts.map((item) => _broadcastItem(item)).toList(),
          ),
        ),
      ),
    );
  }

  // ================= ITEM =================

  Widget _broadcastItem(BroadcastModel item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          _imageBox(item),
          const SizedBox(width: 12),
          Expanded(
            child: AppText(
              item.title,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF2D3748),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Icon(Icons.campaign, color: Colors.white, size: 16,),
          )
        ],
      ),
    );
  }

  // ================= IMAGE / ICON =================

  Widget _imageBox(BroadcastModel item) {
    return SizedBox(
      width: 50,
      height: 50,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          'assets/images/${item.imageName}',
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) {
            return Container(
              decoration: BoxDecoration(
                color: const Color(0xFF2383E2).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                item.fallbackIcon,
                color: const Color(0xFF2383E2),
                size: 20,
              ),
            );
          },
        ),
      ),
    );
  }
}
