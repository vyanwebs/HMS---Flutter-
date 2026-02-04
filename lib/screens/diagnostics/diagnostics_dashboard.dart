import 'package:flutter/material.dart';
import 'package:hms/screens/main_dashboard.dart';
import 'package:hms/screens/diagnostics/diagnostics_components/radiology_test_orders.dart';
import 'package:hms/screens/diagnostics/diagnostics_components/report_uploads.dart';
import 'package:hms/screens/diagnostics/diagnostics_components/dicom_viewer.dart';
import 'package:hms/screens/diagnostics/diagnostics_components/admin_profile.dart';
import 'package:hms/screens/diagnostics/diagnostics_components/diagnostics_settings.dart';
import 'package:hms/utils/constants.dart';

class DiagnosticsDashboard extends StatefulWidget {
  const DiagnosticsDashboard({super.key});

  // Static constants
  static const Color bg = Color(0xFFF6F8FB);
  static const Color sidebarBg = Colors.white;
  static const Color border = Color(0xFFE5E7EB);

  static const Color successBg = Color(0xFFD1FAE5);
  static const Color successText = Color(0xFF047857);
  static const Color dangerBg = Color(0xFFFEE2E2);
  static const Color dangerText = Color(0xFFB91C1C);
  static const Color warningBg = Color(0xFFFFEDD5);
  static const Color warningText = Color(0xFFC2410C);
  static const Color infoBg = Color(0xFFE0ECFF);
  static const Color infoText = Color(0xFF1D4ED8);

  @override
  State<DiagnosticsDashboard> createState() => _DiagnosticsDashboardState();
}

class _DiagnosticsDashboardState extends State<DiagnosticsDashboard> {
  String _selectedNavItem = 'Dashboard';
  bool _showProfileMenu = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DiagnosticsDashboard.bg,
      body: Row(
        children: [
          // Sidebar
          _buildSidebar(),
          
          // Main Content
          Expanded(
            child: Container(
              color: DiagnosticsDashboard.bg,
              child: Column(
                children: [
                  // Top Bar
                  _buildTopBar(),
                  
                  // Divider
                  Container(height: 1, color: DiagnosticsDashboard.border),
                  
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
    return Container(
      width: 260,
      padding: const EdgeInsets.all(20),
      color: DiagnosticsDashboard.sidebarBg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo
          Row(
            children: const [
              Icon(Icons.medical_services, color: AppColors.primary),
              SizedBox(width: 8),
              Text(
                'Docnex',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          
          // Navigation Items
          _buildNavItem(Icons.home, 'Home', 'Home'),
          _buildNavItem(Icons.inbox, 'Inbox', 'Inbox'),
          _buildNavItem(Icons.dashboard, 'Dashboard', 'Dashboard', active: _selectedNavItem == 'Dashboard'),
          
          const SizedBox(height: 20),
          
          // Operations Section
          const Padding(
            padding: EdgeInsets.only(left: 16, bottom: 8),
            child: Text(
              'DIAGNOSTIC OPERATIONS',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          
          _buildNavItem(Icons.science, 'Radiology Test Orders', 'Radiology'),
          _buildNavItem(Icons.upload_file, 'Report Uploads', 'Reports'),
          _buildNavItem(Icons.image, 'DICOM Viewer', 'DICOM'),
          
          const Spacer(),
          
          // Profile Section
          _buildNavItem(Icons.person, 'Admin profile', 'Profile'),
          _buildNavItem(Icons.settings, 'Setting', 'Settings'),
          
          // Logout Option
          if (_showProfileMenu)
            Container(
              margin: const EdgeInsets.only(top: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey.shade100,
              ),
              child: ListTile(
                dense: true,
                leading: const Icon(Icons.logout, size: 20, color: Colors.red),
                title: const Text('Logout', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const MainDashboard()),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, String navId, {bool active = false}) {
    return InkWell(
      onTap: () {
        if (label == 'Home') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainDashboard()),
          );
        } else if (label == 'Admin profile') {
          setState(() {
            _showProfileMenu = !_showProfileMenu;
          });
        } else {
          setState(() {
            _selectedNavItem = navId;
            _showProfileMenu = false;
          });
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        decoration: BoxDecoration(
          color: active ? AppColors.primary.withValues(alpha: 0.1) : null,
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          dense: true,
          leading: Icon(
            icon,
            size: 20,
            color: active ? AppColors.primary : AppColors.textSecondary,
          ),
          title: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: active ? AppColors.primary : AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      height: 70,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24),
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
                const Icon(Icons.search, color: Color(0xFF718096), size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search orders, patients...',
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
    );
  }

  String _getScreenTitle(String navItem) {
    switch (navItem) {
      case 'Dashboard':
        return 'Diagnostics Dashboard';
      case 'Radiology':
        return 'Radiology Test Orders';
      case 'Reports':
        return 'Report Uploads';
      case 'DICOM':
        return 'DICOM Viewer';
      case 'Profile':
        return 'Admin Profile';
      case 'Settings':
        return 'Diagnostics Settings';
      case 'Inbox':
        return 'Inbox';
      default:
        return 'Diagnostics Dashboard';
    }
  }

  Widget _buildSelectedContent() {
    switch (_selectedNavItem) {
      case 'Radiology':
        return const RadiologyTestOrdersScreen();
      case 'Reports':
        return const ReportUploadsScreen();
      case 'DICOM':
        return const DicomViewerScreen();
      case 'Profile':
        return const AdminProfileScreen();
      case 'Settings':
        return const DiagnosticsSettingsScreen();
      case 'Inbox':
        return _buildInboxScreen();
      case 'Dashboard':
      default:
        return _buildDashboardContent();
    }
  }

  Widget _buildDashboardContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const _Header(),
          const SizedBox(height: 24),
          const _Stats(),
          const SizedBox(height: 24),
          _Body(), // Removed const
        ],
      ),
    );
  }

  Widget _buildInboxScreen() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: DiagnosticsDashboard.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Inbox',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                ..._buildInboxItems(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildInboxItems() {
    return [
      _buildInboxItem(
        'New Test Order',
        'Dr. Sharma has requested a Chest X-Ray',
        '10 min ago',
        Icons.science,
        AppColors.primary,
      ),
      _buildInboxItem(
        'Report Ready for Review',
        'MRI report for patient John Smith is ready',
        '30 min ago',
        Icons.assignment,
        Colors.green,
      ),
      _buildInboxItem(
        'Emergency Case',
        'Emergency CT scan required in Radiology',
        '1 hour ago',
        Icons.warning,
        Colors.red,
      ),
      _buildInboxItem(
        'Equipment Maintenance',
        'CT Scanner 1 requires maintenance',
        '2 hours ago',
        Icons.build,
        Colors.orange,
      ),
    ];
  }

  Widget _buildInboxItem(String title, String description, String time, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: DiagnosticsDashboard.border),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                time,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF6B7280),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'New',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF2F80ED),
                    fontWeight: FontWeight.w600,
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

/* ================= HEADER ================= */

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          'Admin / Dashboard',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        const Spacer(),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const RadiologyTestOrdersScreen(),
              ),
            );
          },
          icon: const Icon(Icons.add),
          label: const Text('New order'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }
}

/* ================= STATS ================= */

class _Stats extends StatelessWidget {
  const _Stats();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: const [
        _StatCard('30', 'Total Orders Today',
            [Color(0xFF93C5FD), Color(0xFF60A5FA)]),
        _StatCard('7', 'Pending Tests',
            [Color(0xFF99F6E4), Color(0xFF5EEAD4)]),
        _StatCard('12', 'Reports Pending Upload',
            [Color(0xFF99F6E4), Color(0xFF67E8F9)]),
        _StatCard('9', 'Images Awaiting Review',
            [Color(0xFF86EFAC), Color(0xFF4ADE80)]),
        _StatCard('33', 'Emergency Cases',
            [Color(0xFFA5B4FC), Color(0xFF818CF8)]),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final List<Color> gradient;

  const _StatCard(this.value, this.label, this.gradient);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (label.contains('Total Orders') || label.contains('Pending Tests') || label.contains('Emergency Cases')) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const RadiologyTestOrdersScreen(),
            ),
          );
        } else if (label.contains('Reports Pending')) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ReportUploadsScreen(),
            ),
          );
        } else if (label.contains('Images Awaiting')) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const DicomViewerScreen(),
            ),
          );
        }
      },
      child: Container(
        width: 230,
        height: 110,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: gradient),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const Spacer(),
            Text(
              label,
              style: const TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ================= BODY ================= */

class _Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Expanded(flex: 3, child: _RecentOrders()),
        SizedBox(width: 24),
        Expanded(flex: 1, child: _RightPanel()),
      ],
    );
  }
}

/* ================= RECENT ORDERS ================= */

class _RecentOrders extends StatelessWidget {
  const _RecentOrders();

  @override
  Widget build(BuildContext context) {
    return _Card(
      title: 'Recent orders',
      child: Column(
        children: List.generate(6, (index) => _OrderRow(index: index)),
      ),
    );
  }
}

class _OrderRow extends StatelessWidget {
  final int index;

  const _OrderRow({required this.index});

  @override
  Widget build(BuildContext context) {
    final orders = ['RAD-2024-001', 'RAD-2024-002', 'RAD-2024-003', 'RAD-2024-004', 'RAD-2024-005', 'RAD-2024-006'];
    final patients = ['John Smith', 'Sarah Johnson', 'Robert Brown', 'Emily Davis', 'David Wilson', 'Lisa Anderson'];
    final tests = ['Chest X-Ray', 'MRI Brain', 'CT Abdomen', 'Ultrasound', 'X-Ray Spine', 'CT Chest'];
    final times = ['10:30 A.M.', '11:45 A.M.', '09:15 A.M.', '02:30 P.M.', '04:00 P.M.', '03:20 P.M.'];
    final isEmergency = [true, false, false, false, true, false];
    final isInProgress = [true, false, true, false, true, true];

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const RadiologyTestOrdersScreen(),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade200),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                orders[index],
                style: const TextStyle(fontSize: 13),
              ),
            ),
            Expanded(
              child: Text(
                patients[index],
                style: const TextStyle(fontSize: 13),
              ),
            ),
            Expanded(
              child: Text(
                tests[index],
                style: const TextStyle(fontSize: 13),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: isEmergency[index] 
                      ? DiagnosticsDashboard.dangerBg 
                      : DiagnosticsDashboard.successBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    isEmergency[index] ? 'Emergency' : 'Routine',
                    style: TextStyle(
                      fontSize: 12,
                      color: isEmergency[index] 
                          ? DiagnosticsDashboard.dangerText 
                          : DiagnosticsDashboard.successText,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Text(
                times[index],
                style: const TextStyle(fontSize: 13),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: isInProgress[index]
                      ? DiagnosticsDashboard.infoBg
                      : DiagnosticsDashboard.successBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    isInProgress[index] ? 'In-progress' : 'Completed',
                    style: TextStyle(
                      fontSize: 12,
                      color: isInProgress[index]
                          ? DiagnosticsDashboard.infoText
                          : DiagnosticsDashboard.successText,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RadiologyTestOrdersScreen(),
                        ),
                      );
                    },
                    child: const Icon(
                      Icons.remove_red_eye,
                      size: 18,
                      color: Color(0xFF2F80ED),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RadiologyTestOrdersScreen(),
                        ),
                      );
                    },
                    child: const Icon(
                      Icons.edit,
                      size: 18,
                      color: Color(0xFF2F80ED),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ================= RIGHT PANEL ================= */

class _RightPanel extends StatelessWidget {
  const _RightPanel();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        _QuickActions(),
        SizedBox(height: 16),
        _EquipmentStatus(),
      ],
    );
  }
}

/* ================= QUICK ACTIONS ================= */

class _QuickActions extends StatelessWidget {
  const _QuickActions();

  @override
  Widget build(BuildContext context) {
    return _Card(
      title: 'Quick Actions',
      child: Column(
        children: [
          _ActionBtn(
            '+ New emergency order',
            primary: true,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RadiologyTestOrdersScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: 10),
          _ActionBtn(
            'Search patient',
            onTap: () {
              // Implement search functionality
              print('Search patient clicked');
            },
          ),
          const SizedBox(height: 10),
          _ActionBtn(
            'Schedule appointment',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RadiologyTestOrdersScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: 10),
          _ActionBtn(
            'Export report',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ReportUploadsScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final String text;
  final bool primary;
  final VoidCallback onTap;

  const _ActionBtn(this.text, {this.primary = false, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: primary ? AppColors.primary : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8),
          border: primary ? null : Border.all(color: Colors.grey.shade300),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: primary ? Colors.white : Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}

/* ================= EQUIPMENT STATUS ================= */

class _EquipmentStatus extends StatelessWidget {
  const _EquipmentStatus();

  @override
  Widget build(BuildContext context) {
    return _Card(
      title: 'Equipment Status',
      child: Column(
        children: const [
          _Status('CT Scanner 1', 'Online',
              DiagnosticsDashboard.successBg, DiagnosticsDashboard.successText),
          SizedBox(height: 10),
          _Status('MRI Machine A', 'Connected',
              DiagnosticsDashboard.successBg, DiagnosticsDashboard.successText),
          SizedBox(height: 10),
          _Status('X-Ray Room 1', 'Maintenance',
              DiagnosticsDashboard.warningBg, DiagnosticsDashboard.warningText),
          SizedBox(height: 10),
          _Status('X-Ray Room 2', 'Up-to-date',
              DiagnosticsDashboard.successBg, DiagnosticsDashboard.successText),
        ],
      ),
    );
  }
}

class _Status extends StatelessWidget {
  final String name;
  final String status;
  final Color bg;
  final Color fg;

  const _Status(this.name, this.status, this.bg, this.fg);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to equipment management or show details
        print('Equipment status clicked: $name');
      },
      child: Row(
        children: [
          Expanded(
            child: Text(
              name,
              style: const TextStyle(fontSize: 13),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: fg.withValues(alpha: 0.3)),
            ),
            child: Text(
              status,
              style: TextStyle(color: fg, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

/* ================= CARD ================= */

class _Card extends StatelessWidget {
  final String title;
  final Widget child;

  const _Card({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: DiagnosticsDashboard.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}