import 'package:flutter/material.dart';
import 'package:hms/screens/doctor/doctor_dashboard.dart';
import 'package:hms/utils/constants.dart';

class EPrescriptions extends StatefulWidget {
  const EPrescriptions({super.key});

  @override
  State<EPrescriptions> createState() => _EPrescriptionsState();
}

class _EPrescriptionsState extends State<EPrescriptions> {
  // Medicine list state
  final List<Map<String, dynamic>> _medications = [];
  
  // Controllers
  final TextEditingController _specialInstructionController = TextEditingController();
  final TextEditingController _medicineNameController = TextEditingController();
  String _selectedFrequency = 'Daily 2 dosage';
  String _selectedDuration = '7 days';
  
  // Sample data
  final List<Map<String, dynamic>> _aiSuggestions = [
    {'name': 'Lisioprinti 10 mg', 'dosage': 'Once daily'},
    {'name': 'Lisioprinti 10 mg', 'dosage': 'Twice daily'},
    {'name': 'Lisioprinti 10 mg', 'dosage': 'Once daily'},
  ];

  final List<String> _commonMedications = [
    'Asprine 75 mg.',
    'Asprine 75 mg.',
    'Asprine 75 mg.',
    'Asprine 75 mg.',
    'Asprine 75 mg.',
    'Asprine 75 mg.',
    'Asprine 75 mg.',
    'Asprine 75 mg.',
    'Asprine 75 mg.',
    'Asprine 75 mg.',
  ];

  final List<Map<String, dynamic>> _recentPrescriptions = [
    {'patient': 'Sarah Johnson', 'date': '24/01/2023'},
    {'patient': 'Sarah Johnson', 'date': '24/01/2023'},
    {'patient': 'Sarah Johnson', 'date': '24/01/2023'},
  ];

  @override
  void dispose() {
    _specialInstructionController.dispose();
    _medicineNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC),
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar - AppBar style
            Container(
              height: 70,
              color: const Color(0xFF2383E2),
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 8 : 20,
              ),
              child: Row(
                children: [
                  // Back Button - White color
                  Container(
                    width: 50,
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back,
                          color: Colors.white, size: 24),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const DoctorDashboard()),
                        );
                      },
                    ),
                  ),

                  // Title
                  const Expanded(
                    child: Text(
                      'E-Prescriptions',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  // Voice assistance pill
                  if (!isMobile)
                    Container(
                      height: 44,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(999),
                        border:
                            Border.all(color: Colors.white.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.mic_none_rounded,
                              size: 18,
                              color: Color(0xFF2383E2),
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Voice assistance',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),

            // Main Content Area
            Expanded(
              child: _buildMainContent(isMobile),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent(bool isMobile) {
    return Container(
      color: const Color(0xFFF7FAFC),
      child: Column(
        children: [
          // Greeting and date section
          Container(
            height: 70,
            color: Colors.white,
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 16 : 30,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Greeting and date
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Good morning, Dr. Anderson',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2D3748),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Today 24 Dec., Monday',
                        style: TextStyle(
                          fontSize: 14,
                          color: const Color(0xFF718096),
                        ),
                      ),
                    ],
                  ),
                ),

                // Save Template and Print buttons
                if (!isMobile)
                  Row(
                    children: [
                      // Save Template button
                      Container(
                        height: 44,
                        margin: const EdgeInsets.only(right: 12),
                        child: OutlinedButton.icon(
                          onPressed: _saveTemplate,
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF2383E2)),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          icon: const Icon(
                            Icons.save_outlined,
                            size: 20,
                            color: Color(0xFF2383E2),
                          ),
                          label: const Text(
                            'Save template',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2383E2),
                            ),
                          ),
                        ),
                      ),

                      // Print button
                      Container(
                        height: 44,
                        child: ElevatedButton.icon(
                          onPressed: _printPrescription,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2383E2),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          icon: const Icon(
                            Icons.print_outlined,
                            size: 20,
                            color: Colors.white,
                          ),
                          label: const Text(
                            'Print',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),

          // Divider
          Container(height: 1, color: const Color(0xFFE2E8F0)),

          // Main Content
          Expanded(
            child: Container(
              padding: EdgeInsets.all(isMobile ? 16 : 24),
              child: isMobile ? _buildMobileLayout() : _buildDesktopLayout(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const Text(
            'DOCTOR PANEL >> E-Prescriptions',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF718096),
            ),
          ),
          const SizedBox(height: 20),

          // Main Container with 80-20 layout
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Column - 80% width
              Expanded(
                flex: 8,
                child: _buildMainPrescriptionCard(),
              ),

              const SizedBox(width: 24),

              // Right Column - 20% width
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Common Medication Section
                    _buildCommonMedicationSection(),
                    const SizedBox(height: 24),

                    // Recent Prescriptions Section
                    _buildRecentPrescriptionsSection(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const Text(
            'DOCTOR PANEL >> E-Prescriptions',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF718096),
            ),
          ),
          const SizedBox(height: 20),

          // Main Prescription Card
          _buildMainPrescriptionCard(),
          const SizedBox(height: 20),

          // Mobile buttons row
          Row(
            children: [
              // Save Template button
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _saveTemplate,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF2383E2)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  icon: const Icon(
                    Icons.save_outlined,
                    size: 18,
                    color: Color(0xFF2383E2),
                  ),
                  label: const Text(
                    'Save template',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2383E2),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Print button
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _printPrescription,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2383E2),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  icon: const Icon(
                    Icons.print_outlined,
                    size: 18,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Print',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Common Medication Section
          _buildCommonMedicationSection(),
          const SizedBox(height: 20),

          // Recent Prescriptions Section
          _buildRecentPrescriptionsSection(),
        ],
      ),
    );
  }

  Widget _buildMainPrescriptionCard() {
    return Container(
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
          // E-Prescription Title
          const Text(
            'E-Prescription',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 20),

          // Patient Information Section
          const Text(
            'Patient information',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF4A5568),
            ),
          ),
          const SizedBox(height: 8),

          // Select Patient Button
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF7FAFC),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Select patient',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF718096),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_drop_down,
                      color: Color(0xFF718096)),
                  onPressed: _selectPatient,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Selected Patient Info
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF7FAFC),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Sahah - Johnson UH20242001',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Primary diagnosis',
                      style: TextStyle(
                        fontSize: 12,
                        color: const Color(0xFF718096),
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: Color(0xFF2383E2)),
                  onPressed: _editPatientInfo,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Divider
          Container(height: 1, color: const Color(0xFFE2E8F0)),
          const SizedBox(height: 24),

          // Medication Section
          const Text(
            'Medication',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 16),

          // Add Medication Row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF7FAFC),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _medicineNameController,
                    decoration: InputDecoration(
                      hintText: 'Enter medicine name',
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        color: const Color(0xFF718096),
                      ),
                    ),
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  width: 120,
                  child: DropdownButtonFormField<String>(
                    value: _selectedFrequency,
                    items: ['Daily 2 dosage', 'Daily 1 dosage', 'Weekly', 'Monthly']
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: const TextStyle(fontSize: 12)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedFrequency = value!;
                      });
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                    isExpanded: true,
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  width: 100,
                  child: DropdownButtonFormField<String>(
                    value: _selectedDuration,
                    items: ['7 days', '14 days', '30 days', 'As needed']
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: const TextStyle(fontSize: 12)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedDuration = value!;
                      });
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                    isExpanded: true,
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _addMedication,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2383E2),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text(
                    'Add',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Medication Table Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF7FAFC),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Medicine name',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF4A5568),
                    ),
                  ),
                ),
                SizedBox(
                  width: 120,
                  child: Text(
                    'Frequency',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF4A5568),
                    ),
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: Text(
                    'Duration',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF4A5568),
                    ),
                  ),
                ),
                const SizedBox(width: 80),
              ],
            ),
          ),

          // Medication List
          ..._medications.map((medication) {
            return Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      medication['name'],
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 120,
                    child: Text(
                      medication['frequency'],
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF718096),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    child: Text(
                      medication['duration'],
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF718096),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 80,
                    child: IconButton(
                      icon: const Icon(Icons.delete, size: 18, color: Color(0xFFF56565)),
                      onPressed: () => _removeMedication(medication),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),

          const SizedBox(height: 24),

          // AI Suggestions Section
          const Text(
            'AI medicine suggestion',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF4A5568),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Recommended for hypertension',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF718096),
            ),
          ),
          const SizedBox(height: 12),
          ..._aiSuggestions.map((suggestion) {
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF7FAFC),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      suggestion['name'],
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => _addAiSuggestion(suggestion),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2383E2),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: const Text(
                      '+ Add',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),

          const SizedBox(height: 24),

          // Special Instructions
          const Text(
            'Special instruction',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF4A5568),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _specialInstructionController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Write special instruction',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF2383E2)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommonMedicationSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
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
            'Common medication',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF4A5568),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _commonMedications.map((medication) {
              return GestureDetector(
                onTap: () => _addCommonMedication(medication),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7FAFC),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Text(
                    medication,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentPrescriptionsSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
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
            'Recent prescription',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF4A5568),
            ),
          ),
          const SizedBox(height: 12),
          ..._recentPrescriptions.map((prescription) {
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF7FAFC),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.description,
                    size: 16,
                    color: Color(0xFF718096),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      prescription['patient'],
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                  ),
                  Text(
                    prescription['date'],
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF718096),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  // Action Methods
  void _selectPatient() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Select Patient',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3748),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search patients...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text('Patient ${index + 1}'),
                      subtitle: Text('ID: UH2024200${index + 1}'),
                      onTap: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Patient ${index + 1} selected'),
                            backgroundColor: const Color(0xFF38A169),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _editPatientInfo() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Edit Patient Information',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3748),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Patient Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Patient ID',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Primary Diagnosis',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Patient information updated'),
                            backgroundColor: Color(0xFF38A169),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2383E2),
                      ),
                      child: const Text('Save'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addMedication() {
    if (_medicineNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter medicine name'),
          backgroundColor: Color(0xFFF56565),
        ),
      );
      return;
    }
    
    final newMedication = {
      'name': _medicineNameController.text,
      'frequency': _selectedFrequency,
      'duration': _selectedDuration,
    };
    
    setState(() {
      _medications.add(newMedication);
      _medicineNameController.clear();
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${newMedication['name']} added'),
        backgroundColor: const Color(0xFF38A169),
      ),
    );
  }

  void _removeMedication(Map<String, dynamic> medication) {
    setState(() {
      _medications.remove(medication);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${medication['name']} removed'),
        backgroundColor: const Color(0xFFF56565),
      ),
    );
  }

  void _addAiSuggestion(Map<String, dynamic> suggestion) {
    setState(() {
      _medications.add({
        'name': suggestion['name'],
        'frequency': suggestion['dosage'],
        'duration': '30 days',
      });
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${suggestion['name']} added to prescription'),
        backgroundColor: const Color(0xFF38A169),
      ),
    );
  }

  void _addCommonMedication(String medication) {
    setState(() {
      _medications.add({
        'name': medication,
        'frequency': 'Once daily',
        'duration': 'As needed',
      });
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$medication added to prescription'),
        backgroundColor: const Color(0xFF38A169),
      ),
    );
  }

  void _saveTemplate() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Prescription template saved'),
        backgroundColor: Color(0xFF38A169),
      ),
    );
  }

  void _printPrescription() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.print_outlined,
                size: 64,
                color: Color(0xFF2383E2),
              ),
              const SizedBox(height: 16),
              const Text(
                'Print Prescription',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3748),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'The prescription will be sent to the printer.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF718096),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Prescription sent to printer'),
                            backgroundColor: Color(0xFF38A169),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2383E2),
                      ),
                      child: const Text('Print'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}