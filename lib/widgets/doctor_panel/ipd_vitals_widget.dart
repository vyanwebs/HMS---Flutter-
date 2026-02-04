import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controllers/doctor_dashboard_controllers.dart';
import '../../helper_resposive_class/responsive_layout.dart';
import '../../models/patient_model.dart';
import '../../utils/constants.dart';
import '../../utils/text.dart';
import 'recent_patients_widget.dart';

class IPDVitalsView extends StatelessWidget {
  IPDVitalsView({super.key});

  final doctorDashboardControllers = Get.find<DoctorDashboardControllers>();

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: destopView(),
      tablet: destopView(),
      desktop: destopView(),
    );
  }

  Widget destopView() {
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
              _vitalsList(constraints),
            ],
          ),
        );
      },
    );
  }

  // ================= HEADER =================

  Widget _header(BoxConstraints constraints) {

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const AppText(
          'IPD Vitals Monitor',
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(0xFF2D3748),
        ),
        Obx(
          () => TweenAnimationBuilder<double>(
            tween: Tween<double>(
              begin: 0,
              end: doctorDashboardControllers.isVitalsLoading.value ? 1 : 0,
            ),
            duration: const Duration(seconds: 1),
            curve: Curves.linear,
            builder: (context, value, child) {
              return Transform.rotate(
                angle: value * 6.28,
                child: IconButton(
                  onPressed: doctorDashboardControllers.isVitalsLoading.value
                    ? null
                    : () => doctorDashboardControllers.fetchVitals(),
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

  Widget _vitalsList(BoxConstraints constraints) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 400),
      child: Obx(() {
        final vitals = doctorDashboardControllers.vitals;

        if (vitals.isEmpty) {
          return const Center(
            child: AppText(
              'No IPD vitals available',
              fontSize: 13,
              color: Color(0xFF718096),
            ),
          );
        }

        return ListView.builder(
          itemCount: vitals.length,
          itemBuilder: (_, index) {
            return _vitalItem(vitals[index], constraints);
          },
        );
      }),
    );
  }

  // ================= ITEM =================

  Widget _vitalItem(PatientModel patient, BoxConstraints constraints) {
    final statusConfig = _healthStatusConfig(patient.currentHealthCondition);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: statusConfig.color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Stack(
        children: [
          _vitalContent(patient),
          _statusDot(statusConfig),
        ],
      ),
    );
  }

  // ================= CONTENT =================

  Widget _vitalContent(PatientModel item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          "Room ${item.roomNumber}",
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF2D3748),
        ),
        const SizedBox(height: 8),

        Row(
          children: [
            Expanded(
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "Bed no.: ",
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.greyText
                      )
                    ),
                    TextSpan(
                      text: item.bedNumber,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.black
                      )
                    )
                  ]
                )
              ),
            ),
            Expanded(
              child: Text.rich(
                textAlign: TextAlign.end,
                TextSpan(
                  children: [
                    TextSpan(
                      text: "Temp: ",
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.greyText
                      )
                    ),
                    TextSpan(
                      text: item.currentVitalsReport!.temperature.toString(),
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.black
                      )
                    )
                  ]
                )
              ),
            ),
          ],
        ),

        const SizedBox(height: 6),

        Row(
          children: [
            Expanded(
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "Pulse: ",
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.greyText
                      )
                    ),
                    TextSpan(
                      text: item.currentVitalsReport!.pulse.toString(),
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.black
                      )
                    )
                  ]
                )
              ),
            ),
            Expanded(
              child: Text.rich(
                textAlign: TextAlign.end,
                TextSpan(
                  children: [
                    TextSpan(
                      text: "SpO2: ",
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.greyText
                      )
                    ),
                    TextSpan(
                      text: item.currentVitalsReport!.spo2.toString(),
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.black
                      )
                    )
                  ]
                )
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ================= STATUS DOT =================

  Widget _statusDot(HealthStatusConfig config) {
    return Positioned(
      top: 8,
      right: 8,
      child: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: config.color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 2,
            ),
          ],
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
