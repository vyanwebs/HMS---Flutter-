import 'package:flutter/material.dart';
import 'package:hms/screens/main_dashboard.dart';
import 'package:hms/screens/dialysis/dialysis_components/session_tracking.dart';
import 'package:hms/screens/dialysis/dialysis_components/fluid_management.dart';
import 'package:hms/screens/dialysis/dialysis_components/consumables.dart';
import 'package:hms/screens/dialysis/dialysis_components/dialysis_billing.dart';
import 'package:hms/screens/dialysis/dialysis_components/admin_profile.dart';
import 'package:hms/screens/dialysis/dialysis_components/dialysis_settings.dart';

class DialysisDashboard extends StatefulWidget {
  const DialysisDashboard({super.key});

  // Static constants
  static const Color bg = Color(0xFFF6F8FB);
  static const Color sidebarBg = Colors.white;
  static const Color primary = Color(0xFF2F80ED);
  static const Color border = Color(0xFFE5E7EB);

  @override
  State<DialysisDashboard> createState() => _DialysisDashboardState();
}

class _DialysisDashboardState extends State<DialysisDashboard> {
  String _selectedNavItem = 'Dashboard';
  bool _showProfileMenu = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DialysisDashboard.bg,
      body: Row(
        children: [
          // Sidebar
          _buildSidebar(),
          
          // Main Content
          Expanded(
            child: Container(
              color: DialysisDashboard.bg,
              child: Column(
                children: [
                  // Top Bar
                  _buildTopBar(),
                  
                  // Divider
                  Container(height: 1, color: DialysisDashboard.border),
                  
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
      color: DialysisDashboard.sidebarBg,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo
          Row(
            children: [
              Image.asset(
                'assets/images/app_logo.png',
                height: 32,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.local_hospital, size: 32),
              ),
              const SizedBox(width: 10),
              const Text(
                'Docnex',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 32),
          
          // Navigation Items
          _buildNavItem(Icons.home, 'Home', 'Home'),
          _buildNavItem(Icons.mail_outline, 'Inbox', 'Inbox'),
          _buildNavItem(Icons.dashboard, 'Dashboard', 'Dashboard', active: _selectedNavItem == 'Dashboard'),
          
          const SizedBox(height: 20),
          
          // Operations Section
          const Padding(
            padding: EdgeInsets.only(left: 16, bottom: 8),
            child: Text(
              'DIALYSIS OPERATIONS',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF6B7280),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          
          _buildNavItem(Icons.timeline, 'Session tracking', 'Session'),
          _buildNavItem(Icons.water_drop_outlined, 'Fluid management', 'Fluid'),
          _buildNavItem(Icons.inventory_2_outlined, 'Consumables', 'Consumables'),
          _buildNavItem(Icons.receipt_long_outlined, 'Billing', 'Billing'),
          
          const Spacer(),
          
          // Profile Section
          _buildNavItem(Icons.person_outline, 'Admin profile', 'Profile'),
          _buildNavItem(Icons.settings_outlined, 'Setting', 'Settings'),
          
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
          color: active ? const Color(0xFFEAF2FF) : null,
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          dense: true,
          leading: Icon(
            icon,
            size: 20,
            color: active ? DialysisDashboard.primary : Colors.grey,
          ),
          title: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: active ? DialysisDashboard.primary : const Color(0xFF1F2937),
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
                      hintText: 'Search sessions, patients...',
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
        return 'Dialysis Dashboard';
      case 'Session':
        return 'Session Tracking';
      case 'Fluid':
        return 'Fluid Management';
      case 'Consumables':
        return 'Consumables';
      case 'Billing':
        return 'Dialysis Billing';
      case 'Profile':
        return 'Admin Profile';
      case 'Settings':
        return 'Dialysis Settings';
      case 'Inbox':
        return 'Inbox';
      default:
        return 'Dialysis Dashboard';
    }
  }

  Widget _buildSelectedContent() {
    switch (_selectedNavItem) {
      case 'Session':
        return const SessionTrackingScreen();
      case 'Fluid':
        return const FluidManagementScreen();
      case 'Consumables':
        return const ConsumablesScreen();
      case 'Billing':
        return const DialysisBillingScreen();
      case 'Profile':
        return const AdminProfileScreen();
      case 'Settings':
        return const DialysisSettingsScreen();
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
          const _BodyTop(),
          const SizedBox(height: 24),
          const _BottomSection(),
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
              border: Border.all(color: DialysisDashboard.border),
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
        'New Session Request',
        'Patient John Smith requires dialysis session',
        '10 min ago',
        Icons.timeline,
        DialysisDashboard.primary,
      ),
      _buildInboxItem(
        'Fluid Alert',
        'UV-Deviation detected for patient Sarah',
        '30 min ago',
        Icons.warning,
        Colors.red,
      ),
      _buildInboxItem(
        'Consumables Low Stock',
        'Dialyzers running low - reorder needed',
        '1 hour ago',
        Icons.inventory,
        Colors.orange,
      ),
      _buildInboxItem(
        'Billing Notification',
        'Payment received for session #DL-2024-001',
        '2 hours ago',
        Icons.payment,
        Colors.green,
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
        border: Border.all(color: DialysisDashboard.border),
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
                  color: DialysisDashboard.primary.withValues(alpha: 0.1),
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
        const Text('Admin / Dashboard',
            style: TextStyle(color: Colors.grey)),
        const Spacer(),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SessionTrackingScreen(),
              ),
            );
          },
          icon: const Icon(Icons.add),
          label: const Text('New order'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2F80ED),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
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
    return Row(
      children: const [
        _StatCard('30', 'Sessions Scheduled Today',
            [Color(0xFF7CB9F5), Color(0xFFB6D8FA)]),
        SizedBox(width: 16),
        _StatCard('7', 'Ongoing Sessions',
            [Color(0xFF79E0CF), Color(0xFFB7F3E9)]),
        SizedBox(width: 16),
        _StatCard('12', 'Completed Sessions',
            [Color(0xFF80F3F9), Color(0xFFBFFBFD)]),
        SizedBox(width: 16),
        _StatCard('9', 'Active Alerts',
            [Color(0xFF8FEF8A), Color(0xFFC8F7C5)]),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value, label;
  final List<Color> colors;
  const _StatCard(this.value, this.label, this.colors);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (label.contains('Sessions Scheduled') || label.contains('Ongoing Sessions') || label.contains('Completed Sessions')) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SessionTrackingScreen(),
              ),
            );
          } else if (label.contains('Active Alerts')) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const FluidManagementScreen(),
              ),
            );
          }
        },
        child: Container(
          height: 110,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: colors),
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
      ),
    );
  }
}

/* ================= TOP BODY ================= */

class _BodyTop extends StatelessWidget {
  const _BodyTop();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Expanded(flex: 3, child: _SessionsTable()),
        SizedBox(width: 24),
        Expanded(flex: 1, child: _RightPanel()),
      ],
    );
  }
}

/* ================= SESSION TABLE ================= */

class _SessionsTable extends StatelessWidget {
  const _SessionsTable();

  @override
  Widget build(BuildContext context) {
    return _Card(
      title: "Today's Dialysis Sessions",
      child: Column(
        children: List.generate(
          6,
          (index) => _SessionRow(index: index),
        ),
      ),
    );
  }
}

class _SessionRow extends StatelessWidget {
  final int index;

  const _SessionRow({required this.index});

  @override
  Widget build(BuildContext context) {
    final patients = ['John Smith', 'Sarah Johnson', 'Robert Brown', 'Emily Davis', 'David Wilson', 'Lisa Anderson'];
    final ids = ['P001234', 'P001235', 'P001236', 'P001237', 'P001238', 'P001239'];
    final machines = ['M-01\nB-03', 'M-02\nB-01', 'M-01\nB-02', 'M-03\nB-01', 'M-02\nB-03', 'M-01\nB-04'];
    final times = ['08:00 - 12:00', '09:00 - 13:00', '10:00 - 14:00', '11:00 - 15:00', '12:00 - 16:00', '13:00 - 17:00'];
    final statuses = ['Running', 'Scheduled', 'Completed', 'Running', 'Scheduled', 'Completed'];

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SessionTrackingScreen(),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    patients[index],
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    'ID: ${ids[index]}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Text(
                machines[index],
                style: const TextStyle(fontSize: 13),
              ),
            ),
            Expanded(
              child: Text(
                times[index],
                style: const TextStyle(fontSize: 13),
              ),
            ),
            Expanded(
              child: _StatusChip(statuses[index]),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SessionTrackingScreen(),
                  ),
                );
              },
              child: const Icon(
                Icons.remove_red_eye,
                size: 18,
                color: Color(0xFF2F80ED),
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SessionTrackingScreen(),
                  ),
                );
              },
              child: const Icon(
                Icons.refresh,
                size: 18,
                color: Color(0xFF2F80ED),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String text;
  const _StatusChip(this.text);

  @override
  Widget build(BuildContext context) {
    Color bg, fg;
    if (text == 'Completed') {
      bg = const Color(0xFFE8F9EE);
      fg = const Color(0xFF27AE60);
    } else if (text == 'Scheduled') {
      bg = const Color(0xFFFFF3E6);
      fg = const Color(0xFFF2994A);
    } else {
      bg = const Color(0xFFEAF2FF);
      fg = const Color(0xFF2F80ED);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: fg.withValues(alpha: 0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(color: fg, fontSize: 12),
        textAlign: TextAlign.center,
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
        _Alerts(),
        SizedBox(height: 16),
        _QuickActions(),
      ],
    );
  }
}

/* ================= ALERTS ================= */

class _Alerts extends StatelessWidget {
  const _Alerts();

  @override
  Widget build(BuildContext context) {
    return _Card(
      title: 'Critical Fluid Alerts',
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FluidManagementScreen(),
                ),
              );
            },
            child: const _AlertItem('John Smith', 'UV-Deviation',
                'Fluid removal 15% below target'),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FluidManagementScreen(),
                ),
              );
            },
            child: const _AlertItem('Sarah Johnson', 'Hypotension Risk',
                'BP dropping rapidly during UF'),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FluidManagementScreen(),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF2F80ED).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'View all alerts',
                    style: TextStyle(
                      color: Color(0xFF2F80ED),
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  SizedBox(width: 6),
                  Icon(
                    Icons.arrow_forward,
                    color: Color(0xFF2F80ED),
                    size: 14,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AlertItem extends StatelessWidget {
  final String name, tag, desc;
  const _AlertItem(this.name, this.tag, this.desc);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.redAccent),
        color: const Color(0xFFFFF5F5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning, color: Colors.red, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$name • $tag',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  desc,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/* ================= QUICK ACTIONS (2x2 GRID) ================= */

class _QuickActions extends StatelessWidget {
  const _QuickActions();

  @override
  Widget build(BuildContext context) {
    return _Card(
      title: 'Quick Actions',
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _ActionTile(
                  'Start new session',
                  Icons.timer,
                  const Color(0xFFEAF2FF),
                  const Color(0xFF2F80ED),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SessionTrackingScreen(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ActionTile(
                  'Upload Fluids',
                  Icons.upload,
                  const Color(0xFFE8F9EE),
                  const Color(0xFF27AE60),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FluidManagementScreen(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _ActionTile(
                  'Issue consumables',
                  Icons.inventory,
                  const Color(0xFFFFF3E6),
                  const Color(0xFFF2994A),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ConsumablesScreen(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ActionTile(
                  'View billing',
                  Icons.receipt_long,
                  const Color(0xFFFFF9E6),
                  const Color(0xFFF2C94C),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DialysisBillingScreen(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color bg, color;
  final VoidCallback onTap;

  const _ActionTile(this.text, this.icon, this.bg, this.color, {required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ================= BOTTOM SECTION ================= */

class _BottomSection extends StatelessWidget {
  const _BottomSection();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(flex: 2, child: _Consumables()),
        SizedBox(width: 24),
        Expanded(flex: 1, child: _Billing()),
      ],
    );
  }
}

/* ================= CONSUMABLES ================= */

class _Consumables extends StatelessWidget {
  const _Consumables();

  @override
  Widget build(BuildContext context) {
    return _Card(
      title: 'Consumable Status',
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ConsumablesScreen(),
                ),
              );
            },
            child: const _StockRow('Dialyzers (High-Flux)', 45, 50, low: true),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ConsumablesScreen(),
                ),
              );
            },
            child: const _StockRow('Tubing Sets', 100, 100),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ConsumablesScreen(),
                ),
              );
            },
            child: const _StockRow('Heparin Syringes', 120, 100),
          ),
        ],
      ),
    );
  }
}

class _StockRow extends StatelessWidget {
  final String name;
  final int current, min;
  final bool low;
  const _StockRow(this.name, this.current, this.min, {this.low = false});

  @override
  Widget build(BuildContext context) {
    final percent = current / min;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              name,
              style: const TextStyle(fontSize: 13),
            ),
            const Spacer(),
            Text(
              low ? 'Low-stock' : 'Good',
              style: TextStyle(
                color: low ? Colors.red : Colors.green,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        LinearProgressIndicator(
          value: percent > 1 ? 1 : percent,
          color: low ? Colors.red : Colors.green,
          backgroundColor: Colors.grey.shade200,
          minHeight: 6,
          borderRadius: BorderRadius.circular(3),
        ),
        const SizedBox(height: 4),
        Text(
          'Current: $current  |  Min required: $min',
          style: const TextStyle(fontSize: 11, color: Colors.grey),
        ),
      ],
    );
  }
}

/* ================= BILLING ================= */

class _Billing extends StatelessWidget {
  const _Billing();

  @override
  Widget build(BuildContext context) {
    return _Card(
      title: 'Billing Snapshot',
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DialysisBillingScreen(),
                ),
              );
            },
            child: const _BillingTile('7', 'Sessions billed today', '\$12,800 revenue',
                Color(0xFFE8F9EE)),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DialysisBillingScreen(),
                ),
              );
            },
            child: const _BillingTile('3', 'Pending bills', '\$6,400 pending',
                Color(0xFFFFF3E6)),
          ),
        ],
      ),
    );
  }
}

class _BillingTile extends StatelessWidget {
  final String count, title, subtitle;
  final Color bg;
  const _BillingTile(this.count, this.title, this.subtitle, this.bg);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Text(
            count,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                ),
              ],
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
        border: Border.all(color: const Color(0xFFE5E7EB)),
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