import 'package:flutter/material.dart';

class AdmissionRequestsScreen extends StatefulWidget {
  const AdmissionRequestsScreen({super.key});

  @override
  State<AdmissionRequestsScreen> createState() => _AdmissionRequestsScreenState();
}

class _AdmissionRequestsScreenState extends State<AdmissionRequestsScreen> {
  // Mock admission requests
  final List<Map<String, dynamic>> _admissionRequests = [
    {
      'id': 'ADM-001',
      'patientName': 'John Smith',
      'patientId': 'HMS-P-2024-001',
      'doctor': 'Dr. Sharma',
      'reason': 'Severe fever and dehydration',
      'requestedWard': 'ICU',
      'status': 'Pending',
      'date': '2024-01-15',
      'time': '10:30 AM',
    },
    {
      'id': 'ADM-002',
      'patientName': 'Sarah Johnson',
      'patientId': 'HMS-P-2024-002',
      'doctor': 'Dr. Patel',
      'reason': 'Post-surgery observation',
      'requestedWard': 'General Ward',
      'status': 'Pending',
      'date': '2024-01-15',
      'time': '11:15 AM',
    },
    {
      'id': 'ADM-003',
      'patientName': 'Robert Brown',
      'patientId': 'HMS-P-2024-003',
      'doctor': 'Dr. Gupta',
      'reason': 'Cardiac monitoring',
      'requestedWard': 'Cardiac ICU',
      'status': 'Approved',
      'date': '2024-01-14',
      'time': '02:45 PM',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admission Requests'),
        backgroundColor: const Color(0xFF2D3748),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Stats
          Container(
            padding: const EdgeInsets.all(20),
            color: const Color(0xFFEDF2F7),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStat('Pending', '2', const Color(0xFFED8936)),
                _buildStat('Approved', '1', const Color(0xFF48BB78)),
                _buildStat('Total', '3', const Color(0xFF4299E1)),
              ],
            ),
          ),
          
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const Text(
                  'Admission Requests from Doctors',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 20),
                
                ..._admissionRequests.map((request) => _buildRequestCard(request)).toList(),
                
                const SizedBox(height: 30),
                
                // Available Beds Section
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Available Beds',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D3748),
                        ),
                      ),
                      const SizedBox(height: 15),
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        children: [
                          _buildBedCard('ICU', 'Available: 3', const Color(0xFFF56565)),
                          _buildBedCard('General Ward', 'Available: 12', const Color(0xFF48BB78)),
                          _buildBedCard('AC Ward', 'Available: 8', const Color(0xFF4299E1)),
                          _buildBedCard('Non-AC Ward', 'Available: 15', const Color(0xFFED8936)),
                          _buildBedCard('Maternity', 'Available: 5', const Color(0xFFED64A6)),
                          _buildBedCard('Pediatrics', 'Available: 7', const Color(0xFF9F7AEA)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF718096),
          ),
        ),
      ],
    );
  }

  Widget _buildRequestCard(Map<String, dynamic> request) {
    Color statusColor;
    switch (request['status']) {
      case 'Pending':
        statusColor = const Color(0xFFED8936);
        break;
      case 'Approved':
        statusColor = const Color(0xFF48BB78);
        break;
      case 'Rejected':
        statusColor = const Color(0xFFF56565);
        break;
      default:
        statusColor = const Color(0xFF718096);
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 15),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Request ID: ${request['id']}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4299E1),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: statusColor),
                  ),
                  child: Text(
                    request['status'],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _buildInfoRow('Patient', request['patientName']),
            _buildInfoRow('Patient ID', request['patientId']),
            _buildInfoRow('Doctor', request['doctor']),
            _buildInfoRow('Reason', request['reason']),
            _buildInfoRow('Requested Ward', request['requestedWard']),
            _buildInfoRow('Date', '${request['date']} ${request['time']}'),
            
            if (request['status'] == 'Pending') ...[
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _viewDetails(request),
                      icon: const Icon(Icons.visibility_outlined, size: 16),
                      label: const Text('View Details'),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF4299E1)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _processAdmission(request),
                      icon: const Icon(Icons.check_circle_outline, size: 16),
                      label: const Text('Process Admission'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF48BB78),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF4A5568),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF2D3748),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBedCard(String ward, String status, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            ward,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5),
          Text(
            status,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF718096),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _viewDetails(Map<String, dynamic> request) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Admission Request Details',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 20),
            _buildDetailRow('Request ID', request['id']),
            _buildDetailRow('Patient Name', request['patientName']),
            _buildDetailRow('Patient ID', request['patientId']),
            _buildDetailRow('Referring Doctor', request['doctor']),
            _buildDetailRow('Reason for Admission', request['reason']),
            _buildDetailRow('Requested Ward', request['requestedWard']),
            _buildDetailRow('Date & Time', '${request['date']} ${request['time']}'),
            _buildDetailRow('Status', request['status']),
            const SizedBox(height: 30),
            if (request['status'] == 'Pending') ...[
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _processAdmission(request);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF48BB78),
                      ),
                      child: const Text('Process Admission'),
                    ),
                  ),
                ],
              ),
            ] else ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4299E1),
                  ),
                  child: const Text('Close'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
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

  void _processAdmission(Map<String, dynamic> request) {
    showDialog(
      context: context,
      builder: (context) => AdmissionProcessDialog(
        request: request,
        onConfirm: () {
          setState(() {
            request['status'] = 'Approved';
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Admission processed successfully'),
            ),
          );
        },
      ),
    );
  }
}

class AdmissionProcessDialog extends StatefulWidget {
  final Map<String, dynamic> request;
  final VoidCallback onConfirm;

  const AdmissionProcessDialog({
    super.key,
    required this.request,
    required this.onConfirm,
  });

  @override
  State<AdmissionProcessDialog> createState() => _AdmissionProcessDialogState();
}

class _AdmissionProcessDialogState extends State<AdmissionProcessDialog> {
  final TextEditingController _depositController = TextEditingController();
  String? _selectedWard;
  String? _selectedBed;
  
  final List<String> _wards = ['ICU', 'General Ward', 'AC Ward', 'Non-AC Ward', 'Cardiac ICU'];
  final Map<String, List<String>> _beds = {
    'ICU': ['ICU-01', 'ICU-02', 'ICU-03'],
    'General Ward': ['GW-01', 'GW-02', 'GW-03', 'GW-04'],
    'AC Ward': ['AC-01', 'AC-02', 'AC-03'],
    'Non-AC Ward': ['NAC-01', 'NAC-02', 'NAC-03', 'NAC-04'],
    'Cardiac ICU': ['CICU-01', 'CICU-02'],
  };

  @override
  void initState() {
    super.initState();
    _selectedWard = widget.request['requestedWard'];
    _depositController.text = '5000';
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Process Admission',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Patient: ${widget.request['patientName']}',
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF718096),
              ),
            ),
            const SizedBox(height: 20),
            
            // Reason for Admission
            TextFormField(
              initialValue: widget.request['reason'],
              decoration: const InputDecoration(
                labelText: 'Reason for Admission',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.description_outlined),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 15),
            
            // Ward Selection
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Assign Ward',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.king_bed_outlined),
              ),
              value: _selectedWard,
              items: _wards.map((ward) {
                return DropdownMenuItem(
                  value: ward,
                  child: Text(ward),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedWard = value;
                  _selectedBed = null;
                });
              },
            ),
            const SizedBox(height: 15),
            
            // Bed Selection
            if (_selectedWard != null) ...[
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Assign Bed',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.bed_outlined),
                ),
                value: _selectedBed,
                items: _beds[_selectedWard]?.map((bed) {
                  return DropdownMenuItem(
                    value: bed,
                    child: Text(bed),
                  );
                }).toList() ?? [],
                onChanged: (value) {
                  setState(() {
                    _selectedBed = value;
                  });
                },
              ),
              const SizedBox(height: 15),
            ],
            
            // Initial Deposit
            TextFormField(
              controller: _depositController,
              decoration: const InputDecoration(
                labelText: 'Initial Deposit Amount (₹)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.attach_money_outlined),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            const Text(
              'Note: Additional deposits can be added later',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF718096),
              ),
            ),
            const SizedBox(height: 25),
            
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      _generateReceipt();
                      widget.onConfirm();
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF48BB78),
                    ),
                    child: const Text('Confirm & Generate Receipt'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _generateReceipt() {
    final deposit = _depositController.text;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Deposit Receipt Generated'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle_outline,
              size: 60,
              color: Color(0xFF48BB78),
            ),
            const SizedBox(height: 20),
            Text(
              'Receipt No: RCPT-${DateTime.now().millisecondsSinceEpoch}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Amount: ₹$deposit',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF48BB78),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Patient: ${widget.request['patientName']}',
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
            Text(
              'Ward: $_selectedWard | Bed: $_selectedBed',
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
          ElevatedButton(
            onPressed: () {
              // Print receipt logic
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4299E1),
            ),
            child: const Text('Print Receipt'),
          ),
        ],
      ),
    );
  }
}