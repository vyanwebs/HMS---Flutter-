import 'package:flutter/material.dart';

class PatientHistoryScreen extends StatefulWidget {
  const PatientHistoryScreen({super.key});

  @override
  State<PatientHistoryScreen> createState() => _PatientHistoryScreenState();
}

class _PatientHistoryScreenState extends State<PatientHistoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<PatientHistory> _patients = [
    PatientHistory(
      id: 'P1001',
      name: 'John Smith',
      age: 45,
      gender: 'Male',
      lastVisit: '2024-01-15',
      totalVisits: 8,
      doctor: 'Dr. Sharma',
      department: 'Cardiology',
      nextAppointment: '2024-01-20',
      status: 'Active',
    ),
    PatientHistory(
      id: 'P1002',
      name: 'Michael Brown',
      age: 32,
      gender: 'Male',
      lastVisit: '2024-01-10',
      totalVisits: 5,
      doctor: 'Dr. Patel',
      department: 'Orthopedics',
      nextAppointment: '2024-01-25',
      status: 'Active',
    ),
    PatientHistory(
      id: 'P1003',
      name: 'Lisa Taylor',
      age: 42,
      gender: 'Female',
      lastVisit: '2024-01-12',
      totalVisits: 12,
      doctor: 'Dr. Gupta',
      department: 'Dermatology',
      nextAppointment: '2024-02-01',
      status: 'Active',
    ),
    PatientHistory(
      id: 'P1004',
      name: 'Robert Wilson',
      age: 55,
      gender: 'Male',
      lastVisit: '2023-12-20',
      totalVisits: 15,
      doctor: 'Dr. Singh',
      department: 'Neurology',
      nextAppointment: 'None',
      status: 'Inactive',
    ),
    PatientHistory(
      id: 'P1005',
      name: 'Sarah Johnson',
      age: 28,
      gender: 'Female',
      lastVisit: '2024-01-14',
      totalVisits: 3,
      doctor: 'Dr. Kapoor',
      department: 'Pediatrics',
      nextAppointment: '2024-01-22',
      status: 'Active',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Patient History',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3748),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF4299E1)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFFF7FAFC),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 12),
                  const Icon(Icons.search, color: Color(0xFF718096), size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: 'Search patients by name or ID...',
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
                  if (_searchController.text.isNotEmpty)
                    IconButton(
                      onPressed: () {
                        _searchController.clear();
                        setState(() {});
                      },
                      icon: const Icon(Icons.clear,
                          size: 20, color: Color(0xFF718096)),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Stats Cards
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildStatCard('Total Patients', '${_patients.length}',
                      Icons.group, const Color(0xFF4299E1)),
                  const SizedBox(width: 15),
                  _buildStatCard(
                      'Active Patients',
                      '${_patients.where((p) => p.status == 'Active').length}',
                      Icons.check_circle,
                      const Color(0xFF48BB78)),
                  const SizedBox(width: 15),
                  _buildStatCard(
                      'Total Visits',
                      '${_patients.fold(0, (sum, p) => sum + p.totalVisits)}',
                      Icons.history,
                      const Color(0xFFED8936)),
                  const SizedBox(width: 15),
                  _buildStatCard('Today\'s Appointments', '3',
                      Icons.calendar_today, const Color(0xFF9F7AEA)),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Patients List
            Expanded(
              child: Container(
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
                              'Patient ID',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF2D3748),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'Patient Details',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF2D3748),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'Last Visit',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF2D3748),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'Total Visits',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF2D3748),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'Status',
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

                    // Patients List
                    Expanded(
                      child: ListView.builder(
                        itemCount: _filteredPatients.length,
                        itemBuilder: (context, index) {
                          final patient = _filteredPatients[index];
                          return Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom:
                                    BorderSide(color: const Color(0xFFE2E8F0)),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    patient.id,
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
                                        patient.name,
                                        style: const TextStyle(
                                          color: Color(0xFF2D3748),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        '${patient.age} yrs • ${patient.gender}',
                                        style: const TextStyle(
                                          color: Color(0xFF718096),
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        '${patient.department}',
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        patient.lastVisit,
                                        style: const TextStyle(
                                          color: Color(0xFF2D3748),
                                        ),
                                      ),
                                      Text(
                                        'Dr. ${patient.doctor}',
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${patient.totalVisits}',
                                        style: const TextStyle(
                                          color: Color(0xFF2D3748),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'Next: ${patient.nextAppointment}',
                                        style: const TextStyle(
                                          color: Color(0xFF4299E1),
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
                                      color: patient.status == 'Active'
                                          ? const Color(0xFF48BB78)
                                              .withValues(alpha: 0.1)
                                          : const Color(0xFFF56565)
                                              .withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      patient.status,
                                      style: TextStyle(
                                        color: patient.status == 'Active'
                                            ? const Color(0xFF48BB78)
                                            : const Color(0xFFF56565),
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
                                            _viewPatientDetails(patient),
                                        icon: Icon(Icons.visibility_outlined,
                                            size: 18, color: Color(0xFF4299E1)),
                                        tooltip: 'View History',
                                      ),
                                      IconButton(
                                        onPressed: () =>
                                            _createNewAppointment(patient),
                                        icon: Icon(Icons.add,
                                            size: 18, color: Color(0xFF48BB78)),
                                        tooltip: 'New Appointment',
                                      ),
                                      IconButton(
                                        onPressed: () =>
                                            _exportHistory(patient),
                                        icon: Icon(Icons.download,
                                            size: 18, color: Color(0xFFED8936)),
                                        tooltip: 'Export History',
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      width: 180,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF718096),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<PatientHistory> get _filteredPatients {
    if (_searchController.text.isEmpty) {
      return _patients;
    }
    final searchTerm = _searchController.text.toLowerCase();
    return _patients
        .where((patient) =>
            patient.name.toLowerCase().contains(searchTerm) ||
            patient.id.toLowerCase().contains(searchTerm) ||
            patient.department.toLowerCase().contains(searchTerm))
        .toList();
  }

  void _viewPatientDetails(PatientHistory patient) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Patient History - ${patient.name}'),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow('Patient ID', patient.id),
                _buildDetailRow('Name', patient.name),
                _buildDetailRow(
                    'Age/Gender', '${patient.age} yrs • ${patient.gender}'),
                _buildDetailRow('Primary Doctor', patient.doctor),
                _buildDetailRow('Department', patient.department),
                _buildDetailRow('Total Visits', '${patient.totalVisits}'),
                _buildDetailRow('Last Visit', patient.lastVisit),
                _buildDetailRow('Next Appointment', patient.nextAppointment),
                _buildDetailRow('Status', patient.status),
                const SizedBox(height: 20),
                const Text(
                  'Recent Visits:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 10),
                ...List.generate(
                    3,
                    (index) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF4299E1),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Visit ${patient.totalVisits - index} (${DateTime.now().subtract(Duration(days: index * 30)).toString().substring(0, 10)})',
                                  style: const TextStyle(
                                    color: Color(0xFF4A5568),
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color:
                                      const Color(0xFF48BB78).withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'Completed',
                                  style: TextStyle(
                                    color: const Color(0xFF48BB78),
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _exportHistory(patient);
            },
            child: const Text('Export Full History'),
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

  void _createNewAppointment(PatientHistory patient) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Creating new appointment for ${patient.name}...'),
        backgroundColor: const Color(0xFF4299E1),
      ),
    );

    // In real app, navigate to appointment screen with pre-filled patient data
    final patientData = {
      'patientName': patient.name,
      'patientId': patient.id,
      'age': patient.age,
      'gender': patient.gender,
    };

    // Navigate back with data
    Navigator.pop(context, patientData);
  }

  void _exportHistory(PatientHistory patient) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Exporting history for ${patient.name}...'),
        backgroundColor: const Color(0xFF48BB78),
      ),
    );
  }
}

class PatientHistory {
  final String id;
  final String name;
  final int age;
  final String gender;
  final String lastVisit;
  final int totalVisits;
  final String doctor;
  final String department;
  final String nextAppointment;
  final String status;

  PatientHistory({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.lastVisit,
    required this.totalVisits,
    required this.doctor,
    required this.department,
    required this.nextAppointment,
    required this.status,
  });
}
