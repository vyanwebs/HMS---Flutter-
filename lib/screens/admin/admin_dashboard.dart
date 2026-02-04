import 'package:flutter/material.dart';
import 'package:hms/screens/main_dashboard.dart';
import 'package:hms/utils/constants.dart';
import 'package:hms/screens/admin/components/staff_list_screen.dart';
import 'package:hms/screens/admin/components/shift_management.dart';
import 'package:hms/screens/admin/components/multi_hospital_support.dart';
import 'package:hms/screens/admin/components/roles_permissions.dart';
import 'package:hms/screens/admin/components/medicines_screen.dart';
import 'package:hms/screens/admin/components/equipment_screen.dart';
import 'package:hms/screens/admin/components/billing_rate_master.dart';
import 'package:hms/screens/admin/components/document_templates.dart';
import 'package:hms/screens/admin/components/analytics_reports.dart';
import 'package:hms/screens/admin/components/audit_logs.dart';
import 'package:hms/screens/admin/components/admin_profile.dart';
import 'package:hms/screens/admin/components/settings_screen.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  String _selectedNavItem = 'Dashboard';
  bool _showProfileMenu = false;
  String _selectedWard = 'General ward';
  int _unreadInboxCount = 3;
  final TextEditingController _searchController = TextEditingController();

  // Stats data
  final Map<String, String> _quickStats = {
    'Bed occupancy': '98%',
    'Active staff': '400',
    'Doctors': '50',
    'Active patients': '600'
  };

  // Patient flow data
  final List<int> _patientFlowData = [10000, 8000, 8000, 10000, 4000, 2000, 3000, 0, -1000, -2000, -3000, -2000];
  final List<String> _months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sept', 'Oct', 'Nov', 'Dec'];

  // Weekly patient data
  final Map<String, Map<String, int>> _weeklyPatientData = {
    'Sun': {'OPD': 150, 'IPD': 80, 'Emergency': 40},
    'Mon': {'OPD': 200, 'IPD': 100, 'Emergency': 60},
    'Tues': {'OPD': 220, 'IPD': 110, 'Emergency': 70},
    'Wed': {'OPD': 180, 'IPD': 90, 'Emergency': 50},
    'Thur': {'OPD': 240, 'IPD': 120, 'Emergency': 80},
    'Fri': {'OPD': 200, 'IPD': 100, 'Emergency': 65},
    'Sat': {'OPD': 160, 'IPD': 85, 'Emergency': 45},
  };

  // Ward data
  final Map<String, int> _wardData = {
    'Emergency': 20,
    'ICU Ward': 40,
    'Semi-Private': 40,
    'Private': 40,
  };

  // Recent activities data
  final List<Map<String, String>> _recentActivities = [
    {
      'title': 'Dr. Sarah Wilson Updated patient record Patient Id #1233445',
      'time': '2 minutes ago'
    },
    {
      'title': 'New medicine stock added: Paracetamol 500mg',
      'time': '15 minutes ago'
    },
    {
      'title': 'Billing rate updated for General Ward',
      'time': '30 minutes ago'
    },
    {'title': 'New equipment maintenance scheduled', 'time': '1 hour ago'},
    {'title': 'Audit log generated for January 2024', 'time': '2 hours ago'}
  ];

  // Inbox messages
  final List<Map<String, String>> _inboxMessages = [
    {
      'title': 'Critical Alert: Low Medicine Stock',
      'description':
          'Paracetamol stock below minimum level. Reorder immediately.',
      'time': '10 min ago',
      'priority': 'high'
    },
    {
      'title': 'Billing Snapshot: Monthly Report',
      'description':
          'January billing report generated. Revenue increased by 15%.',
      'time': '30 min ago',
      'priority': 'medium'
    },
    {
      'title': 'System Alert: Equipment Maintenance',
      'description': 'MRI machine in Radiology needs preventive maintenance.',
      'time': '1 hour ago',
      'priority': 'high'
    },
    {
      'title': 'Staff Alert: Shift Change Request',
      'description': 'Nurse Johnson requested shift change for tomorrow.',
      'time': '2 hours ago',
      'priority': 'low'
    },
    {
      'title': 'Audit Alert: Security Update',
      'description': 'Security audit completed. All systems secure.',
      'time': '3 hours ago',
      'priority': 'medium'
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        children: [
          // Sidebar
          _buildSidebar(),
          // Main Content
          _buildMainContent(),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 260,
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        border: Border(right: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo and Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MainDashboard(),
                  ),
                );
              },
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.medical_services,
                        color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Docnex',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),

          // Navigation Menu
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Home and Inbox
                  _buildNavItem(Icons.home_outlined, 'Home', () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MainDashboard(),
                      ),
                    );
                  }),
                  _buildNavItem(Icons.inbox_outlined, 'Inbox', () {
                    setState(() {
                      _selectedNavItem = 'Inbox';
                      _unreadInboxCount = 0;
                    });
                  }, badgeCount: _unreadInboxCount),

                  const SizedBox(height: 24),

                  // Dashboard (Active)
                  _buildNavItem(Icons.dashboard_outlined, 'Dashboard', () {
                    setState(() {
                      _selectedNavItem = 'Dashboard';
                    });
                  }, active: _selectedNavItem == 'Dashboard'),

                  const SizedBox(height: 24),

                  // STAFF Section
                  _buildSection('STAFF'),
                  _buildNavItem(Icons.people_outline, 'Staff List', () {
                    setState(() {
                      _selectedNavItem = 'Staff List';
                    });
                  }),
                  _buildNavItem(Icons.schedule, 'Shift Management', () {
                    setState(() {
                      _selectedNavItem = 'Shift Management';
                    });
                  }),

                  const SizedBox(height: 24),

                  // SYSTEM Section
                  _buildSection('SYSTEM'),
                  _buildNavItem(Icons.apartment, 'Multi-Hospital Support', () {
                    setState(() {
                      _selectedNavItem = 'Multi-Hospital Support';
                    });
                  }),
                  _buildNavItem(Icons.lock_outline, 'Roles & Permissions', () {
                    setState(() {
                      _selectedNavItem = 'Roles & Permissions';
                    });
                  }),

                  const SizedBox(height: 24),

                  // ADMIN CONTROLS Section
                  _buildSection('ADMIN CONTROLS'),
                  _buildNavItem(Icons.medical_services_outlined, 'Medicines',
                      () {
                    setState(() {
                      _selectedNavItem = 'Medicines';
                    });
                  }),
                  _buildNavItem(
                      Icons.precision_manufacturing_outlined, 'Equipment', () {
                    setState(() {
                      _selectedNavItem = 'Equipment';
                    });
                  }),
                  _buildNavItem(
                      Icons.receipt_long_outlined, 'Billing Rate Master', () {
                    setState(() {
                      _selectedNavItem = 'Billing Rate Master';
                    });
                  }),
                  _buildNavItem(
                      Icons.description_outlined, 'Document Templates', () {
                    setState(() {
                      _selectedNavItem = 'Document Templates';
                    });
                  }),
                  _buildNavItem(Icons.analytics_outlined, 'Analytics & Reports',
                      () {
                    setState(() {
                      _selectedNavItem = 'Analytics & Reports';
                    });
                  }),
                  _buildNavItem(Icons.fact_check_outlined, 'Audit Logs', () {
                    setState(() {
                      _selectedNavItem = 'Audit Logs';
                    });
                  }),
                  _buildNavItem(Icons.person_outline, 'Admin Profile', () {
                    setState(() {
                      _selectedNavItem = 'Admin Profile';
                    });
                  }),

                  const SizedBox(height: 24),

                  // Settings
                  _buildNavItem(Icons.settings_outlined, 'Setting', () {
                    setState(() {
                      _selectedNavItem = 'Setting';
                    });
                  }),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // Profile Section
          _buildProfileSection(),
        ],
      ),
    );
  }

  Widget _buildSection(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, VoidCallback onTap,
      {bool active = false, int badgeCount = 0}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        decoration: BoxDecoration(
          color: active ? AppColors.primary.withValues(alpha: 0.12) : null,
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          dense: true,
          leading: Icon(
            icon,
            size: 20,
            color: active ? AppColors.primary : AppColors.textSecondary,
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: active ? FontWeight.w600 : FontWeight.normal,
                    color: active ? AppColors.primary : null,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              if (badgeCount > 0) ...[
                const SizedBox(width: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.error,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    badgeCount.toString(),
                    style: const TextStyle(
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
      ),
    );
  }

  Widget _buildProfileSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(Icons.person, color: AppColors.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Admin User',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'admin@docnex.com',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
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
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          if (_showProfileMenu)
            Column(
              children: [
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        dense: true,
                        leading: const Icon(Icons.person_outline, size: 20),
                        title: const Text('My Profile'),
                        onTap: () {
                          setState(() {
                            _selectedNavItem = 'Admin Profile';
                            _showProfileMenu = false;
                          });
                        },
                      ),
                      const Divider(height: 1),
                      ListTile(
                        dense: true,
                        leading: const Icon(Icons.logout, size: 20),
                        title: const Text('Logout'),
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MainDashboard(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return Expanded(
      child: Container(
        color: AppColors.background,
        child: Column(
          children: [
            // Top Bar
            Container(
              height: 70,
              color: AppColors.cardBackground,
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      _getScreenTitle(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 20),
                  // Search Bar
                  Container(
                    width: 300,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 12),
                        Icon(Icons.search,
                            color: AppColors.textSecondary, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Search...',
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 14,
                              ),
                            ),
                            style: const TextStyle(fontSize: 14),
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
            Container(height: 1, color: AppColors.border),
            // Content Area
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height - 200,
                  ),
                  child: _buildSelectedContent(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getScreenTitle() {
    switch (_selectedNavItem) {
      case 'Dashboard':
        return 'Admin / Dashboard';
      case 'Inbox':
        return 'Inbox';
      case 'Staff List':
        return 'Staff Management';
      case 'Shift Management':
        return 'Shift Management';
      case 'Multi-Hospital Support':
        return 'Multi-Hospital Support';
      case 'Roles & Permissions':
        return 'Roles & Permissions';
      case 'Medicines':
        return 'Medicines Management';
      case 'Equipment':
        return 'Equipment Management';
      case 'Billing Rate Master':
        return 'Billing Rate Master';
      case 'Document Templates':
        return 'Document Templates';
      case 'Analytics & Reports':
        return 'Analytics & Reports';
      case 'Audit Logs':
        return 'Audit Logs';
      case 'Admin Profile':
        return 'Admin Profile';
      case 'Setting':
        return 'Settings';
      default:
        return 'Admin / Dashboard';
    }
  }

  Widget _buildSelectedContent() {
    switch (_selectedNavItem) {
      case 'Inbox':
        return _buildInboxScreen();
      case 'Staff List':
        return const StaffListScreen();
      case 'Shift Management':
        return const ShiftManagementScreen();
      case 'Multi-Hospital Support':
        return const MultiHospitalSupportScreen();
      case 'Roles & Permissions':
        return const RolesPermissionsScreen();
      case 'Medicines':
        return const MedicinesScreen();
      case 'Equipment':
        return const EquipmentScreen();
      case 'Billing Rate Master':
        return const BillingRateMasterScreen();
      case 'Document Templates':
        return const DocumentTemplatesScreen();
      case 'Analytics & Reports':
        return const AnalyticsReportsScreen();
      case 'Audit Logs':
        return const AuditLogsScreen();
      case 'Admin Profile':
        return const AdminProfileScreen();
      case 'Setting':
        return const SettingsScreen();
      case 'Dashboard':
      default:
        return _buildDashboardContent();
    }
  }

  Widget _buildDashboardContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        const Text(
          'Admin / Dashboard',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 24),

        // Top Stats
        _buildTopStats(),

        const SizedBox(height: 24),

        // Middle Section
        _buildMiddleSection(),

        const SizedBox(height: 24),

        // Bottom Section
        _buildBottomSection(),
      ],
    );
  }

  Widget _buildTopStats() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            SizedBox(
              width: (constraints.maxWidth - 48) / 4,
              child: _buildStatCard(
                '30',
                'Total hospitals',
                Colors.blue,
                onTap: () => _showBillingSnapshot('Total Hospitals'),
              ),
            ),
            SizedBox(
              width: (constraints.maxWidth - 48) / 4,
              child: _buildStatCard(
                '1247',
                'Active Staff',
                Colors.teal,
                onTap: () => _showBillingSnapshot('Active Staff'),
              ),
            ),
            SizedBox(
              width: (constraints.maxWidth - 48) / 4,
              child: _buildStatCard(
                '1247',
                'Daily Patients',
                Colors.cyan,
                onTap: () => _showBillingSnapshot('Daily Patients'),
              ),
            ),
            SizedBox(
              width: (constraints.maxWidth - 48) / 4,
              child: _buildStatCard(
                '\$2.4M',
                'Revenue monthly',
                Colors.green,
                onTap: () => _showBillingSnapshot('Revenue Monthly'),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard(String value, String label, Color color,
      {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 140,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConstants.cardRadius),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [color.withValues(alpha: 0.6), color],
          ),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  child: Icon(
                    Icons.analytics_outlined,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white.withValues(alpha: 0.8),
                  size: 16,
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiddleSection() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Patient Flow Analysis
                Expanded(
                  flex: 4,
                  child: _buildCard(
                    titleWidget: Row(
                      children: [
                        const Text(
                          'Patient Flow Analysis >> ',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        DropdownButton<String>(
                          value: _selectedWard,
                          underline: const SizedBox(),
                          items: const [
                            DropdownMenuItem(
                              value: 'General ward',
                              child: Text('General ward'),
                            ),
                            DropdownMenuItem(
                              value: 'ICU ward',
                              child: Text('ICU ward'),
                            ),
                            DropdownMenuItem(
                              value: 'Emergency',
                              child: Text('Emergency'),
                            ),
                            DropdownMenuItem(
                              value: 'Private ward',
                              child: Text('Private ward'),
                            ),
                            DropdownMenuItem(
                              value: 'Semi-private ward',
                              child: Text('Semi-private ward'),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedWard = value!;
                            });
                          },
                        ),
                      ],
                    ),
                    child: GestureDetector(
                      onTap: () => _showDetailedAnalytics('Patient Flow'),
                      child: SizedBox(
                        height: 300,
                        child: _buildPatientFlowChart(),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                // Currently Active Patients
                Expanded(
                  flex: 3,
                  child: _buildCard(
                    title: 'Currently active patients',
                    child: GestureDetector(
                      onTap: () => _showActivePatientsDialog(),
                      child: SizedBox(
                        height: 300,
                        child: _buildWardPatientsChart(),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                // Quick Stats
                Expanded(
                  flex: 2,
                  child: _buildCard(
                    title: 'Quick Stats',
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _buildMiniStat(
                                _quickStats['Bed occupancy']!,
                                'Bed occupancy',
                                const Color(0xFFDAEDFF),
                                onTap: () => _showStatDetails('Bed occupancy'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildMiniStat(
                                _quickStats['Active staff']!,
                                'Active staff',
                                const Color(0xFFFFF4EA),
                                onTap: () {
                                  setState(() {
                                    _selectedNavItem = 'Staff List';
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: _buildMiniStat(
                                _quickStats['Doctors']!,
                                'Doctors',
                                const Color(0xFFE5FFEE),
                                onTap: () => _showStaffDetails('Doctors'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildMiniStat(
                                _quickStats['Active patients']!,
                                'Active patients',
                                const Color(0xFFFFF7E6),
                                onTap: () => _showActivePatientsDialog(),
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
          ],
        );
      },
    );
  }

  Widget _buildBottomSection() {
    return Column(
      children: [
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // OPD/IPD/Emergency Patients
            Expanded(
              flex: 4,
              child: _buildCard(
                title: 'OPD / IPD / Emergency patients this week',
                child: GestureDetector(
                  onTap: () => _showDetailedAnalytics('Weekly Patients'),
                  child: SizedBox(
                    height: 300,
                    child: _buildWeeklyPatientsChart(),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 16),

            // Recent Activity
            Expanded(
              flex: 3,
              child: _buildCard(
                title: 'Recent activity',
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ..._recentActivities.map((activity) {
                      return ListTile(
                        dense: true,
                        contentPadding: const EdgeInsets.symmetric(vertical: 4),
                        leading: const Icon(Icons.circle,
                            size: 8, color: AppColors.success),
                        title: Text(
                          activity['title']!,
                          style: const TextStyle(fontSize: 12),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(activity['time']!),
                        trailing: GestureDetector(
                          onTap: () => _showActivityDetails(activity),
                          child: const Text(
                            'View >>',
                            style: TextStyle(
                              color: AppColors.success,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            _selectedNavItem = 'Audit Logs';
                          });
                        },
                        child: const Text(
                          'View All >>',
                          style: TextStyle(color: AppColors.primary),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCard({
    String? title,
    Widget? titleWidget,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppConstants.cardRadius),
        border: Border.all(color: AppColors.border),
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
        mainAxisSize: MainAxisSize.min,
        children: [
          titleWidget ??
              Text(
                title!,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildMiniStat(String value, String label, Color bgColor,
      {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 90,
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(AppConstants.cardRadius),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientFlowChart() {
    final maxValue = _patientFlowData.reduce((a, b) => a > b ? a : b).abs();
    final minValue = _patientFlowData.reduce((a, b) => a < b ? a : b).abs();
    final chartHeight = 220.0;
    
    return Column(
      children: [
        // Y-axis labels
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 40,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${(maxValue/1000).toInt()}K', style: const TextStyle(fontSize: 10)),
                  const SizedBox(height: 40),
                  const Text('0K', style: TextStyle(fontSize: 10)),
                  const SizedBox(height: 40),
                  Text('-${(maxValue/1000).toInt()}K', style: const TextStyle(fontSize: 10)),
                ],
              ),
            ),
            Expanded(
              child: SizedBox(
                height: chartHeight,
                child: Stack(
                  children: [
                    // Zero line
                    Positioned(
                      top: chartHeight / 2,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 1,
                        color: AppColors.border,
                      ),
                    ),
                    
                    // Grid lines
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 1,
                        color: AppColors.border.withValues(alpha: 0.3),
                      ),
                    ),
                    Positioned(
                      top: chartHeight / 4,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 1,
                        color: AppColors.border.withValues(alpha: 0.3),
                      ),
                    ),
                    Positioned(
                      top: chartHeight * 3/4,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 1,
                        color: AppColors.border.withValues(alpha: 0.3),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 1,
                        color: AppColors.border.withValues(alpha: 0.3),
                      ),
                    ),
                    
                    // Bars
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: _patientFlowData.asMap().entries.map((entry) {
                        final index = entry.key;
                        final value = entry.value;
                        final barHeight = (value.abs() / maxValue) * (chartHeight / 2);
                        final isNegative = value < 0;
                        
                        return Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                width: 20,
                                height: barHeight,
                                margin: const EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                  color: isNegative ? AppColors.error : AppColors.success,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(4),
                                    topRight: Radius.circular(4),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _months[index],
                                style: const TextStyle(fontSize: 10),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWardPatientsChart() {
    final maxValue = _wardData.values.reduce((a, b) => a > b ? a : b);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Ward data list
        ..._wardData.entries.map((entry) {
          final ward = entry.key;
          final patients = entry.value;
          
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(ward, style: const TextStyle(fontSize: 14)),
                    Text('$patients', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  height: 8,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: (patients / maxValue) * 200,
                      decoration: BoxDecoration(
                        color: _getWardColor(ward),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildWeeklyPatientsChart() {
    final maxValue = _weeklyPatientData.values
        .map((data) => data.values.reduce((a, b) => a > b ? a : b))
        .reduce((a, b) => a > b ? a : b);
    
    return Column(
      children: [
        // Legend
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLegendItem('OPD', Colors.blue),
            const SizedBox(width: 16),
            _buildLegendItem('IPD', Colors.green),
            const SizedBox(width: 16),
            _buildLegendItem('Emergency', Colors.orange),
          ],
        ),
        const SizedBox(height: 16),
        
        // Chart
        SizedBox(
          height: 220,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: _weeklyPatientData.entries.map((entry) {
              final day = entry.key;
              final data = entry.value;
              final opd = data['OPD']!;
              final ipd = data['IPD']!;
              final emergency = data['Emergency']!;
              
              return Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 6,
                          height: (emergency / maxValue) * 150,
                          margin: const EdgeInsets.only(right: 1),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        Container(
                          width: 6,
                          height: (ipd / maxValue) * 150,
                          margin: const EdgeInsets.symmetric(horizontal: 1),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        Container(
                          width: 6,
                          height: (opd / maxValue) * 150,
                          margin: const EdgeInsets.only(left: 1),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(day, style: const TextStyle(fontSize: 10)),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        
        // Bottom labels
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text('0', style: const TextStyle(fontSize: 10)),
            Text('${(maxValue/4).toInt()}', style: const TextStyle(fontSize: 10)),
            Text('${(maxValue/2).toInt()}', style: const TextStyle(fontSize: 10)),
            Text('${(maxValue*3/4).toInt()}', style: const TextStyle(fontSize: 10)),
            Text('$maxValue', style: const TextStyle(fontSize: 10)),
          ],
        ),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
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
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Color _getWardColor(String ward) {
    switch (ward) {
      case 'Emergency':
        return Colors.red;
      case 'ICU Ward':
        return Colors.orange;
      case 'Semi-Private':
        return Colors.blue;
      case 'Private':
        return Colors.green;
      default:
        return AppColors.primary;
    }
  }

  Widget _buildInboxScreen() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppConstants.cardRadius),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Inbox',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ..._inboxMessages.map((message) {
            Color priorityColor = Colors.grey;
            switch (message['priority']) {
              case 'high':
                priorityColor = AppColors.error;
                break;
              case 'medium':
                priorityColor = AppColors.warning;
                break;
              case 'low':
                priorityColor = AppColors.success;
                break;
            }

            return GestureDetector(
              onTap: () => _showAlertDetails(message),
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.circle,
                      color: priorityColor,
                      size: 8,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            message['title']!,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            message['description']!,
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          message['time']!,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 12,
                          color: AppColors.textSecondary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  void _showBillingSnapshot(String title) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$title - Detailed Snapshot'),
        content: SizedBox(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Detailed breakdown for the last 30 days:'),
              const SizedBox(height: 16),
              DataTable(
                columns: const [
                  DataColumn(label: Text('Category')),
                  DataColumn(label: Text('Count')),
                  DataColumn(label: Text('Change')),
                ],
                rows: [
                  DataRow(cells: [
                    const DataCell(Text('Hospitals')),
                    const DataCell(Text('30')),
                    DataCell(
                      Row(
                        children: [
                          const Icon(Icons.arrow_upward,
                              color: Colors.green, size: 16),
                          const SizedBox(width: 4),
                          Text('+2',
                              style: TextStyle(color: AppColors.success)),
                        ],
                      ),
                    ),
                  ]),
                  DataRow(cells: [
                    const DataCell(Text('Active Staff')),
                    const DataCell(Text('1247')),
                    DataCell(
                      Row(
                        children: [
                          const Icon(Icons.arrow_upward,
                              color: Colors.green, size: 16),
                          const SizedBox(width: 4),
                          Text('+45',
                              style: TextStyle(color: AppColors.success)),
                        ],
                      ),
                    ),
                  ]),
                  DataRow(cells: [
                    const DataCell(Text('Patients')),
                    const DataCell(Text('1247')),
                    DataCell(
                      Row(
                        children: [
                          const Icon(Icons.arrow_upward,
                              color: Colors.green, size: 16),
                          const SizedBox(width: 4),
                          Text('+89',
                              style: TextStyle(color: AppColors.success)),
                        ],
                      ),
                    ),
                  ]),
                  DataRow(cells: [
                    const DataCell(Text('Revenue')),
                    const DataCell(Text('\$2.4M')),
                    DataCell(
                      Row(
                        children: [
                          const Icon(Icons.arrow_upward,
                              color: Colors.green, size: 16),
                          const SizedBox(width: 4),
                          Text('+15%',
                              style: TextStyle(color: AppColors.success)),
                        ],
                      ),
                    ),
                  ]),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    _selectedNavItem = 'Analytics & Reports';
                  });
                },
                child: const Text('View Full Report'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showDetailedAnalytics(String title) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$title - Detailed Analytics'),
        content: SizedBox(
          width: 600,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Placeholder(
                fallbackHeight: 300,
                child: Center(child: Text('Detailed Analytics Chart')),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    _selectedNavItem = 'Analytics & Reports';
                  });
                },
                child: const Text('Open in Analytics Dashboard'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showActivePatientsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Currently Active Patients'),
        content: SizedBox(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (int i = 1; i <= 10; i++)
                ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.person)),
                  title: Text('Patient #${1000 + i}'),
                  subtitle: Text('Ward ${['A', 'B', 'C'][i % 3]} • Bed $i'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.pop(context);
                    _showPatientDetails(1000 + i);
                  },
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showStatDetails(String stat) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$stat Details'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Current $stat: ${_quickStats[stat]}'),
              const SizedBox(height: 16),
              const Text('Trend: Increasing over last 30 days'),
              const Text('Breakdown by department:'),
              const SizedBox(height: 8),
              const Text('- Cardiology: 25%'),
              const Text('- Emergency: 20%'),
              const Text('- General: 55%'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showStaffDetails(String type) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$type Details'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.people),
                title: Text('Total $type: 50'),
                subtitle: const Text('Active: 48 • On Leave: 2'),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    _selectedNavItem = 'Staff List';
                  });
                },
                child: const Text('View All Staff'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showActivityDetails(Map<String, String> activity) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Activity Details'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(activity['title']!),
              const SizedBox(height: 8),
              Text('Time: ${activity['time']}'),
              const SizedBox(height: 16),
              const Text('Additional Information:'),
              const Text('• User: Admin'),
              const Text('• Department: Administration'),
              const Text('• Action Type: Update'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showAlertDetails(Map<String, String> alert) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(alert['title']!),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(alert['description']!),
              const SizedBox(height: 16),
              const Text('Priority: High'),
              const Text('Status: Unread'),
              Text('Time: ${DateTime.now().toString()}'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  if (alert['title']!.contains('Medicine')) {
                    setState(() {
                      _selectedNavItem = 'Medicines';
                    });
                  } else if (alert['title']!.contains('Billing')) {
                    _showBillingSnapshot('Billing');
                  }
                },
                child: const Text('Take Action'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Mark as Read'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showPatientDetails(int patientId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Patient #$patientId Details'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Name: John Doe'),
              const Text('Age: 45'),
              const Text('Gender: Male'),
              const Text('Admission Date: 2024-01-15'),
              const Text('Ward: General Ward'),
              const Text('Doctor: Dr. Sarah Wilson'),
              const SizedBox(height: 16),
              const Text('Current Status: Stable'),
              const Text('Last Vital Signs: BP 120/80, Temp 98.6°F'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('View Full History'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}