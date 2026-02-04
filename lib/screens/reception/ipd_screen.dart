import 'package:flutter/material.dart';
import 'package:hms/models/ipd_patient_model.dart';
import 'package:hms/screens/reception/patient_components/patient_admission_screen.dart';
import 'package:hms/screens/reception/patient_components/patient_details_screen.dart';
import 'package:hms/screens/reception/patient_components/patient_notes_screen.dart';
import 'package:hms/screens/reception/patient_components/patient_discharge_screen.dart';

class IPDScreen extends StatefulWidget {
  const IPDScreen({super.key});

  @override
  State<IPDScreen> createState() => _IPDScreenState();
}

class _IPDScreenState extends State<IPDScreen> {
  List<IPDPatient> ipdPatients = [
    IPDPatient(
      id: 'P10002',
      name: 'Sarah Johnson',
      age: 32,
      gender: 'Female',
      ward: 'Ward A',
      bedNo: 'A-101',
      admissionDate: '2024-01-14',
      doctor: 'Dr. Sharma',
      status: 'Stable',
      diagnosis: 'Hypertension',
      contactNumber: '+1-555-0123',
      address: '123 Main St, New York',
      emergencyContact: '+1-555-0124',
      insuranceProvider: 'HealthFirst Inc.',
      insurancePolicyNo: 'HF-789012',
      medications: ['Metformin 500mg', 'Lisinopril 10mg'],
      labReports: ['Blood Test Report', 'Urine Analysis'],
    ),
    IPDPatient(
      id: 'P10004',
      name: 'Emily Davis',
      age: 29,
      gender: 'Female',
      ward: 'ICU',
      bedNo: 'ICU-03',
      admissionDate: '2024-01-12',
      doctor: 'Dr. Patel',
      status: 'Critical',
      diagnosis: 'Pneumonia',
      contactNumber: '+1-555-0125',
      address: '456 Oak Ave, Boston',
      emergencyContact: '+1-555-0126',
      insuranceProvider: 'MediCare Plus',
      insurancePolicyNo: 'MC-345678',
    ),
    IPDPatient(
      id: 'P10006',
      name: 'David Miller',
      age: 55,
      gender: 'Male',
      ward: 'Ward B',
      bedNo: 'B-205',
      admissionDate: '2024-01-10',
      doctor: 'Dr. Gupta',
      status: 'Improving',
      diagnosis: 'Diabetes Type 2',
      contactNumber: '+1-555-0127',
      address: '789 Pine Rd, Chicago',
      emergencyContact: '+1-555-0128',
      insuranceProvider: 'Blue Cross',
      insurancePolicyNo: 'BC-901234',
    ),
    IPDPatient(
      id: 'P10008',
      name: 'Lisa Taylor',
      age: 42,
      gender: 'Female',
      ward: 'Ward A',
      bedNo: 'A-102',
      admissionDate: '2024-01-08',
      doctor: 'Dr. Sharma',
      status: 'Stable',
      diagnosis: 'Arthritis',
      contactNumber: '+1-555-0129',
      address: '321 Elm St, Los Angeles',
      emergencyContact: '+1-555-0130',
      insuranceProvider: 'Aetna Health',
      insurancePolicyNo: 'AH-567890',
    ),
  ];

  String _selectedFilter = 'All';
  final List<String> _filters = [
    'All',
    'Ward A',
    'Ward B',
    'ICU',
    'Private Rooms'
  ];
  final TextEditingController _searchController = TextEditingController();

  List<IPDPatient> get _filteredPatients {
    if (_selectedFilter == 'All') {
      return ipdPatients;
    }
    return ipdPatients
        .where((patient) => patient.ward == _selectedFilter)
        .toList();
  }

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
          // Header with Admit Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Inpatient Department (IPD)',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3748),
                ),
              ),
              ElevatedButton.icon(
                onPressed: _admitPatient,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4299E1),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Admit Patient'),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Stats Cards
          Row(
            children: [
              _buildIPDStatCard('Total Admitted', '${ipdPatients.length}',
                  Icons.bed_outlined, const Color(0xFF4299E1)),
              const SizedBox(width: 20),
              _buildIPDStatCard(
                  'ICU Patients',
                  '${ipdPatients.where((p) => p.ward == 'ICU').length}',
                  Icons.medical_services,
                  const Color(0xFFF56565)),
              const SizedBox(width: 20),
              _buildIPDStatCard('Available Beds', '15', Icons.king_bed,
                  const Color(0xFF48BB78)),
              const SizedBox(width: 20),
              _buildIPDStatCard('Today\'s Admissions', '1', Icons.person_add,
                  const Color(0xFFED8936)),
            ],
          ),

          const SizedBox(height: 30),

          // Filter and Search Bar
          Row(
            children: [
              // Filter Chips
              Expanded(
                child: Wrap(
                  spacing: 8,
                  children: _filters.map((filter) {
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
                        color:
                            isSelected ? Colors.white : const Color(0xFF718096),
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
                          hintText: 'Search patients...',
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

          // IPD Patients Table
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
                          'Patient ID',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2D3748),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Name',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2D3748),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Ward/Bed',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2D3748),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Admission Date',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2D3748),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Doctor',
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
                        flex: 2,
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

                // Table Rows
                ..._filteredPatients.where((patient) {
                  final searchTerm = _searchController.text.toLowerCase();
                  return searchTerm.isEmpty ||
                      patient.name.toLowerCase().contains(searchTerm) ||
                      patient.id.toLowerCase().contains(searchTerm) ||
                      patient.ward.toLowerCase().contains(searchTerm);
                }).map((patient) => Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey.shade200),
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
                            child: Text(
                              patient.name,
                              style: const TextStyle(
                                color: Color(0xFF2D3748),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  patient.ward,
                                  style: const TextStyle(
                                    color: Color(0xFF2D3748),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  'Bed: ${patient.bedNo}',
                                  style: const TextStyle(
                                    color: Color(0xFF718096),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Text(
                              patient.admissionDate,
                              style: const TextStyle(
                                color: Color(0xFF718096),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              patient.doctor,
                              style: const TextStyle(
                                color: Color(0xFF4299E1),
                                fontWeight: FontWeight.w500,
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
                                color: patient.status == 'Critical'
                                    ? const Color(0xFFF56565).withValues(alpha: 0.1)
                                    : patient.status == 'Stable'
                                        ? const Color(0xFF48BB78)
                                            .withValues(alpha: 0.1)
                                        : patient.status == 'Improving'
                                            ? const Color(0xFFED8936)
                                                .withValues(alpha: 0.1)
                                            : const Color(0xFF4299E1)
                                                .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                patient.status,
                                style: TextStyle(
                                  color: patient.status == 'Critical'
                                      ? const Color(0xFFF56565)
                                      : patient.status == 'Stable'
                                          ? const Color(0xFF48BB78)
                                          : patient.status == 'Improving'
                                              ? const Color(0xFFED8936)
                                              : const Color(0xFF4299E1),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () => _viewPatientDetails(patient),
                                  icon: const Icon(Icons.visibility_outlined,
                                      size: 18, color: Color(0xFF4299E1)),
                                  tooltip: 'View Details',
                                ),
                                IconButton(
                                  onPressed: () => _editPatient(patient),
                                  icon: const Icon(Icons.edit_outlined,
                                      size: 18, color: Color(0xFF48BB78)),
                                  tooltip: 'Edit',
                                ),
                                IconButton(
                                  onPressed: () => _addNotes(patient),
                                  icon: const Icon(Icons.notes_outlined,
                                      size: 18, color: Color(0xFFED8936)),
                                  tooltip: 'Add Notes',
                                ),
                                IconButton(
                                  onPressed: () => _dischargePatient(patient),
                                  icon: const Icon(Icons.exit_to_app_outlined,
                                      size: 18, color: Color(0xFFF56565)),
                                  tooltip: 'Discharge',
                                ),
                                PopupMenuButton<dynamic>(
                                  icon: const Icon(Icons.more_vert,
                                      color: Color(0xFF718096)),
                                  itemBuilder: (context) {
                                    return [
                                      PopupMenuItem<dynamic>(
                                        value: 'duplicate',
                                        child: const Row(
                                          children: [
                                            Icon(Icons.copy, size: 18),
                                            SizedBox(width: 8),
                                            Text('Duplicate'),
                                          ],
                                        ),
                                      ),
                                      const PopupMenuDivider(),
                                      PopupMenuItem<dynamic>(
                                        value: 'delete',
                                        child: const Row(
                                          children: [
                                            Icon(Icons.delete,
                                                size: 18, color: Colors.red),
                                            SizedBox(width: 8),
                                            Text('Delete'),
                                          ],
                                        ),
                                      ),
                                    ];
                                  },
                                  onSelected: (value) {
                                    if (value == 'duplicate') {
                                      _duplicatePatient(patient);
                                    } else if (value == 'delete') {
                                      _deletePatient(patient);
                                    }
                                  },
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

          // Ward Status
          const Text(
            'Ward Status',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 20),

          Row(
            children: [
              _buildWardStatusCard('Ward A', 20, 15, 5),
              const SizedBox(width: 20),
              _buildWardStatusCard('Ward B', 25, 20, 5),
              const SizedBox(width: 20),
              _buildWardStatusCard('ICU', 10, 8, 2),
              const SizedBox(width: 20),
              _buildWardStatusCard('Private Rooms', 15, 10, 5),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIPDStatCard(
      String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF718096),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWardStatusCard(
      String ward, int totalBeds, int occupied, int available) {
    final wardPatients = ipdPatients.where((p) => p.ward == ward).length;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  ward,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: wardPatients == 0
                        ? const Color(0xFF48BB78).withValues(alpha: 0.1)
                        : wardPatients <= 5
                            ? const Color(0xFFED8936).withValues(alpha: 0.1)
                            : const Color(0xFFF56565).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$wardPatients Patients',
                    style: TextStyle(
                      color: wardPatients == 0
                          ? const Color(0xFF48BB78)
                          : wardPatients <= 5
                              ? const Color(0xFFED8936)
                              : const Color(0xFFF56565),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            _buildBedStatus('Total Beds', totalBeds, const Color(0xFF4299E1)),
            const SizedBox(height: 10),
            _buildBedStatus('Occupied', occupied, const Color(0xFFF56565)),
            const SizedBox(height: 10),
            _buildBedStatus('Available', available, const Color(0xFF48BB78)),
            const SizedBox(height: 10),
            _buildBedStatus(
                'Current Patients', wardPatients, const Color(0xFFED8936)),
          ],
        ),
      ),
    );
  }

  Widget _buildBedStatus(String label, int count, Color color) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: Color(0xFF718096),
            ),
          ),
        ),
        Text(
          '$count',
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // Action Methods
  void _admitPatient() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PatientAdmissionScreen(),
      ),
    );

    if (result != null && result is IPDPatient) {
      setState(() {
        ipdPatients.add(result);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Patient ${result.name} admitted successfully'),
          backgroundColor: const Color(0xFF48BB78),
        ),
      );
    }
  }

  void _viewPatientDetails(IPDPatient patient) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PatientDetailsScreen(patient: patient),
      ),
    );
  }

  void _editPatient(IPDPatient patient) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PatientAdmissionScreen(patientToEdit: patient),
      ),
    );

    if (result != null && result is IPDPatient) {
      setState(() {
        final index = ipdPatients.indexWhere((p) => p.id == patient.id);
        if (index != -1) {
          ipdPatients[index] = result;
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Patient ${result.name} updated successfully'),
          backgroundColor: const Color(0xFF48BB78),
        ),
      );
    }
  }

  void _addNotes(IPDPatient patient) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PatientNotesScreen(patient: patient),
      ),
    );
  }

  void _dischargePatient(IPDPatient patient) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PatientDischargeScreen(patient: patient),
      ),
    );

    if (result != null && result is IPDPatient) {
      setState(() {
        ipdPatients.removeWhere((p) => p.id == patient.id);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Patient ${patient.name} discharged successfully'),
          backgroundColor: const Color(0xFF48BB78),
        ),
      );
    }
  }

  void _duplicatePatient(IPDPatient patient) {
    final duplicatedPatient = patient.copyWith(
      id: '${patient.id}-COPY',
      bedNo: '${patient.bedNo}-COPY',
    );

    setState(() {
      ipdPatients.add(duplicatedPatient);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Patient ${patient.name} duplicated'),
        backgroundColor: const Color(0xFF4299E1),
      ),
    );
  }

  void _deletePatient(IPDPatient patient) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Patient'),
        content: Text('Are you sure you want to delete ${patient.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                ipdPatients.removeWhere((p) => p.id == patient.id);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Patient ${patient.name} deleted'),
                  backgroundColor: const Color(0xFFF56565),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF56565),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
