import 'package:flutter/material.dart';

class PatientFollowUpScreen extends StatelessWidget {
  final VoidCallback onBack;

  const PatientFollowUpScreen({super.key, required this.onBack});

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
                    'Patient Follow-up',
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
                  // Header with Stats
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Follow-up Schedule',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2D3748),
                        ),
                      ),
                      Row(
                        children: [
                          _buildStatBox('Due Today', '8', Colors.orange),
                          const SizedBox(width: 12),
                          _buildStatBox('Overdue', '3', Colors.red),
                          const SizedBox(width: 12),
                          _buildStatBox('Completed', '15', Colors.green),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Follow-up List
                  ..._buildFollowUpItems(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatBox(String title, String count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Text(
            count,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildFollowUpItems() {
    return [
      _buildFollowUpItem(
        patientName: 'John Smith',
        followUpType: 'Post-Op Checkup',
        scheduledDate: 'Today, 2:30 PM',
        status: 'Pending',
        isOverdue: false,
      ),
      _buildFollowUpItem(
        patientName: 'Mary Johnson',
        followUpType: 'Medication Review',
        scheduledDate: 'Today, 4:00 PM',
        status: 'Pending',
        isOverdue: false,
      ),
      _buildFollowUpItem(
        patientName: 'Robert Brown',
        followUpType: 'Lab Test Results',
        scheduledDate: 'Yesterday, 11:00 AM',
        status: 'Overdue',
        isOverdue: true,
      ),
      _buildFollowUpItem(
        patientName: 'Sarah Wilson',
        followUpType: 'Vitals Check',
        scheduledDate: 'Jan 3, 10:00 AM',
        status: 'Scheduled',
        isOverdue: false,
      ),
      _buildFollowUpItem(
        patientName: 'David Lee',
        followUpType: 'Dressing Change',
        scheduledDate: 'Jan 2, 3:00 PM',
        status: 'Completed',
        isOverdue: false,
      ),
    ];
  }

  Widget _buildFollowUpItem({
    required String patientName,
    required String followUpType,
    required String scheduledDate,
    required String status,
    required bool isOverdue,
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
      case 'Completed':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      default:
        statusColor = Colors.blue;
        statusIcon = Icons.calendar_today;
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
      child: Row(
        children: [
          // Status Icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(statusIcon, color: statusColor, size: 20),
          ),

          const SizedBox(width: 16),

          // Patient Info
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
                const SizedBox(height: 4),
                Text(
                  followUpType,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF718096),
                  ),
                ),
              ],
            ),
          ),

          // Schedule Info
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                scheduledDate,
                style: TextStyle(
                  fontSize: 14,
                  color: isOverdue ? Colors.red : const Color(0xFF2D3748),
                  fontWeight: isOverdue ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 12,
                    color: statusColor,
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