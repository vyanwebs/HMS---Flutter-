import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hms/screens/main_dashboard.dart';
import 'package:hms/screens/doctor/opd_ipd_appointments.dart';
import 'package:hms/screens/doctor/patient_history.dart';
import 'package:hms/screens/doctor/lab_test_request.dart';
import 'package:hms/screens/doctor/telecommunication.dart';
import 'package:hms/screens/doctor/ipd_management.dart';
import 'package:hms/screens/doctor/discharge_summary.dart';
import 'package:hms/screens/doctor/doctor_settings.dart';
import 'package:hms/screens/doctor/doctor_profile.dart';
import 'package:hms/screens/doctor/doctor_inbox.dart';
import 'package:hms/utils/enums.dart';

import '../../controllers/doctor_dashboard_controllers.dart';
import '../../controllers/panel_navigation_controller.dart';
import '../../utils/constants.dart';
import '../../utils/images.dart';
import '../../utils/text.dart';
import '../../widgets/doctor_panel/broadcast_widget.dart';
import '../../widgets/doctor_panel/ipd_vitals_widget.dart';
import '../../widgets/doctor_panel/pending_task_widget.dart';
import '../../widgets/doctor_panel/recent_patients_widget.dart';
import '../../widgets/doctor_panel/scheduled_patients_widget.dart';
import '../../widgets/doctor_panel/stat_card_widget.dart';
import '../../widgets/doctor_panel/teleconsultation_widget.dart';
import '../../widgets/doctor_panel/weekly_patients_chart_widget.dart';

class DoctorDashboard extends StatefulWidget {
  const DoctorDashboard({super.key});

  @override
  State<DoctorDashboard> createState() => _DoctorDashboardState();
}

class _DoctorDashboardState extends State<DoctorDashboard> {
  final navController = Get.find<PanelNavigationController>();
  // bool _showProfileMenu = false;
  final doctorDashboardControllers = Get.put(DoctorDashboardControllers());


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // final screenHeight = MediaQuery.of(context).size.height;
    final isMobile = screenWidth < 768;
    // final isTablet = screenWidth >= 768 && screenWidth < 1024;

    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC),
      body: Row(
        children: [
          // Left Navigation Panel - Fixed width for desktop
          if (!isMobile)
            Expanded(
              flex: 1,
              child: Container(
                color: Colors.white,
                child: _buildSidebar(),
              ),
            ),

          // Main Content Area
          Obx(
            () => Expanded(
              flex: 5,
              child: Visibility(
                replacement: const Center(child: CircularProgressIndicator(color: AppColors.info,)),
                visible: !doctorDashboardControllers.isLoading.value,
                child: Container(
                  color: const Color(0xFFF7FAFC),
                  child: Column(
                    children: [
                      // Main Content
                      Expanded(
                        child: _buildSelectedContent(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return Column(
      children: [
        // Scrollable content area
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with Logo
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  child: Row(
                    children: [
                      // App Logo from assets
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
                      const Text(
                        'Docnex',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D3748),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),
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
                        Text('Home'),
                      ],
                    ),
                  ),
                ),

                _buildSidebarItem(
                  title: 'Inbox',
                  menu: DoctorPanelMenu.inbox,
                  icon: Icons.email_outlined,
                ),
                _buildSidebarItem(
                  title: 'Dashboard',
                  menu: DoctorPanelMenu.dashboard,
                  icon: Icons.dashboard_outlined,
                ),

                const Divider(height: 35),

                // NATURE Section Header
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'PATIENT CARE',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFA0AEC0),
                      letterSpacing: 1,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                _buildSidebarItem(
                  title: 'Assigned patients (24)',
                  menu: DoctorPanelMenu.assignedPatients,
                  icon: Icons.group_outlined,
                ),
                _buildSidebarItem(
                  title: 'Telecommunication',
                  menu: DoctorPanelMenu.telecommunication,
                  icon: Icons.video_call_outlined,
                ),

                const Divider(height: 35),

                // CLINICAL RECORDS Section Header
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'CLINICAL RECORDS',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFA0AEC0),
                      letterSpacing: 1,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                _buildSidebarItem(
                  title: 'Laboratory results (24)',
                  menu: DoctorPanelMenu.labResults,
                  icon: Icons.science_outlined,
                ),
                _buildSidebarItem(
                  title: 'Patients Database (24)',
                  menu: DoctorPanelMenu.patientDatabase,
                  icon: Icons.storage_outlined,
                ),

                const Divider(height: 35),

                // LATE PATIENT MANAGEMENT Section Header
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'IN-PATIENT MANAGEMENT',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFA0AEC0),
                      letterSpacing: 1,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                _buildSidebarItem(
                  title: 'Broadcasting',
                  menu: DoctorPanelMenu.broadcasting,
                  imagePath: mageBroadcastIcon,
                ),
                _buildSidebarItem(
                  title: 'Analysis',
                  menu: DoctorPanelMenu.analysis,
                  imagePath: analysisIcon
                ),
                _buildSidebarItem(
                  title: 'Profile',
                  menu: DoctorPanelMenu.profile,
                  icon: Icons.person_outlined
                ),
                _buildSidebarItem(
                  title: 'Setting',
                  menu: DoctorPanelMenu.settings,
                  icon: Icons.settings_outlined
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),

        // Bottom Profile Section - Fixed at bottom
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: Colors.grey.shade200),
            ),
            color: Colors.white,
          ),
          child: Column(
            children: [
              // Simple logout button
              InkWell(
                onTap: () => Get.back(),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.arrow_back, color: AppColors.doctor, size: 22),
                      SizedBox(width: 10),
                      AppText(
                        'Back',
                        fontSize: 15,
                        color: AppColors.doctor,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSidebarItem({
    required String title,
    required DoctorPanelMenu menu,
    IconData? icon,
    String? imagePath,
  }) {
    return Obx(() {
      final isSelected = navController.selectedMenu.value == menu;

      return InkWell(
        onTap: () => navController.changeMenu(menu),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          margin: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF2383E2) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              icon != null
                ? Icon(icon, color: isSelected ? Colors.white : const Color(0xFF718096))
                : Image.asset(imagePath!, color: isSelected ? Colors.white : const Color(0xFF718096), scale: 20,),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFF4A5568),
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
      switch (navController.selectedMenu.value) {
        case DoctorPanelMenu.dashboard:
          return _buildDashboardContent();

        case DoctorPanelMenu.inbox:
          return const DoctorInbox();

        case DoctorPanelMenu.assignedPatients:
          return const OpdIpdAppointments();

        case DoctorPanelMenu.telecommunication:
          return const Telecommunication();

        case DoctorPanelMenu.labResults:
          return const LabTestRequest();

        case DoctorPanelMenu.patientDatabase:
          return const PatientHistory();

        case DoctorPanelMenu.broadcasting:
          return const IpdManagement();

        case DoctorPanelMenu.analysis:
          return const DischargeSummary();

        case DoctorPanelMenu.profile:
          return const DoctorProfile();

        case DoctorPanelMenu.settings:
          return const DoctorSettings();

        default:
          return _buildDashboardContent();
      }
    });
  }

  Widget _buildDashboardContent() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    // final isTablet = screenWidth >= 768 && screenWidth < 1024;

    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header - Only for Dashboard
          const AppText(
            'DOCTOR PANEL >> Dashboard',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF718096),
          ),
          const SizedBox(height: 20),

          // Stats Cards Row
          // _buildStatsCards(isMobile),
          statCard(),

          const SizedBox(height: 20),

          // Main Content Row
          if (!isMobile)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Today's Schedule and Broadcasting
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      // _buildTodaysSchedule(),
                      ScheduleView(),
                      const SizedBox(height: 20),
                      // _buildBroadcasting(),
                      BroadcastView(),
                    ],
                  ),
                ),

                const SizedBox(width: 20),

                // Recent Patients and Pending Tasks
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      RecentPatientsView(),
                      const SizedBox(height: 20),
                      PendingTasksView(),
                      const SizedBox(height: 20),
                      PatientStatisticsChart(
                        labels: doctorDashboardControllers.chartLabels,
                        data: doctorDashboardControllers.chartData,
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 20),

                // Right column widgets - Both boxes with same width
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      IPDVitalsView(),
                      const SizedBox(height: 20),
                      TeleconsultationView(),
                    ],
                  ),
                ),
              ],
            ),

          // Mobile Layout
          if (isMobile)
            Column(
              children: [
                ScheduleView(),
                const SizedBox(height: 20),
                BroadcastView(),
                const SizedBox(height: 20),
                RecentPatientsView(),
                const SizedBox(height: 20),
                PendingTasksView(),
                const SizedBox(height: 20),
                PatientStatisticsChart(
                  labels: doctorDashboardControllers.chartLabels,
                  data: doctorDashboardControllers.chartData,
                ),
                const SizedBox(height: 20),
                IPDVitalsView(),
                const SizedBox(height: 20),
                TeleconsultationView(),
              ],
            ),
        ],
      ),
    );
  }

  List<Widget> _cards() {
    return [
      StatCardWidget(
        title: "Today's Appointments",
        value: doctorDashboardControllers.todaysAppointments.value.toString(),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF2C7EDB), Color(0xFFE1F0FF)],
        ),
        imagePath: 'assets/images/box1.png',
      ),
      StatCardWidget(
        title: 'Pending Lab Reports',
        value: doctorDashboardControllers.pendingLabReports.value.toString(),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF00B894), Color(0xFFE3FCFA)],
        ),
        imagePath: 'assets/images/box2.png',
      ),
      StatCardWidget(
        title: 'Active IPD patients',
        value: doctorDashboardControllers.activeIPDPatients.value.toString(),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF00C9C9), Color(0xFFDFFFFF)],
        ),
        imagePath: 'assets/images/box3.png',
      ),
      StatCardWidget(
        title: 'Teleconsultation',
        value: doctorDashboardControllers.teleconsultation.value.toString(),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF00B83B), Color(0xFFECFEEE)],
        ),
        imagePath: 'assets/images/box4.png',
      ),
    ];
  }

  Widget statCard() {
    return Row(
      children: _cards().map(
        (card) => Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: card,
          ),
        )
      ).toList(),
    );
  }
}