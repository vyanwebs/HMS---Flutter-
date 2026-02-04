import 'package:flutter/material.dart';
import 'package:hms/screens/main_dashboard.dart';
import 'package:hms/screens/pharmacy/pharmacy_components/prescription_processing.dart';
import 'package:hms/screens/pharmacy/pharmacy_components/medicine_inventory.dart';
import 'package:hms/screens/pharmacy/pharmacy_components/batch_expiry_alerts.dart';
import 'package:hms/screens/pharmacy/pharmacy_components/opd_ipd_sales.dart';
import 'package:hms/screens/pharmacy/pharmacy_components/pharmacy_billing.dart';
import 'package:hms/screens/pharmacy/pharmacy_components/consumption_history.dart';
import 'package:hms/screens/pharmacy/pharmacy_components/admin_profile.dart';
import 'package:hms/screens/pharmacy/pharmacy_components/pharmacy_settings.dart';

class PharmacyDashboard extends StatefulWidget {
  const PharmacyDashboard({super.key});

  // Static constants
  static const Color bg = Color(0xFFF6F8FB);
  static const Color sidebarBg = Colors.white;
  static const Color primary = Color(0xFF2F80ED);
  static const Color textDark = Color(0xFF1F2937);
  static const Color textMuted = Color(0xFF6B7280);
  static const Color border = Color(0xFFE5E7EB);

  @override
  State<PharmacyDashboard> createState() => _PharmacyDashboardState();
}

class _PharmacyDashboardState extends State<PharmacyDashboard> {
  String _selectedNavItem = 'Dashboard';
  bool _showProfileMenu = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PharmacyDashboard.bg,
      body: Row(
        children: [
          // Sidebar
          _buildSidebar(),

          // Main Content
          Expanded(
            child: Container(
              color: PharmacyDashboard.bg,
              child: Column(
                children: [
                  // Top Bar
                  _buildTopBar(),

                  // Divider
                  Container(height: 1, color: PharmacyDashboard.border),

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
      padding: const EdgeInsets.all(16),
      color: PharmacyDashboard.sidebarBg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo
          Row(
            children: [
              Image.asset(
                'assets/images/app_logo.png',
                height: 36,
                errorBuilder: (_, __, ___) => const SizedBox(height: 36),
              ),
              const SizedBox(width: 10),
              const Text(
                'Docnex',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: PharmacyDashboard.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Navigation Items
          _buildNavItem(Icons.home, 'Home', 'Home'),
          _buildNavItem(Icons.inbox, 'Inbox', 'Inbox'),
          _buildNavItem(Icons.dashboard, 'Dashboard', 'Dashboard',
              active: _selectedNavItem == 'Dashboard'),

          const SizedBox(height: 16),

          // Operations Section
          const Padding(
            padding: EdgeInsets.only(left: 16, bottom: 8),
            child: Text(
              'OPERATIONS',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF6B7280),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          _buildNavItem(
              Icons.receipt_long, 'Prescription processing', 'Prescription'),
          _buildNavItem(Icons.inventory, 'Medicine inventory', 'Inventory'),
          _buildNavItem(Icons.warning_amber, 'Batch/Expiry/Alert', 'Alerts'),
          _buildNavItem(Icons.point_of_sale, 'OPD/IPD sales', 'Sales'),
          _buildNavItem(Icons.payment, 'Pharmacy billing', 'Billing'),
          _buildNavItem(Icons.history, 'Consumption history', 'History'),

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
                title:
                    const Text('Logout', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MainDashboard()),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, String navId,
      {bool active = false}) {
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
        margin: const EdgeInsets.only(bottom: 4),
        decoration: BoxDecoration(
          color: active ? const Color(0xFFEAF2FF) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          dense: true,
          leading: Icon(
            icon,
            size: 20,
            color: active
                ? PharmacyDashboard.primary
                : PharmacyDashboard.textMuted,
          ),
          title: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: active
                  ? PharmacyDashboard.primary
                  : PharmacyDashboard.textDark,
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
                      hintText: 'Search medicines, prescriptions...',
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
        return 'Pharmacy Dashboard';
      case 'Prescription':
        return 'Prescription Processing';
      case 'Inventory':
        return 'Medicine Inventory';
      case 'Alerts':
        return 'Batch/Expiry Alerts';
      case 'Sales':
        return 'OPD/IPD Sales';
      case 'Billing':
        return 'Pharmacy Billing';
      case 'History':
        return 'Consumption History';
      case 'Profile':
        return 'Admin Profile';
      case 'Settings':
        return 'Pharmacy Settings';
      case 'Inbox':
        return 'Inbox';
      default:
        return 'Pharmacy Dashboard';
    }
  }

  Widget _buildSelectedContent() {
    switch (_selectedNavItem) {
      case 'Prescription':
        return const PrescriptionProcessingScreen();
      case 'Inventory':
        return const MedicineInventoryScreen();
      case 'Alerts':
        return const BatchExpiryAlertsScreen();
      case 'Sales':
        return const OpdIpdSalesScreen();
      case 'Billing':
        return const PharmacyBillingScreen();
      case 'History':
        return const ConsumptionHistoryScreen();
      case 'Profile':
        return const AdminProfileScreen();
      case 'Settings':
        return const PharmacySettingsScreen();
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
        children: const [
          _TopCards(),
          SizedBox(height: 24),
          _MiddleSection(),
          SizedBox(height: 24),
          _BottomSection(),
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
              border: Border.all(color: PharmacyDashboard.border),
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
        'Prescription Approval',
        'Dr. Sharma has sent a new prescription for review',
        '10 min ago',
        Icons.receipt_long,
        PharmacyDashboard.primary,
      ),
      _buildInboxItem(
        'Low Stock Alert',
        'Paracetamol 500mg stock is below minimum level',
        '30 min ago',
        Icons.warning_amber,
        Colors.orange,
      ),
      _buildInboxItem(
        'Expiry Alert',
        'Amoxicillin batch expires in 15 days',
        '1 hour ago',
        Icons.warning,
        Colors.red,
      ),
      _buildInboxItem(
        'Billing Query',
        'Query regarding invoice #PH-2024-00123',
        '2 hours ago',
        Icons.payment,
        Colors.green,
      ),
    ];
  }

  Widget _buildInboxItem(String title, String description, String time,
      IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: PharmacyDashboard.border),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: PharmacyDashboard.primary.withValues(alpha: 0.1),
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

/* ================= TOP CARDS ================= */

class _TopCards extends StatelessWidget {
  const _TopCards();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        _StatCard('30', 'Prescriptions Pending',
            [Color(0xFF6BB5FF), Color(0xFF9ED0FF)]),
        SizedBox(width: 16),
        _StatCard(
            '7', 'Low Stock Medicines', [Color(0xFF5FE3C3), Color(0xFF9BF0DA)]),
        SizedBox(width: 16),
        _StatCard('24', 'Expiring Soon Batches',
            [Color(0xFF7EF2F2), Color(0xFFB6FAFA)]),
        SizedBox(width: 16),
        _StatCard('₹80,000', "Today's Pharmacy Sales",
            [Color(0xFF8EE37D), Color(0xFFB7F2A6)]),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final List<Color> colors;

  const _StatCard(this.value, this.label, this.colors);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          // Navigate based on card type
          if (label.contains('Prescriptions')) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PrescriptionProcessingScreen(),
              ),
            );
          } else if (label.contains('Low Stock')) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const BatchExpiryAlertsScreen(),
              ),
            );
          } else if (label.contains('Expiring')) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const BatchExpiryAlertsScreen(),
              ),
            );
          } else if (label.contains('Sales')) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const OpdIpdSalesScreen(),
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
                  fontSize: 14,
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

/* ================= MIDDLE ================= */

class _MiddleSection extends StatelessWidget {
  const _MiddleSection();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Expanded(flex: 3, child: _PendingPrescriptions()),
        SizedBox(width: 24),
        Expanded(flex: 1, child: _CriticalAlerts()),
      ],
    );
  }
}

/* ================= PENDING ================= */

class _PendingPrescriptions extends StatelessWidget {
  const _PendingPrescriptions();

  @override
  Widget build(BuildContext context) {
    return _Card(
      title: 'Pending Prescriptions',
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search, size: 18),
                    hintText: 'Search prescriptions...',
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 150, // Increased width to prevent overflow
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    hintText: 'Status',
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                  ),
                  value: 'all',
                  items: const [
                    DropdownMenuItem(value: 'all', child: Text('All')),
                    DropdownMenuItem(value: 'pending', child: Text('Pending')),
                    DropdownMenuItem(
                        value: 'processing', child: Text('Processing')),
                    DropdownMenuItem(value: 'ready', child: Text('Ready')),
                  ],
                  onChanged: (value) {
                    // Handle status filter
                    print('Filter by: $value');
                  },
                  icon: const Icon(Icons.arrow_drop_down, size: 20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          for (int i = 0; i < 5; i++) _PrescriptionRow(index: i),
        ],
      ),
    );
  }
}

class _PrescriptionRow extends StatelessWidget {
  final int index;

  const _PrescriptionRow({required this.index});

  @override
  Widget build(BuildContext context) {
    final patients = [
      'Michael Anderson',
      'Sarah Johnson',
      'Robert Brown',
      'Emily Davis',
      'David Wilson'
    ];
    final doctors = [
      'Dr Ankit Sharma',
      'Dr Priya Patel',
      'Dr Rohan Verma',
      'Dr Sneha Reddy',
      'Dr Amit Kumar'
    ];
    final departments = ['IPD', 'OPD', 'IPD', 'OPD', 'IPD'];
    final times = [
      '10:30 a.m.',
      '11:45 a.m.',
      '09:15 a.m.',
      '02:30 p.m.',
      '04:00 p.m.'
    ];

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const PrescriptionProcessingScreen(),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        child: ListTile(
          dense: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          title: Text(
            patients[index],
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            '${doctors[index]} • ${departments[index]} • ${times[index]}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF1E6),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: const Color(0xFFF2994A)),
                ),
                child: const Text(
                  'Pending',
                  style: TextStyle(color: Color(0xFFF2994A), fontSize: 11),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const PrescriptionProcessingScreen(),
                    ),
                  );
                },
                child: Container(
                  height: 32,
                  width: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2F80ED),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/* ================= ALERTS ================= */

class _CriticalAlerts extends StatelessWidget {
  const _CriticalAlerts();

  @override
  Widget build(BuildContext context) {
    return _Card(
      title: 'Critical Alerts',
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BatchExpiryAlertsScreen(),
                ),
              );
            },
            child: const _AlertBox(
              'Low Stock',
              'Paracetamol 500mg\n50 tablets',
              Color(0xFFFFEAEA),
              Colors.red,
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BatchExpiryAlertsScreen(),
                ),
              );
            },
            child: const _AlertBox(
              'Expiring Soon',
              'Paracetamol 500mg\n15 days',
              Color(0xFFFFF3E6),
              Colors.orange,
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BatchExpiryAlertsScreen(),
                ),
              );
            },
            child: const _AlertBox(
              'Stock Mismatch',
              'Paracetamol 500mg\nPhysical count mismatch',
              Color(0xFFEAF2FF),
              Colors.blue,
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BatchExpiryAlertsScreen(),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(12),
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

class _AlertBox extends StatelessWidget {
  final String title;
  final String desc;
  final Color bg;
  final Color borderColor;

  const _AlertBox(this.title, this.desc, this.bg, this.borderColor);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            desc,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

/* ================= BOTTOM ================= */

class _BottomSection extends StatelessWidget {
  const _BottomSection();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(flex: 3, child: _SalesSnapshot()),
        SizedBox(width: 24),
        Expanded(flex: 1, child: _BillingSnapshot()),
      ],
    );
  }
}

class _SalesSnapshot extends StatelessWidget {
  const _SalesSnapshot();

  @override
  Widget build(BuildContext context) {
    return _Card(
      title: 'Sales Snapshot',
      child: Column(
        children: const [
          _ProgressRow('OPD Sales Today', '₹28,450', 0.8),
          SizedBox(height: 12),
          _ProgressRow('IPD Issue Value', '₹18,920', 0.6),
          SizedBox(height: 12),
          _ProgressRow('Cash Payments', '₹35,670', 0.9),
          SizedBox(height: 12),
          _ProgressRow('Insurance Claims', '₹12,450', 0.4),
        ],
      ),
    );
  }
}

class _ProgressRow extends StatelessWidget {
  final String label;
  final String value;
  final double progress;

  const _ProgressRow(this.label, this.value, this.progress);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF6B7280),
                ),
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress,
          color: const Color(0xFF2F80ED),
          backgroundColor: Colors.grey.shade200,
          minHeight: 5,
          borderRadius: BorderRadius.circular(3),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}

class _BillingSnapshot extends StatelessWidget {
  const _BillingSnapshot();

  @override
  Widget build(BuildContext context) {
    return _Card(
      title: 'Quick Actions',
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.9, // Adjusted aspect ratio
        children: [
          _Action(
            'Process prescription',
            Icons.receipt_long,
            Colors.blue,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PrescriptionProcessingScreen(),
                ),
              );
            },
          ),
          _Action(
            'Add stock',
            Icons.add_box,
            Colors.green,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MedicineInventoryScreen(),
                ),
              );
            },
          ),
          _Action(
            'View alerts',
            Icons.notifications_active,
            Colors.red,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BatchExpiryAlertsScreen(),
                ),
              );
            },
          ),
          _Action(
            'Generate bills',
            Icons.receipt,
            Colors.orange,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PharmacyBillingScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _Action extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _Action(this.label, this.icon, this.color, {required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10,
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ================= COMMON ================= */

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
