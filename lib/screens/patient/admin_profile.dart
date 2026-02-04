import 'package:flutter/material.dart';
import 'package:hms/screens/patient/patient_dashboard.dart';

class AdminProfileScreen extends StatelessWidget {
  const AdminProfileScreen({super.key});

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
                  'My Profile',
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
                  // Profile Header
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: PatientDashboard.border),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: PatientDashboard.primary.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.person,
                            size: 60,
                            color: PatientDashboard.primary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'John Smith',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: PatientDashboard.dark,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Patient ID: P10023',
                          style: TextStyle(
                            fontSize: 16,
                            color: PatientDashboard.muted,
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: PatientDashboard.primary,
                          ),
                          child: const Text('Edit Profile'),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Personal Information
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
                          'Personal Information',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: PatientDashboard.dark,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildInfoItem('Email', 'john.smith@email.com'),
                        _buildInfoItem('Phone', '(555) 123-4567'),
                        _buildInfoItem('Date of Birth', 'January 15, 1985'),
                        _buildInfoItem('Gender', 'Male'),
                        _buildInfoItem('Blood Group', 'O+'),
                        _buildInfoItem('Emergency Contact', 'Jane Smith (555) 987-6543'),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Medical Information
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
                          'Medical Information',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: PatientDashboard.dark,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildInfoItem('Primary Doctor', 'Dr. Sarah Johnson'),
                        _buildInfoItem('Allergies', 'Penicillin, Pollen'),
                        _buildInfoItem('Chronic Conditions', 'Hypertension, Type 2 Diabetes'),
                        _buildInfoItem('Current Medications', 'Lisinopril, Metformin, Atorvastatin'),
                        _buildInfoItem('Insurance Provider', 'HealthCare Plus'),
                        _buildInfoItem('Insurance ID', 'HCP-7890-1234'),
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
  
  Widget _buildInfoItem(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: PatientDashboard.dark,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: PatientDashboard.muted,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit, size: 16),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}