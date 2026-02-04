import 'package:flutter/material.dart';

class DischargeSummary extends StatefulWidget {
  const DischargeSummary({super.key});

  @override
  State<DischargeSummary> createState() => _DischargeSummaryState();
}

class _DischargeSummaryState extends State<DischargeSummary> {
  // Controllers for patient information fields
  final TextEditingController _patientNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _bedController = TextEditingController();
  final TextEditingController _admissionDateController =
      TextEditingController();

  // Controllers for discharge summary fields
  final Map<String, TextEditingController> _summaryControllers = {
    'Chief Complaints': TextEditingController(),
    'History of Present Illness': TextEditingController(),
    'Past Medical History': TextEditingController(),
    'Examination Findings': TextEditingController(),
    'Investigations': TextEditingController(),
    'Final Diagnosis': TextEditingController(),
    'Treatment Given': TextEditingController(),
    'Course in Hospital': TextEditingController(),
    'Condition at Discharge': TextEditingController(),
    'Medications on Discharge': TextEditingController(),
    'Follow-up Instructions': TextEditingController(),
    'Diet Advice': TextEditingController(),
    'Activity Restrictions': TextEditingController(),
  };

  @override
  void initState() {
    super.initState();
    // Initialize some sample data for demonstration
    _initializeSampleData();
  }

  void _initializeSampleData() {
    // Patient information
    _patientNameController.text = 'Maria Garcia';
    _ageController.text = '45';
    _genderController.text = 'Male';
    _bedController.text = 'A-101';
    _admissionDateController.text = '2024-01-10';

    // Sample discharge summary data
    _summaryControllers['Chief Complaints']!.text =
        'Chest pain, shortness of breath';
    _summaryControllers['Final Diagnosis']!.text =
        'Acute Myocardial Infarction';
    _summaryControllers['Treatment Given']!.text = 'Aspirin, Clopidogrel, PCI';
  }

  @override
  void dispose() {
    // Dispose all controllers
    _patientNameController.dispose();
    _ageController.dispose();
    _genderController.dispose();
    _bedController.dispose();
    _admissionDateController.dispose();

    // Dispose all summary controllers
    for (var controller in _summaryControllers.values) {
      controller.dispose();
    }

    super.dispose();
  }

  // Button functions
  void _saveDischargeSummary() {
    // Validate required fields
    if (_patientNameController.text.isEmpty) {
      _showSnackBar('Please enter patient name');
      return;
    }

    // Save logic here (in a real app, this would save to database/API)
    _showSnackBar('Discharge summary saved successfully!');

    // Print data for debugging
    print('=== Discharge Summary Saved ===');
    print('Patient: ${_patientNameController.text}');
    print('Age: ${_ageController.text}');
    print('Gender: ${_genderController.text}');
    print('Bed: ${_bedController.text}');
    print('Admission Date: ${_admissionDateController.text}');

    for (var entry in _summaryControllers.entries) {
      if (entry.value.text.isNotEmpty) {
        print('${entry.key}: ${entry.value.text}');
      }
    }
  }

  void _generatePDF() {
    // PDF generation logic
    _showSnackBar('PDF generation started...');

    // In a real app, this would generate and save/download a PDF
    Future.delayed(const Duration(seconds: 2), () {
      _showSnackBar('PDF generated successfully!');
    });
  }

  void _signAndFinalize() {
    // Digital signature logic
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign and Finalize'),
        content: const Text(
            'Are you sure you want to sign and finalize this discharge summary? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSnackBar('Discharge summary signed and finalized!');
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _voiceEntry() {
    // Voice input logic
    _showSnackBar('Voice entry mode activated. Start speaking...');

    // Simulate voice input
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        // Add sample voice input to first empty field
        for (var entry in _summaryControllers.entries) {
          if (entry.value.text.isEmpty) {
            entry.value.text = '[Voice input sample for ${entry.key}]';
            break;
          }
        }
      });
      _showSnackBar('Voice input added successfully!');
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    final isTablet = screenWidth >= 768 && screenWidth < 1024;

    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC),
      body: SafeArea(
        child: Column(
          children: [
            // Main Content Area
            Expanded(
              child: _buildMainContent(isMobile, isTablet),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent(bool isMobile, bool isTablet) {
    return Container(
      color: const Color(0xFFF7FAFC),
      child: Column(
        children: [
          // Divider
          Container(height: 1, color: const Color(0xFFE2E8F0)),

          // Main Content
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(
                  isMobile
                      ? 16
                      : isTablet
                          ? 20
                          : 24,
                ),
                child: _buildContent(isMobile, isTablet),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(bool isMobile, bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title Section
        const Text(
          'Discharge Summary',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3748),
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Create and manage patient discharge summaries',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF718096),
          ),
        ),
        const SizedBox(height: 20),

        // STATS CARDS SECTION - Only 2 boxes with blank space on the right
        _buildStatsCards(isMobile, isTablet),

        const SizedBox(height: 20),

        // Main Content Area - Full screen summary form
        _summaryForm(isMobile),
      ],
    );
  }

  Widget _buildStatsCards(bool isMobile, bool isTablet) {
    final statsData = [
      {
        'title': 'Total Patients',
        'value': '12',
        'gradient': const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF2C7EDB), Color(0xFFE1F0FF)],
        ),
        'image': 'assets/images/box1.png',
      },
      {
        'title': 'Ready for Discharge',
        'value': '8',
        'gradient': const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF00B894), Color(0xFFE3FCFA)],
        ),
        'image': 'assets/images/box2.png',
      },
    ];

    // Create a Row with 2 boxes and leave the rest of the space blank
    return Row(
      children: [
        // First box
        Expanded(
          child: _buildStatCard(
            title: statsData[0]['title'] as String,
            value: statsData[0]['value'] as String,
            gradient: statsData[0]['gradient'] as Gradient,
            imagePath: statsData[0]['image'] as String,
            isMobile: false,
          ),
        ),

        const SizedBox(width: 10),

        // Second box
        Expanded(
          child: _buildStatCard(
            title: statsData[1]['title'] as String,
            value: statsData[1]['value'] as String,
            gradient: statsData[1]['gradient'] as Gradient,
            imagePath: statsData[1]['image'] as String,
            isMobile: false,
          ),
        ),

        // Empty space for the remaining 2 boxes that don't exist
        const Expanded(
          child: SizedBox(), // Empty space
        ),

        const Expanded(
          child: SizedBox(), // Empty space
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required Gradient gradient,
    required String imagePath,
    required bool isMobile,
  }) {
    return Container(
      height: 140,
      padding: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          // Background Image - Adjusted size and position
          Positioned(
            right: 0,
            bottom: 0,
            child: _buildBackgroundImage(imagePath),
          ),

          // Content - Moved to bottom with left margin
          Positioned(
            left: 20, // Added left margin
            bottom: 20, // Position at bottom
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Value at the top
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF000000),
                  ),
                ),
                const SizedBox(height: 50),
                // Title text at the bottom
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF757575),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundImage(String imagePath) {
    return SizedBox(
      width: 120,
      height: 90,
      child: Image.asset(
        imagePath,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 120,
            height: 90,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                _getImageLabel(imagePath),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _getImageLabel(String imagePath) {
    if (imagePath.contains('box1')) return 'Patients';
    if (imagePath.contains('box2')) return 'Ready';
    return 'Image';
  }

  Widget _summaryForm(bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 20),
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
          // Patient Information Section - Now with input fields
          const Text(
            'Patient Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 16),

          // Patient Information Fields in a grid
          if (isMobile)
            Column(
              children: [
                _patientInfoField('Patient Name', _patientNameController),
                _patientInfoField('Age', _ageController,
                    hint: 'e.g., 45 years'),
                _patientInfoField('Gender', _genderController,
                    hint: 'e.g., Male'),
                _patientInfoField('Bed Number', _bedController,
                    hint: 'e.g., A-101'),
                _patientInfoField('Admission Date', _admissionDateController,
                    hint: 'e.g., 2024-01-10'),
              ],
            )
          else
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 4,
              children: [
                _patientInfoField('Patient Name', _patientNameController),
                _patientInfoField('Age', _ageController,
                    hint: 'e.g., 45 years'),
                _patientInfoField('Gender', _genderController,
                    hint: 'e.g., Male'),
                _patientInfoField('Bed Number', _bedController,
                    hint: 'e.g., A-101'),
                _patientInfoField('Admission Date', _admissionDateController,
                    hint: 'e.g., 2024-01-10'),
              ],
            ),

          const SizedBox(height: 24),
          const Divider(color: Color(0xFFE2E8F0)),
          const SizedBox(height: 24),

          // Discharge Summary Form Fields
          const Text(
            'Discharge Summary Details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 16),

          // Form Fields - Now editable
          Column(
            children: _summaryControllers.entries
                .map((entry) => _inputField(entry.key, entry.value))
                .toList(),
          ),

          const SizedBox(height: 20),

          // Action Buttons - Now functional
          if (isMobile)
            Column(
              children: [
                _actionButton('Save', Icons.save, const Color(0xFF2383E2),
                    _saveDischargeSummary),
                const SizedBox(height: 8),
                _actionButton('Generate PDF', Icons.picture_as_pdf,
                    const Color(0xFF2563EB), _generatePDF),
                const SizedBox(height: 8),
                _actionButton('Sign and Finalize', Icons.verified,
                    const Color(0xFF16A34A), _signAndFinalize),
                const SizedBox(height: 8),
                _actionButton('Voice Entry', Icons.mic, const Color(0xFF7C3AED),
                    _voiceEntry),
              ],
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _actionButton('Save', Icons.save, const Color(0xFF2383E2),
                    _saveDischargeSummary),
                const SizedBox(width: 8),
                _actionButton('Generate PDF', Icons.picture_as_pdf,
                    const Color(0xFF2563EB), _generatePDF),
                const SizedBox(width: 8),
                _actionButton('Sign and Finalize', Icons.verified,
                    const Color(0xFF16A34A), _signAndFinalize),
                const SizedBox(width: 8),
                _actionButton('Voice Entry', Icons.mic, const Color(0xFF7C3AED),
                    _voiceEntry),
              ],
            ),
        ],
      ),
    );
  }

  Widget _patientInfoField(String label, TextEditingController controller,
      {String? hint}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF4A5568),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF7FAFC),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hint ?? 'Enter $label',
              hintStyle: const TextStyle(
                fontSize: 14,
                color: Color(0xFFA0AEC0),
              ),
            ),
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF2D3748),
            ),
          ),
        ),
      ],
    );
  }

  Widget _inputField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF4A5568),
            ),
          ),
          const SizedBox(height: 6),
          Container(
            constraints: const BoxConstraints(minHeight: 44),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF7FAFC),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: TextField(
              controller: controller,
              maxLines: 3,
              minLines: 1,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter details here...',
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: Color(0xFFA0AEC0),
                ),
              ),
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

  Widget _actionButton(
      String text, IconData icon, Color color, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        minimumSize: const Size(0, 36),
      ),
      icon: Icon(icon, size: 16),
      label: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
