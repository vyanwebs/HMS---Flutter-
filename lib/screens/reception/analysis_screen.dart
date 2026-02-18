// lib/screens/reception/analysis_screen.dart
import 'package:flutter/material.dart';

class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({super.key});

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  String _selectedPeriod = 'This Month';

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
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Analytics & Reports',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7FAFC),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedPeriod,
                      items: ['Today', 'This Week', 'This Month', 'This Year']
                          .map((period) => DropdownMenuItem(
                                value: period,
                                child: Text(period),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedPeriod = value!;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
        
            // Stats Overview
            Row(
              children: [
                Expanded(
                  child: _buildAnalysisCard(
                    'Total Revenue',
                    '₹2,45,800',
                    '+12.5%',
                    Icons.trending_up,
                    const Color(0xFF48BB78),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: _buildAnalysisCard(
                    'Total Patients',
                    '324',
                    '+8.2%',
                    Icons.people,
                    const Color(0xFF4299E1),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: _buildAnalysisCard(
                    'Avg. Stay Duration',
                    '4.2 days',
                    '-0.5%',
                    Icons.timelapse,
                    const Color(0xFFED8936),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: _buildAnalysisCard(
                    'Bed Occupancy',
                    '78%',
                    '+5.3%',
                    Icons.king_bed,
                    const Color(0xFF9F7AEA),
                  ),
                ),
              ],
            ),
        
            const SizedBox(height: 30),
        
            // Charts Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Revenue Trend',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D3748),
                        ),
                      ),
                      const SizedBox(height: 20),
        
                      Container(
                        padding: const EdgeInsets.all(25),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Column(
                          children: [
                            // Revenue Chart
                            SizedBox(
                              height: 200,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  _buildRevenueBar(40000, 'Jan'),
                                  _buildRevenueBar(45000, 'Feb'),
                                  _buildRevenueBar(52000, 'Mar'),
                                  _buildRevenueBar(48000, 'Apr'),
                                  _buildRevenueBar(60000, 'May'),
                                  _buildRevenueBar(55000, 'Jun'),
                                  _buildRevenueBar(75000, 'Jul'),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Divider(height: 1),
                            const SizedBox(height: 20),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total Revenue: ₹3,75,000',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2D3748),
                                  ),
                                ),
                                Text(
                                  'Growth: +25.3%',
                                  style: TextStyle(
                                    color: Color(0xFF48BB78),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        
                const SizedBox(width: 30),
        
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Patient Distribution',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D3748),
                        ),
                      ),
                      const SizedBox(height: 20),
        
                      Container(
                        padding: const EdgeInsets.all(25),
                        height: 300,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildDistributionItem('IPD Patients', 78,
                                const Color(0xFF4299E1), '24%'),
                            _buildDistributionItem('OPD Patients', 246,
                                const Color(0xFF48BB78), '76%'),
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
                                    flex: 3,
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF48BB78),
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
                ),
              ],
            ),
        
            const SizedBox(height: 30),
        
            // Department Performance
            const Text(
              'Department Performance',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
              ),
            ),
            const SizedBox(height: 20),
        
            Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                children: [
                  // Department Performance Bars
                  _buildPerformanceBar('Cardiology', 85, const Color(0xFF4299E1)),
                  const SizedBox(height: 15),
                  _buildPerformanceBar('Orthopedics', 72, const Color(0xFF48BB78)),
                  const SizedBox(height: 15),
                  _buildPerformanceBar('Neurology', 68, const Color(0xFF9F7AEA)),
                  const SizedBox(height: 15),
                  _buildPerformanceBar('Dermatology', 91, const Color(0xFFED8936)),
                  const SizedBox(height: 15),
                  _buildPerformanceBar('Pediatrics', 79, const Color(0xFFF56565)),
                ],
              ),
            ),
        
            const SizedBox(height: 30),
        
            // Report Generation
            const Text(
              'Generate Reports',
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
                  child: _buildReportCard(
                    'Financial Report',
                    Icons.pie_chart,
                    'Revenue, Expenses, Profit',
                    const Color(0xFF48BB78),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: _buildReportCard(
                    'Patient Statistics',
                    Icons.people,
                    'Admissions, Discharges',
                    const Color(0xFF4299E1),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: _buildReportCard(
                    'Department Report',
                    Icons.local_hospital,
                    'Performance, Utilization',
                    const Color(0xFFED8936),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: _buildReportCard(
                    'Export Data',
                    Icons.download,
                    'Excel, PDF, CSV',
                    const Color(0xFF9F7AEA),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalysisCard(
      String title, String value, String change, IconData icon, Color color) {
    return Container(
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
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: change.startsWith('+')
                      ? const Color(0xFF48BB78).withValues(alpha: 0.1)
                      : const Color(0xFFF56565).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  change,
                  style: TextStyle(
                    color: change.startsWith('+')
                        ? const Color(0xFF48BB78)
                        : const Color(0xFFF56565),
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
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

  Widget _buildRevenueBar(int amount, String month) {
    final maxAmount = 75000.0;
    final barHeight = (amount / maxAmount) * 150;

    return Expanded(
      child: Column(
        children: [
          Container(
            height: barHeight,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF4299E1), Color(0xFF63B3ED)],
              ),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '₹${(amount / 1000).toStringAsFixed(0)}K',
            style: const TextStyle(
              fontSize: 10,
              color: Color(0xFF718096),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            month,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF718096),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDistributionItem(
      String label, int count, Color color, String percentage) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
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
              color: Color(0xFF2D3748),
            ),
          ),
        ),
        Text(
          '$count',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3748),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          percentage,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildPerformanceBar(String department, int percentage, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              department,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
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
          height: 8,
          decoration: BoxDecoration(
            color: const Color(0xFFE2E8F0),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Stack(
            children: [
              Container(
                width: (percentage / 100) * 300,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color, color.withValues(alpha: 0.7)],
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReportCard(
      String title, IconData icon, String subtitle, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF718096),
            ),
          ),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              minimumSize: const Size(double.infinity, 40),
            ),
            child: const Text('Generate'),
          ),
        ],
      ),
    );
  }
}