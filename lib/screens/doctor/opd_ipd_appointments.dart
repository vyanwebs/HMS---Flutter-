import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/assigned_patients_controllers.dart';
import '../../models/patient_model.dart';
import '../../models/teleconsultation_queue_model.dart';
import '../../utils/buttons.dart';
import '../../utils/constants.dart';
import '../../utils/date_formatter.dart';
import '../../utils/enums.dart';
import '../../utils/text.dart';
import '../../widgets/custom_table_widget.dart';
import '../../widgets/doctor_panel/stat_card_widget.dart';

class OpdIpdAppointments extends StatefulWidget {
  const OpdIpdAppointments({super.key});

  @override
  State<OpdIpdAppointments> createState() => _OpdIpdAppointmentsState();
}

class _OpdIpdAppointmentsState extends State<OpdIpdAppointments> {

  final assignedPatientsControllers = Get.put(AssignedPatientsControllers());
  // Sample patient data
  final List<Map<String, dynamic>> _patients = [
    {
      'time': '9.00 a.m.',
      'name': 'John Smith',
      'id': 'PAT123',
      'age': '21 years',
      'gender': 'Male',
    },
    {
      'time': '10.00 a.m.',
      'name': 'Sarah Johnson',
      'id': 'PAT124',
      'age': '35 years',
      'gender': 'Female',
    },
    {
      'time': '11.00 a.m.',
      'name': 'Michael Brown',
      'id': 'PAT125',
      'age': '28 years',
      'gender': 'Male',
    },
    {
      'time': '12.00 p.m.',
      'name': 'Emily Davis',
      'id': 'PAT126',
      'age': '45 years',
      'gender': 'Female',
    },
    {
      'time': '2.00 p.m.',
      'name': 'Robert Wilson',
      'id': 'PAT127',
      'age': '32 years',
      'gender': 'Male',
    },
    {
      'time': '3.00 p.m.',
      'name': 'Lisa Anderson',
      'id': 'PAT128',
      'age': '29 years',
      'gender': 'Female',
    },
    {
      'time': '4.00 p.m.',
      'name': 'David Miller',
      'id': 'PAT129',
      'age': '38 years',
      'gender': 'Male',
    },
    {
      'time': '5.00 p.m.',
      'name': 'Jennifer Walker',
      'id': 'PAT130',
      'age': '42 years',
      'gender': 'Female',
    },
    {
      'time': '6.00 p.m.',
      'name': 'William Lee',
      'id': 'PAT131',
      'age': '51 years',
      'gender': 'Male',
    },
    {
      'time': '7.00 p.m.',
      'name': 'Maria Garcia',
      'id': 'PAT132',
      'age': '33 years',
      'gender': 'Female',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    final isTablet = screenWidth >= 768 && screenWidth < 1024;

    return Obx(
      () => Visibility(
        replacement: const Center(child: CircularProgressIndicator(color: AppColors.info,)),
        visible: !assignedPatientsControllers.isLoading.value,
        child: DefaultTabController(
          length: 3,
          animationDuration: const Duration(milliseconds: 800),
          child: Scaffold(
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
          ),
        ),
      )
    );
  }

  Widget _buildMainContent(bool isMobile, bool isTablet) {
    return Container(
      color: const Color(0xFFF7FAFC),
      child: Column(
        children: [
          // Main Content
          Expanded(
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
          const AppText(
            'DOCTOR PANEL >> Assigned Patients',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF718096),
          ),

        if (isMobile)
          const Text(
            'Assigned Patients',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF718096),
            ),
          ),

        const SizedBox(height: 20),

        // STATS CARDS SECTION - Matching LabTestRequest size
        statCard(),

        const SizedBox(height: 20),

        // Patients List Section
        Expanded(
          child: Container(
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
                _buildTabs(),
                const SizedBox(height: 10,),
                Expanded(
                  child: TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      AppTable(
                        columns: columns,
                        rows: buildRows(PatientTabType.opd),
                      ),
                      AppTable(
                        columns: columns,
                        rows: buildRows(PatientTabType.ipd),
                      ),
                      AppTable(
                        columns: columns,
                        rows: buildRows(PatientTabType.teleconsultation),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabs() {
    return const TabBar(
      isScrollable: true,
      indicatorColor: Color(0xFF3182CE),
      indicatorWeight: 3,
      labelColor: Color(0xFF3182CE),
      unselectedLabelColor: Color(0xFF4A5568),
      labelStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      tabs: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Tab(text: 'Total OPD patients'),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Tab(text: 'Active IPD patients'),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Tab(text: 'Teleconsultation'),
        ),
      ],
    );
  }


  List<Widget> _cards() {
    return [
      StatCardWidget(
        title: "Today's Appointments",
        value: assignedPatientsControllers.todaysAppointments.value.toString(),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF2C7EDB), Color(0xFFE1F0FF)],
        ),
        imagePath: 'assets/images/box1.png',
      ),
      StatCardWidget(
        title: 'Total OPD Patients',
        value: assignedPatientsControllers.totalOPDPatients.value.toString(),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF00B894), Color(0xFFE3FCFA)],
        ),
        imagePath: 'assets/images/box2.png',
      ),
      StatCardWidget(
        title: 'Active IPD patients',
        value: assignedPatientsControllers.activeIPDPatients.value.toString(),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF00C9C9), Color(0xFFDFFFFF)],
        ),
        imagePath: 'assets/images/box3.png',
      ),
      StatCardWidget(
        title: 'Teleconsultation',
        value: assignedPatientsControllers.teleconsultation.value.toString(),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF00B83B), Color(0xFFECFEEE)],
        ),
        imagePath: 'assets/images/box4.png',
      ),
    ];
  }

  Widget statCard() {
    return Row(
      children: _cards().map(
        (card) => Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: card,
          ),
        )
      ).toList(),
    );
  }

  final columns = [
    AppTableColumn(title: 'Time', flex: 1.2),
    AppTableColumn(title: 'Patient', flex: 3),
    AppTableColumn(title: 'Details', flex: 2),
    AppTableColumn(title: 'Action', flex: 3),
  ];

  List<TableRow> buildRows(PatientTabType tabType) {
    final controller = assignedPatientsControllers;

    switch (tabType) {
      case PatientTabType.opd:
        return _buildPatientRows(controller.opdPatients, tabType);

      case PatientTabType.ipd:
        return _buildPatientRows(controller.ipdPatients, tabType);

      case PatientTabType.teleconsultation:
        return _buildTeleRows(controller.telePatients);
    }
  }

  List<TableRow> _buildPatientRows(
    List<PatientModel> patients,
    PatientTabType tabType,
  ) {
    if (patients.isEmpty) {
      return [_emptyRow()];
    }

    return patients.map((patient) {
      return TableRow(
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
        ),
        children: [
          /// Time
          _cell(Text(timeFromDateTime(patient.registeredAt))),

          /// Patient
          _cell(Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.blue.withValues(alpha: 0.2),
                child: Text(patient.initials),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(patient.name, fontWeight: FontWeight.w600),
                  AppText('ID: ${patient.patientId}', color: Colors.grey),
                ],
              ),
            ],
          )),

          /// Details
          _cell(Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${patient.age} years'),
              Text(patient.gender, style: const TextStyle(color: Colors.grey)),
            ],
          )),

          /// Actions
          _cell(_buildActions(patient, tabType)),
        ],
      );
    }).toList();
  }

  List<TableRow> _buildTeleRows(List<TeleconsultationQueueModel> patients) {
    if (patients.isEmpty) {
      return [_emptyRow()];
    }

    return patients.map((tele) {
      return TableRow(
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
        ),
        children: [
          _cell(Text(timeFromDateTime(tele.createdAt))),

          _cell(AppText(
            tele.patientName,
            fontWeight: FontWeight.w600,
          )),

          _cell(AppText(tele.reason)),

          _cell(Row(
            children: [
              AppButton(
                text: 'Accept',
                icon: Icons.check,
                backgroundColor: AppColors.info,
                onPressed: () {},
              ),
              const SizedBox(width: 10),
              AppButton(
                text: 'Reject',
                icon: Icons.cancel_outlined,
                backgroundColor: AppColors.error,
                onPressed: () {},
              ),
            ],
          )),
        ],
      );
    }).toList();
  }

  TableRow _emptyRow() {
    return TableRow(
      children: List.generate(
        columns.length,
        (_) => const Padding(
          padding: EdgeInsets.all(20),
          child: Center(child: Text('No patients found')),
        ),
      ),
    );
  }

  Widget _cell(Widget child) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: child,
    );
  }

  Widget _buildActions(PatientModel patient, PatientTabType tabType) {
    switch (tabType) {
      case PatientTabType.opd:
        return Row(
          children: [
            AppButton(
              onPressed: () {
                assignedPatientsControllers.makeAdmitRequest(patientMongoId: patient.id);
              },
              text: 'Admit',
              icon: Icons.arrow_forward,
              backgroundColor: Colors.greenAccent,
            ),
            const SizedBox(width: 10),
            AppButton(
              onPressed: () {
                assignedPatientsControllers.makeDischargeRequest(patientMongoId: patient.id);
              },
              text: 'Discharge',
              icon: Icons.arrow_back,
              backgroundColor: AppColors.info,
            ),
          ],
        );

      case PatientTabType.ipd:
        return Row(
          children: [
            AppButton(
              onPressed: () {
                assignedPatientsControllers.makeDischargeRequest(patientMongoId: patient.id);
              },
              text: 'Discharge',
              icon: Icons.arrow_back,
              backgroundColor: AppColors.info,
            ),
          ],
        );

      case PatientTabType.teleconsultation:
        return Row(
          children: [
            AppButton(
              onPressed: () {

              },
              text: 'Accept',
              icon: Icons.check,
              backgroundColor: AppColors.info,
            ),
            const SizedBox(width: 10),
            AppButton(
              onPressed: () {
                
              },
              text: 'Reject',
              icon: Icons.cancel_outlined,
              backgroundColor: AppColors.error,
            ),
          ],
        );
    }
  }

  Widget _buildMobilePatientsList() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: _patients.map((patient) {
          return Container(
            margin: const EdgeInsets.only(bottom: 16), // Increased margin
            padding: const EdgeInsets.all(16), // Increased padding
            decoration: BoxDecoration(
              color: const Color(0xFFF7FAFC),
              borderRadius: BorderRadius.circular(10), // Increased radius
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
                        patient['name'],
                        style: const TextStyle(
                          fontSize: 16, // Increased font
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D3748),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      patient['time'],
                      style: const TextStyle(
                        fontSize: 14, // Increased font
                        color: Color(0xFF718096),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16), // Increased spacing
                Row(
                  children: [
                    Container(
                      width: 42, // Increased size
                      height: 42, // Increased size
                      decoration: BoxDecoration(
                        color: const Color(0xFF2383E2),
                        borderRadius:
                            BorderRadius.circular(10), // Increased radius
                      ),
                      child: Center(
                        child: Text(
                          patient['name'][0],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18, // Increased font
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16), // Increased spacing
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'ID: ${patient['id']}',
                            style: const TextStyle(
                              fontSize: 14, // Increased font
                              color: Color(0xFF718096),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6), // Increased spacing
                          Text(
                            'Age: ${patient['age']}',
                            style: const TextStyle(
                              fontSize: 14, // Increased font
                              color: const Color(0xFF718096),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6), // Increased spacing
                          Text(
                            'Gender: ${patient['gender']}',
                            style: const TextStyle(
                              fontSize: 14, // Increased font
                              color: const Color(0xFF718096),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16), // Increased spacing
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Admit Button
                      Expanded(
                        child: Container(
                          height: 32, // Increased height
                          margin: const EdgeInsets.only(
                              right: 8), // Increased margin
                          child: ElevatedButton(
                            onPressed: () => _admitPatient(patient),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF73F181),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12, // Increased padding
                                vertical: 8, // Increased padding
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    8), // Increased radius
                              ),
                              elevation: 0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.add,
                                  size: 16, // Increased size
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 6), // Increased spacing
                                const Text(
                                  'Admit',
                                  style: TextStyle(
                                    fontSize: 14, // Increased font
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Discharge Button
                      Expanded(
                        child: Container(
                          height: 32, // Increased height
                          child: ElevatedButton(
                            onPressed: () => _dischargePatient(patient),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF5EBFFF),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12, // Increased padding
                                vertical: 8, // Increased padding
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    8), // Increased radius
                              ),
                              elevation: 0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.exit_to_app,
                                  size: 16, // Increased size
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 6), // Increased spacing
                                const Text(
                                  'Discharge',
                                  style: TextStyle(
                                    fontSize: 14, // Increased font
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
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

  void _admitPatient(Map<String, dynamic> patient) {
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
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: const Color(0xFF73F181).withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.add,
                    color: Color(0xFF73F181),
                    size: 28,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Admit Patient',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  patient['name'],
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF4A5568),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'ID: ${patient['id']}',
                  style: const TextStyle(
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
                          side: const BorderSide(color: Color(0xFFE2E8F0)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
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
                                  Text('Patient ${patient['name']} admitted'),
                              backgroundColor: const Color(0xFF73F181),
                              duration: const Duration(seconds: 2),
                              behavior: SnackBarBehavior.floating,
                              margin: const EdgeInsets.all(16),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF73F181),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: const Text(
                          'Admit',
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
        ),
      ),
    );
  }

  void _dischargePatient(Map<String, dynamic> patient) {
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
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: const Color(0xFF5EBFFF).withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.exit_to_app,
                    color: Color(0xFF5EBFFF),
                    size: 28,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Discharge Patient',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  patient['name'],
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF4A5568),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'ID: ${patient['id']}',
                  style: const TextStyle(
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
                          side: const BorderSide(color: Color(0xFFE2E8F0)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
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
                                  Text('Patient ${patient['name']} discharged'),
                              backgroundColor: const Color(0xFF5EBFFF),
                              duration: const Duration(seconds: 2),
                              behavior: SnackBarBehavior.floating,
                              margin: const EdgeInsets.all(16),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF5EBFFF),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: const Text(
                          'Discharge',
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
        ),
      ),
    );
  }
}
