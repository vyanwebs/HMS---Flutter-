import 'package:flutter/material.dart';
import 'package:hms/screens/patient/patient_dashboard.dart';

class BillsPaymentsScreen extends StatelessWidget {
  const BillsPaymentsScreen({super.key});

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
                  'Bills & Payments',
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
                  // Summary Cards
                  Row(
                    children: [
                      Expanded(
                        child: _buildSummaryCard(
                          title: 'Total Outstanding',
                          amount: '\$150.00',
                          color: PatientDashboard.danger,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildSummaryCard(
                          title: 'Paid This Month',
                          amount: '\$75.00',
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Recent Bills
                  const Text(
                    'Recent Bills',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: PatientDashboard.dark,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  _buildBillItem(
                    description: 'Consultation Fee - Dr. Johnson',
                    date: 'Nov 17, 2024',
                    amount: '\$75.00',
                    status: 'Paid',
                    statusColor: Colors.green,
                  ),
                  
                  _buildBillItem(
                    description: 'Blood Test - Lab Work',
                    date: 'Nov 16, 2024',
                    amount: '\$45.00',
                    status: 'Paid',
                    statusColor: Colors.green,
                  ),
                  
                  _buildBillItem(
                    description: 'Monthly Medication',
                    date: 'Due: Nov 22, 2024',
                    amount: '\$30.00',
                    status: 'Pending',
                    statusColor: Colors.orange,
                  ),
                  
                  _buildBillItem(
                    description: 'Monthly Health Checkup',
                    date: 'Due: Nov 27, 2024',
                    amount: '\$150.00',
                    status: 'Due',
                    statusColor: PatientDashboard.danger,
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Payment Methods
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: PatientDashboard.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Payment Methods',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: PatientDashboard.dark,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildPaymentMethod(
                          icon: Icons.credit_card,
                          title: 'Credit Card',
                          lastDigits: '**** 1234',
                        ),
                        _buildPaymentMethod(
                          icon: Icons.account_balance,
                          title: 'Bank Transfer',
                          lastDigits: 'Account: 4567',
                        ),
                        _buildPaymentMethod(
                          icon: Icons.wallet,
                          title: 'Digital Wallet',
                          lastDigits: 'Wallet ID: 7890',
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
  
  Widget _buildSummaryCard({
    required String title,
    required String amount,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: PatientDashboard.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: PatientDashboard.muted,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            amount,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildBillItem({
    required String description,
    required String date,
    required String amount,
    required String status,
    required Color statusColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: PatientDashboard.border),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: PatientDashboard.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Icon(Icons.receipt, color: PatientDashboard.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  description,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: PatientDashboard.dark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 14,
                    color: PatientDashboard.muted,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: PatientDashboard.dark,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 12,
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios, size: 16),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
  
  Widget _buildPaymentMethod({
    required IconData icon,
    required String title,
    required String lastDigits,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: PatientDashboard.border),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: PatientDashboard.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(icon, color: PatientDashboard.primary, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: PatientDashboard.dark,
                  ),
                ),
                Text(
                  lastDigits,
                  style: const TextStyle(
                    fontSize: 12,
                    color: PatientDashboard.muted,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit, size: 20),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}