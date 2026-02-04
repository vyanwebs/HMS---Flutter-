import 'package:flutter/material.dart';
import 'package:hms/screens/patient/patient_dashboard.dart';

class PatientAppointments extends StatelessWidget {
  const PatientAppointments({super.key});

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
                  'Online Appointments',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: PatientDashboard.dark,
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PatientDashboard.primary,
                  ),
                  child: const Text('Book Appointment'),
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
                  // Upcoming Appointments
                  _buildSection('Upcoming Appointments', [
                    _buildAppointmentCard(
                      doctor: 'Dr. Sarah Johnson',
                      specialty: 'Cardiologist',
                      date: 'Today, 10:00 AM',
                      status: 'Confirmed',
                      statusColor: Colors.green,
                    ),
                    _buildAppointmentCard(
                      doctor: 'Dr. Michael Chen',
                      specialty: 'Neurologist',
                      date: 'Tomorrow, 2:30 PM',
                      status: 'Confirmed',
                      statusColor: Colors.green,
                    ),
                  ]),
                  
                  const SizedBox(height: 24),
                  
                  // Past Appointments
                  _buildSection('Past Appointments', [
                    _buildAppointmentCard(
                      doctor: 'Dr. Lisa Wong',
                      specialty: 'Dermatologist',
                      date: 'Nov 15, 2024',
                      status: 'Completed',
                      statusColor: Colors.blue,
                    ),
                    _buildAppointmentCard(
                      doctor: 'Dr. Robert Kim',
                      specialty: 'Orthopedist',
                      date: 'Nov 10, 2024',
                      status: 'Completed',
                      statusColor: Colors.blue,
                    ),
                  ]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSection(String title, List<Widget> cards) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: PatientDashboard.dark,
          ),
        ),
        const SizedBox(height: 16),
        ...cards,
      ],
    );
  }
  
  Widget _buildAppointmentCard({
    required String doctor,
    required String specialty,
    required String date,
    required String status,
    required Color statusColor,
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
          // Doctor Avatar
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: PatientDashboard.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Icon(Icons.person, size: 30, color: PatientDashboard.primary),
          ),
          const SizedBox(width: 16),
          
          // Doctor Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doctor,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: PatientDashboard.dark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  specialty,
                  style: const TextStyle(
                    fontSize: 14,
                    color: PatientDashboard.muted,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 13,
                    color: PatientDashboard.muted,
                  ),
                ),
              ],
            ),
          ),
          
          // Status and Actions
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
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
              const SizedBox(height: 8),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.video_call, size: 20),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.chat, size: 20),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.cancel, size: 20),
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}