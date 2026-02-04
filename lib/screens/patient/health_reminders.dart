import 'package:flutter/material.dart';
import 'package:hms/screens/patient/patient_dashboard.dart';

class HealthRemindersScreen extends StatelessWidget {
  const HealthRemindersScreen({super.key});

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
                  'Health Reminders',
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
                  // Today's Reminders
                  const Text(
                    "Today's Reminders",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: PatientDashboard.dark,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  _buildReminderCard(
                    time: '9:00 AM',
                    title: 'Take Morning Medication',
                    description: 'Lisinopril 10mg',
                    icon: Icons.medication,
                    color: Colors.blue,
                    completed: true,
                  ),
                  
                  _buildReminderCard(
                    time: '2:00 PM',
                    title: 'Take Afternoon Medication',
                    description: 'Metformin 500mg',
                    icon: Icons.medication,
                    color: Colors.green,
                    completed: false,
                  ),
                  
                  _buildReminderCard(
                    time: '8:00 PM',
                    title: 'Evening Walk',
                    description: '30 minutes walk',
                    icon: Icons.directions_walk,
                    color: Colors.orange,
                    completed: false,
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Upcoming Reminders
                  const Text(
                    'Upcoming Reminders',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: PatientDashboard.dark,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  _buildReminderCard(
                    time: 'Tomorrow, 10:00 AM',
                    title: 'Doctor Appointment',
                    description: 'Dr. Sarah Johnson - Cardiology',
                    icon: Icons.calendar_today,
                    color: Colors.purple,
                    completed: false,
                  ),
                  
                  _buildReminderCard(
                    time: 'Nov 22, 2024',
                    title: 'Prescription Refill',
                    description: 'Metformin refill needed',
                    icon: Icons.refresh,
                    color: Colors.red,
                    completed: false,
                  ),
                  
                  _buildReminderCard(
                    time: 'Nov 25, 2024',
                    title: 'Blood Test',
                    description: 'Fasting required',
                    icon: Icons.science,
                    color: Colors.teal,
                    completed: false,
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Add New Reminder
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
                          'Add Custom Reminder',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: PatientDashboard.dark,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: PatientDashboard.primary,
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          ),
                          child: const Text('Add New Reminder'),
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
  
  Widget _buildReminderCard({
    required String time,
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required bool completed,
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
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Icon(icon, color: color),
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
                    fontWeight: FontWeight.bold,
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
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 13,
                    color: PatientDashboard.muted,
                  ),
                ),
              ],
            ),
          ),
          Checkbox(
            value: completed,
            onChanged: (value) {},
            activeColor: PatientDashboard.primary,
          ),
          IconButton(
            icon: const Icon(Icons.notifications, size: 20),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}