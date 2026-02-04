import 'package:flutter/material.dart';
import 'package:hms/screens/patient/patient_dashboard.dart';

class TeleconsultationScreen extends StatelessWidget {
  const TeleconsultationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PatientDashboard.bg,
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(24),
            color: Colors.white,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(width: 16),
                const Text(
                  'Teleconsultation',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: PatientDashboard.dark,
                  ),
                ),
              ],
            ),
          ),
          
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Quick Connect
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: PatientDashboard.border),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Quick Connect',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: PatientDashboard.dark,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: PatientDashboard.primary.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.video_call,
                            size: 60,
                            color: PatientDashboard.primary,
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: PatientDashboard.primary,
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          ),
                          child: const Text('Start Video Call'),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Scheduled Calls
                  const Text(
                    'Scheduled Video Calls',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: PatientDashboard.dark,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  _buildScheduledCall(
                    doctor: 'Dr. Sarah Johnson',
                    time: 'Today, 4:00 PM',
                    type: 'Follow-up',
                  ),
                  _buildScheduledCall(
                    doctor: 'Dr. Michael Chen',
                    time: 'Tomorrow, 11:00 AM',
                    type: 'Consultation',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildScheduledCall({
    required String doctor,
    required String time,
    required String type,
  }) {
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
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: PatientDashboard.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Icon(Icons.person, color: PatientDashboard.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doctor,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: PatientDashboard.dark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$type • $time',
                  style: const TextStyle(
                    fontSize: 14,
                    color: PatientDashboard.muted,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: PatientDashboard.primary,
            ),
            child: const Text('Join'),
          ),
        ],
      ),
    );
  }
}