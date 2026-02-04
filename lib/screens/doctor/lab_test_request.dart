import 'package:flutter/material.dart';
import 'package:hms/utils/constants.dart';

class LabTestRequest extends StatefulWidget {
  const LabTestRequest({super.key});

  @override
  State<LabTestRequest> createState() => _LabTestRequestState();
}

class _LabTestRequestState extends State<LabTestRequest> {
  String _selectedFilter = 'All';
  String _selectedPriority = 'All';
  String _selectedStatus = 'All';
  final TextEditingController _searchController = TextEditingController();
  final List<Map<String, dynamic>> _testRequests = [
    {
      'testName': 'Lipid Profile',
      'category': 'Hematology',
      'patient': 'John Smith',
      'date': '12/01/2025',
      'priority': 'Urgent',
      'status': 'Completed',
    },
    {
      'testName': 'Blood Glucose',
      'category': 'Biochemistry',
      'patient': 'Sarah Johnson',
      'date': '11/01/2025',
      'priority': 'Routine',
      'status': 'Completed',
    },
    {
      'testName': 'CBC',
      'category': 'Hematology',
      'patient': 'Michael Brown',
      'date': '13/01/2025',
      'priority': 'Routine',
      'status': 'Completed',
    },
    {
      'testName': 'Liver Function',
      'category': 'Biochemistry',
      'patient': 'Emily Davis',
      'date': '10/01/2025',
      'priority': 'Urgent',
      'status': 'Waiting',
    },
    {
      'testName': 'Thyroid Profile',
      'category': 'Endocrinology',
      'patient': 'Robert Wilson',
      'date': '14/01/2025',
      'priority': 'Routine',
      'status': 'Completed',
    },
    {
      'testName': 'Urine Analysis',
      'category': 'Pathology',
      'patient': 'Lisa Anderson',
      'date': '09/01/2025',
      'priority': 'Routine',
      'status': 'Completed',
    },
    {
      'testName': 'Kidney Function',
      'category': 'Nephrology',
      'patient': 'David Miller',
      'date': '15/01/2025',
      'priority': 'Routine',
      'status': 'Completed',
    },
    {
      'testName': 'HbA1c Test',
      'category': 'Endocrinology',
      'patient': 'James Taylor',
      'date': '16/01/2025',
      'priority': 'Routine',
      'status': 'Completed',
    },
    {
      'testName': 'Vitamin D',
      'category': 'Biochemistry',
      'patient': 'Maria Garcia',
      'date': '17/01/2025',
      'priority': 'Routine',
      'status': 'Waiting',
    },
    {
      'testName': 'Cardiac Enzymes',
      'category': 'Cardiology',
      'patient': 'William Lee',
      'date': '18/01/2025',
      'priority': 'Urgent',
      'status': 'Completed',
    },
    {
      'testName': 'PSA Test',
      'category': 'Urology',
      'patient': 'Richard Clark',
      'date': '19/01/2025',
      'priority': 'Routine',
      'status': 'Completed',
    },
    {
      'testName': 'Stool Culture',
      'category': 'Microbiology',
      'patient': 'Patricia Lewis',
      'date': '20/01/2025',
      'priority': 'Routine',
      'status': 'Waiting',
    },
    {
      'testName': 'Pregnancy Test',
      'category': 'Obstetrics',
      'patient': 'Jennifer Walker',
      'date': '21/01/2025',
      'priority': 'Routine',
      'status': 'Completed',
    },
    {
      'testName': 'HIV Test',
      'category': 'Immunology',
      'patient': 'Thomas Hall',
      'date': '22/01/2025',
      'priority': 'Urgent',
      'status': 'Completed',
    },
    {
      'testName': 'Allergy Panel',
      'category': 'Immunology',
      'patient': 'Susan Young',
      'date': '23/01/2025',
      'priority': 'Routine',
      'status': 'Completed',
    },
    {
      'testName': 'Cortisol Test',
      'category': 'Endocrinology',
      'patient': 'Charles King',
      'date': '24/01/2025',
      'priority': 'Routine',
      'status': 'Waiting',
    },
    {
      'testName': 'Coagulation Profile',
      'category': 'Hematology',
      'patient': 'Jessica Wright',
      'date': '25/01/2025',
      'priority': 'Urgent',
      'status': 'Completed',
    },
    {
      'testName': 'Sputum Culture',
      'category': 'Microbiology',
      'patient': 'Daniel Scott',
      'date': '26/01/2025',
      'priority': 'Routine',
      'status': 'Completed',
    },
    {
      'testName': 'Bone Profile',
      'category': 'Rheumatology',
      'patient': 'Karen Green',
      'date': '27/01/2025',
      'priority': 'Routine',
      'status': 'Completed',
    },
    {
      'testName': 'Iron Studies',
      'category': 'Hematology',
      'patient': 'Paul Adams',
      'date': '28/01/2025',
      'priority': 'Routine',
      'status': 'Waiting',
    },
    {
      'testName': 'Lipase Test',
      'category': 'Gastroenterology',
      'patient': 'Nancy Baker',
      'date': '29/01/2025',
      'priority': 'Urgent',
      'status': 'Completed',
    },
    {
      'testName': 'CRP Test',
      'category': 'Immunology',
      'patient': 'Mark Carter',
      'date': '30/01/2025',
      'priority': 'Routine',
      'status': 'Completed',
    },
    {
      'testName': 'Prolactin Test',
      'category': 'Endocrinology',
      'patient': 'Laura Phillips',
      'date': '31/01/2025',
      'priority': 'Routine',
      'status': 'Completed',
    },
    {
      'testName': 'Amylase Test',
      'category': 'Gastroenterology',
      'patient': 'Steven Evans',
      'date': '01/02/2025',
      'priority': 'Routine',
      'status': 'Waiting',
    },
    {
      'testName': 'Tumor Markers',
      'category': 'Oncology',
      'patient': 'Donna Turner',
      'date': '02/02/2025',
      'priority': 'Urgent',
      'status': 'Completed',
    },
    {
      'testName': 'Drug Screening',
      'category': 'Toxicology',
      'patient': 'Kevin Parker',
      'date': '03/02/2025',
      'priority': 'Routine',
      'status': 'Completed',
    },
    {
      'testName': 'CSF Analysis',
      'category': 'Neurology',
      'patient': 'Amanda Collins',
      'date': '04/02/2025',
      'priority': 'Urgent',
      'status': 'Completed',
    },
  ];

  List<Map<String, dynamic>> get _filteredRequests {
    return _testRequests.where((request) {
      bool filterMatch =
          _selectedFilter == 'All' || request['testName'] == _selectedFilter;
      bool priorityMatch = _selectedPriority == 'All' ||
          request['priority'] == _selectedPriority;
      bool statusMatch =
          _selectedStatus == 'All' || request['status'] == _selectedStatus;
      bool searchMatch = _searchController.text.isEmpty ||
          request['testName']
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()) ||
          request['patient']
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()) ||
          request['category']
              .toLowerCase()
              .contains(_searchController.text.toLowerCase());
      return filterMatch && priorityMatch && statusMatch && searchMatch;
    }).toList();
  }

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
          // Main Content
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
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
        // Header with breadcrumb
        if (!isMobile)
          const Text(
            'LAB Results',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF718096),
            ),
          ),

        if (isMobile)
          const Text(
            'LAB TEST REQUEST',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF718096),
            ),
          ),

        const SizedBox(height: 20),

        // STATS CARDS SECTION
        _buildStatsCards(isMobile, isTablet),

        const SizedBox(height: 20),

        // Test Request Management Section
        Container(
          width: double.infinity,
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
              Text(
                'Test Requests',
                style: TextStyle(
                  fontSize: isMobile ? 16 : 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2D3748),
                ),
              ),
              const SizedBox(height: 16),

              // Search and Filter Row - ALL IN ONE ROW
              _buildSearchFilterRow(isMobile, isTablet),
              const SizedBox(height: 20),

              // Test Requests List/Table
              if (isMobile)
                _buildMobileTestRequestsList()
              else
                _buildDesktopTestRequestsTable(isTablet),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSearchFilterRow(bool isMobile, bool isTablet) {
    if (isMobile) {
      return Column(
        children: [
          // Search Bar (larger for mobile)
          Container(
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFF7FAFC),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              children: [
                const SizedBox(width: 12),
                const Icon(Icons.search, size: 20, color: Color(0xFF718096)),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search',
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Color(0xFFA0AEC0)),
                      contentPadding: EdgeInsets.zero,
                    ),
                    style: const TextStyle(
                      fontSize: 14,
                      color: const Color(0xFF2D3748),
                    ),
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Filter dropdowns in a row for mobile
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterDropdown('All', _selectedFilter, (value) {
                  setState(() {
                    _selectedFilter = value!;
                  });
                }, [
                  'All',
                  'Lipid Profile',
                  'Blood Glucose',
                  'CBC',
                  'Liver Function',
                  'Thyroid Profile',
                  'Urine Analysis',
                  'Kidney Function',
                  'HbA1c Test',
                  'Vitamin D',
                  'Cardiac Enzymes'
                ], isMobile),
                const SizedBox(width: 8),
                _buildFilterDropdown('Priority', _selectedPriority, (value) {
                  setState(() {
                    _selectedPriority = value!;
                  });
                }, ['All', 'Urgent', 'Routine'], isMobile),
                const SizedBox(width: 8),
                _buildFilterDropdown('Status', _selectedStatus, (value) {
                  setState(() {
                    _selectedStatus = value!;
                  });
                }, ['All', 'Completed', 'Waiting'], isMobile),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Action Buttons for mobile
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    _showAddTestRequestForm();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2383E2),
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  icon: const Icon(
                    Icons.add,
                    size: 16,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Request new test',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    _deleteSelectedTests();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF56565),
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  icon: const Icon(
                    Icons.delete_outline,
                    size: 16,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Delete',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    } else {
      // Desktop/Tablet layout
      return Column(
        children: [
          Row(
            children: [
              // Search Bar (larger size)
              Expanded(
                flex: 2,
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7FAFC),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 12),
                      const Icon(Icons.search,
                          size: 20, color: Color(0xFF718096)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: const InputDecoration(
                            hintText: 'Search',
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: Color(0xFFA0AEC0)),
                            contentPadding: EdgeInsets.zero,
                          ),
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF2D3748),
                          ),
                          onChanged: (value) {
                            setState(() {});
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Filter dropdowns
              Expanded(
                child: _buildFilterDropdown('All', _selectedFilter, (value) {
                  setState(() {
                    _selectedFilter = value!;
                  });
                }, [
                  'All',
                  'Lipid Profile',
                  'Blood Glucose',
                  'CBC',
                  'Liver Function',
                  'Thyroid Profile',
                  'Urine Analysis',
                  'Kidney Function',
                  'HbA1c Test',
                  'Vitamin D',
                  'Cardiac Enzymes'
                ], isMobile),
              ),
              const SizedBox(width: 12),

              Expanded(
                child: _buildFilterDropdown('Priority', _selectedPriority,
                    (value) {
                  setState(() {
                    _selectedPriority = value!;
                  });
                }, ['All', 'Urgent', 'Routine'], isMobile),
              ),
              const SizedBox(width: 12),

              Expanded(
                child: _buildFilterDropdown('Status', _selectedStatus, (value) {
                  setState(() {
                    _selectedStatus = value!;
                  });
                }, ['All', 'Completed', 'Waiting'], isMobile),
              ),
              const SizedBox(width: 12),

              // Action Buttons
              SizedBox(
                width: isTablet ? 140 : 160,
                child: ElevatedButton.icon(
                  onPressed: () {
                    _showAddTestRequestForm();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2383E2),
                    padding: EdgeInsets.symmetric(
                      horizontal: isTablet ? 12 : 16,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  icon: const Icon(
                    Icons.add,
                    size: 16,
                    color: Colors.white,
                  ),
                  label: Text(
                    'Request new test',
                    style: TextStyle(
                      fontSize: isTablet ? 11 : 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              SizedBox(
                width: isTablet ? 100 : 120,
                child: ElevatedButton.icon(
                  onPressed: () {
                    _deleteSelectedTests();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF56565),
                    padding: EdgeInsets.symmetric(
                      horizontal: isTablet ? 12 : 16,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  icon: const Icon(
                    Icons.delete_outline,
                    size: 16,
                    color: Colors.white,
                  ),
                  label: Text(
                    'Delete',
                    style: TextStyle(
                      fontSize: isTablet ? 11 : 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    }
  }

  Widget _buildFilterDropdown(
    String hint,
    String value,
    Function(String?) onChanged,
    List<String> items,
    bool isMobile,
  ) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAFC),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButton<String>(
        value: value,
        icon: const Icon(Icons.arrow_drop_down,
            size: 20, color: Color(0xFF718096)),
        iconSize: 16,
        elevation: 16,
        style: TextStyle(
          fontSize: isMobile ? 12 : 13,
          color: const Color(0xFF2D3748),
        ),
        underline: const SizedBox(),
        isExpanded: true,
        onChanged: onChanged,
        items: items.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              overflow: TextOverflow.ellipsis,
            ),
          );
        }).toList(),
        hint: Text(
          hint,
          style: TextStyle(
            fontSize: isMobile ? 12 : 13,
            color: const Color(0xFF718096),
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Widget _buildDesktopTestRequestsTable(bool isTablet) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Container(
        width: double.infinity,
        child: DataTable(
          columnSpacing: isTablet ? 12.0 : 16.0,
          headingRowHeight: 40,
          headingRowColor: MaterialStateProperty.all(const Color(0xFFF7FAFC)),
          headingTextStyle: TextStyle(
            fontSize: isTablet ? 12 : 13,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF4A5568),
          ),
          dataRowHeight: 50,
          columns: [
            DataColumn(
              label: Container(
                width: isTablet ? 120 : 140,
                child: const Text('Test name', overflow: TextOverflow.ellipsis),
              ),
            ),
            DataColumn(
              label: Container(
                width: isTablet ? 100 : 120,
                child: const Text('Category', overflow: TextOverflow.ellipsis),
              ),
            ),
            DataColumn(
              label: Container(
                width: isTablet ? 100 : 120,
                child: const Text('Patient', overflow: TextOverflow.ellipsis),
              ),
            ),
            DataColumn(
              label: Container(
                width: isTablet ? 80 : 90,
                child: const Text('Date', overflow: TextOverflow.ellipsis),
              ),
            ),
            DataColumn(
              label: Container(
                width: isTablet ? 80 : 90,
                child: const Text('Priority', overflow: TextOverflow.ellipsis),
              ),
            ),
            DataColumn(
              label: Container(
                width: isTablet ? 80 : 90,
                child: const Text('Status', overflow: TextOverflow.ellipsis),
              ),
            ),
            DataColumn(
              label: Container(
                width: isTablet ? 140 : 160,
                child: const Text('Actions', overflow: TextOverflow.ellipsis),
              ),
            ),
          ],
          rows: _filteredRequests.map((request) {
            return DataRow(
              cells: [
                DataCell(
                  Container(
                    width: isTablet ? 120 : 140,
                    child: Text(
                      request['testName'],
                      style: TextStyle(
                        fontSize: isTablet ? 12 : 13,
                        color: const Color(0xFF2D3748),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                DataCell(
                  Container(
                    width: isTablet ? 100 : 120,
                    child: Text(
                      request['category'],
                      style: TextStyle(
                        fontSize: isTablet ? 12 : 13,
                        color: const Color(0xFF2D3748),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                DataCell(
                  Container(
                    width: isTablet ? 100 : 120,
                    child: Text(
                      request['patient'],
                      style: TextStyle(
                        fontSize: isTablet ? 12 : 13,
                        color: const Color(0xFF2D3748),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                DataCell(
                  Container(
                    width: isTablet ? 80 : 90,
                    child: Text(
                      request['date'],
                      style: TextStyle(
                        fontSize: isTablet ? 12 : 13,
                        color: const Color(0xFF718096),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                DataCell(
                  Container(
                    width: isTablet ? 80 : 90,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: _getPriorityColor(request['priority'])
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        request['priority'],
                        style: TextStyle(
                          fontSize: isTablet ? 10 : 11,
                          color: _getPriorityColor(request['priority']),
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
                DataCell(
                  Container(
                    width: isTablet ? 80 : 90,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color:
                            _getStatusColor(request['status']).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        request['status'],
                        style: TextStyle(
                          fontSize: isTablet ? 10 : 11,
                          color: _getStatusColor(request['status']),
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
                DataCell(
                  Container(
                    width: isTablet ? 140 : 160,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // View Button - Icon only
                        Container(
                          height: 26,
                          margin: const EdgeInsets.only(right: 4),
                          child: IconButton(
                            onPressed: () => _viewTestRequest(request),
                            icon: Icon(
                              Icons.visibility,
                              size: 14,
                              color: const Color(0xFF38A169),
                            ),
                            style: IconButton.styleFrom(
                              padding: const EdgeInsets.all(5),
                              backgroundColor:
                                  const Color(0xFF38A169).withValues(alpha: 0.1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                                side: BorderSide(
                                  color:
                                      const Color(0xFF38A169).withValues(alpha: 0.3),
                                  width: 1,
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Download Button - Icon only
                        Container(
                          height: 26,
                          margin: const EdgeInsets.only(right: 4),
                          child: IconButton(
                            onPressed: () => _downloadTestReport(request),
                            icon: Icon(
                              Icons.download,
                              size: 14,
                              color: const Color(0xFF2383E2),
                            ),
                            style: IconButton.styleFrom(
                              padding: const EdgeInsets.all(5),
                              backgroundColor:
                                  const Color(0xFF2383E2).withValues(alpha: 0.1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                                side: BorderSide(
                                  color:
                                      const Color(0xFF2383E2).withValues(alpha: 0.3),
                                  width: 1,
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Call Button - Icon only
                        Container(
                          height: 26,
                          child: IconButton(
                            onPressed: () => _callPatient(request),
                            icon: Icon(
                              Icons.call,
                              size: 14,
                              color: const Color(0xFFED8936),
                            ),
                            style: IconButton.styleFrom(
                              padding: const EdgeInsets.all(5),
                              backgroundColor:
                                  const Color(0xFFED8936).withValues(alpha: 0.1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                                side: BorderSide(
                                  color:
                                      const Color(0xFFED8936).withValues(alpha: 0.3),
                                  width: 1,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildMobileTestRequestsList() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: _filteredRequests.map((request) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF7FAFC),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        request['testName'],
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D3748),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color:
                            _getStatusColor(request['status']).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        request['status'],
                        style: TextStyle(
                          fontSize: 10,
                          color: _getStatusColor(request['status']),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Category: ${request['category']}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF718096),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Patient: ${request['patient']}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF718096),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Date: ${request['date']}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF718096),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getPriorityColor(request['priority'])
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        request['priority'],
                        style: TextStyle(
                          fontSize: 10,
                          color: _getPriorityColor(request['priority']),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // View Button
                      Container(
                        height: 28,
                        margin: const EdgeInsets.only(right: 8),
                        child: IconButton(
                          onPressed: () => _viewTestRequest(request),
                          icon: const Icon(
                            Icons.visibility,
                            size: 14,
                            color: Color(0xFF38A169),
                          ),
                          style: IconButton.styleFrom(
                            padding: const EdgeInsets.all(6),
                            backgroundColor:
                                const Color(0xFF38A169).withValues(alpha: 0.1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                              side: BorderSide(
                                color: const Color(0xFF38A169).withValues(alpha: 0.3),
                                width: 1,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Download Button
                      Container(
                        height: 28,
                        margin: const EdgeInsets.only(right: 8),
                        child: IconButton(
                          onPressed: () => _downloadTestReport(request),
                          icon: const Icon(
                            Icons.download,
                            size: 14,
                            color: Color(0xFF2383E2),
                          ),
                          style: IconButton.styleFrom(
                            padding: const EdgeInsets.all(6),
                            backgroundColor:
                                const Color(0xFF2383E2).withValues(alpha: 0.1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                              side: BorderSide(
                                color: const Color(0xFF2383E2).withValues(alpha: 0.3),
                                width: 1,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Call Button
                      Container(
                        height: 28,
                        child: IconButton(
                          onPressed: () => _callPatient(request),
                          icon: const Icon(
                            Icons.call,
                            size: 14,
                            color: Color(0xFFED8936),
                          ),
                          style: IconButton.styleFrom(
                            padding: const EdgeInsets.all(6),
                            backgroundColor:
                                const Color(0xFFED8936).withValues(alpha: 0.1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                              side: BorderSide(
                                color: const Color(0xFFED8936).withValues(alpha: 0.3),
                                width: 1,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'Urgent':
        return const Color(0xFFF56565);
      case 'Routine':
        return const Color(0xFF38A169);
      default:
        return const Color(0xFF718096);
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Completed':
        return const Color(0xFF38A169);
      case 'Waiting':
        return const Color(0xFFED8936);
      default:
        return const Color(0xFF718096);
    }
  }

  void _downloadTestReport(Map<String, dynamic> request) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Downloading report for ${request['testName']}'),
        backgroundColor: const Color(0xFF2383E2),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _callPatient(Map<String, dynamic> request) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 350),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFFED8936).withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.call,
                    color: Color(0xFFED8936),
                    size: 24,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Calling Patient',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  request['patient'],
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF4A5568),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Test: ${request['testName']}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF718096),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          side: const BorderSide(color: Color(0xFFE2E8F0)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF718096),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text('Call ended with ${request['patient']}'),
                              backgroundColor: const Color(0xFF38A169),
                              duration: const Duration(seconds: 2),
                              behavior: SnackBarBehavior.floating,
                              margin: const EdgeInsets.all(16),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFED8936),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: const Text(
                          'End Call',
                          style: TextStyle(
                            fontSize: 13,
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
        ),
      ),
    );
  }

  void _viewTestRequest(Map<String, dynamic> request) {
    showDialog(
      context: context,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Test Request Details',
                      style: TextStyle(
                        fontSize: 16,
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
                _buildDetailRow('Test Name:', request['testName']),
                _buildDetailRow('Category:', request['category']),
                _buildDetailRow('Patient:', request['patient']),
                _buildDetailRow('Date:', request['date']),
                _buildDetailRow('Priority:', request['priority']),
                _buildDetailRow('Status:', request['status']),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2383E2),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: const Text('Close'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF4A5568),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
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

  Widget _buildStatsCards(bool isMobile, bool isTablet) {
    final statsData = [
      {
        'title': 'Total Patients',
        'value': '27',
        'gradient': const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF2C7EDB), Color(0xFFE1F0FF)],
        ),
        'image': 'assets/images/box1.png',
      },
      {
        'title': 'Completed Tests',
        'value': '20',
        'gradient': const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF00B894), Color(0xFFE3FCFA)],
        ),
        'image': 'assets/images/box2.png',
      },
      {
        'title': 'Waiting Tests',
        'value': '7',
        'gradient': const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF00C9C9), Color(0xFFDFFFFF)],
        ),
        'image': 'assets/images/box3.png',
      },
      {
        'title': 'Cancelled Tests',
        'value': '0',
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
                // Value (24) at the top - Changed color to #000000
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF000000), // Changed to #000000
                  ),
                ),
                const SizedBox(height: 50),
                // Title text at the bottom - Changed color to #757575
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF757575), // Changed to #757575
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
    if (imagePath.contains('box1')) return 'Total Patients';
    if (imagePath.contains('box2')) return 'Completed Tests';
    if (imagePath.contains('box3')) return 'Waiting Tests';
    if (imagePath.contains('box4')) return 'Cancelled Tests';
    return 'Image';
  }

  void _deleteSelectedTests() {
    showDialog(
      context: context,
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
                const Icon(
                  Icons.warning,
                  size: 48,
                  color: Color(0xFFF56565),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Delete Multiple Tests',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'This will delete all selected test requests. This action cannot be undone.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF718096),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          side: const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Color(0xFF718096)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Multiple test requests deleted'),
                              backgroundColor: Color(0xFF38A169),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF56565),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: const Text('Delete All'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAddTestRequestForm() {
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
                    const Text(
                      'Add New Test Request',
                      style: TextStyle(
                        fontSize: 16,
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
                const SizedBox(height: 20),
                const Text(
                    'Add new test request form would be implemented here'),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          side: const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Color(0xFF718096)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('New test request added'),
                              backgroundColor: Color(0xFF38A169),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2383E2),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: const Text('Add Request'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}