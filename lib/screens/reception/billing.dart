// lib/screens/reception/billing.dart
import 'package:flutter/material.dart';

class BillingScreen extends StatefulWidget {
  const BillingScreen({super.key});

  @override
  State<BillingScreen> createState() => _BillingScreenState();
}

class _BillingScreenState extends State<BillingScreen> {
  final List<BillingItem> billingItems = [
    BillingItem(
      id: 'B1001',
      patientName: 'John Smith',
      date: '2024-01-15',
      amount: 4500,
      status: 'Paid',
      type: 'OPD',
    ),
    BillingItem(
      id: 'B1002',
      patientName: 'Sarah Johnson',
      date: '2024-01-14',
      amount: 32000,
      status: 'Pending',
      type: 'IPD',
    ),
    BillingItem(
      id: 'B1003',
      patientName: 'Michael Brown',
      date: '2024-01-13',
      amount: 1500,
      status: 'Paid',
      type: 'OPD',
    ),
    BillingItem(
      id: 'B1004',
      patientName: 'Emily Davis',
      date: '2024-01-12',
      amount: 45000,
      status: 'Partially Paid',
      type: 'IPD',
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
                'Billing & Payments',
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
                icon: const Icon(Icons.receipt_long, size: 18),
                label: const Text('Create New Bill'),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Stats Cards
          Row(
            children: [
              _buildBillingStatCard('Total Revenue', '₹2,45,800',
                  Icons.attach_money, const Color(0xFF48BB78)),
              const SizedBox(width: 20),
              _buildBillingStatCard('Pending Payments', '₹45,000',
                  Icons.pending_actions, const Color(0xFFED8936)),
              const SizedBox(width: 20),
              _buildBillingStatCard('Today\'s Collection', '₹12,500',
                  Icons.today, const Color(0xFF4299E1)),
              const SizedBox(width: 20),
              _buildBillingStatCard('Total Bills', '156',
                  Icons.receipt, const Color(0xFF9F7AEA)),
            ],
          ),

          const SizedBox(height: 30),

          // Billing Actions
          Row(
            children: [
              Expanded(
                child: _buildBillingActionCard(
                  'Generate Bill',
                  Icons.receipt_long,
                  const Color(0xFF4299E1),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: _buildBillingActionCard(
                  'Process Payment',
                  Icons.payment,
                  const Color(0xFF48BB78),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: _buildBillingActionCard(
                  'View Reports',
                  Icons.bar_chart,
                  const Color(0xFFED8936),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: _buildBillingActionCard(
                  'Export Invoices',
                  Icons.download,
                  const Color(0xFF9F7AEA),
                ),
              ),
            ],
          ),

          const SizedBox(height: 30),

          // Recent Bills
          const Text(
            'Recent Bills',
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
                    border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
                  ),
                  child: const Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Bill ID',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2D3748),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Patient Name',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2D3748),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Date',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2D3748),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Amount',
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
                ...billingItems.map((item) => Container(
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
                              item.id,
                              style: const TextStyle(
                                color: Color(0xFF4299E1),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              item.patientName,
                              style: const TextStyle(
                                color: Color(0xFF2D3748),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              item.date,
                              style: const TextStyle(
                                color: Color(0xFF718096),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              '₹${item.amount}',
                              style: const TextStyle(
                                color: Color(0xFF2D3748),
                                fontWeight: FontWeight.bold,
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
                                color: item.type == 'IPD'
                                    ? const Color(0xFF4299E1).withValues(alpha: 0.1)
                                    : const Color(0xFF48BB78).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                item.type,
                                style: TextStyle(
                                  color: item.type == 'IPD'
                                      ? const Color(0xFF4299E1)
                                      : const Color(0xFF48BB78),
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
                                color: item.status == 'Paid'
                                    ? const Color(0xFF48BB78).withValues(alpha: 0.1)
                                    : item.status == 'Pending'
                                        ? const Color(0xFFED8936).withValues(alpha: 0.1)
                                        : const Color(0xFF9F7AEA).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                item.status,
                                style: TextStyle(
                                  color: item.status == 'Paid'
                                      ? const Color(0xFF48BB78)
                                      : item.status == 'Pending'
                                          ? const Color(0xFFED8936)
                                          : const Color(0xFF9F7AEA),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.visibility_outlined,
                                      size: 18, color: Color(0xFF4299E1)),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.print_outlined,
                                      size: 18, color: Color(0xFF48BB78)),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.payment_outlined,
                                      size: 18, color: Color(0xFFED8936)),
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

          // Payment Summary
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
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
                        'Payment Summary',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D3748),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildPaymentSummaryItem('Total Billing', '₹2,45,800'),
                      _buildPaymentSummaryItem('Received', '₹2,00,800'),
                      _buildPaymentSummaryItem('Pending', '₹45,000'),
                      _buildPaymentSummaryItem('Discount Given', '₹12,500'),
                      const Divider(height: 30),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Net Balance',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2D3748),
                            ),
                          ),
                          Text(
                            '₹2,00,800',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF48BB78),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 30),

              Expanded(
                child: Container(
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
                        'Payment Methods',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D3748),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildPaymentMethodItem('Cash', '₹1,20,000', 60),
                      _buildPaymentMethodItem('Card', '₹60,000', 30),
                      _buildPaymentMethodItem('UPI', '₹15,800', 8),
                      _buildPaymentMethodItem('Insurance', '₹5,000', 2),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBillingStatCard(
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

  Widget _buildBillingActionCard(String title, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
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
          const SizedBox(height: 15),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3748),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentSummaryItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF718096),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3748),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodItem(String method, String amount, int percentage) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                method,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2D3748),
                ),
              ),
              Text(
                '$amount ($percentage%)',
                style: const TextStyle(
                  color: Color(0xFF718096),
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
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF4299E1),
                      const Color(0xFF4299E1).withValues(alpha: 0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BillingItem {
  final String id;
  final String patientName;
  final String date;
  final int amount;
  final String status;
  final String type;

  BillingItem({
    required this.id,
    required this.patientName,
    required this.date,
    required this.amount,
    required this.status,
    required this.type,
  });
}