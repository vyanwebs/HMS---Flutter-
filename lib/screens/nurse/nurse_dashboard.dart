import 'package:flutter/material.dart';
import 'package:hms/screens/nurse/inbox_screen.dart';
import 'package:hms/screens/nurse/treatment_plans_screen.dart';
import 'package:hms/screens/nurse/patient_followup_screen.dart';
import 'package:hms/screens/nurse/vitals_monitoring_screen.dart';
import 'package:hms/screens/nurse/iv_fluid_alerts_screen.dart';
import 'package:hms/screens/nurse/medications_procedures_screen.dart';
import 'package:hms/screens/nurse/ipd_pharmacy_orders_screen.dart';
import 'package:hms/screens/nurse/geo_attendance_screen.dart';
import 'package:hms/screens/nurse/admin_profile_screen.dart';
import 'package:hms/screens/nurse/settings_screen.dart';

import '../main_dashboard.dart';

class NurseDashboard extends StatefulWidget {
  const NurseDashboard({super.key});

  @override
  State<NurseDashboard> createState() => _NurseDashboardState();
}

class _NurseDashboardState extends State<NurseDashboard> {
  String _selectedNavItem = 'Dashboard';
  bool _showProfileMenu = false;
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

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
                  // Top Bar - Only for Dashboard screen
                  if (_selectedNavItem == 'Dashboard')
                    Container(
                      height: 70,
                      color: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: isMobile ? 16 : 30,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // For mobile, show hamburger menu
                          if (isMobile)
                            IconButton(
                              icon: const Icon(Icons.menu,
                                  color: Color(0xFF2383E2)),
                              onPressed: () {
                                _showMobileSidebar(context);
                              },
                            ),

                          // Greeting and date - Only for Dashboard
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Nursing Station',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF2D3748),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Today 02 Jan., Friday',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF718096),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          if (!isMobile) const SizedBox(width: 16),

                          // Add patient button - Only for Dashboard
                          if (!isMobile && _selectedNavItem == 'Dashboard')
                            ElevatedButton.icon(
                              onPressed: () {
                                _addPatient();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2383E2),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 0,
                                minimumSize: const Size(0, 40),
                              ),
                              icon: const Icon(
                                Icons.add,
                                size: 16,
                                color: Colors.white,
                              ),
                              label: const Text(
                                'Add patient',
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

                  // Divider - Only for Dashboard
                  if (_selectedNavItem == 'Dashboard')
                    Container(height: 1, color: const Color(0xFFE2E8F0)),

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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0094FE),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.medical_services,
                            color: Colors.white, size: 24),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'DozNex',
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

                // Home Section
                _buildSidebarItem('Home', Icons.home_outlined, true),
                _buildSidebarItem('Inbox', Icons.email_outlined, false),

                const SizedBox(height: 30),

                // Dashboard Section Header
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Admin / Dashboard',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFA0AEC0),
                      letterSpacing: 1,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                _buildSidebarItem('Dashboard', Icons.dashboard_outlined, false),

                const SizedBox(height: 30),

                // CUSTOMER CASE Section Header
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'CUSTOMER CASE',
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
                    'Treatment Plans', Icons.assignment_outlined, false),
                _buildSidebarItem(
                    'Patient Follow-up', Icons.follow_the_signs_outlined, false),

                const SizedBox(height: 30),

                // VIRUS & MONITORING Section Header
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'VIRUS & MONITORING',
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
                    'Vitals Monitoring', Icons.monitor_heart_outlined, false),
                _buildSidebarItem(
                    'IV Fluid Alerts', Icons.invert_colors_outlined, false),

                const SizedBox(height: 30),

                // MICROCYTOSIS & PROCEDURES Section Header
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'MICROCYTOSIS & PROCEDURES',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFA0AEC0),
                      letterSpacing: 1,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                _buildSidebarItem('Medications & Procedures',
                    Icons.medication_outlined, false),
                _buildSidebarItem('IPD Pharmacy Orders',
                    Icons.local_pharmacy_outlined, false),
                _buildSidebarItem(
                    'Geo Attendance', Icons.location_on_outlined, false),
                _buildSidebarItem(
                    'Admin profile', Icons.person_outlined, false),
                _buildSidebarItem('Setting', Icons.settings_outlined, false),

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
              // Nurse Profile
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0094FE).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Icon(
                      Icons.person,
                      color: const Color(0xFF0094FE),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Nurse Sharma',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2D3748),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Head Nurse',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _showProfileMenu = !_showProfileMenu;
                      });
                    },
                    child: Icon(
                      _showProfileMenu ? Icons.expand_less : Icons.expand_more,
                      color: Colors.grey.shade600,
                      size: 24,
                    ),
                  ),
                ],
              ),

              // Logout Menu
              if (_showProfileMenu)
                Container(
                  padding: const EdgeInsets.only(top: 15),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MainDashboard()),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(Icons.logout,
                              color: Colors.grey.shade600, size: 22),
                          const SizedBox(width: 15),
                          const Text(
                            'Logout',
                            style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFF2D3748),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSidebarItem(String title, IconData icon, bool isHome) {
    final isSelected = _selectedNavItem == title;
    return InkWell(
      onTap: () {
        if (isHome) {
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
          color: isSelected ? const Color(0xFF0094FE) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? Colors.white : const Color(0xFF718096),
            ),
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
    // Return the selected screen content
    switch (_selectedNavItem) {
      case 'Dashboard':
        return _buildDashboardContent();
      case 'Inbox':
        return InboxScreen(onBack: () => setState(() => _selectedNavItem = 'Dashboard'));
      case 'Treatment Plans':
        return TreatmentPlansScreen(onBack: () => setState(() => _selectedNavItem = 'Dashboard'));
      case 'Patient Follow-up':
        return PatientFollowUpScreen(onBack: () => setState(() => _selectedNavItem = 'Dashboard'));
      case 'Vitals Monitoring':
        return VitalsMonitoringScreen(onBack: () => setState(() => _selectedNavItem = 'Dashboard'));
      case 'IV Fluid Alerts':
        return IVFluidAlertsScreen(onBack: () => setState(() => _selectedNavItem = 'Dashboard'));
      case 'Medications & Procedures':
        return MedicationsProceduresScreen(onBack: () => setState(() => _selectedNavItem = 'Dashboard'));
      case 'IPD Pharmacy Orders':
        return IPDPharmacyOrdersScreen(onBack: () => setState(() => _selectedNavItem = 'Dashboard'));
      case 'Geo Attendance':
        return GeoAttendanceScreen(onBack: () => setState(() => _selectedNavItem = 'Dashboard'));
      case 'Admin profile':
        return AdminProfileScreen(onBack: () => setState(() => _selectedNavItem = 'Dashboard'));
      case 'Setting':
        return SettingsScreen(onBack: () => setState(() => _selectedNavItem = 'Dashboard'));
      default:
        return _buildDashboardContent();
    }
  }

  Widget _buildDashboardContent() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header - Only for Dashboard
          const Text(
            'NURSING PANEL >> Dashboard',
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

          // Assigned Patients Header with Add Patient Button and Filter Dropdown
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Assigned patients',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3748),
                  ),
                ),
                Row(
                  children: [
                    // All Dropdown Filter
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedFilter,
                          icon: const Icon(Icons.keyboard_arrow_down,
                              size: 20, color: Colors.grey),
                          items: ['All', 'Critical', 'Stable', 'Observation']
                              .map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF4A5568),
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedFilter = newValue!;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Add Patient Button
                    ElevatedButton.icon(
                      onPressed: _addPatient,
                      icon: const Icon(Icons.add, size: 16),
                      label: const Text('Add patient'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0094FE),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Main Content Row
          if (!isMobile)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Patient Cards Grid
                Expanded(
                  flex: 3,
                  child: _buildPatientGrid(),
                ),

                const SizedBox(width: 20),

                // Side Panel (Upcoming Tasks & Emergency Alerts)
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      _buildUpcomingTasks(),
                      const SizedBox(height: 20),
                      _buildEmergencyAlerts(),
                    ],
                  ),
                ),
              ],
            ),

          // Mobile Layout
          if (isMobile)
            Column(
              children: [
                _buildPatientGrid(),
                const SizedBox(height: 20),
                _buildUpcomingTasks(),
                const SizedBox(height: 20),
                _buildEmergencyAlerts(),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildStatsCards(bool isMobile) {
    final statsData = [
      {
        'title': 'Total Patients',
        'value': '30',
        'color': const Color(0xFF8EC9FF),
        'icon': Icons.people_outline,
      },
      {
        'title': 'Critical Cases',
        'value': '12',
        'color': const Color(0xFF8EF0E0),
        'icon': Icons.warning_amber_outlined,
      },
      {
        'title': 'Pending Tasks',
        'value': '12',
        'color': const Color(0xFF9EF7FF),
        'icon': Icons.pending_actions_outlined,
      },
      {
        'title': 'Medications Due',
        'value': '9',
        'color': const Color(0xFFA9F5A1),
        'icon': Icons.medication_outlined,
      },
    ];

    if (isMobile) {
      return Wrap(
        spacing: 10,
        runSpacing: 10,
        children: statsData.map((stat) {
          return SizedBox(
            width: (MediaQuery.of(context).size.width - 48) / 2,
            child: _buildStatCard(
              title: stat['title'] as String,
              value: stat['value'] as String,
              color: stat['color'] as Color,
              icon: stat['icon'] as IconData,
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
              color: stat['color'] as Color,
              icon: stat['icon'] as IconData,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return GestureDetector(
      onTap: () {
        if (title.contains('Patients')) {
          setState(() {
            _selectedNavItem = 'Vitals Monitoring';
          });
        } else if (title.contains('Critical')) {
          setState(() {
            _selectedNavItem = 'IV Fluid Alerts';
          });
        } else if (title.contains('Tasks')) {
          setState(() {
            _selectedNavItem = 'Medications & Procedures';
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: Colors.white, size: 20),
                ),
                Icon(Icons.arrow_forward_ios,
                    color: Colors.white.withValues(alpha: 0.8), size: 14),
              ],
            ),
            const SizedBox(height: 15),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withValues(alpha: 0.9),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientGrid() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    final crossAxisCount = isMobile ? 1 : 2;
    final cardWidth = isMobile
        ? screenWidth - 32
        : (screenWidth - (screenWidth * 0.25 + 64)) / 2 - 8;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: crossAxisCount,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: isMobile ? 1.0 : 0.7,
      children: const [
        _PatientCard(
          name: 'Mann Sharma',
          age: 67,
          bed: 'ICU-A',
          bedNumber: 'Bed 01',
          status: 'Critical',
          diagnosis: 'Acute Myocardial Infarction',
          bp: '140/90',
          pulse: '88 bpm',
          temp: '98.6°F',
          spo2: '98%',
          nextMedication: 'Insulin 10 units',
          nextMedicationTime: '2.30 P.M.',
        ),
        _PatientCard(
          name: 'Mann Sharma',
          age: 67,
          bed: 'ICU-A',
          bedNumber: 'Bed 08',
          status: 'Stable',
          diagnosis: 'Acute Myocardial Infarction',
          bp: '140/90',
          pulse: '88 bpm',
          temp: '98.6°F',
          spo2: '98%',
          nextMedication: 'Insulin 10 units',
          nextMedicationTime: '2.30 P.M.',
        ),
        _PatientCard(
          name: 'Mann Sharma',
          age: 67,
          bed: 'ICU-A',
          bedNumber: 'Bed 05',
          status: 'Observation',
          diagnosis: 'Acute Myocardial Infarction',
          bp: '140/90',
          pulse: '88 bpm',
          temp: '98.6°F',
          spo2: '98%',
          nextMedication: 'Insulin 10 units',
          nextMedicationTime: '2.30 P.M.',
        ),
        _PatientCard(
          name: 'Mann Sharma',
          age: 67,
          bed: 'ICU-A',
          bedNumber: 'Bed 07',
          status: 'Stable',
          diagnosis: 'Acute Myocardial Infarction',
          bp: '140/90',
          pulse: '88 bpm',
          temp: '98.6°F',
          spo2: '98%',
          nextMedication: 'Insulin 10 units',
          nextMedicationTime: '2.30 P.M.',
        ),
      ],
    );
  }

  Widget _buildUpcomingTasks() {
    final tasksCount = 4;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF2E9),
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
              const Text(
                'Upcoming tasks',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2D3748),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF0094FE),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$tasksCount',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Upcoming Tasks List
          Column(
            children: [
              _buildUpcomingTaskItem(
                patient: 'Mann Sharma',
                task: 'Administer Insulin - 10 units',
                time: '2.30 P.M.',
                bed: 'Bed 12',
                isCritical: true,
              ),
              _buildUpcomingTaskItem(
                patient: 'Mann Sharma',
                task: 'Administer Insulin - 10 units',
                time: '2.30 P.M.',
                bed: 'Bed 12',
                isCritical: true,
              ),
              _buildUpcomingTaskItem(
                patient: 'Mann Sharma',
                task: 'Administer Insulin - 10 units',
                time: '2.30 P.M.',
                bed: 'Bed 12',
                isCritical: true,
              ),
              _buildUpcomingTaskItem(
                patient: 'Mann Sharma',
                task: 'Administer Insulin - 10 units',
                time: '2.30 P.M.',
                bed: 'Bed 12',
                isCritical: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingTaskItem({
    required String patient,
    required String task,
    required String time,
    required String bed,
    required bool isCritical,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedNavItem = 'Medications & Procedures';
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.person, size: 18, color: Colors.grey),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    patient,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    task,
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
                Text(
                  '$time, $bed',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF718096),
                  ),
                ),
                const SizedBox(height: 4),
                if (isCritical)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.red.shade100,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'Critical',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyAlerts() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFECEC),
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
          const Text(
            'Emergency alert',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 16),

          // Critical Alert
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red.shade200),
            ),
            child: const Row(
              children: [
                Icon(Icons.warning_amber, color: Colors.red, size: 24),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Critical Alert\nPatient in Bed 12 requires immediate attention',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // IV Fluid Alert
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange.shade200),
            ),
            child: const Row(
              children: [
                Icon(Icons.invert_colors, color: Colors.orange, size: 24),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'IV Fluid Alert\nLow fluid level detected - Bed 8',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.orange,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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

  void _addPatient() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Patient'),
        content:
            const Text('Add patient functionality will be implemented here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

class _PatientCard extends StatelessWidget {
  final String name;
  final int age;
  final String bed;
  final String bedNumber;
  final String status;
  final String diagnosis;
  final String bp;
  final String pulse;
  final String temp;
  final String spo2;
  final String nextMedication;
  final String nextMedicationTime;

  const _PatientCard({
    required this.name,
    required this.age,
    required this.bed,
    required this.bedNumber,
    required this.status,
    required this.diagnosis,
    required this.bp,
    required this.pulse,
    required this.temp,
    required this.spo2,
    required this.nextMedication,
    required this.nextMedicationTime,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    switch (status) {
      case 'Critical':
        statusColor = Colors.red;
        break;
      case 'Stable':
        statusColor = Colors.green;
        break;
      case 'Observation':
        statusColor = Colors.orange;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.all(16),
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
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Patient Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$name',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2D3748),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Age $age - $bed • $bedNumber',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF718096),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 11,
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Diagnosis Section
          const Text(
            'Diagnosis :',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            diagnosis,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF718096),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 12),

          // Latest Vitals and Next Medication in Same Row - Same Height
          SizedBox(
            height: 100,
            child: Row(
              children: [
                // Latest Vitals Box
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Latest Vitals',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2D3748),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'BP : $bp',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF4A5568),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Pulse : $pulse',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF4A5568),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Temp : $temp',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF4A5568),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'SpO₂ : $spo2',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF4A5568),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Next Medication Box
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE6F7FF),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFB3E0FF)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Next medication',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2D3748),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  nextMedication,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF2D3748),
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.orange.shade100,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  nextMedicationTime,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.orange.shade800,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    minimumSize: const Size(0, 36),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, size: 14, color: Colors.white),
                      SizedBox(width: 4),
                      Text(
                        'Add vital',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2383E2),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    minimumSize: const Size(0, 36),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.medication, size: 14, color: Colors.white),
                      SizedBox(width: 4),
                      Text(
                        'Medication',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}