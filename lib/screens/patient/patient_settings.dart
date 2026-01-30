import 'package:flutter/material.dart';
import 'package:hms/screens/patient/patient_dashboard.dart';

import '../main_dashboard.dart';

class PatientSettingsScreen extends StatelessWidget {
  const PatientSettingsScreen({super.key});

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
                  'Settings',
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
                  // Account Settings
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: PatientDashboard.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Account Settings',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: PatientDashboard.dark,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildSettingItem(
                          icon: Icons.notifications,
                          title: 'Notifications',
                          subtitle: 'Manage your notification preferences',
                        ),
                        _buildSettingItem(
                          icon: Icons.security,
                          title: 'Privacy & Security',
                          subtitle: 'Control your privacy settings',
                        ),
                        _buildSettingItem(
                          icon: Icons.language,
                          title: 'Language',
                          subtitle: 'English (US)',
                        ),
                        _buildSettingItem(
                          icon: Icons.palette,
                          title: 'Appearance',
                          subtitle: 'Light mode',
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Health Settings
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: PatientDashboard.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Health Settings',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: PatientDashboard.dark,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildSettingItem(
                          icon: Icons.medical_services,
                          title: 'Health Data Sharing',
                          subtitle: 'Control data sharing with doctors',
                        ),
                        _buildSettingItem(
                          icon: Icons.emergency,
                          title: 'Emergency Settings',
                          subtitle: 'Configure emergency contacts',
                        ),
                        _buildSettingItem(
                          icon: Icons.medication,
                          title: 'Medication Reminders',
                          subtitle: 'Customize reminder settings',
                        ),
                        _buildSettingItem(
                          icon: Icons.fitness_center,
                          title: 'Health Goals',
                          subtitle: 'Set and track health goals',
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Support
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: PatientDashboard.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Support',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: PatientDashboard.dark,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildSettingItem(
                          icon: Icons.help,
                          title: 'Help Center',
                          subtitle: 'Get help with the app',
                        ),
                        _buildSettingItem(
                          icon: Icons.description,
                          title: 'Terms & Conditions',
                          subtitle: 'View terms of service',
                        ),
                        _buildSettingItem(
                          icon: Icons.privacy_tip,
                          title: 'Privacy Policy',
                          subtitle: 'Read our privacy policy',
                        ),
                        _buildSettingItem(
                          icon: Icons.info,
                          title: 'About',
                          subtitle: 'App version 1.0.0',
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Logout Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MainDashboard(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: PatientDashboard.danger,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Logout'),
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
  
  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: PatientDashboard.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Icon(icon, color: PatientDashboard.primary),
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
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 14,
                    color: PatientDashboard.muted,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 16, color: PatientDashboard.muted),
        ],
      ),
    );
  }
}