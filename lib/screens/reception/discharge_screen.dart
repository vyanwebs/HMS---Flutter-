// lib/screens/reception/discharge_screen.dart
import 'package:flutter/material.dart';

class DischargeScreen extends StatefulWidget {
  const DischargeScreen({super.key});

  @override
  State<DischargeScreen> createState() => _DischargeScreenState();
}

class _DischargeScreenState extends State<DischargeScreen> {
  final List<DischargePatient> dischargePatients = [
    DischargePatient(
      id: 'P10015',
      name: 'Thomas Anderson',
      admissionDate: '2024-01-05',
      dischargeDate: '2024-01-15',
      ward: 'Ward B',
      totalBill: 45000,
      status: 'Pending Clearance',
    ),
    DischargePatient(
      id: 'P10012',
      name: 'Jennifer Lee',
      admissionDate: '2024-01-08',
      dischargeDate: '2024-01-14',
      ward: 'Ward A',
      totalBill: 32000,
      status: 'Ready for Discharge',
    ),
    DischargePatient(
      id: 'P10009',
      name: 'William Brown',
      admissionDate: '2024-01-03',
      dischargeDate: '2024-01-13',
      ward: 'ICU',
      totalBill: 85000,
      status: 'Discharged',
    ),
    DischargePatient(
      id: 'P10007',
      name: 'Maria Garcia',
      admissionDate: '2024-01-02',
      dischargeDate: '2024-01-12',
      ward: 'Private Room',
      totalBill: 65000,
      status: 'Discharged',
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
                'Patient Discharge',
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
                icon: const Icon(Icons.exit_to_app, size: 18),
                label: const Text('Initiate Discharge'),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Stats Cards
          Row(
            children: [
              _buildDischargeStatCard('Pending Discharge', '3',
                  Icons.pending_actions, const Color(0xFFED8936)),
              const SizedBox(width: 20),
              _buildDischargeStatCard('Today\'s Discharges', '2',
                  Icons.today, const Color(0xFF4299E1)),
              const SizedBox(width: 20),
              _buildDischargeStatCard('Awaiting Payment', '4',
                  Icons.payment, const Color(0xFFF56565)),
              const SizedBox(width: 20),
              _buildDischargeStatCard('Total This Month', '24',
                  Icons.bar_chart, const Color(0xFF48BB78)),
            ],
          ),

          const SizedBox(height: 30),

          // Discharge Process
          Container(
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: const Color(0xFFF7FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Discharge Process Steps',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 20),

                Row(
                  children: [
                    _buildProcessStep(1, 'Medical Clearance', true),
                    _buildProcessLine(true),
                    _buildProcessStep(2, 'Bill Generation', true),
                    _buildProcessLine(true),
                    _buildProcessStep(3, 'Payment', false),
                    _buildProcessLine(false),
                    _buildProcessStep(4, 'Final Clearance', false),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // Patients for Discharge
          const Text(
            'Patients for Discharge',
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
                          'Patient ID',
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
                          'Admission Date',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2D3748),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Discharge Date',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2D3748),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Ward',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2D3748),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Total Bill',
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
                ...dischargePatients.map((patient) => Container(
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
                            child: Text(
                              patient.admissionDate,
                              style: const TextStyle(
                                color: Color(0xFF718096),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              patient.dischargeDate,
                              style: const TextStyle(
                                color: Color(0xFF718096),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              patient.ward,
                              style: const TextStyle(
                                color: Color(0xFF2D3748),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              '₹${patient.totalBill}',
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
                                color: patient.status == 'Discharged'
                                    ? const Color(0xFF48BB78).withValues(alpha: 0.1)
                                    : patient.status == 'Ready for Discharge'
                                        ? const Color(0xFF4299E1).withValues(alpha: 0.1)
                                        : const Color(0xFFED8936).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                patient.status,
                                style: TextStyle(
                                  color: patient.status == 'Discharged'
                                      ? const Color(0xFF48BB78)
                                      : patient.status == 'Ready for Discharge'
                                          ? const Color(0xFF4299E1)
                                          : const Color(0xFFED8936),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                if (patient.status == 'Ready for Discharge')
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(Icons.payment,
                                        size: 18, color: Color(0xFF48BB78)),
                                    tooltip: 'Process Payment',
                                  ),
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.receipt_outlined,
                                      size: 18, color: Color(0xFF4299E1)),
                                  tooltip: 'Generate Bill',
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.exit_to_app,
                                      size: 18, color: Color(0xFFF56565)),
                                  tooltip: 'Final Discharge',
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

          // Quick Actions
          Row(
            children: [
              Expanded(
                child: _buildDischargeActionCard(
                  'Generate Discharge Summary',
                  Icons.description,
                  const Color(0xFF4299E1),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: _buildDischargeActionCard(
                  'Print Final Bill',
                  Icons.print,
                  const Color(0xFF48BB78),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: _buildDischargeActionCard(
                  'Medication Instructions',
                  Icons.medication,
                  const Color(0xFFED8936),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: _buildDischargeActionCard(
                  'Follow-up Appointment',
                  Icons.calendar_today,
                  const Color(0xFF9F7AEA),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDischargeStatCard(
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
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    value,
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
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
          ],
        ),
      ),
    );
  }

  Widget _buildProcessStep(int step, String title, bool completed) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: completed
                ? const Color(0xFF48BB78)
                : const Color(0xFFE2E8F0),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '$step',
              style: TextStyle(
                color: completed ? Colors.white : const Color(0xFF718096),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            color: completed
                ? const Color(0xFF2D3748)
                : const Color(0xFF718096),
            fontWeight: completed ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildProcessLine(bool completed) {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        color: completed
            ? const Color(0xFF48BB78)
            : const Color(0xFFE2E8F0),
      ),
    );
  }

  Widget _buildDischargeActionCard(
      String title, IconData icon, Color color) {
    return Container(
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
    );
  }
}

class DischargePatient {
  final String id;
  final String name;
  final String admissionDate;
  final String dischargeDate;
  final String ward;
  final int totalBill;
  final String status;

  DischargePatient({
    required this.id,
    required this.name,
    required this.admissionDate,
    required this.dischargeDate,
    required this.ward,
    required this.totalBill,
    required this.status,
  });
}