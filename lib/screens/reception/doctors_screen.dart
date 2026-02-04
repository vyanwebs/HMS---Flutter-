// lib/screens/reception/doctors_screen.dart
import 'package:flutter/material.dart';

class DoctorsScreen extends StatefulWidget {
  const DoctorsScreen({super.key});

  @override
  State<DoctorsScreen> createState() => _DoctorsScreenState();
}

class _DoctorsScreenState extends State<DoctorsScreen> {
  final List<Doctor> doctors = [
    Doctor(
      id: 'D1001',
      name: 'Dr. Rajesh Sharma',
      specialty: 'Cardiology',
      department: 'Cardiology',
      qualification: 'MD, DM Cardiology',
      experience: '15 years',
      availability: 'Available',
      consultationFee: 1500,
    ),
    Doctor(
      id: 'D1002',
      name: 'Dr. Priya Patel',
      specialty: 'Orthopedics',
      department: 'Orthopedics',
      qualification: 'MS Orthopedics',
      experience: '12 years',
      availability: 'Available',
      consultationFee: 1200,
    ),
    Doctor(
      id: 'D1003',
      name: 'Dr. Amit Gupta',
      specialty: 'Dermatology',
      department: 'Dermatology',
      qualification: 'MD Dermatology',
      experience: '10 years',
      availability: 'On Leave',
      consultationFee: 1000,
    ),
    Doctor(
      id: 'D1004',
      name: 'Dr. Neha Singh',
      specialty: 'Neurology',
      department: 'Neurology',
      qualification: 'DM Neurology',
      experience: '18 years',
      availability: 'Available',
      consultationFee: 2000,
    ),
    Doctor(
      id: 'D1005',
      name: 'Dr. Sanjay Kumar',
      specialty: 'Pediatrics',
      department: 'Pediatrics',
      qualification: 'MD Pediatrics',
      experience: '8 years',
      availability: 'Available',
      consultationFee: 800,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Doctors Management',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3748),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4299E1),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                icon: const Icon(Icons.person_add, size: 18),
                label: const Text('Add Doctor'),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Stats Cards
          Row(
            children: [
              _buildDoctorStatCard('Total Doctors', '24', Icons.people,
                  const Color(0xFF4299E1)),
              const SizedBox(width: 20),
              _buildDoctorStatCard('Available Today', '18', Icons.check_circle,
                  const Color(0xFF48BB78)),
              const SizedBox(width: 20),
              _buildDoctorStatCard('On Leave', '3', Icons.beach_access,
                  const Color(0xFFED8936)),
              const SizedBox(width: 20),
              _buildDoctorStatCard('Departments', '8', Icons.category,
                  const Color(0xFF9F7AEA)),
            ],
          ),

          const SizedBox(height: 30),

          // Doctors List
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Doctors List',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    const SizedBox(height: 20),

                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          // Table Header
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: const BoxDecoration(
                              color: Color(0xFFF7FAFC),
                              border: Border(
                                  bottom: BorderSide(color: Color(0xFFE2E8F0))),
                            ),
                            child: const Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Doctor ID',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF2D3748),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    'Name & Specialty',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF2D3748),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    'Department',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF2D3748),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    'Availability',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF2D3748),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    'Fee',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF2D3748),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    'Actions',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF2D3748),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Doctors List
                          ...doctors.map((doctor) => Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        color: const Color(0xFFE2E8F0)),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        doctor.id,
                                        style: const TextStyle(
                                          color: Color(0xFF4299E1),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            doctor.name,
                                            style: const TextStyle(
                                              color: Color(0xFF2D3748),
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            doctor.specialty,
                                            style: const TextStyle(
                                              color: Color(0xFF718096),
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF4299E1)
                                              .withValues(alpha: 0.1),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          doctor.department,
                                          style: const TextStyle(
                                            color: Color(0xFF4299E1),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: doctor.availability ==
                                                  'Available'
                                              ? const Color(0xFF48BB78)
                                                  .withValues(alpha: 0.1)
                                              : const Color(0xFFED8936)
                                                  .withValues(alpha: 0.1),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          doctor.availability,
                                          style: TextStyle(
                                            color: doctor.availability ==
                                                    'Available'
                                                ? const Color(0xFF48BB78)
                                                : const Color(0xFFED8936),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        '₹${doctor.consultationFee}',
                                        style: const TextStyle(
                                          color: Color(0xFF2D3748),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Row(
                                        children: [
                                          IconButton(
                                            onPressed: () {},
                                            icon: const Icon(
                                                Icons.visibility_outlined,
                                                size: 18,
                                                color: Color(0xFF4299E1)),
                                          ),
                                          IconButton(
                                            onPressed: () {},
                                            icon: const Icon(Icons.edit_outlined,
                                                size: 18,
                                                color: Color(0xFF48BB78)),
                                          ),
                                          IconButton(
                                            onPressed: () {},
                                            icon: const Icon(Icons.delete_outline,
                                                size: 18,
                                                color: Color(0xFFF56565)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 30),

              // Doctor Details & Schedule
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Doctor Schedule',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    const SizedBox(height: 20),

                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Column(
                        children: [
                          _buildScheduleItem('Monday', '9 AM - 5 PM', 'OPD'),
                          const SizedBox(height: 15),
                          _buildScheduleItem('Tuesday', '9 AM - 5 PM', 'OPD'),
                          const SizedBox(height: 15),
                          _buildScheduleItem('Wednesday', '9 AM - 1 PM', 'OPD'),
                          const SizedBox(height: 15),
                          _buildScheduleItem('Thursday', '9 AM - 5 PM', 'OPD'),
                          const SizedBox(height: 15),
                          _buildScheduleItem('Friday', '9 AM - 5 PM', 'OPD'),
                          const SizedBox(height: 15),
                          _buildScheduleItem('Saturday', '9 AM - 1 PM', 'OPD'),
                          const SizedBox(height: 15),
                          _buildScheduleItem('Sunday', 'Emergency Only', 'On Call'),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    const Text(
                      'Quick Actions',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    const SizedBox(height: 20),

                    GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      childAspectRatio: 1.5,
                      children: [
                        _buildQuickActionCard(
                          'Schedule Appointment',
                          Icons.calendar_today,
                          const Color(0xFF4299E1),
                        ),
                        _buildQuickActionCard(
                          'View Availability',
                          Icons.schedule,
                          const Color(0xFF48BB78),
                        ),
                        _buildQuickActionCard(
                          'Assign Patient',
                          Icons.person_add,
                          const Color(0xFFED8936),
                        ),
                        _buildQuickActionCard(
                          'Generate Report',
                          Icons.assignment,
                          const Color(0xFF9F7AEA),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 30),

          // Department-wise Distribution
          const Text(
            'Department-wise Doctors Distribution',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: _buildDepartmentCard(
                  'Cardiology',
                  5,
                  const Color(0xFF4299E1),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: _buildDepartmentCard(
                  'Orthopedics',
                  4,
                  const Color(0xFF48BB78),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: _buildDepartmentCard(
                  'Dermatology',
                  3,
                  const Color(0xFFED8936),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: _buildDepartmentCard(
                  'Neurology',
                  3,
                  const Color(0xFF9F7AEA),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: _buildDepartmentCard(
                  'Pediatrics',
                  4,
                  const Color(0xFFF56565),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorStatCard(
      String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 15),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF718096),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleItem(String day, String timings, String type) {
    return Row(
      children: [
        Expanded(
          child: Text(
            day,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3748),
            ),
          ),
        ),
        Expanded(
          child: Text(
            timings,
            style: const TextStyle(
              color: Color(0xFF718096),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: type == 'OPD'
                ? const Color(0xFF4299E1).withValues(alpha: 0.1)
                : const Color(0xFFED8936).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            type,
            style: TextStyle(
              color: type == 'OPD'
                  ? const Color(0xFF4299E1)
                  : const Color(0xFFED8936),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionCard(String title, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3748),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDepartmentCard(String name, int doctors, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.local_hospital, color: color, size: 24),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '$doctors doctors',
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Doctor {
  final String id;
  final String name;
  final String specialty;
  final String department;
  final String qualification;
  final String experience;
  final String availability;
  final int consultationFee;

  Doctor({
    required this.id,
    required this.name,
    required this.specialty,
    required this.department,
    required this.qualification,
    required this.experience,
    required this.availability,
    required this.consultationFee,
  });
}