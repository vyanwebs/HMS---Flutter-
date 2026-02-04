import 'package:flutter/material.dart';

import '../../utils/text.dart';

class PatientHistory extends StatefulWidget {
  const PatientHistory({super.key});

  @override
  State<PatientHistory> createState() => _PatientHistoryState();
}

class _PatientHistoryState extends State<PatientHistory> {
  // State variables
  String _selectedPatient = 'Sahah Johnson - UH20242001';
  final TextEditingController _searchController = TextEditingController();
  final List<String> _patients = [
    'Sahah Johnson - UH20242001',
    'John Smith - UH20242002',
    'Emily Davis - UH20242003',
    'Michael Brown - UH20242004',
    'Robert Wilson - UH20242005',
    'Lisa Anderson - UH20242006',
    'David Miller - UH20242007',
  ];

  // Sample timeline data
  final List<Map<String, dynamic>> _timelineData = [
    {
      'color': Color(0xFFE8F1FF),
      'iconColor': Color(0xFF3B82F6),
      'title': 'OPD Consultation',
      'subtitle': 'Chest pain evaluation , ECG performed',
      'doctor': 'Dr. Sarah Williams',
      'date': '15 Jan 2025',
      'time': '10:30 AM',
      'details': 'Patient presented with chest pain lasting 30 minutes. ECG showed ST elevation in inferior leads. Blood pressure: 140/90 mmHg, Heart rate: 92 bpm.',
      'downloadUrl': 'https://hospital.com/reports/consultation_001.pdf',
    },
    {
      'color': Color(0xFFF1EDFF),
      'iconColor': Color(0xFF8B5CF6),
      'title': 'Laboratory Tests',
      'subtitle': 'Complete Blood Count, Lipid Profile, Troponin I',
      'doctor': 'Dr. Sarah Williams',
      'date': '15 Jan 2025',
      'time': '11:45 AM',
      'details': 'Blood tests ordered. Results: Troponin I - 2.5 ng/mL (elevated), Cholesterol - 240 mg/dL, HDL - 38 mg/dL, LDL - 180 mg/dL.',
      'downloadUrl': 'https://hospital.com/reports/lab_results_001.pdf',
    },
    {
      'color': Color(0xFFFFF1E8),
      'iconColor': Color(0xFFF97316),
      'title': 'OPD Consultation',
      'subtitle': 'Chest pain evaluation , ECG performed',
      'doctor': 'Dr. Sarah Williams',
      'date': '22 Jan 2025',
      'time': '02:15 PM',
      'details': 'Follow-up consultation. Patient reports improvement in chest pain. ECG shows resolution of ST elevation. Blood pressure: 130/85 mmHg.',
      'downloadUrl': 'https://hospital.com/reports/consultation_002.pdf',
    },
    {
      'color': Color(0xFFEAF7EF),
      'iconColor': Color(0xFF22C55E),
      'title': 'Diagnosis',
      'subtitle': 'Acute Myocardial Infarction - Inferior Wall',
      'doctor': 'Dr. Sarah Williams',
      'date': '15 Jan 2025',
      'time': '12:30 PM',
      'details': 'Final diagnosis: Acute Inferior Wall Myocardial Infarction. Based on ECG changes and elevated cardiac enzymes. Recommended for cardiac monitoring.',
      'downloadUrl': 'https://hospital.com/reports/diagnosis_001.pdf',
    },
    {
      'color': Color(0xFFFCEBFF),
      'iconColor': Color(0xFFD946EF),
      'title': 'Prescription',
      'subtitle': 'Aspirin 75mg, Atorvastatin 40mg, Clopidogrel 75mg',
      'doctor': 'Dr. Sarah Williams',
      'date': '15 Jan 2025',
      'time': '01:00 PM',
      'details': 'Prescribed medications: Aspirin 75mg daily, Atorvastatin 40mg at bedtime, Clopidogrel 75mg daily. Follow-up in 1 week.',
      'downloadUrl': 'https://hospital.com/reports/prescription_001.pdf',
    },
    {
      'color': Color(0xFFFFF7DB),
      'iconColor': Color(0xFFEAB308),
      'title': 'Follow-up Visit',
      'subtitle': 'Blood pressure monitoring, medication review',
      'doctor': 'Dr. Sarah Williams',
      'date': '29 Jan 2025',
      'time': '09:45 AM',
      'details': 'Follow-up visit. Patient reports no chest pain. Blood pressure controlled at 125/80 mmHg. Medication compliance good.',
      'downloadUrl': 'https://hospital.com/reports/followup_001.pdf',
    },
    {
      'color': Color(0xFFE8F1FF),
      'iconColor': Color(0xFF3B82F6),
      'title': 'Annual Health Checkup',
      'subtitle': 'Complete metabolic panel, HbA1c, Lipid profile',
      'doctor': 'Dr. Sarah Williams',
      'date': '05 Feb 2025',
      'time': '11:00 AM',
      'details': 'Annual comprehensive health checkup. All parameters within normal range. HbA1c: 5.8%, Lipid profile improved.',
      'downloadUrl': 'https://hospital.com/reports/annual_checkup_001.pdf',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    final isTablet = screenWidth >= 768 && screenWidth < 1024;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        child: Column(
          children: [
            // Main Content Area
            Expanded(
              child: Container(
                color: const Color(0xFFF7F8FA),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      // Main Content
                      Container(
                        padding: EdgeInsets.all(
                          isMobile
                              ? 16
                              : isTablet
                                  ? 20
                                  : 24,
                        ),
                        child: _buildContent(isMobile, isTablet),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(bool isMobile, bool isTablet) {
    // Filter timeline data based on search
    final filteredTimeline = _timelineData.where((item) {
      final searchText = _searchController.text.toLowerCase();
      if (searchText.isEmpty) return true;
      return item['title'].toLowerCase().contains(searchText) ||
          item['subtitle'].toLowerCase().contains(searchText) ||
          item['details'].toLowerCase().contains(searchText);
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with breadcrumb
        if (isMobile) ...[
          const Text(
            'CLINICAL RECORDS >> Patient History',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF718096),
            ),
          ),
          const SizedBox(height: 20),
        ],

        // Desktop header
        if (!isMobile)
          const AppText(
            'CLINICAL RECORDS >> Patient History',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF718096),
          ),

        if (!isMobile) const SizedBox(height: 20),

        const Text(
          'Patient history timeline',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        const Text(
          'Chronological view of patient medical records',
          style: TextStyle(color: Colors.black54),
        ),
        const SizedBox(height: 16),

        _patientInfoCard(isMobile, isTablet),
        const SizedBox(height: 24),

        Text(
          'Medical history - ${_selectedPatient.split(' - ')[0]}',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),

        // Show message if no results found
        if (filteredTimeline.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: const Center(
              child: Column(
                children: [
                  Icon(Icons.search_off, size: 48, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No records found',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Try searching with different keywords',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          )
        else
          // Timeline items
          ...filteredTimeline.map((item) {
            return _timelineItem(
              color: item['color'] as Color,
              iconColor: item['iconColor'] as Color,
              title: item['title'] as String,
              subtitle: item['subtitle'] as String,
              doctor: item['doctor'] as String,
              details: item['details'] as String,
              date: item['date'] as String,
              time: item['time'] as String,
              downloadUrl: item['downloadUrl'] as String,
            );
          }).toList(),

        // Add some bottom padding for better scrolling
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _patientInfoCard(bool isMobile, bool isTablet) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Patient information',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _patientDropdown(),
              ),
              SizedBox(width: isMobile ? 8 : 16),
              Expanded(
                child: _searchBox(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _patientDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Select patient', style: TextStyle(fontSize: 12)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: DropdownButton<String>(
            value: _selectedPatient,
            icon: const Icon(Icons.keyboard_arrow_down, size: 18, color: Colors.black45),
            iconSize: 16,
            elevation: 16,
            style: const TextStyle(color: Colors.black54),
            underline: const SizedBox(),
            isExpanded: true,
            onChanged: (String? newValue) {
              setState(() {
                _selectedPatient = newValue!;
              });
            },
            items: _patients.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _searchBox() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Search history', style: TextStyle(fontSize: 12)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              hintText: 'Search by diagnosis, medication',
              border: InputBorder.none,
              hintStyle: TextStyle(color: Colors.black54),
              suffixIcon: Icon(Icons.search, size: 18, color: Colors.black45),
            ),
            style: const TextStyle(color: Colors.black54),
            onChanged: (value) {
              setState(() {});
            },
          ),
        ),
      ],
    );
  }

  Widget _timelineItem({
    required Color color,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String doctor,
    required String details,
    required String date,
    required String time,
    required String downloadUrl,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.medical_services, color: iconColor, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFBFDFF),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(color: Colors.black54)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.person_outline,
                          size: 14, color: Colors.black45),
                      const SizedBox(width: 4),
                      Text(
                        doctor,
                        style: const TextStyle(fontSize: 12, color: Colors.black54),
                      ),
                      const Spacer(),
                      Text(
                        '$date • $time',
                        style: const TextStyle(fontSize: 12, color: Colors.black45),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          _showDetailsDialog(title, details, doctor, date, time);
                        },
                        child: const Text(
                          'View Details',
                          style: TextStyle(
                              color: Color(0xFF2563EB),
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      const SizedBox(width: 24),
                      TextButton(
                        onPressed: () {
                          _downloadReport(title, downloadUrl);
                        },
                        child: const Text(
                          'Download',
                          style: TextStyle(
                              color: Color(0xFF16A34A),
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void _showDetailsDialog(String title, String details, String doctor, String date, String time) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F8FA),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.person_outline, size: 16, color: Colors.black45),
                          const SizedBox(width: 8),
                          Text(
                            'Doctor: $doctor',
                            style: const TextStyle(color: Colors.black87),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 16, color: Colors.black45),
                          const SizedBox(width: 8),
                          Text(
                            'Date: $date',
                            style: const TextStyle(color: Colors.black87),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.access_time, size: 16, color: Colors.black45),
                          const SizedBox(width: 8),
                          Text(
                            'Time: $time',
                            style: const TextStyle(color: Colors.black87),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Details',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  details,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: const Text(
                      'Close',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _downloadReport(String title, String url) {
    // Show downloading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: const Color(0xFF16A34A).withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.download,
                    color: Color(0xFF16A34A),
                    size: 28,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Downloading Report',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF4A5568),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF16A34A)),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Preparing file for download...',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // Show success message
                      _showDownloadSuccess(title);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF16A34A),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: const Text(
                      'Complete Download',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    // Simulate download process
    Future.delayed(const Duration(seconds: 2), () {
      if (context.mounted) {
        Navigator.pop(context);
        _showDownloadSuccess(title);
      }
    });
  }

  void _showDownloadSuccess(String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Successfully downloaded: $title'),
        backgroundColor: const Color(0xFF16A34A),
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}