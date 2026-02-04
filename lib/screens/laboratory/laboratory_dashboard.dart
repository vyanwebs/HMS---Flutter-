import 'package:flutter/material.dart';
import 'package:hms/utils/constants.dart';

class LaboratoryDashboard extends StatelessWidget {
  const LaboratoryDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Laboratory Dashboard'),
        backgroundColor: AppColors.laboratory,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                _buildStatCard('Total Tests', '156', Icons.science),
                _buildStatCard('Pending', '18', Icons.pending),
                _buildStatCard('Today\'s Tests', '24', Icons.today),
                _buildStatCard('Completed', '138', Icons.check_circle),
              ],
            ),
            const SizedBox(height: 20),

            // Pending Tests
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Pending Tests',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildTestItem('LAB-001', 'Blood Test', 'Dr. Sharma', '2 hours'),
                    _buildTestItem('LAB-002', 'Urine Analysis', 'Dr. Patel', '4 hours'),
                    _buildTestItem('LAB-003', 'X-Ray Chest', 'Dr. Gupta', '1 day'),
                    _buildTestItem('LAB-004', 'MRI Scan', 'Dr. Singh', '2 days'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Recent Results
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Recent Results',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildResultItem('John Smith', 'Blood Test', 'Normal'),
                    _buildResultItem('Sarah Johnson', 'Liver Function', 'Abnormal'),
                    _buildResultItem('Robert Brown', 'Diabetes Panel', 'Normal'),
                    _buildResultItem('Maria Garcia', 'Thyroid Test', 'Normal'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Quick Actions
            const Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                _buildActionCard('New Test', Icons.add_circle),
                _buildActionCard('Upload Report', Icons.upload),
                _buildActionCard('View Reports', Icons.description),
                _buildActionCard('Equipment', Icons.biotech),
                _buildActionCard('Inventory', Icons.inventory),
                _buildActionCard('Schedule', Icons.calendar_today),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.laboratory,
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.laboratory, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestItem(String testId, String testName, String doctor, String time) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.laboratory.withValues(alpha: 0.1),
          child: Icon(Icons.science, color: AppColors.laboratory),
        ),
        title: Text(testName),
        subtitle: Text('$testId • $doctor'),
        trailing: Text(
          time,
          style: const TextStyle(
            color: Colors.orange,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildResultItem(String patient, String test, String result) {
    Color resultColor = result == 'Normal' ? Colors.green : Colors.red;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: resultColor.withValues(alpha: 0.1),
          child: Icon(
            result == 'Normal' ? Icons.check_circle : Icons.warning,
            color: resultColor,
          ),
        ),
        title: Text(patient),
        subtitle: Text(test),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: resultColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: resultColor.withValues(alpha: 0.3)),
          ),
          child: Text(
            result,
            style: TextStyle(
              color: resultColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard(String title, IconData icon) {
    return Card(
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: AppColors.laboratory, size: 32),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}