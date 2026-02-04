import 'package:flutter/material.dart';
import 'package:hms/screens/main_dashboard.dart';
import 'package:hms/screens/insurance/insurance_components/claim_initiation.dart';
import 'package:hms/screens/insurance/insurance_components/pre_approval_management.dart';
import 'package:hms/screens/insurance/insurance_components/insurance_billing.dart';
import 'package:hms/screens/insurance/insurance_components/payment_tracking.dart';
import 'package:hms/screens/insurance/insurance_components/documentation_export.dart';
import 'package:hms/screens/insurance/insurance_components/admin_profile.dart';
import 'package:hms/screens/insurance/insurance_components/insurance_settings.dart';

class InsuranceDashboard extends StatefulWidget {
  const InsuranceDashboard({super.key});

  // Static constants
  static const Color bg = Color(0xFFF6F8FB);
  static const Color sidebarBg = Colors.white;
  static const Color primary = Color(0xFF2F80ED);
  static const Color textDark = Color(0xFF1F2937);
  static const Color textMuted = Color(0xFF6B7280);
  static const Color border = Color(0xFFE5E7EB);

  @override
  State<InsuranceDashboard> createState() => _InsuranceDashboardState();
}

class _InsuranceDashboardState extends State<InsuranceDashboard> {
  String _selectedNavItem = 'Dashboard';
  bool _showProfileMenu = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: InsuranceDashboard.bg,
      body: Row(
        children: [
          // Sidebar
          _buildSidebar(),
          
          // Main Content
          Expanded(
            child: Container(
              color: InsuranceDashboard.bg,
              child: Column(
                children: [
                  // Top Bar
                  _buildTopBar(),
                  
                  // Divider
                  Container(height: 1, color: InsuranceDashboard.border),
                  
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
      color: InsuranceDashboard.sidebarBg,
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
                  color: InsuranceDashboard.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          
          // Navigation Items
          _buildNavItem(Icons.home, 'Home', 'Home'),
          _buildNavItem(Icons.inbox, 'Inbox', 'Inbox'),
          _buildNavItem(Icons.dashboard, 'Dashboard', 'Dashboard', active: _selectedNavItem == 'Dashboard'),
          
          const SizedBox(height: 16),
          
          // Operations Section
          const Padding(
            padding: EdgeInsets.only(left: 16, bottom: 8),
            child: Text(
              'INSURANCE OPERATIONS',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF6B7280),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          
          _buildNavItem(Icons.assignment, 'Claim initiation', 'Claim'),
          _buildNavItem(Icons.fact_check, 'Pre approval management', 'PreApproval'),
          _buildNavItem(Icons.receipt_long, 'Insurance billing', 'Billing'),
          _buildNavItem(Icons.payments, 'Payment tracking', 'Payment'),
          _buildNavItem(Icons.description, 'Documentation export', 'Documentation'),
          
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
            color: active ? InsuranceDashboard.primary : InsuranceDashboard.textMuted,
          ),
          title: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: active ? InsuranceDashboard.primary : InsuranceDashboard.textDark,
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
                      hintText: 'Search claims, patients...',
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
        return 'Insurance Dashboard';
      case 'Claim':
        return 'Claim Initiation';
      case 'PreApproval':
        return 'Pre-Approval Management';
      case 'Billing':
        return 'Insurance Billing';
      case 'Payment':
        return 'Payment Tracking';
      case 'Documentation':
        return 'Documentation Export';
      case 'Profile':
        return 'Admin Profile';
      case 'Settings':
        return 'Insurance Settings';
      case 'Inbox':
        return 'Inbox';
      default:
        return 'Insurance Dashboard';
    }
  }

  Widget _buildSelectedContent() {
    switch (_selectedNavItem) {
      case 'Claim':
        return const ClaimInitiationScreen();
      case 'PreApproval':
        return const PreApprovalManagementScreen();
      case 'Billing':
        return const InsuranceBillingScreen();
      case 'Payment':
        return const PaymentTrackingScreen();
      case 'Documentation':
        return const DocumentationExportScreen();
      case 'Profile':
        return const AdminProfileScreen();
      case 'Settings':
        return const InsuranceSettingsScreen();
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
          _TopStats(),
          SizedBox(height: 24),
          _MainSection(),
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
              border: Border.all(color: InsuranceDashboard.border),
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
        'Claim Approval Request',
        'New claim requires your approval for patient John Smith',
        '10 min ago',
        Icons.assignment,
        InsuranceDashboard.primary,
      ),
      _buildInboxItem(
        'Pre-Approval Expiring',
        'Pre-approval for cardiac surgery expires in 2 days',
        '30 min ago',
        Icons.warning,
        Colors.orange,
      ),
      _buildInboxItem(
        'Payment Received',
        'Payment of ₹75,000 received for claim CLM-2024-001',
        '1 hour ago',
        Icons.payment,
        Colors.green,
      ),
      _buildInboxItem(
        'Documentation Query',
        'Insurance company requesting additional documents',
        '2 hours ago',
        Icons.description,
        Colors.red,
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
        border: Border.all(color: InsuranceDashboard.border),
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
                  color: InsuranceDashboard.primary.withValues(alpha: 0.1),
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

/* ================= TOP STATS ================= */

class _TopStats extends StatelessWidget {
  const _TopStats();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        _StatCard('30', 'Claims Created Today',
            [Color(0xFF6BB5FF), Color(0xFF9ED0FF)]),
        SizedBox(width: 16),
        _StatCard('7', 'Pending Pre-Approvals',
            [Color(0xFF5FE3C3), Color(0xFF9BF0DA)]),
        SizedBox(width: 16),
        _StatCard('24', 'Bills Submitted',
            [Color(0xFF7EF2F2), Color(0xFFB6FAFA)]),
        SizedBox(width: 16),
        _StatCard('₹18.5L', 'Payments Received',
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
          if (label.contains('Claims Created')) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ClaimInitiationScreen(),
              ),
            );
          } else if (label.contains('Pre-Approvals')) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PreApprovalManagementScreen(),
              ),
            );
          } else if (label.contains('Bills Submitted')) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const InsuranceBillingScreen(),
              ),
            );
          } else if (label.contains('Payments Received')) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PaymentTrackingScreen(),
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

/* ================= MAIN ================= */

class _MainSection extends StatelessWidget {
  const _MainSection();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Expanded(
          flex: 3,
          child: Column(
            children: [
              _RecentClaims(),
              SizedBox(height: 24),
              _BillingSnapshot(),
            ],
          ),
        ),
        SizedBox(width: 24),
        Expanded(flex: 1, child: _RightColumn()),
      ],
    );
  }
}

/* ================= RECENT CLAIMS ================= */

class _RecentClaims extends StatelessWidget {
  const _RecentClaims();

  @override
  Widget build(BuildContext context) {
    return _Card(
      title: 'Recent Claims',
      child: Column(
        children: [
          _header(),
          const SizedBox(height: 12),
          _tableHeader(),
          for (int i = 0; i < 5; i++) _ClaimRow(index: i),
        ],
      ),
    );
  }

  Widget _header() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search, size: 18),
              hintText: 'Search claims...',
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
          width: 160,
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              hintText: 'All',
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
              DropdownMenuItem(value: 'approved', child: Text('Approved')),
              DropdownMenuItem(value: 'rejected', child: Text('Rejected')),
            ],
            onChanged: (value) {
              // Handle status filter
              print('Filter by: $value');
            },
            icon: const Icon(Icons.arrow_drop_down, size: 20),
          ),
        )
      ],
    );
  }

  Widget _tableHeader() {
    return Container(
      padding: const EdgeInsets.all(12),
      color: Colors.grey.shade200,
      child: const Row(
        children: [
          Expanded(flex: 2, child: Text('Patient')),
          Expanded(flex: 2, child: Text('Insurance/TPA')),
          Expanded(flex: 2, child: Text('Claim ID')),
          Expanded(flex: 2, child: Text('Status')),
          Expanded(flex: 2, child: Text('Amount')),
          Expanded(flex: 1, child: Text('Actions')),
        ],
      ),
    );
  }
}

class _ClaimRow extends StatelessWidget {
  final int index;

  const _ClaimRow({required this.index});

  @override
  Widget build(BuildContext context) {
    final patients = ['John Smith', 'Sarah Johnson', 'Robert Brown', 'Emily Davis', 'David Wilson'];
    final ids = ['P001234', 'P001235', 'P001236', 'P001237', 'P001238'];
    final insurers = ['Star Health Insurance', 'ICICI Lombard', 'HDFC ERGO', 'Max Bupa', 'Reliance Health'];
    final claimIds = ['CLM-2024-001', 'CLM-2024-002', 'CLM-2024-003', 'CLM-2024-004', 'CLM-2024-005'];
    final amounts = ['₹75,000', '₹1,20,000', '₹45,000', '₹89,500', '₹65,000'];

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ClaimInitiationScreen(),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade200),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    patients[index],
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    'ID: ${ids[index]}',
                    style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                insurers[index],
                style: const TextStyle(fontSize: 13),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                claimIds[index],
                style: const TextStyle(fontSize: 13),
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEAD1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Pending',
                  style: TextStyle(fontSize: 11),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                amounts[index],
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ClaimInitiationScreen(),
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
                          builder: (context) => const ClaimInitiationScreen(),
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

/* ================= RIGHT COLUMN ================= */

class _RightColumn extends StatelessWidget {
  const _RightColumn();

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
      title: 'Pre Approval Alerts',
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PreApprovalManagementScreen(),
                ),
              );
            },
            child: const _AlertItem(
              'Pre-approval pending > 24 hrs',
              'Cardiac surgery pre-approval',
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PreApprovalManagementScreen(),
                ),
              );
            },
            child: const _AlertItem(
              'Missing documents',
              'Discharge summary and final bill',
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PreApprovalManagementScreen(),
                ),
              );
            },
            child: const _AlertItem(
              'Insurer query',
              'Additional investigation reports',
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PreApprovalManagementScreen(),
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
  final String title;
  final String desc;

  const _AlertItem(this.title, this.desc);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEAEA),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red),
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
            style: const TextStyle(fontSize: 11),
          ),
        ],
      ),
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
            'Create new claim',
            Icons.add,
            Colors.blue,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ClaimInitiationScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: 10),
          _ActionBtn(
            'Upload pre approval doc.',
            Icons.upload,
            Colors.orange,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PreApprovalManagementScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: 10),
          _ActionBtn(
            'Generate insurance bill',
            Icons.receipt,
            Colors.amber,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const InsuranceBillingScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: 10),
          _ActionBtn(
            'Documentation Export',
            Icons.cloud_upload,
            Colors.green,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DocumentationExportScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

/* ================= BILLING SNAPSHOT ================= */

class _BillingSnapshot extends StatelessWidget {
  const _BillingSnapshot();

  @override
  Widget build(BuildContext context) {
    return _Card(
      title: 'Billing & Payment Snapshot',
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          _CircleStat('Amount Claimed', '₹24.5L', Icons.person),
          _CircleStat('Amount Approved', '₹18.2L', Icons.check_circle),
          _CircleStat('Amount Received', '₹16.8L', Icons.trending_up),
          _CircleStat('Outstanding Amount', '₹7.7L', Icons.receipt),
        ],
      ),
    );
  }
}

class _CircleStat extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _CircleStat(this.label, this.value, this.icon);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const PaymentTrackingScreen(),
          ),
        );
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 34,
            backgroundColor: Colors.grey.shade200,
            child: Icon(icon, color: const Color(0xFF2F80ED), size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}

/* ================= COMMON ================= */

class _ActionBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionBtn(this.label, this.icon, this.color, {required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: color,
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

class _Card extends StatelessWidget {
  final String title;
  final Widget child;

  const _Card({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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