import 'package:flutter/material.dart';

class IPDPharmacyOrdersScreen extends StatelessWidget {
  final VoidCallback onBack;

  const IPDPharmacyOrdersScreen({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC),
      body: Column(
        children: [
          // Top Bar
          Container(
            height: 70,
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 30),
            child: Row(
              children: [
                if (isMobile)
                  IconButton(
                    icon:
                        const Icon(Icons.arrow_back, color: Color(0xFF2383E2)),
                    onPressed: onBack,
                  ),
                Expanded(
                  child: Text(
                    'IPD Pharmacy Orders',
                    style: TextStyle(
                      fontSize: isMobile ? 18 : 24,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2D3748),
                    ),
                  ),
                ),
                if (!isMobile)
                  ElevatedButton(
                    onPressed: onBack,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0094FE),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                    ),
                    child: const Text('Back to Dashboard'),
                  ),
              ],
            ),
          ),

          // Divider
          Container(height: 1, color: const Color(0xFFE2E8F0)),

          // Main Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(isMobile ? 16 : 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with Tabs
                  DefaultTabController(
                    length: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const TabBar(
                          indicatorColor: Color(0xFF0094FE),
                          labelColor: Color(0xFF0094FE),
                          unselectedLabelColor: Color(0xFF718096),
                          tabs: [
                            Tab(text: 'Pending Orders'),
                            Tab(text: 'Approved Orders'),
                            Tab(text: 'Dispensed'),
                          ],
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 500,
                          child: TabBarView(
                            children: [
                              _buildPendingOrders(),
                              _buildApprovedOrders(),
                              _buildDispensedOrders(),
                            ],
                          ),
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

  Widget _buildPendingOrders() {
    return ListView(
      shrinkWrap: true,
      children: [
        _buildPharmacyOrderItem(
          orderId: 'PH-00123',
          patientName: 'John Smith',
          doctorName: 'Dr. Sharma',
          medications: 'Insulin, Metformin, Losartan',
          requestedDate: 'Jan 2, 2024 10:30 AM',
          status: 'Pending',
          isUrgent: true,
        ),
        _buildPharmacyOrderItem(
          orderId: 'PH-00124',
          patientName: 'Robert Brown',
          doctorName: 'Dr. Patel',
          medications: 'Morphine, Amoxicillin',
          requestedDate: 'Jan 2, 2024 11:45 AM',
          status: 'Pending',
          isUrgent: false,
        ),
        _buildPharmacyOrderItem(
          orderId: 'PH-00125',
          patientName: 'Mary Johnson',
          doctorName: 'Dr. Kumar',
          medications: 'Paracetamol, Ibuprofen',
          requestedDate: 'Jan 2, 2024 1:15 PM',
          status: 'Pending',
          isUrgent: false,
        ),
      ],
    );
  }

  Widget _buildApprovedOrders() {
    return ListView(
      shrinkWrap: true,
      children: [
        _buildPharmacyOrderItem(
          orderId: 'PH-00120',
          patientName: 'David Lee',
          doctorName: 'Dr. Gupta',
          medications: 'Aspirin, Clopidogrel',
          requestedDate: 'Jan 1, 2024 3:30 PM',
          status: 'Approved',
          isUrgent: false,
          approvedDate: 'Jan 2, 2024 9:00 AM',
          approvedBy: 'Pharmacist John',
        ),
      ],
    );
  }

  Widget _buildDispensedOrders() {
    return ListView(
      shrinkWrap: true,
      children: [
        _buildPharmacyOrderItem(
          orderId: 'PH-00119',
          patientName: 'Sarah Wilson',
          doctorName: 'Dr. Singh',
          medications: 'Metformin, Glimepiride',
          requestedDate: 'Jan 1, 2024 2:00 PM',
          status: 'Dispensed',
          isUrgent: false,
          dispensedDate: 'Jan 1, 2024 4:30 PM',
          dispensedBy: 'Pharmacist Mary',
        ),
      ],
    );
  }

  Widget _buildPharmacyOrderItem({
    required String orderId,
    required String patientName,
    required String doctorName,
    required String medications,
    required String requestedDate,
    required String status,
    required bool isUrgent,
    String? approvedDate,
    String? approvedBy,
    String? dispensedDate,
    String? dispensedBy,
  }) {
    Color statusColor;
    IconData statusIcon;

    switch (status) {
      case 'Pending':
        statusColor = Colors.orange;
        statusIcon = Icons.access_time;
        break;
      case 'Approved':
        statusColor = Colors.blue;
        statusIcon = Icons.check_circle_outline;
        break;
      case 'Dispensed':
        statusColor = Colors.green;
        statusIcon = Icons.local_pharmacy;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Order ID: $orderId',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2D3748),
                          ),
                        ),
                        if (isUrgent) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.red.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'URGENT',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.red,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    Text(
                      patientName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    Icon(statusIcon, size: 14, color: statusColor),
                    const SizedBox(width: 4),
                    Text(
                      status,
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Details
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('Doctor', doctorName),
              _buildDetailRow('Medications', medications),
              _buildDetailRow('Requested', requestedDate),
              if (approvedDate != null && approvedBy != null)
                _buildDetailRow('Approved', '$approvedDate by $approvedBy'),
              if (dispensedDate != null && dispensedBy != null)
                _buildDetailRow('Dispensed', '$dispensedDate by $dispensedBy'),
            ],
          ),

          const SizedBox(height: 16),

          // Action Buttons
          if (status == 'Pending')
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    child: const Text(
                      'Approve',
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    child: const Text(
                      'Reject',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          if (status == 'Approved')
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0094FE),
                padding: const EdgeInsets.symmetric(vertical: 10),
                minimumSize: const Size(double.infinity, 40),
              ),
              child: const Text(
                'Mark as Dispensed',
                style: TextStyle(fontSize: 13),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF718096),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF2D3748),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
