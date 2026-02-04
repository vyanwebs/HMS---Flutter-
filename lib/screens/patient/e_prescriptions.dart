import 'package:flutter/material.dart';
import 'package:hms/screens/patient/patient_dashboard.dart';

class EPrescriptionsScreen extends StatelessWidget {
  const EPrescriptionsScreen({super.key});

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
                  'e-Prescriptions',
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
                  // Current Medications
                  _buildPrescriptionCard(
                    medication: 'Lisinopril',
                    dosage: '10mg',
                    frequency: 'Once daily',
                    doctor: 'Dr. Sarah Johnson',
                    refills: '3 refills left',
                  ),
                  
                  _buildPrescriptionCard(
                    medication: 'Metformin',
                    dosage: '500mg',
                    frequency: 'Twice daily',
                    doctor: 'Dr. Sarah Johnson',
                    refills: '2 refills left',
                  ),
                  
                  _buildPrescriptionCard(
                    medication: 'Atorvastatin',
                    dosage: '20mg',
                    frequency: 'Once daily',
                    doctor: 'Dr. Michael Chen',
                    refills: '1 refill left',
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Request Refill
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
                          'Need a Refill?',
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
                          child: const Text('Request Prescription Refill'),
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
  
  Widget _buildPrescriptionCard({
    required String medication,
    required String dosage,
    required String frequency,
    required String doctor,
    required String refills,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: PatientDashboard.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: PatientDashboard.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(Icons.medication, color: PatientDashboard.primary),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      medication,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: PatientDashboard.dark,
                      ),
                    ),
                    Text(
                      '$dosage • $frequency',
                      style: const TextStyle(
                        fontSize: 14,
                        color: PatientDashboard.muted,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  refills,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          Row(
            children: [
              const Icon(Icons.person, size: 16, color: PatientDashboard.muted),
              const SizedBox(width: 8),
              Text(
                'Prescribed by: $doctor',
                style: const TextStyle(
                  fontSize: 14,
                  color: PatientDashboard.muted,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {},
                child: const Text('View Details'),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: () {},
                child: const Text('Order Now'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}