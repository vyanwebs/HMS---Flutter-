import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/doctor_dashboard_controllers.dart';
import '../../helper_resposive_class/responsive_layout.dart';
import '../../models/teleconsultation_queue_model.dart';
import '../../utils/buttons.dart';
import '../../utils/constants.dart';
import '../../utils/images.dart';
import '../../utils/text.dart';

class TeleconsultationView extends StatelessWidget {
  TeleconsultationView({super.key});

  final doctorDashboardControllers = Get.find<DoctorDashboardControllers>();

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _header(constraints),
              const SizedBox(height: 16),
              _queueList(constraints),
            ],
          ),
        );
      },
    );
  }

  // ================= HEADER =================

  Widget _header(BoxConstraints constraints) {

    return const AppText(
      'Teleconsultation Queue',
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Color(0xFF2D3748),
    );
  }

  // ================= LIST =================

  Widget _queueList(BoxConstraints constraints) {

    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 200),
      child: Obx(
        () => ListView.builder(
          itemCount: doctorDashboardControllers.queue.length,
          itemBuilder: (_, index) {
            return _queueItem(
              doctorDashboardControllers.queue[index],
              constraints,
            );
          },
        ),
      ),
    );
  }

  // ================= ITEM =================

  Widget _queueItem(
    TeleconsultationQueueModel item,
    BoxConstraints constraints,
  ) {
    bool isMobile = constraints.maxWidth < 450;

    return GestureDetector(
      onTap: () => {},
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          children: [
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    item.patientName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    fontSize: isMobile ? 13 : 14,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF2D3748),
                  ),
                  const SizedBox(height: 2),
                  AppText(
                    item.waitingTime,
                    fontSize: 12,
                    color: const Color(0xFF718096),
                  ),
                ],
              ),
            ),
            AppButton(
              onPressed: () {},
              text: "Join",
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
              borderRadius: 5,
              backgroundColor: Colors.green,
            )
          ],
        ),
      ),
    );
  }
}