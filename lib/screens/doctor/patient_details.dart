import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../controllers/patient_details_controllers.dart';
import '../../helper_resposive_class/responsive_layout.dart';
import '../../models/patient_model.dart';
import '../../utils/buttons.dart';
import '../../utils/constants.dart';
import '../../utils/enums.dart';
import '../../utils/images.dart';
import '../../utils/text.dart';
import '../main_dashboard.dart';
import 'patient_details_investigation.dart';
import 'patient_details_monitoring.dart';
import 'patient_details_surgical_notes.dart';
import 'patient_details_treatment.dart';

class PatientDetails extends StatelessWidget {
  final PatientModel patient;

  PatientDetails({super.key, required this.patient});

  final patientDetailsController = Get.put(PatientDetailsControllers());

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: desktopView(context),
      tablet: desktopView(context),
      desktop: desktopView(context),
    );
  }

  Widget desktopView(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.white,
              child: _buildSidebar(),
            ),
          ),
          Expanded(
            flex: 5,
            child: _buildSelectedContent(context),
          ),
        ],
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(top: 100),
        child: FloatingActionButton(
          onPressed: () {},
          backgroundColor: AppColors.info,
          child: const Icon(Icons.note_alt_outlined, color: Colors.white,),
          
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    );
  }

  Widget _overviewContent(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      children: [
        patientCard(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                children: [
                  patientOverview(context),
                  const SizedBox(height: 30),
                  actions(),
                  const SizedBox(height: 30),
                  symptomManagement(),
                  const SizedBox(height: 30),
                  diagnosisManagement(),
                ],
              ),
            ),
            const SizedBox(width: 25),
            Expanded(
              child: Column(
                children: [
                  prescriptionManagement(),
                  const SizedBox(height: 20),
                  medicalDatabase(),
                  const SizedBox(height: 20),
                  prescriptionCard(),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSidebar() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Row(
            children: [
              // App Logo from assets
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    appLogo,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      // Fallback to icon if image doesn't load
                      return Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF2383E2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.medical_services, color: Colors.white, size: 24),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Docnex',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3748),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          margin: const EdgeInsets.all(2),
          child: InkWell(
            onTap: () {
              Get.offAll(() => const MainDashboard());
            },
            child: const Row(
              children: [
                Icon(Icons.home_outlined, color: Colors.grey,),
                SizedBox(width: 12),
                Text('Home'),
              ],
            ),
          ),
        ),
        _sideItem(
          title: 'Overview',
          menu: PatientDetailsMenu.overview,
          icon: Icons.description_outlined,
        ),
        _sideItem(
          title: 'Monitoring',
          menu: PatientDetailsMenu.monitoring,
          icon: Icons.monitor_heart_outlined,
        ),
        _sideItem(
          title: 'Treatment',
          menu: PatientDetailsMenu.treatment,
          icon: Icons.water_drop_outlined,
        ),
        _sideItem(
          title: 'Investigation',
          menu: PatientDetailsMenu.investigation,
          icon: Icons.content_paste_search,
        ),
        _sideItem(
          title: 'Surgical Notes',
          menu: PatientDetailsMenu.surgicalNotes,
          imagePath: surgicalNotes,
        ),

        const Spacer(),

        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: Colors.grey.shade200),
            ),
            color: Colors.white,
          ),
          child: Column(
            children: [
              // Simple logout button
              InkWell(
                onTap: () => Get.back(),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.arrow_back, color: AppColors.doctor, size: 22),
                      SizedBox(width: 10),
                      AppText(
                        'Back',
                        fontSize: 15,
                        color: AppColors.doctor,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _sideItem({
    required String title,
    required PatientDetailsMenu menu,
    IconData? icon,
    String? imagePath,
  }) {
    return Obx(() {
      final isSelected = patientDetailsController.selectedMenu.value == menu;

      return InkWell(
        onTap: () => patientDetailsController.select(menu),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.info : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              icon != null
                  ? Icon(icon,
                      size: 20,
                      color: isSelected ? Colors.white : Colors.grey)
                  : Image.asset(
                      imagePath!,
                      scale: 22,
                      color: isSelected ? Colors.white : Colors.grey,
                    ),
              const SizedBox(width: 12),
              AppText(
                title,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildSelectedContent(BuildContext context) {
    return Obx(() {
      switch (patientDetailsController.selectedMenu.value) {
        case PatientDetailsMenu.overview:
          return _overviewContent(context);

        case PatientDetailsMenu.monitoring:
          return const PatientDetailsMonitoring();

        case PatientDetailsMenu.treatment:
          return const PatientDetailsTreatment();

        case PatientDetailsMenu.investigation:
          return const PatientDetailsInvestigation();

        case PatientDetailsMenu.surgicalNotes:
          return const PatientDetailsSurgicalNotes();
      }
    });
  }

  Widget avatar() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.greyText),
        image: const DecorationImage(
          image: AssetImage(userImage),
          fit: BoxFit.cover
        )
      ),
    );
  }

  Widget patientCard() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.info.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8)
      ),
      child: Row(
        children: [
          avatar(),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  patient.name,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                AppText(
                  "ID: ${patient.id} : Age-${patient.age} : ${patient.gender}",
                  fontSize: 12,
                  color: AppColors.greyText,
                )
              ],
            )
          ),
          const SizedBox(width: 20),
          IconButton(
            onPressed: () {},
            style: ButtonStyle(
              backgroundColor: const WidgetStatePropertyAll(AppColors.info),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
              )
            ),
            color: Colors.white,
            icon: const Icon(Icons.copy_rounded),
          )
        ],
      ),
    );
  }

  Widget patientOverview(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // ===== Header =====
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.info.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                avatar(),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AppText(
                        "Patient overview",
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                      AppText(
                        "ID: ${patient.id} : Age-${patient.age} : ${patient.gender}",
                        fontSize: 12,
                        color: AppColors.greyText,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ===== Cards Section =====
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: admissionCard()),
              const SizedBox(width: 16),
              Expanded(child: vitalsCard(context)),
            ],
          ),
        ],
      ),
    );
  }

  Widget admissionCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppText(
            "Admission",
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          const SizedBox(height: 12),

          infoRow("Date", "17/12/2025"),
          infoRow("Reason", "Not specified"),
          infoRow("Symptoms", "No symptoms"),

          const SizedBox(height: 6),
          const AppText(
            "10 min ago",
            fontSize: 11,
            color: AppColors.greyText,
          ),

          const SizedBox(height: 14),

          SizedBox(
            width: double.infinity,
            child: AppButton(
              onPressed: () {},
              text: "Add Symptoms",
              iconIsLast: false,
              icon: Icons.add,
            ),
          )
        ],
      ),
    );
  }

  Widget vitalsCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppText(
            "Latest vital’s",
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          const SizedBox(height: 12),

          vitalRow("BP", "140/90"),
          vitalRow("Pulse", "88 bpm"),
          vitalRow("Temp", "98.6°F"),
          vitalRow("SpO₂", "98%"),

          const SizedBox(height: 6),
          const AppText(
            "10 min ago",
            fontSize: 11,
            color: AppColors.greyText,
          ),

          const SizedBox(height: 14),

          SizedBox(
            width: double.infinity,
            child: AppButton(
              onPressed: () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => AddVitalDialog(patient: patient),
                );
              },
              text: "Add Vitals",
              iconIsLast: false,
              icon: Icons.add,
            ),
          )
        ],
      ),
    );
  }

  Widget infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: AppText(
              "$label :",
              color: AppColors.greyText,
              fontSize: 13,
            ),
          ),
          AppText(
            value,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }

  Widget vitalRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppText(
            "$label :",
            color: AppColors.greyText,
            fontSize: 13,
          ),
          AppText(
            value,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }

  Widget actions() {
    return Wrap(
      spacing: 40,
      runSpacing: 40,
      alignment: WrapAlignment.start,
      children: [
        actionItem(
          icon: Icons.remove_red_eye,
          label: "View History",
          color: Colors.blue,
          onTap: () {
            debugPrint("View History clicked");
          },
        ),

        actionItem(
          customIcon: const HugeIcon(
            icon: HugeIcons.strokeRoundedCertificate01,
            color: Colors.white,
            size: 24,
          ),
          label: "Certificate",
          color: Colors.green,
          onTap: () {
            debugPrint("Certificates clicked");
          },
        ),

        actionItem(
          icon: Icons.note_add_outlined,
          label: "Prescription",
          color: Colors.orange,
          onTap: () {
            debugPrint("Notes clicked");
          },
        ),

        actionItem(
          icon: Icons.bed_outlined,
          label: "Admit",
          color: Colors.purple,
          onTap: () {
            debugPrint("Bed Assign clicked");
          },
        ),

        actionItem(
          icon: CupertinoIcons.lab_flask,
          label: "Lab Assign",
          color: AppColors.info,
          onTap: () {
            debugPrint("Lab Tests clicked");
          },
        ),

        actionItem(
          customIcon: const HugeIcon(
            icon: HugeIcons.strokeRoundedInvestigation,
            color: Colors.white,
            size: 24,
          ),
          label: "Investigation",
          color: Colors.pinkAccent,
          onTap: () {
            debugPrint("Investigations clicked");
          },
        ),
      ],
    );
  }

  Widget actionItem({
    IconData? icon,
    Widget? customIcon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
              child: customIcon ??
                  Icon(
                    icon,
                    color: Colors.white,
                    size: 24,
                  ),
            ),
            const SizedBox(height: 8),
            AppText(
              label,
              fontSize: 11,
              color: color,
              fontWeight: FontWeight.w500,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget managementCard({
    required String title,
    required String buttonText,
    required String hintText,
    required List<String> chips,
    required VoidCallback onButtonTap,
    ValueChanged<String>? onChanged,
  }) {
    final controller = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final FocusNode textFocus = FocusNode();

    void submit() {
      if (formKey.currentState!.validate()) {
        onButtonTap();
        controller.clear();
        FocusScope.of(textFocus.context!).unfocus();
      }
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(
                  title,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                AppButton(
                  onPressed: submit,
                  text: buttonText,
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                  borderRadius: 6,
                ),
              ],
            ),

            const SizedBox(height: 14),

            const AppText(
              "Enter symptoms",
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),

            const SizedBox(height: 8),

            /// Input with Validator
            TextFormField(
              controller: controller,
              focusNode: textFocus,
              onChanged: onChanged,
              textInputAction: TextInputAction.done,
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return "Please enter a value";
                }
                return null;
              },
              onFieldSubmitted: (_) => submit(), // ✅ ENTER KEY
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(color: Colors.grey.shade400),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),

            const SizedBox(height: 12),

            /// Chips
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: chips.map(
                (chip) => chipItem(
                  label: chip,
                  controller: controller,
                ),
              ).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget chipItem({
    required String label,
    required TextEditingController controller,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(6),
        onTap: () {
          controller.text = label;          // ✅ set text
          controller.selection = TextSelection.fromPosition(
            TextPosition(offset: controller.text.length),
          ); // cursor at end
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.info.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(6),
          ),
          child: AppText(
            label,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget symptomManagement() {
    return managementCard(
      title: "Symptom management",
      buttonText: "Add Symptoms",
      hintText: "Enter symptoms",
      chips: [
        "Fever",
        "Chills / Rigors",
        "Fever",
        "Chills / Rigors",
        "Fatigue",
      ],
      onButtonTap: () {

      },
    );
  }

  Widget diagnosisManagement() {
    return managementCard(
      title: "Diagnosis management",
      buttonText: "Add Diagnosis",
      hintText: "Enter symptoms",
      chips: [
        "Viral Fever",
        "Bacterial Infection",
        "Fever",
        "Chills / Rigors",
        "Fatigue",
      ],
      onButtonTap: () {

      },
    );
  }

  Widget prescriptionManagement() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.info.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8)
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.info.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(4)
            ),
            child: const Icon(Icons.post_add, color: Colors.blue),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppText(
                  "Prescription Management",
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                AppText(
                  "ID: ${patient.id} : Age-${patient.age} : ${patient.gender}",
                  fontSize: 12,
                  color: AppColors.greyText,
                )
              ],
            )
          ),
        ],
      ),
    );
  }

  Widget medicalDatabase() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 25),
      decoration: BoxDecoration(
        color: AppColors.info.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(50)
      ),
      child: Row(
        children: [
          const Icon(Icons.post_add, color: Colors.blue),
          const SizedBox(width: 12),
          const Expanded(
            child: AppText(
              "Quick access to your medical database",
              fontSize: 12,
              color: AppColors.greyText,
            )
          ),
          AppButton(
            onPressed: () {},
            padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 20),
            borderRadius: 50,
            text: "Open database",
          )
        ],
      ),
    );
  } 

  Widget prescriptionCard() {
    final morningCtrl = TextEditingController(text: "0");
    final afternoonCtrl = TextEditingController(text: "0");
    final nightCtrl = TextEditingController(text: "0");

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Frequently used medicines
          const AppText(
            "Frequently used medicines",
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          const SizedBox(height: 10),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: patientDetailsController.frequentlyUsedMedicines.map((e) => lightChip(e)).toList(),
          ),

          const SizedBox(height: 20),

          /// Prescription details
          const AppText(
            "Prescription details",
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),

          const SizedBox(height: 14),

          /// Selected medicine
          const AppText(
            "Selected medicine",
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
          const SizedBox(height: 8),

          TextFormField(
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              hintText: "Enter Medicine name",
              hintStyle: TextStyle(color: Colors.grey.shade400),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
            ),
          ),

          const SizedBox(height: 18),

          /// Dosage information
          const AppText(
            "Dosage information",
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(child: dosageBox(title: "Morning", controller: morningCtrl)),
              const SizedBox(width: 10),
              Expanded(child: dosageBox(title: "Afternoon", controller: afternoonCtrl)),
              const SizedBox(width: 10),
              Expanded(child: dosageBox(title: "Night", controller: nightCtrl)),
            ],
          ),

          const SizedBox(height: 14),

          /// Meal timing
          Obx(
            () => Row(
              children: [
                mealButton(
                  text: "Before meal",
                  selected: patientDetailsController.isBeforeMeal.value,
                  onTap: patientDetailsController.selectBeforeMeal,
                ),
                const SizedBox(width: 10),
                mealButton(
                  text: "After meal",
                  selected: !patientDetailsController.isBeforeMeal.value,
                  onTap: patientDetailsController.selectAfterMeal,
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          /// Duration
          const AppText(
            "Duration",
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
          const SizedBox(height: 8),

          TextFormField(
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              hintText: "Enter duration",
              hintStyle: TextStyle(color: Colors.grey.shade400),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
            ),
          ),

          const SizedBox(height: 16),

          /// Add comment
          const AppText(
            "Add comment",
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
          const SizedBox(height: 8),

          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.grey.shade300,
                style: BorderStyle.solid,
              ),
            ),
            child: TextFormField(
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Enter specific prescription comment",
                hintStyle: TextStyle(color: Colors.grey.shade400),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(12),
              ),
            ),
          ),

          const SizedBox(height: 20),

          /// Add prescription button
          Center(
            child: SizedBox(
              width: 200,
              child: AppButton(
                text: "Add prescription",
                onPressed: () {
                  // TODO: controller.addPrescription()
                },
                padding: const EdgeInsets.symmetric(vertical: 12),
                borderRadius: 8,
              ),
            ),
          ),

          const SizedBox(height: 24),

          /// Current prescription
          const AppText(
            "Current prescription",
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),

          const SizedBox(height: 12),

          currentPrescriptionItem(),

        ],
      ),
    );
  }

  Widget lightChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.info.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: AppText(
        label,
        fontSize: 11,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget mealButton({
    required String text,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(6),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: selected ? AppColors.info : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Center(
              child: AppText(
                text,
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: selected ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget dosageBox({
    required String title,
    required TextEditingController controller,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.info.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          AppText(
            title,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          const SizedBox(height: 6),

          SizedBox(
            width: 80,
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              maxLength: 2,
              textInputAction: TextInputAction.next,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: const InputDecoration(
                counterText: "",
                isDense: true,
                border: InputBorder.none,
              ),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget currentPrescriptionItem() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          /// Icon
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.info.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.medical_services_outlined,
              color: AppColors.info,
              size: 20,
            ),
          ),

          const SizedBox(width: 12),

          /// Medicine name
          const Expanded(
            child: AppText(
              "Abcd 25 mg tablet",
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),

          /// Dosage chips
          const Row(
            children: [
              DosageMiniChip(label: "M", value: "1"),
              SizedBox(width: 6),
              DosageMiniChip(label: "A", value: "1"),
              SizedBox(width: 6),
              DosageMiniChip(label: "N", value: "1"),
            ],
          ),

          const SizedBox(width: 10),

          /// Delete
          IconButton(
            onPressed: () {},
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Colors.red.withValues(alpha: 0.2))
            ),
            icon: const Icon(
              Icons.delete_forever,
              color: Colors.red,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }

}

class DosageMiniChip extends StatelessWidget {
  final String label;
  final String value;

  const DosageMiniChip({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.info.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        children: [
          AppText(label, fontSize: 10),
          AppText(
            value,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }
}

class AddVitalDialog extends StatelessWidget {
  final PatientModel patient;

  const AddVitalDialog({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(40),
      backgroundColor: Colors.transparent,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 🔹 Blur background
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
            child: Container(),
          ),

          // 🔹 Main Card
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: SizedBox(
              width: 900,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _patientInfo(),
                  const SizedBox(width: 30),
                  Expanded(child: _vitalsForm(context)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= LEFT PATIENT CARD =================
  Widget _patientInfo() {
    return Container(
      width: 260,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: AppColors.info.withValues(alpha: 0.15),
            child: Text(
              patient.initials,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          AppText(
            patient.name,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          const SizedBox(height: 4),
          AppText(
            'Pat Id : ${patient.patientId}',
            fontSize: 12,
            color: AppColors.greyText,
          ),
          const SizedBox(height: 10),
          AppText(
            'Gender : ${patient.gender}',
            fontSize: 12,
          ),
          AppText(
            'Age : ${patient.age} years',
            fontSize: 12,
          ),
        ],
      ),
    );
  }

  // ================= RIGHT FORM =================
  Widget _vitalsForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppText(
              'Add Vitals',
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            const SizedBox(height: 6),
            AppText(
              'Add vital details for ${patient.name}',
              fontSize: 12,
              color: AppColors.greyText,
            ),
            const SizedBox(height: 20),
            
            _input(label: 'BP'),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(child: _input(label: 'Pulse')),
                const SizedBox(width: 16),
                Expanded(child: _input(label: 'Temperature')),
              ],
            ),
            
            const SizedBox(height: 16),
            _input(label: 'SpO₂'),
            
            const SizedBox(height: 30),
          ],
        ),

        // ================= ACTIONS =================
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Close'),
            ),
            const SizedBox(width: 20),
            AppButton(
              text: 'Add',
              onPressed: () {
                // TODO: controller.addVitals()
                Get.back();
              },
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
            ),
          ],
        )
      ],
    );
  }

  Widget _input({required String label}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          label,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        const SizedBox(height: 6),
        TextFormField(
          decoration: InputDecoration(
            hintText: label,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ),
        ),
      ],
    );
  }
}
