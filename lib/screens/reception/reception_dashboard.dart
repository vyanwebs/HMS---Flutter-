import 'package:flutter/material.dart';
import 'package:hms/screens/reception/patient_directory.dart';
import 'package:hms/screens/reception/ipd_screen.dart';
import 'package:hms/screens/reception/opd_screen.dart';
import 'package:hms/screens/reception/discharge_screen.dart';
import 'package:hms/screens/reception/doctors_screen.dart';
import 'package:hms/screens/reception/billing.dart';
import 'package:hms/screens/reception/analysis_screen.dart';
import 'package:hms/screens/reception/settings_screen.dart';
import 'package:hms/screens/reception/patient_registration.dart';
import 'package:hms/screens/reception/existing_patient.dart';
import 'package:hms/screens/reception/admission_requests.dart';
import 'package:hms/screens/reception/appointments_screen.dart';
import 'package:hms/widgets/quick_action_button.dart';
import 'package:hms/utils/constants.dart';

import '../main_dashboard.dart';

class ReceptionDashboard extends StatefulWidget {
  const ReceptionDashboard({super.key});

  @override
  State<ReceptionDashboard> createState() => _ReceptionDashboardState();
}

class _ReceptionDashboardState extends State<ReceptionDashboard> {
  String _selectedNavItem = 'Dashboard';
  bool _showProfileMenu = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC),
      body: Row(
        children: [
          // Left Navigation Panel
          Container(
            width: 280,
            color: Colors.white,
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
                          color: const Color(0xFF4299E1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.medical_services,
                            color: Colors.white, size: 24),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'DocNex',
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

                // Navigation Items
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildNavSection('Home', Icons.home_outlined),
                        _buildNavSection('Inbox', Icons.email_outlined),

                        const SizedBox(height: 30),

                        // Dashboard Section
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'Dashboard',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFA0AEC0),
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        _buildNavItem('Dashboard', Icons.dashboard_outlined),
                        _buildNavItem('Appointments', Icons.calendar_today),

                        const SizedBox(height: 30),

                        // PATIENT Section
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'PATIENT',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFA0AEC0),
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        _buildNavItem(
                            'Patient Directory', Icons.people_outlined),
                        _buildNavItem('IPD', Icons.bed_outlined),
                        _buildNavItem('OPD', Icons.medical_services_outlined),
                        _buildNavItem('Discharge', Icons.exit_to_app_outlined),

                        const SizedBox(height: 30),

                        // SYSTEM Section
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'SYSTEM',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFA0AEC0),
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        _buildNavItem('Doctors', Icons.person_outline),
                        _buildNavItem('Billing', Icons.receipt_outlined),
                        _buildNavItem('Analysis', Icons.bar_chart_outlined),
                        _buildNavItem('Settings', Icons.settings_outlined),
                      ],
                    ),
                  ),
                ),

                // Bottom Profile Section
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.grey.shade200),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFF4299E1).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child:
                            const Icon(Icons.person, color: Color(0xFF4299E1)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Reception',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF2D3748),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'docnexhms@24.com',
                              style: TextStyle(
                                fontSize: 12,
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
                          _showProfileMenu
                              ? Icons.expand_less
                              : Icons.expand_more,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),

                // Logout Menu
                if (_showProfileMenu)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.grey.shade200),
                      ),
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MainDashboard()),
                        );
                      },
                      child: Row(
                        children: [
                          Icon(Icons.logout,
                              color: Colors.grey.shade600, size: 20),
                          const SizedBox(width: 12),
                          const Text(
                            'Logout',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF2D3748),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Main Content Area
          Expanded(
            child: Container(
              color: const Color(0xFFF7FAFC),
              child: Column(
                children: [
                  // Top Bar
                  Container(
                    height: 70,
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _getScreenTitle(_selectedNavItem),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D3748),
                          ),
                        ),

                        // Search Bar
                        Container(
                          width: 300,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF7FAFC),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: Row(
                            children: [
                              const SizedBox(width: 12),
                              const Icon(Icons.search,
                                  color: Color(0xFF718096), size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  controller: _searchController,
                                  decoration: const InputDecoration(
                                    hintText: 'Search...',
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(
                                      color: Color(0xFFA0AEC0),
                                      fontSize: 14,
                                    ),
                                  ),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF2D3748),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Divider
                  Container(height: 1, color: const Color(0xFFE2E8F0)),

                  // Main Content
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(30),
                      child: _buildSelectedContent(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getScreenTitle(String navItem) {
    switch (navItem) {
      case 'Dashboard':
        return 'Reception Dashboard';
      case 'Appointments':
        return 'Appointments Management';
      case 'Patient Directory':
        return 'Patient Directory';
      case 'IPD':
        return 'Inpatient Department (IPD)';
      case 'OPD':
        return 'Outpatient Department (OPD)';
      case 'Discharge':
        return 'Patient Discharge';
      case 'Doctors':
        return 'Doctors Management';
      case 'Billing':
        return 'Billing & Payments';
      case 'Analysis':
        return 'Analytics & Reports';
      case 'Settings':
        return 'System Settings';
      case 'Inbox':
        return 'Inbox';
      default:
        return 'Reception Dashboard';
    }
  }

  Widget _buildNavSection(String title, IconData icon) {
    final isSelected = _selectedNavItem == title;
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        color: isSelected ? const Color(0xFF4299E1) : Colors.transparent,
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? Colors.white : const Color(0xFF718096),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : const Color(0xFF4A5568),
              ),
            ),
            if (title == 'Inbox') ...[
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFF56565),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  '3',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(String title, IconData icon) {
    final isSelected = _selectedNavItem == title;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedNavItem = title;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF4299E1) : Colors.transparent,
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
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : const Color(0xFF4A5568),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedContent() {
    switch (_selectedNavItem) {
      case 'Appointments':
        return const AppointmentsScreen();
      case 'Patient Directory':
        return const PatientDirectory();
      case 'IPD':
        return const IPDScreen();
      case 'OPD':
        return const OPDScreen();
      case 'Discharge':
        return const DischargeScreen();
      case 'Doctors':
        return const DoctorsScreen();
      case 'Billing':
        return const BillingScreen();
      case 'Analysis':
        return const AnalysisScreen();
      case 'Settings':
        return const SettingsScreen();
      case 'Inbox':
        return _buildInboxScreen();
      case 'Dashboard':
      default:
        return _buildDashboardContent();
    }
  }

  Widget _buildDashboardContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Stats Grid - First Row
        Row(
          children: [
            Expanded(
              child: _buildGradientStatCard(
                title: 'Total Patients',
                value: '30',
                icon: Icons.people_outline,
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF59BDFF), Color(0xFFF1FAFF)],
                ),
                onTap: () {
                  setState(() {
                    _selectedNavItem = 'Patient Directory';
                  });
                },
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: _buildGradientStatCard(
                title: 'IPD Patients',
                value: '8',
                icon: Icons.bed_outlined,
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF57E3D8), Color(0xFFE3FCFA)],
                ),
                onTap: () {
                  setState(() {
                    _selectedNavItem = 'IPD';
                  });
                },
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: _buildGradientStatCard(
                title: 'OPD Patients',
                value: '21',
                icon: Icons.medical_services_outlined,
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF50FFFF), Color(0xFFDFFFFF)],
                ),
                onTap: () {
                  setState(() {
                    _selectedNavItem = 'OPD';
                  });
                },
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: _buildGradientStatCard(
                title: 'Total Billing',
                value: '₹32,450',
                icon: Icons.receipt_outlined,
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF68EF77), Color(0xFFECFEEE)],
                ),
                onTap: () {
                  setState(() {
                    _selectedNavItem = 'Billing';
                  });
                },
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        // Stats Grid - Second Row
        Row(
          children: [
            Expanded(
              child: _buildGradientStatCard(
                title: 'Pending Payments',
                value: '8',
                icon: Icons.payment_outlined,
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF8D9EFF), Color(0xFFFFFFFF)],
                ),
                onTap: () {
                  setState(() {
                    _selectedNavItem = 'Billing';
                  });
                },
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: _buildGradientStatCard(
                title: 'Available Beds',
                value: '15',
                icon: Icons.king_bed_outlined,
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFFDD349), Color(0xFFFFFBF0)],
                ),
                onTap: () {
                  setState(() {
                    _selectedNavItem = 'IPD';
                  });
                },
              ),
            ),
            const Spacer(flex: 2),
          ],
        ),

        const SizedBox(height: 30),

        // Second Row: Weekly Analytics, IPD vs OPD Ratio, Quick Actions
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Weekly Summary Analytics
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(25),
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
                    const Text(
                      'Weekly Summary Analytics',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    const SizedBox(height: 25),

                    // Weekly Chart Only
                    SizedBox(
                      height: 180,
                      child: Column(
                        children: [
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                _buildChartBar(20, 'Mon'),
                                _buildChartBar(21, 'Tue'),
                                _buildChartBar(14, 'Wed'),
                                _buildChartBar(7, 'Thu'),
                                _buildChartBar(20, 'Fri'),
                                _buildChartBar(21, 'Sat'),
                                _buildChartBar(14, 'Sun'),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(width: 30),

            // IPD vs OPD Ratio
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(25),
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
                    const Text(
                      'IPD Vs OPD Ratio',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    const SizedBox(height: 25),

                    // Single Circle with Both Colors
                    Center(
                      child: Stack(
                        children: [
                          // Background Circle
                          Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFFE2E8F0),
                                width: 20,
                              ),
                            ),
                          ),
                          // IPD Arc (58%)
                          SizedBox(
                            width: 200,
                            height: 200,
                            child: CustomPaint(
                              painter: _CirclePainter(
                                color: const Color(0xFF4299E1),
                                percentage: 0.58,
                              ),
                            ),
                          ),
                          // OPD Arc (42%)
                          SizedBox(
                            width: 200,
                            height: 200,
                            child: CustomPaint(
                              painter: _CirclePainter(
                                color: const Color(0xFF48BB78),
                                percentage: 0.42,
                                startAngle: 0.58,
                              ),
                            ),
                          ),
                          // Center Text
                          Positioned.fill(
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    '100%',
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF2D3748),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    'Total Patients',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: const Color(0xFF718096),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Legend
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildLegend(
                            const Color(0xFF4299E1), 'IPD (58%)', '8 Patients'),
                        const SizedBox(width: 30),
                        _buildLegend(const Color(0xFF48BB78), 'OPD (42%)',
                            '21 Patients'),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(width: 30),

            // Quick Actions
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(25),
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
                    const Text(
                      'Quick Actions',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    const SizedBox(height: 25),

                    // First row of quick actions
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: QuickActionButton(
                            icon: Icons.add_circle_outline,
                            label: 'New Appointment',
                            color: const Color(0xFF4299E1),
                            onTap: () {
                              setState(() {
                                _selectedNavItem = 'Appointments';
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: QuickActionButton(
                            icon: Icons.receipt_outlined,
                            label: 'Generate Bill',
                            color: const Color(0xFF48BB78),
                            onTap: () {
                              setState(() {
                                _selectedNavItem = 'Billing';
                              });
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    // Second row of quick actions
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: QuickActionButton(
                            icon: Icons.person_add_outlined,
                            label: 'Admit Patient',
                            color: const Color(0xFFED8936),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const PatientRegistration(),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: QuickActionButton(
                            icon: Icons.exit_to_app_outlined,
                            label: 'Discharge Patient',
                            color: const Color(0xFFF56565),
                            onTap: () {
                              setState(() {
                                _selectedNavItem = 'Discharge';
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 30),

        // Third Row: Weekly Appointments and Recent Activity
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Weekly Appointments
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(25),
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
                    const Text(
                      'Weekly Appointments',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    const SizedBox(height: 25),

                    // Appointments Chart
                    SizedBox(
                      height: 180,
                      child: Column(
                        children: [
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                _buildAppointmentBar(28, 'Mon'),
                                _buildAppointmentBar(21, 'Tue'),
                                _buildAppointmentBar(14, 'Wed'),
                                _buildAppointmentBar(7, 'Thu'),
                                _buildAppointmentBar(20, 'Fri'),
                                _buildAppointmentBar(21, 'Sat'),
                                _buildAppointmentBar(14, 'Sun'),
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

            const SizedBox(width: 30),

            // Recent Activity
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(25),
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
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Recent Activity',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'View All',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF4299E1),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),

                    // Activity List
                    ..._buildActivityItems(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGradientStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: Colors.white, size: 24),
                ),
                Icon(Icons.arrow_forward_ios,
                    color: Colors.white.withValues(alpha: 0.8), size: 16),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              value,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withValues(alpha: 0.9),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartBar(int height, String day) {
    final maxHeight = 21.0;
    final barHeight = (height / maxHeight) * 120;

    return Expanded(
      child: Column(
        children: [
          const SizedBox(height: 20),
          Container(
            height: barHeight,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF4299E1),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            day,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF718096),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentBar(int height, String day) {
    final maxHeight = 28.0;
    final barHeight = (height / maxHeight) * 120;

    return Expanded(
      child: Column(
        children: [
          const SizedBox(height: 20),
          Container(
            height: barHeight,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFED8936),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            day,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF718096),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend(Color color, String title, String subtitle) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2D3748),
              ),
            ),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF718096),
              ),
            ),
          ],
        ),
      ],
    );
  }

  List<Widget> _buildActivityItems() {
    return [
      _buildActivityItem('Patient John Smith admitted to ICU',
          Icons.add_circle_outline, const Color(0xFF48BB78)),
      _buildActivityItem('New appointment scheduled for Dr. Sharma',
          Icons.calendar_today_outlined, const Color(0xFF4299E1)),
      _buildActivityItem('Lab report uploaded for Patient ID: P10023',
          Icons.description_outlined, const Color(0xFFED8936)),
      _buildActivityItem('Payment received from Patient ID: P10018',
          Icons.payment_outlined, const Color(0xFF9F7AEA)),
      _buildActivityItem('Discharge summary generated for Patient ID: P10015',
          Icons.exit_to_app_outlined, const Color(0xFFF56565)),
    ];
  }

  Widget _buildActivityItem(String text, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF4A5568),
              ),
            ),
          ),
          const Text(
            '10 min ago',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF718096),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInboxScreen() {
    return Container(
      padding: const EdgeInsets.all(25),
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
          const Text(
            'Inbox',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 20),
          ..._buildInboxItems(),
        ],
      ),
    );
  }

  List<Widget> _buildInboxItems() {
    return [
      _buildInboxItem('New Appointment Request',
          'Dr. Sharma has requested an appointment for tomorrow', '10 min ago'),
      _buildInboxItem('Lab Report Ready',
          'Lab report for Patient ID: P10023 is ready', '30 min ago'),
      _buildInboxItem('Payment Reminder',
          'Payment pending for Patient ID: P10018', '1 hour ago'),
      _buildInboxItem('Discharge Request',
          'Discharge request for Patient ID: P10015', '2 hours ago'),
      _buildInboxItem(
          'New Admission', 'New patient admission in Ward 3', '3 hours ago'),
    ];
  }

  Widget _buildInboxItem(String title, String description, String time) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF4299E1).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.email, color: Color(0xFF4299E1)),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF718096),
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFFA0AEC0),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Painter for Circle Chart
class _CirclePainter extends CustomPainter {
  final Color color;
  final double percentage;
  final double startAngle;

  _CirclePainter({
    required this.color,
    required this.percentage,
    this.startAngle = 0.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 20
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;

    final sweepAngle = 2 * 3.14159 * percentage;
    final startAngleRad = 2 * 3.14159 * startAngle - (3.14159 / 2);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngleRad,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
