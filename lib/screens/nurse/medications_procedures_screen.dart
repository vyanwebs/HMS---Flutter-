import 'package:flutter/material.dart';

class MedicationsProceduresScreen extends StatelessWidget {
  final VoidCallback onBack;

  const MedicationsProceduresScreen({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC),
      body: Column(
        children: [
          // Top Bar
          Container(
            height: 70,
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 30),
            child: Row(
              children: [
                if (isMobile)
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Color(0xFF2383E2)),
                    onPressed: onBack,
                  ),
                Expanded(
                  child: Text(
                    'Medications & Procedures',
                    style: TextStyle(
                      fontSize: isMobile ? 18 : 24,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2D3748),
                    ),
                  ),
                ),
                if (!isMobile)
                  ElevatedButton(
                    onPressed: onBack,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0094FE),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                    child: const Text('Back to Dashboard'),
                  ),
              ],
            ),
          ),

          // Divider
          Container(height: 1, color: const Color(0xFFE2E8F0)),

          // Main Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(isMobile ? 16 : 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with Tabs
                  DefaultTabController(
                    length: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const TabBar(
                          indicatorColor: Color(0xFF0094FE),
                          labelColor: Color(0xFF0094FE),
                          unselectedLabelColor: Color(0xFF718096),
                          tabs: [
                            Tab(text: 'Pending'),
                            Tab(text: 'Administered'),
                            Tab(text: 'Scheduled'),
                          ],
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 500,
                          child: TabBarView(
                            children: [
                              _buildPendingMedications(),
                              _buildAdministeredMedications(),
                              _buildScheduledMedications(),
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
        ],
      ),
    );
  }

  Widget _buildPendingMedications() {
    return ListView(
      shrinkWrap: true,
      children: [
        _buildMedicationItem(
          patientName: 'John Smith',
          medication: 'Insulin - 10 units',
          route: 'Subcutaneous',
          frequency: 'Before meals',
          scheduledTime: '2:30 PM',
          status: 'Pending',
          isOverdue: false,
          isCritical: true,
        ),
        _buildMedicationItem(
          patientName: 'Robert Brown',
          medication: 'Morphine - 5mg',
          route: 'IV',
          frequency: 'Every 4 hours',
          scheduledTime: '2:00 PM',
          status: 'Overdue',
          isOverdue: true,
          isCritical: true,
        ),
        _buildMedicationItem(
          patientName: 'Mary Johnson',
          medication: 'Amoxicillin - 500mg',
          route: 'Oral',
          frequency: 'Three times daily',
          scheduledTime: '3:00 PM',
          status: 'Pending',
          isOverdue: false,
          isCritical: false,
        ),
        _buildMedicationItem(
          patientName: 'Sarah Wilson',
          medication: 'Paracetamol - 650mg',
          route: 'Oral',
          frequency: 'As needed',
          scheduledTime: '2:45 PM',
          status: 'Pending',
          isOverdue: false,
          isCritical: false,
        ),
      ],
    );
  }

  Widget _buildAdministeredMedications() {
    return ListView(
      shrinkWrap: true,
      children: [
        _buildMedicationItem(
          patientName: 'David Lee',
          medication: 'Metformin - 850mg',
          route: 'Oral',
          frequency: 'Twice daily',
          scheduledTime: '1:00 PM',
          status: 'Administered',
          isOverdue: false,
          isCritical: false,
          administeredTime: '1:05 PM',
          administeredBy: 'Nurse Sharma',
        ),
        _buildMedicationItem(
          patientName: 'Emma Davis',
          medication: 'Losartan - 50mg',
          route: 'Oral',
          frequency: 'Once daily',
          scheduledTime: '12:00 PM',
          status: 'Administered',
          isOverdue: false,
          isCritical: false,
          administeredTime: '12:10 PM',
          administeredBy: 'Nurse Patel',
        ),
      ],
    );
  }

  Widget _buildScheduledMedications() {
    return ListView(
      shrinkWrap: true,
      children: [
        _buildMedicationItem(
          patientName: 'John Smith',
          medication: 'Insulin - 10 units',
          route: 'Subcutaneous',
          frequency: 'Before meals',
          scheduledTime: '6:30 PM',
          status: 'Scheduled',
          isOverdue: false,
          isCritical: true,
        ),
        _buildMedicationItem(
          patientName: 'Robert Brown',
          medication: 'Morphine - 5mg',
          route: 'IV',
          frequency: 'Every 4 hours',
          scheduledTime: '6:00 PM',
          status: 'Scheduled',
          isOverdue: false,
          isCritical: true,
        ),
        _buildMedicationItem(
          patientName: 'Mary Johnson',
          medication: 'Amoxicillin - 500mg',
          route: 'Oral',
          frequency: 'Three times daily',
          scheduledTime: '7:00 PM',
          status: 'Scheduled',
          isOverdue: false,
          isCritical: false,
        ),
      ],
    );
  }

  Widget _buildMedicationItem({
    required String patientName,
    required String medication,
    required String route,
    required String frequency,
    required String scheduledTime,
    required String status,
    required bool isOverdue,
    required bool isCritical,
    String? administeredTime,
    String? administeredBy,
  }) {
    Color statusColor;
    IconData statusIcon;
    
    switch (status) {
      case 'Pending':
        statusColor = Colors.orange;
        statusIcon = Icons.access_time;
        break;
      case 'Overdue':
        statusColor = Colors.red;
        statusIcon = Icons.warning;
        break;
      case 'Administered':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'Scheduled':
        statusColor = Colors.blue;
        statusIcon = Icons.schedule;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      patientName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    Text(
                      medication,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF718096),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    Icon(statusIcon, size: 14, color: statusColor),
                    const SizedBox(width: 4),
                    Text(
                      status,
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Details
          Row(
            children: [
              _buildDetailItem('Route', route, Icons.alt_route),
              const SizedBox(width: 16),
              _buildDetailItem('Frequency', frequency, Icons.repeat),
              const SizedBox(width: 16),
              _buildDetailItem('Time', scheduledTime, Icons.access_time),
            ],
          ),

          const SizedBox(height: 12),

          // Administered Info (if applicable)
          if (administeredTime != null && administeredBy != null)
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, size: 14, color: Colors.green),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Administered at $administeredTime by $administeredBy',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 12),

          // Action Buttons
          if (status == 'Pending' || status == 'Overdue')
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0094FE),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    child: const Text(
                      'Mark as Administered',
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF0094FE)),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    child: Text(
                      'Delay',
                      style: TextStyle(
                        color: const Color(0xFF0094FE),
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFF7FAFC),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            Icon(icon, size: 14, color: const Color(0xFF718096)),
            const SizedBox(width: 6),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF718096),
                    ),
                  ),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2D3748),
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