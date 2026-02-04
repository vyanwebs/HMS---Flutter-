import 'package:flutter/material.dart';

class IpdManagement extends StatefulWidget {
  const IpdManagement({super.key});

  @override
  State<IpdManagement> createState() => _IpdManagementState();
}

class _IpdManagementState extends State<IpdManagement> {
  String _selectedFilter = 'All';
  String _selectedTab = 'Vital Monitoring'; // NEW: Track selected tab
  final TextEditingController _searchController = TextEditingController();

  // NEW: Sample patient data
  final List<Map<String, dynamic>> _patients = [
    {
      'name': 'John Smith',
      'age': '45',
      'bed': 'B-205',
      'ward': 'General Ward',
      'status': 'Stable',
      'statusColor': Color(0xFFDBEAFE),
      'selected': false,
      'diagnosis': 'Hypertension',
      'admissionDate': '2024-01-10',
      'gender': 'Male',
      'vitals': [
        {
          'time': '08:00 AM',
          'bp': '120/80',
          'pulse': '72',
          'temp': '98.9°F',
          'spo2': '98%',
          'rr': '16'
        },
        {
          'time': '12:00 PM',
          'bp': '122/82',
          'pulse': '74',
          'temp': '99.0°F',
          'spo2': '97%',
          'rr': '16'
        },
        {
          'time': '04:00 PM',
          'bp': '121/79',
          'pulse': '73',
          'temp': '98.8°F',
          'spo2': '98%',
          'rr': '15'
        },
      ],
      'criticalNotes': [
        'Blood pressure stable on current medication.',
        'No signs of distress during night rounds.',
        'Patient responding well to treatment.'
      ],
      'treatmentPlans': [
        'Continue with current antihypertensive medication.',
        'Monitor blood pressure every 6 hours.',
        'Encourage low-sodium diet.'
      ]
    },
    {
      'name': 'Sarah Johnson',
      'age': '32',
      'bed': 'C-101',
      'ward': 'ICU',
      'status': 'Critical',
      'statusColor': Color(0xFFFEE2E2),
      'selected': true,
      'diagnosis': 'Pneumonia',
      'admissionDate': '2024-01-12',
      'gender': 'Female',
      'vitals': [
        {
          'time': '08:00 AM',
          'bp': '130/90',
          'pulse': '95',
          'temp': '101.2°F',
          'spo2': '92%',
          'rr': '22'
        },
        {
          'time': '12:00 PM',
          'bp': '128/88',
          'pulse': '92',
          'temp': '100.8°F',
          'spo2': '93%',
          'rr': '21'
        },
        {
          'time': '04:00 PM',
          'bp': '132/92',
          'pulse': '96',
          'temp': '101.0°F',
          'spo2': '91%',
          'rr': '23'
        },
      ],
      'criticalNotes': [
        'Requires oxygen support - maintaining at 2L/min.',
        'Fever persists despite antibiotics.',
        'Monitoring for sepsis markers.'
      ],
      'treatmentPlans': [
        'Continue IV antibiotics for 7 days.',
        'Oxygen therapy as needed.',
        'Regular chest physiotherapy.'
      ]
    },
    {
      'name': 'Michael Brown',
      'age': '58',
      'bed': 'A-305',
      'ward': 'Cardiology',
      'status': 'Improving',
      'statusColor': Color(0xFFDCFCE7),
      'selected': false,
      'diagnosis': 'Myocardial Infarction',
      'admissionDate': '2024-01-09',
      'gender': 'Male',
      'vitals': [
        {
          'time': '08:00 AM',
          'bp': '118/78',
          'pulse': '68',
          'temp': '98.6°F',
          'spo2': '99%',
          'rr': '14'
        },
        {
          'time': '12:00 PM',
          'bp': '120/80',
          'pulse': '70',
          'temp': '98.7°F',
          'spo2': '98%',
          'rr': '15'
        },
        {
          'time': '04:00 PM',
          'bp': '119/79',
          'pulse': '69',
          'temp': '98.6°F',
          'spo2': '99%',
          'rr': '14'
        },
      ],
      'criticalNotes': [
        'Post-MI recovery progressing well.',
        'No arrhythmias detected in 24hrs.',
        'Tolerating cardiac rehab exercises.'
      ],
      'treatmentPlans': [
        'Continue beta-blockers and aspirin.',
        'Cardiac rehabilitation program.',
        'Dietary counseling for heart-healthy diet.'
      ]
    },
    {
      'name': 'Emily Davis',
      'age': '28',
      'bed': 'D-102',
      'ward': 'Pediatrics',
      'status': 'Stable',
      'statusColor': Color(0xFFDBEAFE),
      'selected': false,
      'diagnosis': 'Bronchitis',
      'admissionDate': '2024-01-11',
      'gender': 'Female',
      'vitals': [
        {
          'time': '08:00 AM',
          'bp': '110/70',
          'pulse': '75',
          'temp': '99.1°F',
          'spo2': '97%',
          'rr': '18'
        },
        {
          'time': '12:00 PM',
          'bp': '112/72',
          'pulse': '76',
          'temp': '99.0°F',
          'spo2': '98%',
          'rr': '17'
        },
        {
          'time': '04:00 PM',
          'bp': '111/71',
          'pulse': '74',
          'temp': '98.9°F',
          'spo2': '97%',
          'rr': '18'
        },
      ],
      'criticalNotes': [
        'Cough improving with medication.',
        'Able to maintain oxygen saturation without support.',
        'Good appetite and hydration.'
      ],
      'treatmentPlans': [
        'Bronchodilator inhaler every 6 hours.',
        'Monitor respiratory rate.',
        'Encourage fluid intake.'
      ]
    },
    {
      'name': 'Robert Wilson',
      'age': '65',
      'bed': 'B-208',
      'ward': 'General Ward',
      'status': 'Improving',
      'statusColor': Color(0xFFDCFCE7),
      'selected': false,
      'diagnosis': 'Diabetes Management',
      'admissionDate': '2024-01-08',
      'gender': 'Male',
      'vitals': [
        {
          'time': '08:00 AM',
          'bp': '125/85',
          'pulse': '72',
          'temp': '98.4°F',
          'spo2': '98%',
          'rr': '16'
        },
        {
          'time': '12:00 PM',
          'bp': '123/83',
          'pulse': '73',
          'temp': '98.5°F',
          'spo2': '97%',
          'rr': '16'
        },
        {
          'time': '04:00 PM',
          'bp': '124/84',
          'pulse': '71',
          'temp': '98.4°F',
          'spo2': '98%',
          'rr': '15'
        },
      ],
      'criticalNotes': [
        'Blood sugar levels stabilizing.',
        'No signs of infection at wound site.',
        'Responding well to insulin regimen.'
      ],
      'treatmentPlans': [
        'Regular insulin injections as prescribed.',
        'Monitor blood glucose 4 times daily.',
        'Foot care and wound dressing changes.'
      ]
    },
    {
      'name': 'David Miller',
      'age': '42',
      'bed': 'C-105',
      'ward': 'Orthopedics',
      'status': 'Stable',
      'statusColor': Color(0xFFDBEAFE),
      'selected': false,
      'diagnosis': 'Fractured Femur',
      'admissionDate': '2024-01-07',
      'gender': 'Male',
      'vitals': [
        {
          'time': '08:00 AM',
          'bp': '118/76',
          'pulse': '70',
          'temp': '98.6°F',
          'spo2': '99%',
          'rr': '14'
        },
        {
          'time': '12:00 PM',
          'bp': '119/77',
          'pulse': '71',
          'temp': '98.7°F',
          'spo2': '98%',
          'rr': '15'
        },
        {
          'time': '04:00 PM',
          'bp': '117/75',
          'pulse': '69',
          'temp': '98.6°F',
          'spo2': '99%',
          'rr': '14'
        },
      ],
      'criticalNotes': [
        'Post-surgical site healing well.',
        'Pain controlled with medication.',
        'Physical therapy sessions ongoing.'
      ],
      'treatmentPlans': [
        'Continue pain management as needed.',
        'Daily physiotherapy sessions.',
        'Monitor for signs of infection.'
      ]
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
    // NEW: Get selected patient
    final selectedPatient = _patients.firstWhere(
      (patient) => patient['selected'] == true,
      orElse: () => _patients[1], // Default to Sarah Johnson if none selected
    );

    // NEW: Filter patients based on selected filter
    final filteredPatients = _patients.where((patient) {
      if (_selectedFilter == 'All') return true;
      return patient['status'] == _selectedFilter;
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header - Only showing "IPD Management"
        const SizedBox(height: 20),

        // Title Section
        const Text(
          'IPD Management',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3748),
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'In-patient department monitoring and care',
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF718096),
          ),
        ),
        const SizedBox(height: 20),

        // STATS CARDS SECTION
        _buildStatsCards(isMobile, isTablet),

        const SizedBox(height: 20),

        // Main Content Area
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Patient List (Left Column)
            Expanded(
              flex: isMobile ? 1 : 4,
              child: Container(
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
                    const Text(
                      'IPD Patients',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildFilterTabs(isMobile),
                    const SizedBox(height: 16),
                    // NEW: Use filtered patients list
                    ...filteredPatients.map((patient) {
                      return _patientTile(
                        patient['name'] as String,
                        patient['age'] as String,
                        patient['bed'] as String,
                        patient['ward'] as String,
                        patient['status'] as String,
                        patient['statusColor'] as Color,
                        patient['selected'] as bool,
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),

            if (!isMobile) const SizedBox(width: 20),

            // Patient Details (Right Column) - Hidden on mobile
            if (!isMobile)
              Expanded(
                flex: 6,
                child: Column(
                  children: [
                    // Patient Details Card
                    Container(
                      width: double.infinity,
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
                          Row(
                            children: [
                              Text(
                                selectedPatient['name'] as String,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2D3748),
                                ),
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color:
                                      selectedPatient['statusColor'] as Color,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  selectedPatient['status'] as String,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: _getStatusTextColor(
                                        selectedPatient['status'] as String),
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${selectedPatient['age']} Years • ${selectedPatient['gender']}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xFF718096),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _Info(
                                  label: 'Bed number',
                                  value: selectedPatient['bed'] as String),
                              _Info(
                                  label: 'Ward',
                                  value: selectedPatient['ward'] as String),
                              _Info(
                                  label: 'Admission Date',
                                  value: selectedPatient['admissionDate']
                                      as String),
                            ],
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Diagnosis',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF718096),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            selectedPatient['diagnosis'] as String,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2D3748),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Vital Monitoring Card
                    Container(
                      width: double.infinity,
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
                          // NEW: Tab Navigation
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedTab = 'Vital Monitoring';
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color:
                                            _selectedTab == 'Vital Monitoring'
                                                ? const Color(0xFF2383E2)
                                                : Colors.transparent,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    'Vital Monitoring',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: _selectedTab == 'Vital Monitoring'
                                          ? const Color(0xFF2383E2)
                                          : const Color(0xFF718096),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 24),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedTab = 'Critical Notes';
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: _selectedTab == 'Critical Notes'
                                            ? const Color(0xFF2383E2)
                                            : Colors.transparent,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    'Critical Notes',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: _selectedTab == 'Critical Notes'
                                          ? const Color(0xFF2383E2)
                                          : const Color(0xFF718096),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 24),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedTab = 'Treatment Plans';
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: _selectedTab == 'Treatment Plans'
                                            ? const Color(0xFF2383E2)
                                            : Colors.transparent,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    'Treatment Plans',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: _selectedTab == 'Treatment Plans'
                                          ? const Color(0xFF2383E2)
                                          : const Color(0xFF718096),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // NEW: Content based on selected tab
                          if (_selectedTab == 'Vital Monitoring') ...[
                            const Text(
                              'Vital Signs',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2D3748),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              width: double.infinity,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    minWidth:
                                        MediaQuery.of(context).size.width * 0.5,
                                  ),
                                  child: _buildVitalTable(
                                      selectedPatient['vitals']
                                          as List<Map<String, String>>),
                                ),
                              ),
                            ),
                          ] else if (_selectedTab == 'Critical Notes') ...[
                            const Text(
                              'Critical Notes',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2D3748),
                              ),
                            ),
                            const SizedBox(height: 16),
                            ...(selectedPatient['criticalNotes']
                                    as List<String>)
                                .map((note) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      margin: const EdgeInsets.only(
                                          top: 8, right: 12),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF2383E2),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        note,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Color(0xFF4A5568),
                                          height: 1.5,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ] else if (_selectedTab == 'Treatment Plans') ...[
                            const Text(
                              'Treatment Plans',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2D3748),
                              ),
                            ),
                            const SizedBox(height: 16),
                            ...(selectedPatient['treatmentPlans']
                                    as List<String>)
                                .map((plan) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      margin: const EdgeInsets.only(
                                          top: 8, right: 12),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF00B894),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        plan,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Color(0xFF4A5568),
                                          height: 1.5,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),

        // Mobile View - Patient Details (shown below on mobile)
        if (isMobile) ...[
          const SizedBox(height: 20),
          Container(
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
                  'Patient Details',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Text(
                      selectedPatient['name'] as String,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: selectedPatient['statusColor'] as Color,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        selectedPatient['status'] as String,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _getStatusTextColor(
                              selectedPatient['status'] as String),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '${selectedPatient['age']} Years • ${selectedPatient['gender']}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF718096),
                  ),
                ),
                const SizedBox(height: 16),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _Info(label: 'Bed number', value: 'B-205'),
                    _Info(label: 'Ward', value: 'General'),
                  ],
                ),
                const SizedBox(height: 12),
                const Row(
                  children: [
                    _Info(label: 'Admission Date', value: '2024-01-12'),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Diagnosis',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF718096),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Pneumonia',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 20),

                // Mobile Vital Signs
                const Text(
                  'Vital Signs',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: MediaQuery.of(context).size.width * 0.8,
                      ),
                      child: _buildVitalTable(selectedPatient['vitals']
                          as List<Map<String, String>>),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildStatsCards(bool isMobile, bool isTablet) {
    // NEW: Calculate stats from patient data
    final totalPatients = _patients.length;
    final stableCount = _patients.where((p) => p['status'] == 'Stable').length;
    final improvingCount =
        _patients.where((p) => p['status'] == 'Improving').length;
    final criticalCount =
        _patients.where((p) => p['status'] == 'Critical').length;

    final statsData = [
      {
        'title': 'Total Patients',
        'value': totalPatients.toString(),
        'gradient': const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF2C7EDB), Color(0xFFE1F0FF)],
        ),
        'image': 'assets/images/box1.png',
      },
      {
        'title': 'Stable',
        'value': stableCount.toString(),
        'gradient': const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF00B894), Color(0xFFE3FCFA)],
        ),
        'image': 'assets/images/box2.png',
      },
      {
        'title': 'Improving',
        'value': improvingCount.toString(),
        'gradient': const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF00C9C9), Color(0xFFDFFFFF)],
        ),
        'image': 'assets/images/box3.png',
      },
      {
        'title': 'Critical',
        'value': criticalCount.toString(),
        'gradient': const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF00B83B), Color(0xFFECFEEE)],
        ),
        'image': 'assets/images/box4.png',
      },
    ];

    if (isMobile) {
      return Column(
        children: statsData.map((stat) {
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: _buildStatCard(
              title: stat['title'] as String,
              value: stat['value'] as String,
              gradient: stat['gradient'] as Gradient,
              imagePath: stat['image'] as String,
              isMobile: true,
            ),
          );
        }).toList(),
      );
    }

    return Row(
      children: statsData.map((stat) {
        return Expanded(
          child: Container(
            margin: const EdgeInsets.only(right: 10),
            child: _buildStatCard(
              title: stat['title'] as String,
              value: stat['value'] as String,
              gradient: stat['gradient'] as Gradient,
              imagePath: stat['image'] as String,
              isMobile: false,
            ),
          ),
        );
      }).toList(),
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
    if (imagePath.contains('box2')) return 'Stable';
    if (imagePath.contains('box3')) return 'Improving';
    if (imagePath.contains('box4')) return 'Critical';
    return 'Image';
  }

  Widget _buildFilterTabs(bool isMobile) {
    final filters = ['All', 'Stable', 'Critical', 'Improving'];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((filter) {
          return Container(
            margin: const EdgeInsets.only(right: 8),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _selectedFilter = filter;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _selectedFilter == filter
                    ? const Color(0xFF2383E2)
                    : const Color(0xFFF7FAFC),
                foregroundColor: _selectedFilter == filter
                    ? Colors.white
                    : const Color(0xFF718096),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: _selectedFilter == filter
                        ? const Color(0xFF2383E2)
                        : const Color(0xFFE2E8F0),
                  ),
                ),
                elevation: 0,
                minimumSize: const Size(0, 36),
              ),
              child: Text(
                filter,
                style: TextStyle(
                  fontSize: isMobile ? 12 : 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // NEW: Updated patientTile with click functionality
  Widget _patientTile(String name, String age, String bed, String ward,
      String status, Color statusColor, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          // Deselect all patients first
          for (var patient in _patients) {
            patient['selected'] = false;
          }
          // Find and select the clicked patient
          final patientIndex = _patients.indexWhere((p) => p['name'] == name);
          if (patientIndex != -1) {
            _patients[patientIndex]['selected'] = true;
          }
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE6F2FF) : const Color(0xFFF7FAFC),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color:
                isSelected ? const Color(0xFF2383E2) : const Color(0xFFE2E8F0),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFF2383E2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Age : $age years',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF718096),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Bed : $bed • Ward : $ward',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF718096),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                status,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: _getStatusTextColor(status),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Color _getStatusTextColor(String status) {
    switch (status) {
      case 'Stable':
        return const Color(0xFF2563EB);
      case 'Critical':
        return const Color(0xFFDC2626);
      case 'Improving':
        return const Color(0xFF16A34A);
      default:
        return const Color(0xFF4B5563);
    }
  }

  // NEW: Updated vital table to accept data parameter
  Widget _buildVitalTable(List<Map<String, String>> vitals) {
    return DataTable(
      columnSpacing: 60,
      headingRowHeight: 48,
      headingRowColor: MaterialStateProperty.all(const Color(0xFFF7FAFC)),
      headingTextStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Color(0xFF4A5568),
      ),
      dataRowHeight: 44,
      columns: const [
        DataColumn(label: Text('Time')),
        DataColumn(label: Text('BP')),
        DataColumn(label: Text('Pulse')),
        DataColumn(label: Text('Temp')),
        DataColumn(label: Text('SpO2')),
        DataColumn(label: Text('RR')),
      ],
      rows: vitals.map((vital) {
        return DataRow(cells: [
          DataCell(Text(vital['time']!, style: _tableTextStyle())),
          DataCell(Text(vital['bp']!, style: _tableTextStyle())),
          DataCell(Text(vital['pulse']!, style: _tableTextStyle())),
          DataCell(Text(vital['temp']!, style: _tableTextStyle())),
          DataCell(Text(vital['spo2']!, style: _tableTextStyle())),
          DataCell(Text(vital['rr']!, style: _tableTextStyle())),
        ]);
      }).toList(),
    );
  }

  TextStyle _tableTextStyle() {
    return const TextStyle(
      fontSize: 14,
      color: Color(0xFF4A5568),
      fontWeight: FontWeight.w500,
    );
  }
}

class _Info extends StatelessWidget {
  final String label;
  final String value;

  const _Info({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF718096),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D3748),
          ),
        ),
      ],
    );
  }
}
