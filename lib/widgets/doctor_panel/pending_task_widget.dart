import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/Doctor/doctor_dashboard_controllers.dart';
import '../../helper_resposive_class/responsive_layout.dart';
import '../../models/pending_task_model.dart';
import '../../utils/text.dart';

class PendingTasksView extends StatelessWidget {
  PendingTasksView({super.key});

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
      builder: (context, constraints) => Container(
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
            _header(constraints),
            const SizedBox(height: 16),
            _taskList(constraints),
          ],
        ),
      ),
    );
  }

  // ================= HEADER =================

  Widget _header(BoxConstraints constraints) {
    bool isMobile = constraints.maxWidth < 450;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const AppText(
          'Pending Tasks',
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF2D3748),
        ),
        Obx(
          () => TweenAnimationBuilder<double>(
            tween: Tween<double>(
              begin: 0,
              end: doctorDashboardControllers.isTasksLoading.value ? 1 : 0,
            ),
            duration: const Duration(seconds: 1),
            curve: Curves.linear,
            builder: (context, value, child) {
              return Transform.rotate(
                angle: value * 6.28,
                child: IconButton(
                  onPressed: doctorDashboardControllers.isTasksLoading.value
                    ? null
                    : () => doctorDashboardControllers.fetchPendingTasks(),
                  icon: const Icon(Icons.autorenew, size: 20),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ================= LIST =================

  Widget _taskList(BoxConstraints constraints) {
    double maxHeight;

    if (constraints.maxWidth < 450) {
      maxHeight = 140;
    } else if (constraints.maxWidth < 900) {
      maxHeight = 170;
    } else {
      maxHeight = 220;
    }

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: Obx(
        () => ListView.builder(
          itemCount: doctorDashboardControllers.tasks.length,
          itemBuilder: (_, index) {
            return _taskItem(
              doctorDashboardControllers.tasks[index],
              constraints,
            );
          },
        ),
      ),
    );
  }

  // ================= ITEM =================

  Widget _taskItem(PendingTaskModel item, BoxConstraints constraints) {
    bool isMobile = constraints.maxWidth < 450;

    final Color priorityColor = _priorityColor(item.priority);

    return GestureDetector(
      onTap: () => () {},
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    item.title,
                    maxLines: isMobile ? 2 : 1,
                    overflow: TextOverflow.ellipsis,
                    fontSize: isMobile ? 12 : 13,
                    color: const Color(0xFF2D3748),
                  ),
                  const SizedBox(height: 4),
                  AppText(
                    item.timeAgo,
                    fontSize: 11,
                    color: const Color(0xFF718096),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            _priorityBadge(item.priority, priorityColor),
          ],
        ),
      ),
    );
  }

  // ================= PRIORITY BADGE =================

  Widget _priorityBadge(String text, Color color) {
    return Container(
      constraints: const BoxConstraints(minWidth: 60),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: AppText(
        text,
        textAlign: TextAlign.center,
        fontSize: 11,
        color: color,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  // ================= HELPERS =================

  Color _priorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return const Color(0xFFF56565);
      case 'medium':
        return const Color(0xFFED8936);
      case 'low':
        return const Color(0xFF48BB78);
      default:
        return const Color(0xFF718096);
    }
  }
}
