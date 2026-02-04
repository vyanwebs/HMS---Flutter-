import 'package:flutter/material.dart';

class ExistingPatientScreen extends StatefulWidget {
  const ExistingPatientScreen({super.key});

  @override
  State<ExistingPatientScreen> createState() => _ExistingPatientScreenState();
}

class _ExistingPatientScreenState extends State<ExistingPatientScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchType = 'Name';
  final List<String> _searchTypes = ['Name', 'Phone', 'Patient ID'];
  
  // Mock patient data
  final List<Map<String, dynamic>> _patients = [
    {
      'id': 'HMS-P-2024-001',
      'name': 'John Smith',
      'age': 45,
      'gender': 'Male',
      'phone': '9876543210',
      'lastVisit': '2024-01-15',
    },
    {
      'id': 'HMS-P-2024-002',
      'name': 'Sarah Johnson',
      'age': 32,
      'gender': 'Female',
      'phone': '9876543211',
      'lastVisit': '2024-01-14',
    },
    {
      'id': 'HMS-P-2024-003',
      'name': 'Robert Brown',
      'age': 58,
      'gender': 'Male',
      'phone': '9876543212',
      'lastVisit': '2024-01-13',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Existing Patient'),
        backgroundColor: const Color(0xFF2D3748),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Section
            Container(
              padding: const EdgeInsets.all(20),
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
                children: [
                  const Text(
                    'Search Patient',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                  const SizedBox(height: 15),
                  
                  // Search Type Selection
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Search By',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search_outlined),
                    ),
                    value: _searchType,
                    items: _searchTypes.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _searchType = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 15),
                  
                  // Search Input
                  TextFormField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Enter $_searchType',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.person_search_outlined),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: _searchPatients,
                      ),
                    ),
                    onFieldSubmitted: (value) => _searchPatients(),
                  ),
                  const SizedBox(height: 10),
                  
                  // Quick Search Tips
                  const Text(
                    'Quick Search Tips:',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF718096),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    '• Search by patient name (e.g., "John Smith")\n• Search by phone number (e.g., "9876543210")\n• Search by Patient ID (e.g., "HMS-P-2024-001")',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF718096),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Search Results
            const Text(
              'Search Results',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 15),
            
            ..._patients.map((patient) => _buildPatientCard(patient)).toList(),
            
            const SizedBox(height: 30),
            
            // Recent Patients
            const Text(
              'Recent Patients',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 15),
            
            Container(
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
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('ID')),
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Age')),
                  DataColumn(label: Text('Last Visit')),
                  DataColumn(label: Text('Actions')),
                ],
                rows: _patients.map((patient) {
                  return DataRow(cells: [
                    DataCell(Text(patient['id'])),
                    DataCell(Text(patient['name'])),
                    DataCell(Text(patient['age'].toString())),
                    DataCell(Text(patient['lastVisit'])),
                    DataCell(
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.visibility_outlined, size: 18),
                            onPressed: () => _viewPatientDetails(patient),
                            color: const Color(0xFF4299E1),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit_outlined, size: 18),
                            onPressed: () => _editPatient(patient),
                            color: const Color(0xFF48BB78),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline, size: 18),
                            onPressed: () => _continueVisit(patient),
                            color: const Color(0xFFED8936),
                          ),
                        ],
                      ),
                    ),
                  ]);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientCard(Map<String, dynamic> patient) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: const Color(0xFF4299E1).withValues(alpha: 0.1),
              child: const Icon(
                Icons.person_outline,
                color: Color(0xFF4299E1),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    patient['name'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Icon(Icons.badge_outlined, size: 14, color: Color(0xFF718096)),
                      const SizedBox(width: 5),
                      Text(
                        patient['id'],
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF718096),
                        ),
                      ),
                      const SizedBox(width: 15),
                      const Icon(Icons.phone_outlined, size: 14, color: Color(0xFF718096)),
                      const SizedBox(width: 5),
                      Text(
                        patient['phone'],
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF718096),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              children: [
                OutlinedButton.icon(
                  onPressed: () => _viewPatientDetails(patient),
                  icon: const Icon(Icons.visibility_outlined, size: 16),
                  label: const Text('View'),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF4299E1)),
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: () => _continueVisit(patient),
                  icon: const Icon(Icons.arrow_forward_outlined, size: 16),
                  label: const Text('Continue Visit'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4299E1),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _searchPatients() {
    final query = _searchController.text.trim();
    if (query.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter search query'),
        ),
      );
      return;
    }
    
    // In a real app, you would call an API here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Searching for "$query" by $_searchType...'),
      ),
    );
  }

  void _viewPatientDetails(Map<String, dynamic> patient) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Patient Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailItem('Patient ID', patient['id']),
              _buildDetailItem('Name', patient['name']),
              _buildDetailItem('Age', patient['age'].toString()),
              _buildDetailItem('Gender', patient['gender']),
              _buildDetailItem('Phone', patient['phone']),
              _buildDetailItem('Last Visit', patient['lastVisit']),
              const SizedBox(height: 10),
              const Divider(),
              const Text(
                'Past Visits:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              const Text('• OPD Visit - 15 Jan 2024 (Dr. Sharma)'),
              const Text('• Lab Test - 10 Jan 2024'),
              const Text('• OPD Visit - 05 Jan 2024 (Dr. Patel)'),
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
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4299E1),
            ),
            child: const Text('Edit Details'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF4A5568),
              ),
            ),
          ),
          Expanded(
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

  void _editPatient(Map<String, dynamic> patient) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Patient Details'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: patient['name'],
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              const SizedBox(height: 10),
              TextFormField(
                initialValue: patient['phone'],
                decoration: const InputDecoration(labelText: 'Phone'),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 10),
              TextFormField(
                initialValue: patient['age'].toString(),
                decoration: const InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
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
              // Update patient logic
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Patient details updated successfully'),
                ),
              );
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4299E1),
            ),
            child: const Text('Save Changes'),
          ),
        ],
      ),
    );
  }

  void _continueVisit(Map<String, dynamic> patient) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Continue Visit'),
        content: const Text('Patient has been assigned to doctor\'s list.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}