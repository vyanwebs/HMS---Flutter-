import 'package:flutter/material.dart';
import 'package:hms/screens/reception/opd_components/new_opd_appointment_screen.dart';
import 'package:hms/screens/reception/opd_components/opd_patient_registration.dart';
import 'package:hms/screens/reception/opd_components/patient_history_screen.dart';
import 'package:hms/screens/reception/opd_components/prescription_screen.dart';
import 'package:hms/screens/reception/opd_components/opd_billing_screen.dart';
import 'package:hms/models/opd_appointment_model.dart';

class OPDScreen extends StatelessWidget {
  const OPDScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF7FAFC),
      child: const _OPDScreenContent(),
    );
  }
}

class _OPDScreenContent extends StatefulWidget {
  const _OPDScreenContent();

  @override
  State<_OPDScreenContent> createState() => _OPDScreenContentState();
}

class _OPDScreenContentState extends State<_OPDScreenContent> {
  List<OPDAppointment> appointments = [
    OPDAppointment(
      id: 'A1001',
      patientName: 'John Smith',
      age: 45,
      gender: 'Male',
      doctor: 'Dr. Sharma',
      department: 'Cardiology',
      time: '10:00 AM',
      date: '2024-01-16',
      status: 'Confirmed',
      contactNumber: '+1-555-0101',
      appointmentType: 'New',
      reason: 'Chest Pain',
    ),
    OPDAppointment(
      id: 'A1002',
      patientName: 'Michael Brown',
      age: 32,
      gender: 'Male',
      doctor: 'Dr. Patel',
      department: 'Orthopedics',
      time: '11:30 AM',
      date: '2024-01-16',
      status: 'Waiting',
      contactNumber: '+1-555-0102',
      appointmentType: 'Follow-up',
      reason: 'Knee Pain',
    ),
    OPDAppointment(
      id: 'A1003',
      patientName: 'Lisa Taylor',
      age: 42,
      gender: 'Female',
      doctor: 'Dr. Gupta',
      department: 'Dermatology',
      time: '02:00 PM',
      date: '2024-01-16',
      status: 'Confirmed',
      contactNumber: '+1-555-0103',
      appointmentType: 'Consultation',
      reason: 'Skin Allergy',
    ),
    OPDAppointment(
      id: 'A1004',
      patientName: 'Robert Wilson',
      age: 55,
      gender: 'Male',
      doctor: 'Dr. Singh',
      department: 'Neurology',
      time: '03:30 PM',
      date: '2024-01-16',
      status: 'Cancelled',
      contactNumber: '+1-555-0104',
      appointmentType: 'New',
      reason: 'Headache',
    ),
    OPDAppointment(
      id: 'A1005',
      patientName: 'Sarah Johnson',
      age: 28,
      gender: 'Female',
      doctor: 'Dr. Kapoor',
      department: 'Pediatrics',
      time: '09:00 AM',
      date: '2024-01-16',
      status: 'Completed',
      contactNumber: '+1-555-0105',
      appointmentType: 'Follow-up',
      reason: 'Child Vaccination',
    ),
  ];

  List<OPDDepartment> departments = [
    OPDDepartment(
      name: 'Cardiology',
      doctors: 5,
      patientsToday: 45,
      availability: 'High',
      waitingTime: '15 mins',
    ),
    OPDDepartment(
      name: 'Orthopedics',
      doctors: 4,
      patientsToday: 38,
      availability: 'Medium',
      waitingTime: '25 mins',
    ),
    OPDDepartment(
      name: 'Dermatology',
      doctors: 3,
      patientsToday: 28,
      availability: 'Low',
      waitingTime: '40 mins',
    ),
    OPDDepartment(
      name: 'Neurology',
      doctors: 2,
      patientsToday: 22,
      availability: 'Medium',
      waitingTime: '30 mins',
    ),
    OPDDepartment(
      name: 'Pediatrics',
      doctors: 4,
      patientsToday: 35,
      availability: 'High',
      waitingTime: '20 mins',
    ),
  ];

  List<OPDDoctor> doctors = [
    OPDDoctor(
      name: 'Dr. Sharma',
      department: 'Cardiology',
      timings: '10 AM - 4 PM',
      availableSlots: 8,
      currentStatus: 'Available',
      consultationFee: 500.0,
    ),
    OPDDoctor(
      name: 'Dr. Patel',
      department: 'Orthopedics',
      timings: '9 AM - 5 PM',
      availableSlots: 6,
      currentStatus: 'Available',
      consultationFee: 600.0,
    ),
    OPDDoctor(
      name: 'Dr. Gupta',
      department: 'Dermatology',
      timings: '11 AM - 6 PM',
      availableSlots: 4,
      currentStatus: 'Busy',
      consultationFee: 450.0,
    ),
    OPDDoctor(
      name: 'Dr. Singh',
      department: 'Neurology',
      timings: '8 AM - 2 PM',
      availableSlots: 5,
      currentStatus: 'Available',
      consultationFee: 700.0,
    ),
  ];

  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Outpatient Department (OPD)',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _createNewAppointment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4299E1),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('New Appointment'),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Stats Cards
            SizedBox(
              height: 140,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildOPDStatCard(
                      'Today\'s Appointments',
                      '${appointments.length}',
                      Icons.calendar_today,
                      const Color(0xFF4299E1)),
                  const SizedBox(width: 20),
                  _buildOPDStatCard(
                      'Waiting Patients',
                      '${appointments.where((a) => a.status == 'Waiting').length}',
                      Icons.timer,
                      const Color(0xFFED8936)),
                  const SizedBox(width: 20),
                  _buildOPDStatCard(
                      'Doctors Available',
                      '${doctors.where((d) => d.currentStatus == 'Available').length}',
                      Icons.person,
                      const Color(0xFF48BB78)),
                  const SizedBox(width: 20),
                  _buildOPDStatCard(
                      'Total Departments',
                      '${departments.length}',
                      Icons.category,
                      const Color(0xFF9F7AEA)),
                  const SizedBox(width: 20),
                  _buildOPDStatCard(
                      'Completed Today',
                      '${appointments.where((a) => a.status == 'Completed').length}',
                      Icons.check_circle,
                      const Color(0xFF38B2AC)),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Filter and Search
            Row(
              children: [
                // Filter Chips
                Expanded(
                  child: Wrap(
                    spacing: 8,
                    children: [
                      'All',
                      'Today',
                      'Upcoming',
                      'Completed',
                      'Cancelled'
                    ].map((filter) {
                      final isSelected = _selectedFilter == filter;
                      return ChoiceChip(
                        label: Text(filter),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _selectedFilter = selected ? filter : 'All';
                          });
                        },
                        backgroundColor: Colors.white,
                        selectedColor: const Color(0xFF4299E1),
                        labelStyle: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF718096),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: isSelected
                                ? const Color(0xFF4299E1)
                                : const Color(0xFFE2E8F0),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                // Search Bar
                Container(
                  width: 300,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7FAFC),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 12),
                      const Icon(Icons.search,
                          color: Color(0xFF718096), size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: const InputDecoration(
                            hintText: 'Search appointments...',
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                              color: Color(0xFFA0AEC0),
                              fontSize: 14,
                            ),
                          ),
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF2D3748),
                          ),
                          onChanged: (value) {
                            setState(() {});
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Today's Appointments
            const Text(
              'Today\'s Appointments',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 15),

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
                      border:
                          Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
                    ),
                    child: const Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Appointment ID',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2D3748),
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Patient',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2D3748),
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Doctor/Dept',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2D3748),
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Time',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2D3748),
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Status',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2D3748),
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Actions',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2D3748),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Appointments List
                  ..._filteredAppointments.map((appointment) => Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: const Color(0xFFE2E8F0)),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                appointment.id,
                                style: const TextStyle(
                                  color: Color(0xFF4299E1),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    appointment.patientName,
                                    style: const TextStyle(
                                      color: Color(0xFF2D3748),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    '${appointment.age} yrs • ${appointment.gender}',
                                    style: const TextStyle(
                                      color: Color(0xFF718096),
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    appointment.doctor,
                                    style: const TextStyle(
                                      color: Color(0xFF4299E1),
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    appointment.department,
                                    style: const TextStyle(
                                      color: Color(0xFF718096),
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    appointment.time,
                                    style: const TextStyle(
                                      color: Color(0xFF2D3748),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    appointment.date,
                                    style: const TextStyle(
                                      color: Color(0xFF718096),
                                      fontSize: 11,
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
                                  color: _getStatusColor(appointment.status)
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  appointment.status,
                                  style: TextStyle(
                                    color: _getStatusColor(appointment.status),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: () =>
                                        _viewAppointmentDetails(appointment),
                                    icon: const Icon(Icons.visibility_outlined,
                                        size: 18, color: Color(0xFF4299E1)),
                                    tooltip: 'View Details',
                                  ),
                                  IconButton(
                                    onPressed: () =>
                                        _editAppointment(appointment),
                                    icon: const Icon(Icons.edit_outlined,
                                        size: 18, color: Color(0xFF48BB78)),
                                    tooltip: 'Edit',
                                  ),
                                  IconButton(
                                    onPressed: () =>
                                        _generatePrescription(appointment),
                                    icon: const Icon(
                                        Icons.medical_services_outlined,
                                        size: 18,
                                        color: Color(0xFFED8936)),
                                    tooltip: 'Prescription',
                                  ),
                                  if (appointment.status == 'Waiting' ||
                                      appointment.status == 'Confirmed')
                                    IconButton(
                                      onPressed: () =>
                                          _completeAppointment(appointment),
                                      icon: const Icon(
                                          Icons.check_circle_outlined,
                                          size: 18,
                                          color: Color(0xFF38B2AC)),
                                      tooltip: 'Complete',
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

            const SizedBox(height: 30),

            // Departments & Doctors
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Departments
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Departments',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D3748),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Column(
                          children: departments
                              .map((dept) => _buildDepartmentItem(dept))
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 20),

                // Doctors
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Doctors Available',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D3748),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Column(
                          children: doctors
                              .map((doctor) => _buildDoctorItem(doctor))
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Quick Actions
            const Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 20),

            Wrap(
              spacing: 20,
              runSpacing: 20,
              children: [
                _buildQuickActionCard(
                  'Register New OPD Patient',
                  Icons.person_add,
                  const Color(0xFF4299E1),
                  _registerNewPatient,
                ),
                _buildQuickActionCard(
                  'View Patient History',
                  Icons.history,
                  const Color(0xFF48BB78),
                  _viewPatientHistory,
                ),
                _buildQuickActionCard(
                  'Print Prescription',
                  Icons.print,
                  const Color(0xFFED8936),
                  _printPrescription,
                ),
                _buildQuickActionCard(
                  'Generate OPD Bill',
                  Icons.receipt,
                  const Color(0xFF9F7AEA),
                  _generateOPDBill,
                ),
                _buildQuickActionCard(
                  'Today\'s Reports',
                  Icons.assignment,
                  const Color(0xFFF56565),
                  _viewReports,
                ),
                _buildQuickActionCard(
                  'Doctor Schedule',
                  Icons.schedule,
                  const Color(0xFF38B2AC),
                  _viewDoctorSchedule,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOPDStatCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      width: 200,
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
    );
  }

  Widget _buildDepartmentItem(OPDDepartment dept) {
    Color availabilityColor;
    switch (dept.availability) {
      case 'High':
        availabilityColor = const Color(0xFF48BB78);
        break;
      case 'Medium':
        availabilityColor = const Color(0xFFED8936);
        break;
      case 'Low':
        availabilityColor = const Color(0xFFF56565);
        break;
      default:
        availabilityColor = const Color(0xFF4299E1);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF4299E1).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.local_hospital,
                color: Color(0xFF4299E1), size: 20),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dept.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${dept.doctors} doctors • ${dept.patientsToday} patients',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF718096),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Wait time: ${dept.waitingTime}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFFA0AEC0),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: availabilityColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              dept.availability,
              style: TextStyle(
                color: availabilityColor,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorItem(OPDDoctor doctor) {
    Color statusColor;
    switch (doctor.currentStatus) {
      case 'Available':
        statusColor = const Color(0xFF48BB78);
        break;
      case 'Busy':
        statusColor = const Color(0xFFED8936);
        break;
      case 'Away':
        statusColor = const Color(0xFFF56565);
        break;
      default:
        statusColor = const Color(0xFF718096);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF48BB78).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.person, color: Color(0xFF48BB78), size: 20),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doctor.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  doctor.department,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF718096),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  doctor.timings,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFFA0AEC0),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Fee: ₹${doctor.consultationFee} • Slots: ${doctor.availableSlots}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF4299E1),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              doctor.currentStatus,
              style: TextStyle(
                color: statusColor,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard(
      String title, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 180,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
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
            const SizedBox(height: 15),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF2D3748),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Filtered Appointments
  List<OPDAppointment> get _filteredAppointments {
    List<OPDAppointment> filtered = appointments;

    // Apply status filter
    if (_selectedFilter == 'Today') {
      filtered = filtered.where((a) => a.date == '2024-01-16').toList();
    } else if (_selectedFilter == 'Upcoming') {
      filtered = filtered
          .where((a) => a.status == 'Confirmed' || a.status == 'Waiting')
          .toList();
    } else if (_selectedFilter == 'Completed') {
      filtered = filtered.where((a) => a.status == 'Completed').toList();
    } else if (_selectedFilter == 'Cancelled') {
      filtered = filtered.where((a) => a.status == 'Cancelled').toList();
    }

    // Apply search filter
    if (_searchController.text.isNotEmpty) {
      final searchTerm = _searchController.text.toLowerCase();
      filtered = filtered
          .where((a) =>
              a.patientName.toLowerCase().contains(searchTerm) ||
              a.id.toLowerCase().contains(searchTerm) ||
              a.doctor.toLowerCase().contains(searchTerm) ||
              a.department.toLowerCase().contains(searchTerm))
          .toList();
    }

    return filtered;
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Confirmed':
        return const Color(0xFF48BB78);
      case 'Waiting':
        return const Color(0xFFED8936);
      case 'Completed':
        return const Color(0xFF38B2AC);
      case 'Cancelled':
        return const Color(0xFFF56565);
      default:
        return const Color(0xFF718096);
    }
  }

  // Action Methods
  void _createNewAppointment() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const NewOPDAppointmentScreen(),
      ),
    );

    if (result != null && result is OPDAppointment) {
      setState(() {
        appointments.add(result);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Appointment created for ${result.patientName}'),
          backgroundColor: const Color(0xFF48BB78),
        ),
      );
    }
  }

  void _registerNewPatient() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const OPDPatientRegistrationScreen(),
      ),
    );

    if (result != null && result is Map<String, dynamic>) {
      // Create an appointment from the patient registration data
      final newAppointment = OPDAppointment(
        id: 'A${1000 + appointments.length}',
        patientName: result['patientName'],
        age: result['age'],
        gender: result['gender'],
        doctor: 'Dr. Sharma',
        department: 'General',
        time: '10:00 AM',
        date: '2024-01-16',
        status: 'Confirmed',
        contactNumber: result['contactNumber'] ?? '+1-555-0000',
        appointmentType: 'New',
        reason: 'General Consultation',
      );

      setState(() {
        appointments.add(newAppointment);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Patient ${result['patientName']} registered successfully'),
          backgroundColor: const Color(0xFF48BB78),
        ),
      );
    }
  }

  void _viewPatientHistory() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PatientHistoryScreen(),
      ),
    );
  }

  void _generatePrescription(OPDAppointment appointment) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PrescriptionScreen(appointment: appointment),
      ),
    );
  }

  void _printPrescription() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PrescriptionScreen(),
      ),
    );
  }

  void _generateOPDBill() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const OPDBillingScreen(),
      ),
    );
  }

  void _viewReports() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Today\'s OPD Reports'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('• Total Appointments: 24'),
            Text('• Completed: 15'),
            Text('• Pending: 8'),
            Text('• Cancelled: 1'),
            Text('• Revenue Generated: ₹12,500'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              // Generate PDF report
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Report generated and saved'),
                  backgroundColor: Color(0xFF48BB78),
                ),
              );
            },
            child: const Text('Export PDF'),
          ),
        ],
      ),
    );
  }

  void _viewDoctorSchedule() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Doctor Schedule'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: doctors
                .map((doctor) => ListTile(
                      leading:
                          const Icon(Icons.person, color: Color(0xFF4299E1)),
                      title: Text(doctor.name),
                      subtitle:
                          Text('${doctor.department} • ${doctor.timings}'),
                      trailing: Chip(
                        label: Text(doctor.currentStatus),
                        backgroundColor: _getStatusColor(doctor.currentStatus)
                            .withValues(alpha: 0.1),
                        labelStyle: TextStyle(
                            color: _getStatusColor(doctor.currentStatus)),
                      ),
                    ))
                .toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _viewAppointmentDetails(OPDAppointment appointment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Appointment Details - ${appointment.id}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Patient', appointment.patientName),
            _buildDetailRow(
                'Age/Gender', '${appointment.age} yrs • ${appointment.gender}'),
            _buildDetailRow('Contact', appointment.contactNumber),
            _buildDetailRow('Doctor', appointment.doctor),
            _buildDetailRow('Department', appointment.department),
            _buildDetailRow(
                'Date & Time', '${appointment.date} at ${appointment.time}'),
            _buildDetailRow('Type', appointment.appointmentType),
            _buildDetailRow('Reason', appointment.reason),
            _buildDetailRow('Status', appointment.status),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '$label:',
              style: const TextStyle(
                color: Color(0xFF718096),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                color: Color(0xFF2D3748),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _editAppointment(OPDAppointment appointment) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            NewOPDAppointmentScreen(appointmentToEdit: appointment),
      ),
    );

    if (result != null && result is OPDAppointment) {
      setState(() {
        final index = appointments.indexWhere((a) => a.id == appointment.id);
        if (index != -1) {
          appointments[index] = result;
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Appointment updated for ${result.patientName}'),
          backgroundColor: const Color(0xFF48BB78),
        ),
      );
    }
  }

  void _completeAppointment(OPDAppointment appointment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Complete Appointment'),
        content: const Text('Mark this appointment as completed?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                final index =
                    appointments.indexWhere((a) => a.id == appointment.id);
                if (index != -1) {
                  appointments[index] = OPDAppointment(
                    id: appointment.id,
                    patientName: appointment.patientName,
                    age: appointment.age,
                    gender: appointment.gender,
                    doctor: appointment.doctor,
                    department: appointment.department,
                    time: appointment.time,
                    date: appointment.date,
                    status: 'Completed',
                    contactNumber: appointment.contactNumber,
                    appointmentType: appointment.appointmentType,
                    reason: appointment.reason,
                  );
                }
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      'Appointment for ${appointment.patientName} completed'),
                  backgroundColor: const Color(0xFF38B2AC),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF38B2AC),
            ),
            child: const Text('Complete'),
          ),
        ],
      ),
    );
  }
}
