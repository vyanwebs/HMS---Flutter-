import 'package:flutter/material.dart';
import 'package:hms/utils/constants.dart';

class DoctorInbox extends StatelessWidget {
  const DoctorInbox({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inbox'),
        backgroundColor: const Color(0xFF2383E2),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildInboxItem(
            'New Lab Report',
            'Lab report for Patient: John Smith is ready for review',
            '10 min ago',
            Icons.science,
            const Color(0xFF4299E1),
          ),
          _buildInboxItem(
            'Appointment Reminder',
            'You have an OPD appointment with Mann Sharma at 9:00 AM',
            '30 min ago',
            Icons.calendar_today,
            const Color(0xFF48BB78),
          ),
          _buildInboxItem(
            'Discharge Request',
            'Discharge request for Patient ID: P10023',
            '1 hour ago',
            Icons.exit_to_app,
            const Color(0xFFED8936),
          ),
          _buildInboxItem(
            'Prescription Approval',
            'Prescription needs approval for Sarah Johnson',
            '2 hours ago',
            Icons.medical_services,
            const Color(0xFF9F7AEA),
          ),
          _buildInboxItem(
            'IPD Alert',
            'Patient in Room 101 requires attention',
            '3 hours ago',
            Icons.local_hospital,
            const Color(0xFFF56565),
          ),
        ],
      ),
    );
  }

  Widget _buildInboxItem(String title, String description, String time, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(25),
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
          Column(
            children: [
              Text(
                time,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFFA0AEC0),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}