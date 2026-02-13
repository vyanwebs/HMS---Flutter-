import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hms/utils/images.dart';

import '../../controllers/ipd_management_controllers.dart';
import '../../models/avatar_model.dart';
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
      final patient = ipdControllers.selectedPatient.value;

      if (patient == null) {
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
                    patient.name,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  _statusBadge(patient.healthCondition),
                ],
              ),

              const SizedBox(height: 8),

              AppText(
                "${patient.age} Years • ${patient.gender}",
                color: Colors.black54,
              ),

              const SizedBox(height: 20),

              /// INFO BLOCKS
              Row(
                children: [
                  Expanded(
                    child: _InfoBlock(
                      title: "Bed number",
                      value: extractBedNumber(patient.bedAssign),
                    ),
                  ),
                  Expanded(
                    child: _InfoBlock(
                      title: "Ward",
                      value: extractWardFromBedAssign(patient.bedAssign),
                    ),
                  ),
                  Expanded(
                    child: _InfoBlock(
                      title: "Admission Code",
                      value: patient.admissionCode,
                    ),
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
                          _vitalMonitoringTab(),
                          _treatmentPlansTab(),
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

  Widget _vitalMonitoringTab() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// ================= HEADER (FIXED) =================
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              AppText(
                "Vital signs",
                fontWeight: FontWeight.w600,
              ),
              AppText(
                "+ Add Reading",
                color: Colors.blue,
                fontWeight: FontWeight.w500,
              ),
            ],
          ),

          const SizedBox(height: 16),

          /// ================= TABLE HEADER (FIXED) =================
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

          /// ================= SCROLLABLE CONTENT =================
          Expanded(
            child: ListView.builder(
              itemCount: 20,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 16,
                  ),
                  child: const Row(
                    children: [
                      Expanded(child: AppText("08:00 AM")),
                      Expanded(child: AppText("120/80")),
                      Expanded(child: AppText("72")),
                      Expanded(child: AppText("98.6°F")),
                      Expanded(child: AppText("98%")),
                      Expanded(child: AppText("16")),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _treatmentPlansTab() {
    return ListView(
      children: [

        _treatmentSectionCard(
          title: "Medications",
          items: const [
            "Aspirin 75mg - Once daily",
            "Atorvastatin 20mg - Once daily at bedtime",
          ],
        ),

        const SizedBox(height: 20),

        _treatmentSectionCard(
          title: "Procedures",
          items: const [
            "ECG monitoring - Every 6 hours",
            "Blood tests - Daily morning",
          ],
        ),

        const SizedBox(height: 30),

        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2C7EDB),
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 14,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text("Change treatment plan"),
            onPressed: () {},
          ),
        ),
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
