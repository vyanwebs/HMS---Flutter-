import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hms/models/ipd_management_details_model.dart';

import '../../controllers/Doctor/ipd_management_controllers.dart';
import '../../models/avatar_model.dart';
import '../../utils/buttons.dart';
import '../../utils/date_formatter.dart';
import '../../utils/images.dart';
import '../../utils/string_utils.dart';
import '../../utils/text.dart';
import '../../widgets/doctor_panel/stat_card_widget.dart';

class IpdManagement extends StatelessWidget {
  IpdManagement({super.key});

  final ipdControllers = Get.put(IpdManagementControllers());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// ================= TOP STAT CARDS =================
              _topStatCards(),
              const SizedBox(height: 30),

              const AppText(
                "IPD Management",
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 6),
              const AppText(
                "In-patient department monitoring and care",
                color: Colors.black54,
              ),
              const SizedBox(height: 24),

              /// ================= MAIN SECTION =================
              Expanded(
                child: Row(
                  children: [

                    /// LEFT PANEL
                    Expanded(
                      flex: 3,
                      child: _patientListPanel(),
                    ),

                    const SizedBox(width: 24),

                    /// RIGHT PANEL
                    Expanded(
                      flex: 7,
                      child: _patientDetailsPanel(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =========================================================
  // TOP STAT CARDS
  // =========================================================

  Widget _topStatCards() {
    return Obx(() {
      return Row(
        children: [
          Expanded(
            child: StatCardWidget(
              title: "Total patients",
              value: ipdControllers.totalPatients.toString(),
              gradient: const LinearGradient(
                colors: [Color(0xFF2C7EDB), Color(0xFFE1F0FF)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              imagePath: "assets/images/box1.png",
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: StatCardWidget(
              title: "Stable",
              value: ipdControllers.stableCount.toString(),
              gradient: const LinearGradient(
                colors: [Color(0xFF00B894), Color(0xFFE3FCFA)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              imagePath: "assets/images/box2.png",
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: StatCardWidget(
              title: "Improving",
              value: ipdControllers.improvingCount.toString(),
              gradient: const LinearGradient(
                colors: [Color(0xFF00C9C9), Color(0xFFDFFFFF)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              imagePath: "assets/images/box3.png",
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: StatCardWidget(
              title: "Critical",
              value: ipdControllers.criticalCount.toString(),
              gradient: const LinearGradient(
                colors: [Color(0xFF00B83B), Color(0xFFECFEEE)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              imagePath: "assets/images/box4.png",
            ),
          ),
        ],
      );
    });
  }

  // =========================================================
  // LEFT PANEL - PATIENT LIST
  // =========================================================

  Widget _patientListPanel() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppText(
            "IPD Patients",
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          const SizedBox(height: 16),

          /// IMPORTANT → give height
          Expanded(
            child: Obx(() {
              if (ipdControllers.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (ipdControllers.patients.isEmpty) {
                return const Center(child: AppText("No patients found"));
              }

              return ListView.builder(
                itemCount: ipdControllers.patients.length,
                itemBuilder: (_, i) {
                  final patient = ipdControllers.patients[i];

                  return Obx(() {
                    final isSelected = ipdControllers.selectedPatient.value?.id == patient.id;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: InkWell(
                        onTap: () => ipdControllers.selectPatient(patient),
                        child: _patientCard(
                          name: patient.name,
                          age: "${patient.age} yr/${patient.gender}",
                          bed: extractBedNumber(patient.bedAssign),
                          ward: extractWardFromBedAssign(patient.bedAssign),
                          status: patient.healthCondition,
                          avatar: patient.avatar,
                          isSelected: isSelected,
                        ),
                      ),
                    );
                  });
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _patientCard({
    required String name,
    required String age,
    required String bed,
    required String ward,
    required String status,
    required PatientAvatarModel avatar,
    bool isSelected = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isSelected ? Colors.blue : const Color(0xFFE2E8F0),
          width: isSelected ? 2 : 1,
        ),
        color: isSelected ? const Color(0xFFF0F7FF) : Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // CircleAvatar(
              //   radius: 18,
              //   backgroundImage: avatar.url.isNotEmpty
              //       ? NetworkImage(avatar.url)
              //       : null,
              //   child: avatar.url.isEmpty
              //       ? AppText(
              //           name.isNotEmpty ? name[0].toUpperCase() : "?",
              //           fontWeight: FontWeight.bold
              //         )
              //       : null,
              // ),
              const CircleAvatar(
                backgroundImage: AssetImage(userImage),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(name, fontWeight: FontWeight.w600),
                    AppText(age, fontSize: 12, color: Colors.black54),
                  ],
                ),
              ),
              _statusBadge(status),
            ],
          ),
          const SizedBox(height: 10),
          AppText("Bed : $bed", fontSize: 12),
          AppText("Ward : $ward", fontSize: 12),
        ],
      ),
    );
  }

  // =========================================================
  // RIGHT PANEL - DETAILS
  // =========================================================

  Widget _patientDetailsPanel() {
    return Obx(() {

      /// 🔄 Show loader while fetching details
      if (ipdControllers.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final details = ipdControllers.patientDetails.value;

      if (details == null) {
        return const Center(child: AppText("Select a patient"));
      }

      return DefaultTabController(
        length: 2,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: _cardDecoration(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText(
                    details.patient.name,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  _statusBadge(details.patient.healthCondition),
                ],
              ),

              const SizedBox(height: 8),

              AppText(
                "${details.patient.age} Years • ${details.patient.gender}",
                color: Colors.black54,
              ),

              const SizedBox(height: 20),

              /// INFO BLOCKS
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// Top Row
                  Row(
                    children: [
                      Expanded(
                        child: _InfoBlock(
                          title: "Bed number",
                          value: extractBedNumber(details.patient.bedAssign),
                        ),
                      ),
                      Expanded(
                        child: _InfoBlock(
                          title: "Ward",
                          value: extractWardFromBedAssign(details.patient.bedAssign),
                        ),
                      ),
                      Expanded(
                        child: _InfoBlock(
                          title: "Admission Date",
                          value: dateFromDateTime(details.admission.admittedAt),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// Diagnosis Row (FULL WIDTH)
                  _InfoBlock(
                    title: "Diagnosis",
                    value: _buildDiagnosisText(details),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              /// TABS
              Expanded(
                child: Column(
                  children: [
                    const TabBar(
                      indicatorColor: Colors.blue,
                      tabs: [
                        Tab(text: "Vital monitoring"),
                        Tab(text: "Treatment plans"),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: TabBarView(
                        children: [
                          _vitalMonitoringTab(details),
                          _treatmentPlansTab(details),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  String _buildDiagnosisText(IpdManagementDetailsModel details) {
    final diagnosis = details.diagnosis;

    if (diagnosis == null || diagnosis.diagnoses.isEmpty) {
      return "N/A";
    }

    return diagnosis.diagnoses.join(", ");
  }

  Widget _vitalMonitoringTab(IpdManagementDetailsModel details) {
    final vitals = details.vitals;

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const AppText("Vital signs", fontWeight: FontWeight.w600),
              TextButton(
                onPressed: () {},
                child: const Row(
                  children: [
                    Icon(Icons.add, color: Colors.blue,),
                    SizedBox(width: 4,),
                    AppText(
                      "Add Reading",
                      color: Colors.blue,
                      fontWeight: FontWeight.w500
                    ),
                  ],
                )
              ),
            ],
          ),

          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              children: [
                Expanded(child: AppText("Time")),
                Expanded(child: AppText("BP")),
                Expanded(child: AppText("Pulse")),
                Expanded(child: AppText("Temp")),
                Expanded(child: AppText("SpO2")),
                Expanded(child: AppText("RR")),
              ],
            ),
          ),

          const SizedBox(height: 8),

          Expanded(
            child: vitals == null
              ? const Center(child: AppText("No vitals recorded"))
              : ListView(
                  children: [
                    _vitalRow(
                      dateFromDateTime(vitals.recordedAt),
                      vitals.bp,
                      vitals.pulse.toString(),
                      "${vitals.temperature}°F",
                      "${vitals.spo2}%",
                      vitals.respirationRate,
                    ),
                  ],
                ),
          ),
        ],
      ),
    );
  }

  Widget _vitalRow(
    String time,
    String bp,
    String pulse,
    String temp,
    String spo2,
    int respirationRate,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Row(
        children: [
          Expanded(child: AppText(time)),
          Expanded(child: AppText(bp)),
          Expanded(child: AppText(pulse)),
          Expanded(child: AppText(temp)),
          Expanded(child: AppText(spo2)),
          Expanded(child: AppText(respirationRate.toString())),
        ],
      ),
    );
  }

  Widget _treatmentPlansTab(IpdManagementDetailsModel details) {
    final medication = details.medication;
    final procedure = details.procedure;
    final ivFluid = details.ivFluid;
    final instruction = details.instruction;

    final hasData =
        medication != null ||
        procedure != null ||
        ivFluid != null ||
        instruction != null;

    return ListView(
      children: [

        /// ================= MEDICATIONS =================
        if (medication != null)
          _treatmentSectionCard(
            title: "Medications",
            items: [
              "${medication.name} "
              "(${medication.type}) "
              "- ${medication.mealRelation} "
              "[${medication.status}]"
            ],
          ),

        if (medication != null)
          const SizedBox(height: 20),

        /// ================= IV FLUIDS =================
        if (ivFluid != null)
          _treatmentSectionCard(
            title: "IV Fluids",
            items: [
              "${ivFluid.name} "
              "- ${ivFluid.quantity} "
              "- ${ivFluid.duration} "
              "[${ivFluid.status}]"
            ],
          ),

        if (ivFluid != null)
          const SizedBox(height: 20),

        /// ================= PROCEDURES =================
        if (procedure != null)
          _treatmentSectionCard(
            title: "Procedures",
            items: [
              "${procedure.procedure} "
              "- ${procedure.frequency} "
              "[${procedure.status}]"
            ],
          ),

        if (procedure != null)
          const SizedBox(height: 20),

        /// ================= SPECIAL INSTRUCTIONS =================
        if (instruction != null)
          _treatmentSectionCard(
            title: "Special Instructions",
            items: [
              "${instruction.instruction} "
              "[${instruction.status}]"
            ],
          ),

        if (instruction != null)
          const SizedBox(height: 20),

        /// ================= EMPTY STATE =================
        if (!hasData)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: Center(
              child: AppText(
                "No treatment plan available",
                color: Colors.black54,
              ),
            ),
          ),

        const SizedBox(height: 30),

        /// ================= CHANGE PLAN BUTTON =================
        Align(
          alignment: Alignment.centerRight,
          child: AppButton(
            text: "Change treatment plan",
            icon: Icons.refresh,
            backgroundColor: const Color(0xFF2C7EDB),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            borderRadius: 8,
            onPressed: () {},
          ),
        ),

        const SizedBox(height: 20),
      ],
    );
  }

  Widget _treatmentSectionCard({
    required String title,
    required List<String> items,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// Section Title
          AppText(
            title,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),

          const SizedBox(height: 16),

          /// Items
          Column(
            children: items.map((item) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.medication_outlined,
                      size: 18,
                      color: Colors.black54,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: AppText(
                        item,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // =========================================================

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: const Color(0xFFE2E8F0)),
    );
  }

  Widget _statusBadge(String status) {
    final s = status.toLowerCase().trim();

    Color color;

    if (s.contains("critical")) {
      color = Colors.red;
    } 
    else if (s.contains("serious")) {
      color = Colors.orange;
    } 
    else if (s.contains("improving")) {
      color = Colors.green;
    } 
    else if (s.contains("stable")) {
      color = Colors.blue;
    } 
    else {
      color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: AppText(
        status,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: color,
      ),
    );
  }
}

class _InfoBlock extends StatelessWidget {
  final String title;
  final String value;

  const _InfoBlock({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(title, fontSize: 12, color: Colors.black54),
        const SizedBox(height: 6),
        AppText(value, fontWeight: FontWeight.w600),
      ],
    );
  }
}
