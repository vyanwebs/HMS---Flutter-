import 'package:flutter/material.dart';

class TreatmentPlansScreen extends StatelessWidget {
  final VoidCallback onBack;

  const TreatmentPlansScreen({super.key, required this.onBack});

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
                    'Treatment Plans',
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
                  // Header with Filter
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Active Treatment Plans',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2D3748),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: 'All',
                            icon:
                                const Icon(Icons.keyboard_arrow_down, size: 20),
                            items: ['All', 'Critical', 'Ongoing', 'Completed']
                                .map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (value) {},
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Treatment Plans Grid
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: isMobile ? 1 : 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: isMobile ? 1.5 : 1.2,
                    children: [
                      _buildTreatmentPlanCard(
                        patientName: 'John Smith',
                        diagnosis: 'Acute Myocardial Infarction',
                        doctor: 'Dr. Sharma',
                        startDate: 'Jan 1, 2024',
                        endDate: 'Jan 15, 2024',
                        status: 'Critical',
                        progress: 0.4,
                      ),
                      _buildTreatmentPlanCard(
                        patientName: 'Mary Johnson',
                        diagnosis: 'Pneumonia',
                        doctor: 'Dr. Patel',
                        startDate: 'Dec 28, 2023',
                        endDate: 'Jan 10, 2024',
                        status: 'Ongoing',
                        progress: 0.7,
                      ),
                      _buildTreatmentPlanCard(
                        patientName: 'Robert Brown',
                        diagnosis: 'Diabetes Management',
                        doctor: 'Dr. Kumar',
                        startDate: 'Dec 15, 2023',
                        endDate: 'Jan 31, 2024',
                        status: 'Ongoing',
                        progress: 0.6,
                      ),
                      _buildTreatmentPlanCard(
                        patientName: 'Sarah Wilson',
                        diagnosis: 'Post-Surgery Recovery',
                        doctor: 'Dr. Gupta',
                        startDate: 'Jan 2, 2024',
                        endDate: 'Jan 20, 2024',
                        status: 'Stable',
                        progress: 0.2,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTreatmentPlanCard({
    required String patientName,
    required String diagnosis,
    required String doctor,
    required String startDate,
    required String endDate,
    required String status,
    required double progress,
  }) {
    Color statusColor;
    switch (status) {
      case 'Critical':
        statusColor = Colors.red;
        break;
      case 'Stable':
        statusColor = Colors.green;
        break;
      default:
        statusColor = Colors.orange;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Patient Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  patientName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3748),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Diagnosis
          Text(
            'Diagnosis: $diagnosis',
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF718096),
            ),
          ),

          const SizedBox(height: 12),

          // Doctor and Dates
          Row(
            children: [
              const Icon(Icons.person_outline,
                  size: 16, color: Color(0xFFA0AEC0)),
              const SizedBox(width: 4),
              Text(
                doctor,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF718096),
                ),
              ),
              const Spacer(),
              const Icon(Icons.calendar_today,
                  size: 16, color: Color(0xFFA0AEC0)),
              const SizedBox(width: 4),
              Text(
                '$startDate - $endDate',
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF718096),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Progress Bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Progress: ${(progress * 100).toInt()}%',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                  Text(
                    '${(progress * 100).toInt()}%',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              LinearProgressIndicator(
                value: progress,
                backgroundColor: const Color(0xFFE2E8F0),
                valueColor: AlwaysStoppedAnimation<Color>(
                  status == 'Critical' ? Colors.red : const Color(0xFF0094FE),
                ),
                minHeight: 6,
                borderRadius: BorderRadius.circular(3),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0094FE),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  child: const Text(
                    'View Details',
                    style: TextStyle(fontSize: 13),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF0094FE)),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  child: Text(
                    'Update',
                    style: TextStyle(
                      color: const Color(0xFF0094FE),
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
