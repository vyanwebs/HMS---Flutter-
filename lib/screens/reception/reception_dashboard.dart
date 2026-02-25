import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hms/screens/reception/external_doctor_screen.dart';
import 'package:hms/screens/reception/track_patient_screen.dart';

import '../../controllers/Reception/opd_registration_controller.dart';
import '../../controllers/panel_navigation_controller.dart';
import '../../utils/enums.dart';
import '../../utils/images.dart';
import '../../utils/text.dart';
import '../admin/components/settings_screen.dart';
import '../main_dashboard.dart';
import 'analysis_screen.dart';
import 'billing.dart';
import 'discharge_screen.dart';
import 'doctor_management_screen.dart';
import 'ipd_screen.dart';
import 'opd_screen.dart';
import 'patient_management.dart';

class ReceptionDashboard extends StatefulWidget {
  const ReceptionDashboard({super.key});

  @override
  State<ReceptionDashboard> createState() => _ReceptionDashboardState();
}

class _ReceptionDashboardState extends State<ReceptionDashboard> {

  final navController = Get.find<PanelNavigationController>();
  final controller = Get.put(OPDRegistrationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC),
      body: Row(
        children: [
          // Left Navigation Panel
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.white,
              child: _buildSidebar()
            )
          ),

          // Main Content Area
          Expanded(
            flex: 5,
            child: _buildSelectedContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return Column(
      children: [

        // Logo
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    appLogo,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      // Fallback to icon if image doesn't load
                      return Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF2383E2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.medical_services, color: Colors.white, size: 24),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const AppText(
                'Docnex',
                fontSize: 24,
                color: Color(0xFF2D3748),
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
        ),

        /// 🔵 SCROLLABLE CONTENT
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                  margin: const EdgeInsets.all(2),
                  child: InkWell(
                    onTap: () {
                      Get.offAll(() => const MainDashboard());
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.home_outlined),
                        SizedBox(width: 12),
                        AppText('Home'),
                      ],
                    ),
                  ),
                ),

                _buildSidebarItem(
                  title: 'Inbox',
                  menu: ReceptionPanelMenu.inbox,
                  icon: Icons.email_outlined,
                ),

                const Divider(height: 35),

                _sectionTitle("Management Hub"),

                _buildSidebarItem(
                  title: "OPD registration",
                  menu: ReceptionPanelMenu.opd,
                  icon: Icons.person_add_alt_1,
                ),

                _buildSidebarItem(
                  title: "IPD management",
                  menu: ReceptionPanelMenu.ipd,
                  icon: Icons.bed_outlined,
                ),

                _buildSidebarItem(
                  title: "Patient management",
                  menu: ReceptionPanelMenu.patientManagement,
                  icon: Icons.people_outline,
                ),

                _buildSidebarItem(
                  title: "Discharged patients",
                  menu: ReceptionPanelMenu.discharge,
                  icon: Icons.exit_to_app,
                ),

                const SizedBox(height: 20),

                _sectionTitle("System"),

                _buildSidebarItem(
                  title: "Doctors",
                  menu: ReceptionPanelMenu.doctors,
                  icon: Icons.medical_services_outlined,
                ),

                _buildSidebarItem(
                  title: "Track patients",
                  menu: ReceptionPanelMenu.track_patient,
                  icon: Icons.medical_services_outlined,
                ),

                _buildSidebarItem(
                  title: "External Doctor",
                  menu: ReceptionPanelMenu.externaldoctor,
                  icon: Icons.medical_services_outlined,
                ),

                _buildSidebarItem(
                  title: "Appointments",
                  menu: ReceptionPanelMenu.appointments,
                  icon: Icons.calendar_today_outlined,
                ),

                _buildSidebarItem(
                  title: "Billing",
                  menu: ReceptionPanelMenu.billing,
                  icon: Icons.receipt_outlined,
                ),
              ],
            ),
          ),
        ),

        /// 🔵 FIXED BOTTOM BACK BUTTON (LIKE DOCTOR)
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: Colors.grey.shade200)),
          ),
          child: InkWell(
            onTap: () => Get.back(),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.arrow_back, color: Color(0xFF2383E2)),
                SizedBox(width: 8),
                AppText(
                  'Back',
                  color: Color(0xFF2383E2),
                  fontWeight: FontWeight.w600,
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildSidebarItem({
    required String title,
    required ReceptionPanelMenu menu,
    required IconData icon,
  }) {
    return Obx(() {
      final isSelected = navController.selectedMenu.value == menu;

      return InkWell(
        onTap: () => navController.changeMenu(menu),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF2383E2) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isSelected
                ? Colors.white
                : const Color(0xFF718096),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: AppText(
                  title,
                  color: isSelected
                  ? Colors.white
                  : const Color(0xFF4A5568),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildSelectedContent() {
    return Obx(() {
      final menu = navController.selectedMenu.value;

      switch (menu) {

        case ReceptionPanelMenu.opd:
          return OPDScreen();

        case ReceptionPanelMenu.ipd:
          return IPDScreen();

        case ReceptionPanelMenu.patientManagement:
          return PatientManagement();

        case ReceptionPanelMenu.discharge:
          return const DischargeScreen();

        case ReceptionPanelMenu.doctors:
          return const DoctorManagementScreen();

        case ReceptionPanelMenu.track_patient:
          return const TrackPatientsScreen();

        case ReceptionPanelMenu.externaldoctor:
          return const ExternalDoctorScreen();

        case ReceptionPanelMenu.billing:
          return const BillingScreen();

        case ReceptionPanelMenu.analysis:
          return const AnalysisScreen();

        case ReceptionPanelMenu.settings:
          return const SettingsScreen();

        default:
          return OPDScreen();
      }
    });
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: AppText(
        title,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: Colors.grey,
      ),
    );
  }

}
