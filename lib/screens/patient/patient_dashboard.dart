import 'package:flutter/material.dart';

import '../main_dashboard.dart';

class PatientDashboard extends StatefulWidget {
  const PatientDashboard({super.key});

  static const bg = Color(0xFFF6F8FB);
  static const primary = Color(0xFF2F80ED);
  static const muted = Color(0xFF6B7280);
  static const dark = Color(0xFF1F2937);
  static const border = Color(0xFFE5E7EB);
  static const danger = Color(0xFFF04438);

  @override
  State<PatientDashboard> createState() => _PatientDashboardState();
}

class _PatientDashboardState extends State<PatientDashboard> {
  String _selectedNavItem = 'Dashboard';
  bool _showProfileMenu = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PatientDashboard.bg,
      body: Row(
        children: [
          _Sidebar(
            selectedNavItem: _selectedNavItem,
            onNavItemSelected: (item) {
              setState(() {
                _selectedNavItem = item;
              });
            },
            showProfileMenu: _showProfileMenu,
            onProfileMenuToggle: () {
              setState(() {
                _showProfileMenu = !_showProfileMenu;
              });
            },
          ),
          Expanded(
            child: Column(
              children: [
                _TopBar(
                  onBookAppointment: () {
                    _navigateToScreen(context, 'Online Appointments');
                  },
                ),
                Divider(height: 1, color: PatientDashboard.border),
                Expanded(child: _Content(selectedNavItem: _selectedNavItem)),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _navigateToScreen(BuildContext context, String screenName) {
    switch (screenName) {
      case 'Online Appointments':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => _PatientAppointmentsScreen(),
          ),
        );
        break;
      case 'Teleconsultation':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => _TeleconsultationScreen(),
          ),
        );
        break;
      case 'Lab Results':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => _LabResultsScreen(),
          ),
        );
        break;
      case 'e-Prescriptions':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => _EPrescriptionsScreen(),
          ),
        );
        break;
      case 'Bills & Payments':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => _BillsPaymentsScreen(),
          ),
        );
        break;
      case 'Health Reminders':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => _HealthRemindersScreen(),
          ),
        );
        break;
      case 'Emergency SOS':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => _EmergencySOSScreen(),
          ),
        );
        break;
      case 'Admin Profile':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => _AdminProfileScreen(),
          ),
        );
        break;
      case 'Setting':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => _PatientSettingsScreen(),
          ),
        );
        break;
    }
  }
}

/* ================= SIDEBAR ================= */

class _Sidebar extends StatelessWidget {
  final String selectedNavItem;
  final Function(String) onNavItemSelected;
  final bool showProfileMenu;
  final VoidCallback onProfileMenuToggle;

  const _Sidebar({
    required this.selectedNavItem,
    required this.onNavItemSelected,
    required this.showProfileMenu,
    required this.onProfileMenuToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo Section
          GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const MainDashboard(),
                ),
              );
            },
            child: Row(
              children: const [
                Icon(Icons.local_hospital, color: PatientDashboard.primary, size: 32),
                SizedBox(width: 10),
                Text(
                  'Docnex',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: PatientDashboard.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          
          // Navigation Items
          _NavItem(
            Icons.home,
            'Home',
            active: selectedNavItem == 'Home',
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => MainDashboard(),
                ),
              );
            },
          ),
          _NavItem(
            Icons.mail_outline,
            'Inbox',
            active: selectedNavItem == 'Inbox',
            onTap: () => onNavItemSelected('Inbox'),
          ),
          _NavItem(
            Icons.dashboard,
            'Dashboard',
            active: selectedNavItem == 'Dashboard',
            onTap: () => onNavItemSelected('Dashboard'),
          ),
          
          const SizedBox(height: 16),
          
          // CARE & APPOINTMENTS Section
          _Section('CARE & APPOINTMENTS'),
          _NavItem(
            Icons.calendar_today,
            'Online Appointments',
            active: selectedNavItem == 'Online Appointments',
            onTap: () {
              final state = context.findAncestorStateOfType<_PatientDashboardState>();
              state?._navigateToScreen(context, 'Online Appointments');
            },
          ),
          _NavItem(
            Icons.video_call,
            'Teleconsultation',
            active: selectedNavItem == 'Teleconsultation',
            onTap: () {
              final state = context.findAncestorStateOfType<_PatientDashboardState>();
              state?._navigateToScreen(context, 'Teleconsultation');
            },
          ),
          
          const SizedBox(height: 16),
          
          // MEDICAL RECORDS Section
          _Section('MEDICAL RECORDS'),
          _NavItem(
            Icons.science,
            'Lab Results',
            active: selectedNavItem == 'Lab Results',
            onTap: () {
              final state = context.findAncestorStateOfType<_PatientDashboardState>();
              state?._navigateToScreen(context, 'Lab Results');
            },
          ),
          _NavItem(
            Icons.receipt_long,
            'e-Prescriptions',
            active: selectedNavItem == 'e-Prescriptions',
            onTap: () {
              final state = context.findAncestorStateOfType<_PatientDashboardState>();
              state?._navigateToScreen(context, 'e-Prescriptions');
            },
          ),
          
          const SizedBox(height: 16),
          
          // BILLING Section
          _Section('BILLING'),
          _NavItem(
            Icons.payment,
            'Bills & Payments',
            active: selectedNavItem == 'Bills & Payments',
            onTap: () {
              final state = context.findAncestorStateOfType<_PatientDashboardState>();
              state?._navigateToScreen(context, 'Bills & Payments');
            },
          ),
          _NavItem(
            Icons.notifications,
            'Health Reminders',
            active: selectedNavItem == 'Health Reminders',
            onTap: () {
              final state = context.findAncestorStateOfType<_PatientDashboardState>();
              state?._navigateToScreen(context, 'Health Reminders');
            },
          ),
          _NavItem(
            Icons.warning,
            'Emergency SOS',
            active: selectedNavItem == 'Emergency SOS',
            onTap: () {
              final state = context.findAncestorStateOfType<_PatientDashboardState>();
              state?._navigateToScreen(context, 'Emergency SOS');
            },
          ),
          
          const Spacer(),
          
          // Profile and Settings
          _NavItem(
            Icons.person,
            'Admin Profile',
            active: selectedNavItem == 'Admin Profile',
            onTap: () {
              final state = context.findAncestorStateOfType<_PatientDashboardState>();
              state?._navigateToScreen(context, 'Admin Profile');
            },
          ),
          _NavItem(
            Icons.settings,
            'Setting',
            active: selectedNavItem == 'Setting',
            onTap: () {
              final state = context.findAncestorStateOfType<_PatientDashboardState>();
              state?._navigateToScreen(context, 'Setting');
            },
          ),
          
          // Profile Menu (Bottom Section)
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: PatientDashboard.border)),
              color: Colors.white,
            ),
            child: Column(
              children: [
                ListTile(
                  dense: true,
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: PatientDashboard.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(Icons.person, color: PatientDashboard.primary),
                  ),
                  title: const Text(
                    'Patient User',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: PatientDashboard.dark,
                    ),
                  ),
                  subtitle: Text(
                    'patient@docnex.com',
                    style: TextStyle(
                      fontSize: 12,
                      color: PatientDashboard.muted,
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      showProfileMenu ? Icons.expand_less : Icons.expand_more,
                      color: PatientDashboard.muted,
                    ),
                    onPressed: onProfileMenuToggle,
                  ),
                ),
                
                if (showProfileMenu)
                  Column(
                    children: [
                      Divider(height: 1, color: PatientDashboard.border),
                      ListTile(
                        dense: true,
                        leading: Icon(Icons.logout, size: 20, color: PatientDashboard.danger),
                        title: const Text(
                          'Logout',
                          style: TextStyle(color: PatientDashboard.danger),
                        ),
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MainDashboard(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String text;
  const _Section(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(fontSize: 11, color: PatientDashboard.muted),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _NavItem(this.icon, this.label, {
    this.active = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: active ? const Color(0xFFEAF2FF) : null,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        dense: true,
        leading: Icon(icon, size: 20, color: active ? PatientDashboard.primary : PatientDashboard.muted),
        title: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: active ? PatientDashboard.primary : PatientDashboard.dark,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}

/* ================= TOP BAR ================= */

class _TopBar extends StatelessWidget {
  final VoidCallback onBookAppointment;
  
  const _TopBar({required this.onBookAppointment});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      color: Colors.white,
      child: Row(
        children: [
          const Text(
            'Patient / Dashboard',
            style: TextStyle(fontSize: 14, color: PatientDashboard.muted),
          ),
          const Spacer(),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: PatientDashboard.primary,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            ),
            onPressed: onBookAppointment,
            child: const Text('Book new appointment'),
          ),
          
          // Notification Icon
          IconButton(
            icon: Badge(
              label: const Text('3'),
              child: const Icon(Icons.notifications_none, color: PatientDashboard.muted),
            ),
            onPressed: () {
              final state = context.findAncestorStateOfType<_PatientDashboardState>();
              state?._navigateToScreen(context, 'Health Reminders');
            },
          ),
        ],
      ),
    );
  }
}

/* ================= CONTENT ================= */

class _Content extends StatelessWidget {
  final String selectedNavItem;
  
  const _Content({required this.selectedNavItem});

  @override
  Widget build(BuildContext context) {
    switch (selectedNavItem) {
      case 'Inbox':
        return _buildInboxScreen();
      case 'Dashboard':
      default:
        return _buildDashboardScreen(context);
    }
  }
  
  Widget _buildDashboardScreen(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          _TopCards(context: context),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(flex: 3, child: _Timeline()),
              const SizedBox(width: 24),
              SizedBox(width: 360, child: _RightPanel()),
            ],
          )
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
          const Text(
            'Inbox',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: PatientDashboard.dark,
            ),
          ),
          const SizedBox(height: 16),
          ..._buildInboxItems(),
        ],
      ),
    );
  }
  
  List<Widget> _buildInboxItems() {
    return [
      _buildInboxItem(
        'Appointment Confirmation',
        'Your appointment with Dr. Sarah John has been confirmed for tomorrow at 10:00 AM.',
        '10 min ago',
        Icons.calendar_today,
        PatientDashboard.primary,
      ),
      _buildInboxItem(
        'Lab Results Ready',
        'Your blood test results from 2 days ago are now available for viewing.',
        '1 hour ago',
        Icons.science,
        Colors.green,
      ),
      _buildInboxItem(
        'Payment Reminder',
        'Reminder: Your outstanding payment of \$150.00 is due in 5 days.',
        '2 hours ago',
        Icons.payment,
        Colors.orange,
      ),
      _buildInboxItem(
        'Prescription Update',
        'Dr. Johnson has updated your prescription for Hypertension medication.',
        '3 hours ago',
        Icons.medication,
        Colors.purple,
      ),
      _buildInboxItem(
        'Health Checkup Reminder',
        'Your monthly health checkup is scheduled for next week. Please confirm.',
        '1 day ago',
        Icons.health_and_safety,
        Colors.teal,
      ),
    ];
  }
  
  Widget _buildInboxItem(String title, String description, String time, IconData icon, Color iconColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: PatientDashboard.border),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(icon, color: iconColor, size: 20),
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
                    color: PatientDashboard.dark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: PatientDashboard.muted,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                time,
                style: const TextStyle(
                  fontSize: 12,
                  color: PatientDashboard.muted,
                ),
              ),
              const SizedBox(height: 8),
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios, size: 16),
                onPressed: () {
                  // Navigate to detailed view
                },
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
  final BuildContext context;
  
  const _TopCards({required this.context});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatCard(
          title: 'Dr Sarah John',
          subtitle: 'Cardiologist\nToday • 10:00 A.M.\nConfirmed',
          colors: [const Color(0xFF7DB9FF), const Color(0xFFB6D9FF)],
          onTap: () {
            final state = context.findAncestorStateOfType<_PatientDashboardState>();
            state?._navigateToScreen(context, 'Online Appointments');
          },
        ),
        const SizedBox(width: 16),
        _StatCard(
          title: '3',
          subtitle: 'Total medicines\nAvailable',
          colors: [const Color(0xFF6FE3C5), const Color(0xFFADF0DD)],
          onTap: () {
            final state = context.findAncestorStateOfType<_PatientDashboardState>();
            state?._navigateToScreen(context, 'e-Prescriptions');
          },
        ),
        const SizedBox(width: 16),
        _StatCard(
          title: 'Blood Test',
          subtitle: '2 days ago\nNext dose: 2:00 PM',
          colors: [const Color(0xFF78F2F2), const Color(0xFFBFF9F9)],
          onTap: () {
            final state = context.findAncestorStateOfType<_PatientDashboardState>();
            state?._navigateToScreen(context, 'Lab Results');
          },
        ),
        const SizedBox(width: 16),
        _StatCard(
          title: '\$150.00',
          subtitle: 'Outstanding Payment\nDue in 5 days',
          colors: [const Color(0xFF93E47D), const Color(0xFFBFF3AE)],
          onTap: () {
            final state = context.findAncestorStateOfType<_PatientDashboardState>();
            state?._navigateToScreen(context, 'Bills & Payments');
          },
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<Color> colors;
  final VoidCallback onTap;

  const _StatCard({
    required this.title,
    required this.subtitle,
    required this.colors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 130,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: colors),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const Icon(Icons.arrow_forward_ios, size: 16),
                ],
              ),
              const Spacer(),
              Text(subtitle, style: const TextStyle(fontSize: 13)),
            ],
          ),
        ),
      ),
    );
  }
}

/* ================= TIMELINE ================= */

class _Timeline extends StatelessWidget {
  const _Timeline();

  @override
  Widget build(BuildContext context) {
    return _Card(
      title: "Today's Health Timeline",
      child: Column(
        children: [
          _TimeRow(
            time: '9:00 AM',
            text: 'Take morning medication',
            dotColor: Colors.green,
            icon: Icons.medication,
            iconColor: Colors.green,
            onTap: () {
              final state = context.findAncestorStateOfType<_PatientDashboardState>();
              state?._navigateToScreen(context, 'e-Prescriptions');
            },
          ),
          _TimeRow(
            time: '10:30 AM',
            text: 'Appointment with Dr. Johnson',
            dotColor: Colors.blue,
            icon: Icons.calendar_today,
            iconColor: Colors.blue,
            onTap: () {
              final state = context.findAncestorStateOfType<_PatientDashboardState>();
              state?._navigateToScreen(context, 'Online Appointments');
            },
          ),
          _TimeRow(
            time: '2:00 PM',
            text: 'Take afternoon medication',
            dotColor: Colors.lightGreen,
            icon: Icons.schedule,
            iconColor: Colors.lightGreen,
            onTap: () {
              final state = context.findAncestorStateOfType<_PatientDashboardState>();
              state?._navigateToScreen(context, 'Health Reminders');
            },
          ),
          _TimeRow(
            time: '4:00 PM',
            text: 'Teleconsultation follow-up',
            dotColor: Colors.redAccent,
            icon: Icons.call,
            iconColor: Colors.redAccent,
            onTap: () {
              final state = context.findAncestorStateOfType<_PatientDashboardState>();
              state?._navigateToScreen(context, 'Teleconsultation');
            },
          ),
          _TimeRow(
            time: '6:00 PM',
            text: 'Evening health check',
            dotColor: Colors.purple,
            icon: Icons.health_and_safety,
            iconColor: Colors.purple,
            onTap: () {
              final state = context.findAncestorStateOfType<_PatientDashboardState>();
              state?._navigateToScreen(context, 'Health Reminders');
            },
          ),
        ],
      ),
    );
  }
}

class _TimeRow extends StatelessWidget {
  final String time;
  final String text;
  final Color dotColor;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  const _TimeRow({
    required this.time,
    required this.text,
    required this.dotColor,
    required this.icon,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 28),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: dotColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(time, style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(text, style: const TextStyle(fontSize: 13, color: PatientDashboard.muted)),
                ],
              ),
            ),
            Icon(icon, color: iconColor, size: 22),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_ios, size: 16, color: PatientDashboard.muted),
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
      children: [
        const _TreatmentCard(),
        const SizedBox(height: 16),
        const _BillingSnapshot(),
        const SizedBox(height: 16),
        _EmergencyCard(),
      ],
    );
  }
}

class _TreatmentCard extends StatelessWidget {
  const _TreatmentCard();

  @override
  Widget build(BuildContext context) {
    return _Card(
      title: 'Current Treatment',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Hypertension Management', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          const Text('Latest diagnosis', style: TextStyle(fontSize: 12, color: PatientDashboard.muted)),
          const SizedBox(height: 12),
          const Text('Medication therapy and lifestyle modifications'),
          const SizedBox(height: 12),
          const Text('Dr. Sarah Johnson', style: TextStyle(fontWeight: FontWeight.bold)),
          const Text('Prescribed doctor', style: TextStyle(fontSize: 12, color: PatientDashboard.muted)),
          const SizedBox(height: 16),
          Row(
            children: [
              OutlinedButton(
                onPressed: () {
                  final state = context.findAncestorStateOfType<_PatientDashboardState>();
                  state?._navigateToScreen(context, 'e-Prescriptions');
                },
                child: const Text('View Details'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: PatientDashboard.primary,
                ),
                onPressed: () {
                  final state = context.findAncestorStateOfType<_PatientDashboardState>();
                  state?._navigateToScreen(context, 'Teleconsultation');
                },
                child: const Text('Contact Doctor'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BillingSnapshot extends StatelessWidget {
  const _BillingSnapshot();

  @override
  Widget build(BuildContext context) {
    return _Card(
      title: 'Billing Snapshot',
      child: Column(
        children: [
          _BillingItem(
            title: 'Consultation Fee',
            amount: '\$75.00',
            date: 'Nov 15, 2024',
            status: 'Paid',
            statusColor: Colors.green,
          ),
          _BillingItem(
            title: 'Lab Tests',
            amount: '\$45.00',
            date: 'Nov 16, 2024',
            status: 'Paid',
            statusColor: Colors.green,
          ),
          _BillingItem(
            title: 'Medication',
            amount: '\$30.00',
            date: 'Nov 17, 2024',
            status: 'Pending',
            statusColor: Colors.orange,
          ),
          _BillingItem(
            title: 'Monthly Checkup',
            amount: '\$150.00',
            date: 'Due in 5 days',
            status: 'Due',
            statusColor: PatientDashboard.danger,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: PatientDashboard.primary,
              ),
              onPressed: () {
                final state = context.findAncestorStateOfType<_PatientDashboardState>();
                state?._navigateToScreen(context, 'Bills & Payments');
              },
              child: const Text('View All Bills'),
            ),
          ),
        ],
      ),
    );
  }
}

class _BillingItem extends StatelessWidget {
  final String title;
  final String amount;
  final String date;
  final String status;
  final Color statusColor;

  const _BillingItem({
    required this.title,
    required this.amount,
    required this.date,
    required this.status,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: PatientDashboard.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: PatientDashboard.dark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 12,
                    color: PatientDashboard.muted,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: PatientDashboard.dark,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 10,
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios, size: 16),
            onPressed: () {
              final state = context.findAncestorStateOfType<_PatientDashboardState>();
              state?._navigateToScreen(context, 'Bills & Payments');
            },
          ),
        ],
      ),
    );
  }
}

class _EmergencyCard extends StatelessWidget {
  const _EmergencyCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1F1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: PatientDashboard.danger),
      ),
      child: Column(
        children: [
          const Text(
            'Emergency Quick Access',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: PatientDashboard.danger),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: PatientDashboard.danger,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: () {
                final state = context.findAncestorStateOfType<_PatientDashboardState>();
                state?._navigateToScreen(context, 'Emergency SOS');
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.warning, size: 20),
                  SizedBox(width: 8),
                  Text('Emergency SOS'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Emergency Contacts:', style: TextStyle(color: PatientDashboard.danger)),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Hospital: (555) 123-4567', style: TextStyle(fontSize: 12)),
                  Text('Ambulance: 911', style: TextStyle(fontSize: 12)),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.phone, color: PatientDashboard.danger),
                onPressed: () {
                  // Make emergency call
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/* ================= COMMON CARD ================= */

class _Card extends StatelessWidget {
  final String title;
  final Widget child;

  const _Card({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: PatientDashboard.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios, size: 16),
                onPressed: () {
                  // Navigate to detailed view
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }
}

/* ================= TEMPORARY SCREENS ================= */
// These are simplified versions for now. You can replace them with separate files later.

class _PatientAppointmentsScreen extends StatelessWidget {
  const _PatientAppointmentsScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Online Appointments'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const Center(
        child: Text('Online Appointments Screen'),
      ),
    );
  }
}

class _TeleconsultationScreen extends StatelessWidget {
  const _TeleconsultationScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teleconsultation'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const Center(
        child: Text('Teleconsultation Screen'),
      ),
    );
  }
}

class _LabResultsScreen extends StatelessWidget {
  const _LabResultsScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab Results'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const Center(
        child: Text('Lab Results Screen'),
      ),
    );
  }
}

class _EPrescriptionsScreen extends StatelessWidget {
  const _EPrescriptionsScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('e-Prescriptions'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const Center(
        child: Text('e-Prescriptions Screen'),
      ),
    );
  }
}

class _BillsPaymentsScreen extends StatelessWidget {
  const _BillsPaymentsScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bills & Payments'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const Center(
        child: Text('Bills & Payments Screen'),
      ),
    );
  }
}

class _HealthRemindersScreen extends StatelessWidget {
  const _HealthRemindersScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Reminders'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const Center(
        child: Text('Health Reminders Screen'),
      ),
    );
  }
}

class _EmergencySOSScreen extends StatelessWidget {
  const _EmergencySOSScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency SOS'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const Center(
        child: Text('Emergency SOS Screen'),
      ),
    );
  }
}

class _AdminProfileScreen extends StatelessWidget {
  const _AdminProfileScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const Center(
        child: Text('Admin Profile Screen'),
      ),
    );
  }
}

class _PatientSettingsScreen extends StatelessWidget {
  const _PatientSettingsScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const Center(
        child: Text('Patient Settings Screen'),
      ),
    );
  }
}