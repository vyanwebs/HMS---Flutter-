import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hms/screens/main_dashboard.dart';
import 'package:hms/screens/doctor/opd_ipd_appointments.dart';
import 'package:hms/screens/doctor/e_prescriptions.dart';
import 'package:hms/screens/doctor/patient_history.dart';
import 'package:hms/screens/doctor/lab_test_request.dart';
import 'package:hms/screens/doctor/telecommunication.dart';
import 'package:hms/screens/doctor/ipd_management.dart';
import 'package:hms/screens/doctor/discharge_summary.dart';
import 'package:hms/screens/doctor/doctor_settings.dart';
import 'package:hms/screens/doctor/doctor_profile.dart';
import 'package:hms/screens/doctor/add_appointment.dart';
import 'package:hms/screens/doctor/doctor_inbox.dart';
import 'package:hms/utils/constants.dart';

import '../../utils/images.dart';
import '../../utils/text.dart';

class DoctorDashboard extends StatefulWidget {
  const DoctorDashboard({super.key});

  @override
  State<DoctorDashboard> createState() => _DoctorDashboardState();
}

class _DoctorDashboardState extends State<DoctorDashboard> {
  String _selectedNavItem = 'Dashboard';
  bool _showProfileMenu = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isMobile = screenWidth < 768;
    final isTablet = screenWidth >= 768 && screenWidth < 1024;

    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC),
      body: Row(
        children: [
          // Left Navigation Panel - Fixed width for desktop
          if (!isMobile)
            Container(
              width: 280,
              color: Colors.white,
              child: _buildSidebar(),
            ),

          // Main Content Area
          Expanded(
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
                            'assets/images/app_logo.png',
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
                _buildSidebarItem('Home', icon: Icons.home_outlined),
                _buildSidebarItem('Inbox', icon: Icons.email_outlined),
                _buildSidebarItem('Dashboard', icon: Icons.dashboard_outlined),

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
                _buildSidebarItem('Assigned patients (24)', icon: Icons.group_outlined),
                _buildSidebarItem('Telecommunication', icon: Icons.video_call_outlined),

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
                _buildSidebarItem('Laboratory results (24)', icon: Icons.science_outlined),
                _buildSidebarItem('Patients Database (24)', icon: Icons.storage_outlined),

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
                _buildSidebarItem('Broadcasting', imagePath: mageBroadcastIcon),
                _buildSidebarItem('Analysis', imagePath: analysisIcon),
                _buildSidebarItem('Profile', icon: Icons.person_outlined),
                _buildSidebarItem('Setting', icon: Icons.settings_outlined),

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
                onTap: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainDashboard()));
                },
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

  Widget _buildSidebarItem(
    String title, {
    IconData? icon,
    String? imagePath,
  }) {
    assert(
      (icon != null && imagePath == null) ||
          (icon == null && imagePath != null),
      'You must provide either an icon or an imagePath, but not both.',
    );

    final isSelected = _selectedNavItem == title;

    Widget leadingWidget;

    if (icon != null) {
      leadingWidget = Icon(
        icon,
        size: 20,
        color: isSelected ? Colors.white : const Color(0xFF718096),
      );
    } else {
      leadingWidget = Image.asset(
        imagePath!,
        width: 20,
        color: isSelected ? Colors.white : const Color(0xFF718096),
      );
    }

    return InkWell(
      onTap: () {
        if (title == 'Home') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainDashboard()),
          );
        } else {
          setState(() {
            _selectedNavItem = title;
          });
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2383E2) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            leadingWidget,
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? Colors.white : const Color(0xFF4A5568),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedContent() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    // Return the selected screen content
    switch (_selectedNavItem) {
      case 'Dashboard':
        return _buildDashboardContent();
      case 'Inbox':
        return const DoctorInbox();
      case 'Assigned patients (24)':
        return OpdIpdAppointments();
      case 'Telecommunication':
        return Telecommunication();
      case 'Laboratory results (24)':
        return LabTestRequest();
      case 'Patients Database (24)':
        return PatientHistory();
      case 'IPD Management':
        return IpdManagement();
      case 'Discharge Summary':
        return DischargeSummary();
      case 'Profile':
        return DoctorProfile();
      case 'Setting':
        return DoctorSettings();
      default:
        return _buildDashboardContent();
    }
  }

  Widget _buildDashboardContent() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    final isTablet = screenWidth >= 768 && screenWidth < 1024;

    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header - Only for Dashboard
          const Text(
            'DOCTOR PANEL >> Dashboard',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF718096),
            ),
          ),
          const SizedBox(height: 20),

          // Stats Cards Row
          _buildStatsCards(isMobile),

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
                      _buildTodaysSchedule(),
                      const SizedBox(height: 20),
                      _buildBroadcasting(),
                    ],
                  ),
                ),

                const SizedBox(width: 20),

                // Recent Patients and Pending Tasks
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      _buildRecentPatients(),
                      const SizedBox(height: 20),
                      _buildPendingTasks(),
                      const SizedBox(height: 20),
                      _buildWeeklyPatientGraph(),
                    ],
                  ),
                ),

                const SizedBox(width: 20),

                // Right column widgets - Both boxes with same width
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      _buildIPDVitalsMonitor(),
                      const SizedBox(height: 20),
                      _buildTeleconsultationQueue(),
                    ],
                  ),
                ),
              ],
            ),

          // Mobile Layout
          if (isMobile)
            Column(
              children: [
                _buildTodaysSchedule(),
                const SizedBox(height: 20),
                _buildBroadcasting(),
                const SizedBox(height: 20),
                _buildRecentPatients(),
                const SizedBox(height: 20),
                _buildPendingTasks(),
                const SizedBox(height: 20),
                _buildWeeklyPatientGraph(),
                const SizedBox(height: 20),
                _buildIPDVitalsMonitor(),
                const SizedBox(height: 20),
                _buildTeleconsultationQueue(),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildStatsCards(bool isMobile) {
    final statsData = [
      {
        'title': "Today's Appointments",
        'value': '24',
        'gradient': const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF2C7EDB), Color(0xFFE1F0FF)],
        ),
        'image': 'assets/images/box1.png',
      },
      {
        'title': 'Pending Lab Reports',
        'value': '24',
        'gradient': const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF00B894), Color(0xFFE3FCFA)],
        ),
        'image': 'assets/images/box2.png',
      },
      {
        'title': 'Active IPD patients',
        'value': '24',
        'gradient': const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF00C9C9), Color(0xFFDFFFFF)],
        ),
        'image': 'assets/images/box3.png',
      },
      {
        'title': 'Teleconsultation',
        'value': '24',
        'gradient': const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF00B83B), Color(0xFFECFEEE)],
        ),
        'image': 'assets/images/box4.png',
      },
    ];

    if (isMobile) {
      return Column(
        children: statsData.map((stat) {
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: _buildStatCard(
              title: stat['title'] as String,
              value: stat['value'] as String,
              gradient: stat['gradient'] as Gradient,
              imagePath: stat['image'] as String,
            ),
          );
        }).toList(),
      );
    }

    return Row(
      children: statsData.map((stat) {
        return Expanded(
          child: Container(
            margin: const EdgeInsets.only(right: 10),
            child: _buildStatCard(
              title: stat['title'] as String,
              value: stat['value'] as String,
              gradient: stat['gradient'] as Gradient,
              imagePath: stat['image'] as String,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required Gradient gradient,
    required String imagePath,
  }) {
    return Container(
      height: 140,
      padding: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          // Background Image - Adjusted size and position
          Positioned(
            right: 0,
            bottom: 0,
            child: _buildBackgroundImage(imagePath),
          ),

          // Content - Moved to bottom with left margin
          Positioned(
            left: 20, // Added left margin
            bottom: 20, // Position at bottom
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Value (24) at the top - Changed color to #000000
                AppText(
                  value,
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF000000),
                ),
                const SizedBox(height: 50),
                // Title text at the bottom - Changed color to #757575
                AppText(
                  title,
                  fontSize: 16,
                  color: const Color(0xFF757575),
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundImage(String imagePath) {
    return SizedBox(
      width: 120,
      height: 90,
      child: Image.asset(
        imagePath,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 120,
            height: 90,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                _getImageLabel(imagePath),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _getImageLabel(String imagePath) {
    if (imagePath.contains('box1')) return 'Appointments';
    if (imagePath.contains('box2')) return 'Lab Reports';
    if (imagePath.contains('box3')) return 'IPD Patients';
    if (imagePath.contains('box4')) return 'Teleconsultation';
    return 'Image';
  }

  Widget _buildTodaysSchedule() {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  "Today's Schedule",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _selectedNavItem = 'Assigned patients (24)';
                  });
                },
                child: const Text(
                  'View All',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF2383E2),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Schedule Items - Make scrollable
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 300),
            child: SingleChildScrollView(
              child: Column(
                children: _buildScheduleItems(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBroadcasting() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  'Broadcasting',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to broadcasting page
                },
                child: const Text(
                  'View All',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF2383E2),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Broadcasting Items - Make scrollable
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 250),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildBroadcastItem('General Announcement', 'general.png'),
                  _buildBroadcastItem(
                      'Emergency announcement', 'emergency.png'),
                  _buildBroadcastItem('For reception message', 'reception.png'),
                  _buildBroadcastItem('For pharmacy message', 'pharmacy.png'),
                  _buildBroadcastItem('For laboratory message', 'lab.png'),
                  _buildBroadcastItem('For nurse message', 'nurse.png'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBroadcastItem(String title, String imageName) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          // Image container
          Container(
            width: 50,
            height: 50,
            child: ClipRRect(
              child: Image.asset(
                'assets/images/$imageName',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback to icon if image doesn't load
                  return Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF2383E2).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getIconForBroadcastItem(title),
                      color: const Color(0xFF2383E2),
                      size: 20,
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF2D3748),
              ),
            ),
          ),
          // Removed the right arrow icon as requested
        ],
      ),
    );
  }

  IconData _getIconForBroadcastItem(String title) {
    if (title.contains('General')) return Icons.campaign_outlined;
    if (title.contains('Emergency')) return Icons.warning_outlined;
    if (title.contains('reception')) return Icons.desk_outlined;
    if (title.contains('pharmacy')) return Icons.local_pharmacy_outlined;
    if (title.contains('laboratory')) return Icons.science_outlined;
    if (title.contains('nurse')) return Icons.medical_services_outlined;
    return Icons.notifications_outlined;
  }

  List<Widget> _buildScheduleItems() {
    final scheduleItems = [
      _buildScheduleItem('Mann Sharma', '9.00 A.M.', 'OPD', 'Confirmed', userImage),
      _buildScheduleItem('Mann Sharma', '9.00 A.M.', 'Follow-up', 'Confirmed', userImage),
      _buildScheduleItem('Mann Sharma', '9.00 A.M.', 'OPD', 'Confirmed', userImage),
      _buildScheduleItem('Mann Sharma', '9.00 A.M.', 'Teleconsultation', 'Confirmed', userImage),
      _buildScheduleItem('Mann Sharma', '9.00 A.M.', 'OPD', 'Confirmed', userImage),
      _buildScheduleItem('Mann Sharma', '9.00 A.M.', 'IPD Review', 'Confirmed', userImage),
    ];

    return scheduleItems;
  }

  Widget _buildScheduleItem(String patient, String time, String type, String status, String image) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedNavItem = 'Assigned patients (24)';
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
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
                  Text(
                    patient,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    type,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF718096),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                AppText(
                  time,
                  fontSize: 12,
                  color: const Color(0xFF718096),
                ),
                const SizedBox(height: 4,),
                Container(
                  constraints: const BoxConstraints(minWidth: 70),
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  decoration: BoxDecoration(
                    color: _getStatusColor(status).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: AppText(
                    status,
                    fontSize: 11,
                    color: _getStatusColor(status),
                    fontWeight: FontWeight.w500,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentPatients() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  'Recent Patients',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _selectedNavItem = 'Patients Database (24)';
                  });
                },
                child: const Text(
                  'View All',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF2383E2),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Recent Patients List - Make scrollable
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 200),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildRecentPatientItem('Mann Sharma', 'Hypertension', 'Stable', '2 days ago'),
                  _buildRecentPatientItem('Mann Sharma', 'Hypertension', 'Stable', '2 days ago'),
                  _buildRecentPatientItem('Mann Sharma', 'Hypertension', 'Stable', '2 days ago'),
                  _buildRecentPatientItem('Mann Sharma', 'Hypertension', 'Stable', '2 days ago'),
                  _buildRecentPatientItem('Mann Sharma', 'Hypertension', 'Stable', '2 days ago'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentPatientItem(String name, String condition, String status, String time) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedNavItem = 'Patients Database (24)';
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF7FAFC),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
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
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                  const SizedBox(height: 4),
                  AppText(
                    condition,
                    fontSize: 12,
                    color: const Color(0xFF718096),
                  ),
                  const SizedBox(height: 4),
                  AppText(
                    time,
                    fontSize: 12,
                    color: const Color(0xFF718096),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF38A169).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    status,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF38A169),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFFA0AEC0),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIPDVitalsMonitor() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'IPD Vitals Monitor',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 16),

          // IPD Vitals - Make scrollable
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 400),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildVitalItem(
                    room: 'Room 101',
                    bedNo: 'Bed no.~ 80/180',
                    pulse: 'Pulse~ 80',
                    temp: 'Temp~ 98.6°F',
                    spo2: 'SpO2~ 98%',
                  ),
                  _buildVitalItem(
                    room: 'Room 102',
                    bedNo: 'Bed no.~ 81/180',
                    pulse: 'Pulse~ 75',
                    temp: 'Temp~ 97.8°F',
                    spo2: 'SpO2~ 96%',
                    isSpecial: true,
                  ),
                  _buildVitalItem(
                    room: 'Room 103',
                    bedNo: 'Bed no.~ 82/180',
                    pulse: 'Pulse~ 82',
                    temp: 'Temp~ 99.1°F',
                    spo2: 'SpO2~ 97%',
                    isSpecial: true,
                  ),
                  _buildVitalItem(
                    room: 'Room 104',
                    bedNo: 'Bed no.~ 83/180',
                    pulse: 'Pulse~ 78',
                    temp: 'Temp~ 98.2°F',
                    spo2: 'SpO2~ 99%',
                  ),
                  _buildVitalItem(
                    room: 'Room 105',
                    bedNo: 'Bed no.~ 84/180',
                    pulse: 'Pulse~ 85',
                    temp: 'Temp~ 98.8°F',
                    spo2: 'SpO2~ 95%',
                  ),
                  _buildVitalItem(
                    room: 'Room 106',
                    bedNo: 'Bed no.~ 85/180',
                    pulse: 'Pulse~ 79',
                    temp: 'Temp~ 97.9°F',
                    spo2: 'SpO2~ 98%',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVitalItem({
    required String room,
    required String bedNo,
    required String pulse,
    required String temp,
    required String spo2,
    bool isSpecial = false,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedNavItem = 'IPD Management';
        });
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSpecial ? const Color(0xFFFFEDEB) : const Color(0xFFF7FAFC),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Stack(
          children: [
            // Content
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  room,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 8),

                // First row: Bed No. and Temp
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        bedNo,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF718096),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        temp,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF2D3748),
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                // Second row: Pulse and SpO2
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        pulse,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF2D3748),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        spo2,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF2D3748),
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // Red or Green Dot in top right corner
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: isSpecial
                      ? const Color(0xFFF56565)
                      : const Color(0xFF48BB78),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPendingTasks() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pending Tasks',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 16),

          // Pending Tasks - Make scrollable
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 150),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildPendingTaskItem('Review lab results for John Smith',
                      'High', '2 days ago'),
                  _buildPendingTaskItem(
                      'Complete discharge summary for Room 305',
                      'Medium',
                      '2 days ago'),
                  _buildPendingTaskItem(
                      'Approve prescription for Sarah Johnson',
                      'Low',
                      '2 days ago'),
                  _buildPendingTaskItem('Update patient records for Alex Brown',
                      'Medium', '1 day ago'),
                  _buildPendingTaskItem(
                      'Follow up with emergency case', 'High', 'Just now'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPendingTaskItem(String task, String priority, String time) {
    Color priorityColor;
    switch (priority.toLowerCase()) {
      case 'high':
        priorityColor = const Color(0xFFF56565);
        break;
      case 'medium':
        priorityColor = const Color(0xFFED8936);
        break;
      case 'low':
        priorityColor = const Color(0xFF48BB78);
        break;
      default:
        priorityColor = const Color(0xFF718096);
    }

    return GestureDetector(
      onTap: () {
        if (task.contains('lab results')) {
          setState(() {
            _selectedNavItem = 'Laboratory results (24)';
          });
        } else if (task.contains('discharge summary')) {
          setState(() {
            _selectedNavItem = 'Discharge Summary';
          });
        } else if (task.contains('prescription')) {
          setState(() {
            _selectedNavItem = 'E-Prescriptions';
          });
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF2D3748),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    time,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF718096),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              constraints: const BoxConstraints(minWidth: 60),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: priorityColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                priority,
                style: TextStyle(
                  fontSize: 11,
                  color: priorityColor,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyPatientGraph() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'OPD/IPD/Emergency patients this week',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 20),

          // Days of the week
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              _GraphDay(day: 'Sun'),
              _GraphDay(day: 'Mon'),
              _GraphDay(day: 'Tue'),
              _GraphDay(day: 'Wed'),
              _GraphDay(day: 'Thu'),
              _GraphDay(day: 'Fri'),
              _GraphDay(day: 'Sat'),
            ],
          ),
          const SizedBox(height: 10),

          // Graph bars - Fixed height to prevent overflow
          SizedBox(
            height: 120,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _GraphBar(height: 60, color: Color(0xFF2383E2), label: 'IPD'),
                _GraphBar(height: 90, color: Color(0xFF48BB78), label: 'OPD'),
                _GraphBar(height: 30, color: Color(0xFF2383E2), label: 'IPD'),
                _GraphBar(height: 75, color: Color(0xFF48BB78), label: 'OPD'),
                _GraphBar(height: 45, color: Color(0xFF2383E2), label: 'IPD'),
                _GraphBar(
                    height: 100, color: Color(0xFFED8936), label: 'Emergency'),
                _GraphBar(height: 67, color: Color(0xFF48BB78), label: 'OPD'),
              ],
            ),
          ),

          // Legend
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _GraphLegend(color: Color(0xFF2383E2), label: 'IPD'),
              const SizedBox(width: 16),
              _GraphLegend(color: Color(0xFF48BB78), label: 'OPD'),
              const SizedBox(width: 16),
              _GraphLegend(color: Color(0xFFED8936), label: 'Emergency'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTeleconsultationQueue() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Teleconsultation Queue',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 16),

          // Teleconsultation Queue - Make scrollable
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 150),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildQueueItem('Mann Sharma', 'Waiting: 5 min'),
                  _buildQueueItem('John Smith', 'Waiting: 10 min'),
                  _buildQueueItem('Sarah Johnson', 'Waiting: 2 min'),
                  _buildQueueItem('Robert Brown', 'Waiting: 8 min'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQueueItem(String name, String waitingTime) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedNavItem = 'Telecommunication';
        });
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF7FAFC),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFF2383E2).withOpacity(0.1),
                borderRadius: BorderRadius.circular(18),
              ),
              child:
                  const Icon(Icons.person, color: Color(0xFF2383E2), size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    waitingTime,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF718096),
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _selectedNavItem = 'Telecommunication';
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2383E2),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
                minimumSize: const Size(0, 36),
              ),
              child: const Text(
                'Join',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return const Color(0xFF38A169);
      case 'pending':
        return const Color(0xFFED8936);
      case 'cancelled':
        return const Color(0xFFF56565);
      default:
        return const Color(0xFF718096);
    }
  }

  void _showMobileSidebar(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.85,
          child: _buildSidebar(),
        );
      },
    );
  }
}

class _GraphDay extends StatelessWidget {
  final String day;

  const _GraphDay({required this.day});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(
        day,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 12,
          color: Color(0xFF718096),
        ),
      ),
    );
  }
}

class _GraphBar extends StatelessWidget {
  final double height;
  final Color color;
  final String label;

  const _GraphBar({
    required this.height,
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            height: height,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: Color(0xFF718096),
            ),
          ),
        ],
      ),
    );
  }
}

class _GraphLegend extends StatelessWidget {
  final Color color;
  final String label;

  const _GraphLegend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF2D3748),
          ),
        ),
      ],
    );
  }
}