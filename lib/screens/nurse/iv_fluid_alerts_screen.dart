import 'package:flutter/material.dart';

class IVFluidAlertsScreen extends StatelessWidget {
  final VoidCallback onBack;

  const IVFluidAlertsScreen({super.key, required this.onBack});

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
                    'IV Fluid Alerts',
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
                  // Header with Stats
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'IV Fluid Monitoring',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2D3748),
                        ),
                      ),
                      Row(
                        children: [
                          _buildStatBox('Active IVs', '12', Colors.blue),
                          const SizedBox(width: 12),
                          _buildStatBox('Low Fluid', '3', Colors.orange),
                          const SizedBox(width: 12),
                          _buildStatBox('Critical', '2', Colors.red),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Alert Status Cards
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: isMobile ? 1 : 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: isMobile ? 1.8 : 2,
                    children: [
                      _buildAlertCard(
                        patientName: 'John Smith',
                        bed: 'ICU-A, Bed 01',
                        fluidType: 'Normal Saline',
                        remainingVolume: '150',
                        totalVolume: '1000',
                        rate: '50',
                        timeRemaining: '3 hours',
                        status: 'Critical',
                        isCritical: true,
                      ),
                      _buildAlertCard(
                        patientName: 'Robert Brown',
                        bed: 'ICU-B, Bed 03',
                        fluidType: 'Dextrose 5%',
                        remainingVolume: '300',
                        totalVolume: '500',
                        rate: '30',
                        timeRemaining: '10 hours',
                        status: 'Low',
                        isCritical: false,
                      ),
                      _buildAlertCard(
                        patientName: 'Mary Johnson',
                        bed: 'Ward 2, Bed 05',
                        fluidType: 'Ringer Lactate',
                        remainingVolume: '400',
                        totalVolume: '1000',
                        rate: '40',
                        timeRemaining: '15 hours',
                        status: 'Normal',
                        isCritical: false,
                      ),
                      _buildAlertCard(
                        patientName: 'Sarah Wilson',
                        bed: 'Ward 1, Bed 08',
                        fluidType: 'Normal Saline',
                        remainingVolume: '800',
                        totalVolume: '1000',
                        rate: '20',
                        timeRemaining: '10 hours',
                        status: 'Normal',
                        isCritical: false,
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

  Widget _buildStatBox(String title, String count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Text(
            count,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertCard({
    required String patientName,
    required String bed,
    required String fluidType,
    required String remainingVolume,
    required String totalVolume,
    required String rate,
    required String timeRemaining,
    required String status,
    required bool isCritical,
  }) {
    Color statusColor;
    switch (status) {
      case 'Critical':
        statusColor = Colors.red;
        break;
      case 'Low':
        statusColor = Colors.orange;
        break;
      default:
        statusColor = Colors.green;
    }

    double progress = double.parse(remainingVolume) / double.parse(totalVolume);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCritical ? Colors.red.shade300 : const Color(0xFFE2E8F0),
          width: isCritical ? 2 : 1,
        ),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      patientName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    Text(
                      bed,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF718096),
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

          const SizedBox(height: 16),

          // Fluid Info
          Row(
            children: [
              const Icon(Icons.invert_colors,
                  size: 16, color: Color(0xFFA0AEC0)),
              const SizedBox(width: 6),
              Text(
                'Fluid: $fluidType',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF2D3748),
                ),
              ),
              const Spacer(),
              const Icon(Icons.speed, size: 16, color: Color(0xFFA0AEC0)),
              const SizedBox(width: 6),
              Text(
                'Rate: ${rate}ml/hr',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF2D3748),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Progress Bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Volume: ${remainingVolume}ml / ${totalVolume}ml',
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
                valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                minHeight: 8,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Time Remaining
          Row(
            children: [
              const Icon(Icons.access_time, size: 16, color: Color(0xFFA0AEC0)),
              const SizedBox(width: 6),
              Text(
                'Time remaining: $timeRemaining',
                style: TextStyle(
                  fontSize: 14,
                  color: isCritical ? Colors.red : const Color(0xFF2D3748),
                  fontWeight: isCritical ? FontWeight.w600 : FontWeight.normal,
                ),
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
                    'Change Bag',
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
                    'Acknowledge',
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
