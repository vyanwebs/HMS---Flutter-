// lib/screens/reception/patient_directory.dart
import 'package:flutter/material.dart';

class PatientDirectory extends StatefulWidget {
  const PatientDirectory({super.key});

  @override
  State<PatientDirectory> createState() => _PatientDirectoryState();
}

class _PatientDirectoryState extends State<PatientDirectory> {
  final List<Patient> patients = [
    Patient(
      id: 'P10001',
      name: 'John Smith',
      age: 45,
      gender: 'Male',
      type: 'OPD',
      status: 'Active',
      lastVisit: '2024-01-15',
      phone: '+91 9876543210',
      email: 'john.smith@email.com',
      address: '123 Main Street, City',
      bloodGroup: 'O+',
      allergies: 'None',
    ),
    Patient(
      id: 'P10002',
      name: 'Sarah Johnson',
      age: 32,
      gender: 'Female',
      type: 'IPD',
      status: 'Admitted',
      lastVisit: '2024-01-14',
      phone: '+91 8765432109',
      email: 'sarah.j@email.com',
      address: '456 Oak Avenue, City',
      bloodGroup: 'A+',
      allergies: 'Penicillin',
    ),
    Patient(
      id: 'P10003',
      name: 'Michael Brown',
      age: 58,
      gender: 'Male',
      type: 'OPD',
      status: 'Active',
      lastVisit: '2024-01-13',
      phone: '+91 7654321098',
      email: 'michael.b@email.com',
      address: '789 Pine Road, City',
      bloodGroup: 'B+',
      allergies: 'Dust, Pollen',
    ),
    Patient(
      id: 'P10004',
      name: 'Emily Davis',
      age: 29,
      gender: 'Female',
      type: 'IPD',
      status: 'Admitted',
      lastVisit: '2024-01-12',
      phone: '+91 6543210987',
      email: 'emily.d@email.com',
      address: '321 Elm Street, City',
      bloodGroup: 'AB+',
      allergies: 'None',
    ),
    Patient(
      id: 'P10005',
      name: 'Robert Wilson',
      age: 65,
      gender: 'Male',
      type: 'OPD',
      status: 'Inactive',
      lastVisit: '2024-01-10',
      phone: '+91 5432109876',
      email: 'robert.w@email.com',
      address: '654 Maple Lane, City',
      bloodGroup: 'O-',
      allergies: 'Shellfish',
    ),
    Patient(
      id: 'P10006',
      name: 'Lisa Taylor',
      age: 42,
      gender: 'Female',
      type: 'OPD',
      status: 'Active',
      lastVisit: '2024-01-09',
      phone: '+91 4321098765',
      email: 'lisa.t@email.com',
      address: '987 Cedar Street, City',
      bloodGroup: 'A-',
      allergies: 'Latex',
    ),
    Patient(
      id: 'P10007',
      name: 'David Miller',
      age: 55,
      gender: 'Male',
      type: 'IPD',
      status: 'Admitted',
      lastVisit: '2024-01-08',
      phone: '+91 3210987654',
      email: 'david.m@email.com',
      address: '147 Walnut Avenue, City',
      bloodGroup: 'B-',
      allergies: 'Aspirin',
    ),
    Patient(
      id: 'P10008',
      name: 'Jennifer Lee',
      age: 38,
      gender: 'Female',
      type: 'OPD',
      status: 'Active',
      lastVisit: '2024-01-07',
      phone: '+91 2109876543',
      email: 'jennifer.l@email.com',
      address: '258 Birch Road, City',
      bloodGroup: 'O+',
      allergies: 'Peanuts',
    ),
  ];

  String _selectedFilter = 'All';
  String _selectedStatus = 'All';
  final TextEditingController _searchController = TextEditingController();

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _addNewPatient() {
    _showSnackBar('Add New Patient feature clicked');
    // In a real app, you would navigate to a patient form screen
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Patient'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Patient registration form would appear here.'),
            SizedBox(height: 10),
            Text('Name: ________________'),
            SizedBox(height: 10),
            Text('Age: ________________'),
            SizedBox(height: 10),
            Text('Contact: ________________'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSnackBar('Patient added successfully!');
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _handleQuickAction(String action) {
    switch (action) {
      case 'View Medical History':
        _showSnackBar('Opening Medical History...');
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Medical History'),
            content: const SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Patient: John Smith (P10001)'),
                  SizedBox(height: 10),
                  Text('• Consultation: 2024-01-15 - General Checkup'),
                  SizedBox(height: 5),
                  Text('• Diagnosis: Healthy, Normal BP'),
                  SizedBox(height: 5),
                  Text('• Prescription: Multivitamins'),
                  SizedBox(height: 10),
                  Text('• Consultation: 2023-12-10 - Fever'),
                  SizedBox(height: 5),
                  Text('• Diagnosis: Viral Infection'),
                  SizedBox(height: 5),
                  Text('• Prescription: Paracetamol, Rest'),
                ],
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
        break;
      case 'Print Patient Card':
        _showSnackBar('Printing Patient Card...');
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Print Patient Card'),
            content:
                const Text('Patient card for John Smith is being printed.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
        break;
      case 'Schedule Follow-up':
        _showSnackBar('Opening Follow-up Scheduler...');
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Schedule Follow-up'),
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Patient: John Smith'),
                SizedBox(height: 10),
                Text('Select Date: ________________'),
                SizedBox(height: 10),
                Text('Select Time: ________________'),
                SizedBox(height: 10),
                Text('Reason: ________________'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showSnackBar('Follow-up scheduled successfully!');
                },
                child: const Text('Schedule'),
              ),
            ],
          ),
        );
        break;
      case 'Export Patient Data':
        _showSnackBar('Exporting Patient Data...');
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Export Patient Data'),
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Select export format:'),
                SizedBox(height: 10),
                Text('• PDF'),
                SizedBox(height: 5),
                Text('• Excel'),
                SizedBox(height: 5),
                Text('• CSV'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showSnackBar('Data exported successfully!');
                },
                child: const Text('Export'),
              ),
            ],
          ),
        );
        break;
    }
  }

  void _viewPatientDetails(Patient patient) {
    _showSnackBar('Viewing details for ${patient.name}');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Patient Details - ${patient.id}'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Name: ${patient.name}',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              Text('Age: ${patient.age} years'),
              Text('Gender: ${patient.gender}'),
              Text('Blood Group: ${patient.bloodGroup}'),
              Text('Type: ${patient.type}'),
              Text('Status: ${patient.status}'),
              Text('Allergies: ${patient.allergies}'),
              const SizedBox(height: 10),
              const Text('Contact Information:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text('Phone: ${patient.phone}'),
              Text('Email: ${patient.email}'),
              Text('Address: ${patient.address}'),
              const SizedBox(height: 10),
              const Text('Visit Information:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text('Last Visit: ${patient.lastVisit}'),
            ],
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
              _editPatient(patient);
            },
            child: const Text('Edit'),
          ),
        ],
      ),
    );
  }

  void _editPatient(Patient patient) {
    _showSnackBar('Editing ${patient.name}');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Patient - ${patient.name}'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: patient.name,
                decoration: const InputDecoration(labelText: 'Full Name'),
              ),
              TextFormField(
                initialValue: patient.age.toString(),
                decoration: const InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                initialValue: patient.phone,
                decoration: const InputDecoration(labelText: 'Phone'),
              ),
              TextFormField(
                initialValue: patient.email,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextFormField(
                initialValue: patient.address,
                decoration: const InputDecoration(labelText: 'Address'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSnackBar('Patient details updated successfully!');
            },
            child: const Text('Save Changes'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
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
                  'Patient Directory',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _addNewPatient,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4299E1),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                  icon: const Icon(Icons.person_add, size: 18),
                  label: const Text('Add New Patient'),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Stats Cards
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildPatientStatCard('Total Patients', '30',
                      Icons.people_outline, const Color(0xFF4299E1)),
                  const SizedBox(width: 20),
                  _buildPatientStatCard('IPD Patients', '8', Icons.bed_outlined,
                      const Color(0xFF48BB78)),
                  const SizedBox(width: 20),
                  _buildPatientStatCard('OPD Patients', '21',
                      Icons.medical_services_outlined, const Color(0xFFED8936)),
                  const SizedBox(width: 20),
                  _buildPatientStatCard(
                      'New Today', '3', Icons.today, const Color(0xFF9F7AEA)),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Filters
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF7FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                children: [
                  // Search row
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Search Patients',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF718096),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border:
                                    Border.all(color: const Color(0xFFE2E8F0)),
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
                                        hintText:
                                            'Search by name, ID, or phone...',
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
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Filter row
                  Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    children: [
                      // Type Filter
                      SizedBox(
                        width: 180,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Patient Type',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF718096),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              height: 40,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border:
                                    Border.all(color: const Color(0xFFE2E8F0)),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _selectedFilter,
                                  isExpanded: true,
                                  items: [
                                    'All',
                                    'OPD',
                                    'IPD',
                                    'Emergency',
                                    'Follow-up'
                                  ]
                                      .map((type) => DropdownMenuItem(
                                            value: type,
                                            child: Text(type),
                                          ))
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedFilter = value!;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Status Filter
                      SizedBox(
                        width: 180,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Status',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF718096),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              height: 40,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border:
                                    Border.all(color: const Color(0xFFE2E8F0)),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _selectedStatus,
                                  isExpanded: true,
                                  items: [
                                    'All',
                                    'Active',
                                    'Admitted',
                                    'Inactive',
                                    'Discharged'
                                  ]
                                      .map((status) => DropdownMenuItem(
                                            value: status,
                                            child: Text(status),
                                          ))
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedStatus = value!;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
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
                  'View Medical History',
                  Icons.history,
                  const Color(0xFF4299E1),
                  () => _handleQuickAction('View Medical History'),
                ),
                _buildQuickActionCard(
                  'Print Patient Card',
                  Icons.print,
                  const Color(0xFF48BB78),
                  () => _handleQuickAction('Print Patient Card'),
                ),
                _buildQuickActionCard(
                  'Schedule Follow-up',
                  Icons.calendar_today,
                  const Color(0xFFED8936),
                  () => _handleQuickAction('Schedule Follow-up'),
                ),
                _buildQuickActionCard(
                  'Export Patient Data',
                  Icons.download,
                  const Color(0xFF9F7AEA),
                  () => _handleQuickAction('Export Patient Data'),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Patients Table
            const Text(
              'All Patients',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 20),

            // Patients Table - No horizontal scrolling
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
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                    ),
                    child: const Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Patient ID',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2D3748),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            'Patient Details',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2D3748),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Contact',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2D3748),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Type',
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
                            'Last Visit',
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

                  // Table Rows
                  ...patients.map((patient) => Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: const Color(0xFFE2E8F0)),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    patient.id,
                                    style: const TextStyle(
                                      color: Color(0xFF4299E1),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'BG: ${patient.bloodGroup}',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Color(0xFF718096),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    patient.name,
                                    style: const TextStyle(
                                      color: Color(0xFF2D3748),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${patient.age} yrs • ${patient.gender}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF718096),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    patient.address,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Color(0xFFA0AEC0),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    patient.phone,
                                    style: const TextStyle(
                                      color: Color(0xFF2D3748),
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    patient.email,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Color(0xFF718096),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: patient.type == 'IPD'
                                      ? const Color(0xFF4299E1).withValues(alpha: 0.1)
                                      : const Color(0xFF48BB78)
                                          .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  patient.type,
                                  style: TextStyle(
                                    color: patient.type == 'IPD'
                                        ? const Color(0xFF4299E1)
                                        : const Color(0xFF48BB78),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: patient.status == 'Active'
                                      ? const Color(0xFF48BB78).withValues(alpha: 0.1)
                                      : patient.status == 'Admitted'
                                          ? const Color(0xFFED8936)
                                              .withValues(alpha: 0.1)
                                          : const Color(0xFF718096)
                                              .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  patient.status,
                                  style: TextStyle(
                                    color: patient.status == 'Active'
                                        ? const Color(0xFF48BB78)
                                        : patient.status == 'Admitted'
                                            ? const Color(0xFFED8936)
                                            : const Color(0xFF718096),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    patient.lastVisit,
                                    style: const TextStyle(
                                      color: Color(0xFF2D3748),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '10 days ago',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Color(0xFF718096),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  IconButton(
                                    onPressed: () =>
                                        _viewPatientDetails(patient),
                                    icon: const Icon(Icons.visibility_outlined,
                                        size: 18, color: Color(0xFF4299E1)),
                                    tooltip: 'View Details',
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                  ),
                                  IconButton(
                                    onPressed: () => _editPatient(patient),
                                    icon: const Icon(Icons.edit_outlined,
                                        size: 18, color: Color(0xFF48BB78)),
                                    tooltip: 'Edit Patient',
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
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

            // Patient Statistics
            const Text(
              'Patient Statistics',
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
                Container(
                  width: MediaQuery.of(context).size.width > 800
                      ? (MediaQuery.of(context).size.width - 70) / 2
                      : double.infinity,
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Age Distribution',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2D3748),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildAgeDistribution(
                          '0-18 years', 15, const Color(0xFF4299E1)),
                      const SizedBox(height: 10),
                      _buildAgeDistribution(
                          '19-40 years', 35, const Color(0xFF48BB78)),
                      const SizedBox(height: 10),
                      _buildAgeDistribution(
                          '41-60 years', 28, const Color(0xFFED8936)),
                      const SizedBox(height: 10),
                      _buildAgeDistribution(
                          '60+ years', 22, const Color(0xFF9F7AEA)),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width > 800
                      ? (MediaQuery.of(context).size.width - 70) / 2
                      : double.infinity,
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Gender Distribution',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2D3748),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildGenderDistribution(
                          'Male', 55, const Color(0xFF4299E1)),
                      const SizedBox(height: 10),
                      _buildGenderDistribution(
                          'Female', 45, const Color(0xFF9F7AEA)),
                      const SizedBox(height: 20),
                      Container(
                        height: 100,
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Color(0xFF4299E1),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    bottomLeft: Radius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Color(0xFF9F7AEA),
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(8),
                                    bottomRight: Radius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Pagination & Summary
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Patient Summary',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Showing ${patients.length} of 30 patients • Last updated: Today',
                  style: const TextStyle(
                    color: Color(0xFF718096),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 20),
                // Pagination
                Center(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 10,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () {
                          _showSnackBar('Previous page clicked');
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          side: const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                        icon: const Icon(Icons.arrow_back_ios,
                            size: 14, color: Color(0xFF718096)),
                        label: const Text(
                          'Previous',
                          style: TextStyle(color: Color(0xFF718096)),
                        ),
                      ),
                      ...[
                        '1',
                        '2',
                        '3',
                        '...',
                        '6'
                      ].map((page) => GestureDetector(
                            onTap: () {
                              _showSnackBar('Page $page clicked');
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: page == '1'
                                    ? const Color(0xFF4299E1)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: page == '1'
                                      ? const Color(0xFF4299E1)
                                      : const Color(0xFFE2E8F0),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  page,
                                  style: TextStyle(
                                    color: page == '1'
                                        ? Colors.white
                                        : const Color(0xFF718096),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          )),
                      OutlinedButton.icon(
                        onPressed: () {
                          _showSnackBar('Next page clicked');
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          side: const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                        icon: const Text(
                          'Next',
                          style: TextStyle(color: Color(0xFF718096)),
                        ),
                        label: const Icon(Icons.arrow_forward_ios,
                            size: 14, color: Color(0xFF718096)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientStatCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      width: 250,
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
    );
  }

  Widget _buildQuickActionCard(
      String title, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 250,
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
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2D3748),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAgeDistribution(String range, int percentage, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              range,
              style: const TextStyle(
                color: Color(0xFF2D3748),
              ),
            ),
            Text(
              '$percentage%',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 6,
          decoration: BoxDecoration(
            color: const Color(0xFFE2E8F0),
            borderRadius: BorderRadius.circular(3),
          ),
          child: FractionallySizedBox(
            widthFactor: percentage / 100,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGenderDistribution(String gender, int percentage, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              gender,
              style: const TextStyle(
                color: Color(0xFF2D3748),
              ),
            ),
            Text(
              '$percentage%',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 6,
          decoration: BoxDecoration(
            color: const Color(0xFFE2E8F0),
            borderRadius: BorderRadius.circular(3),
          ),
          child: FractionallySizedBox(
            widthFactor: percentage / 100,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class Patient {
  final String id;
  final String name;
  final int age;
  final String gender;
  final String type;
  final String status;
  final String lastVisit;
  final String phone;
  final String email;
  final String address;
  final String bloodGroup;
  final String allergies;

  Patient({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.type,
    required this.status,
    required this.lastVisit,
    required this.phone,
    required this.email,
    required this.address,
    required this.bloodGroup,
    required this.allergies,
  });
}
