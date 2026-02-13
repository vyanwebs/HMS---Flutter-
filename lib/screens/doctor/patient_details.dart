import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mdi_icons/flutter_mdi_icons.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../controllers/patient_details_controllers.dart';
import '../../helper_resposive_class/responsive_layout.dart';
import '../../models/patient_model.dart';
import '../../utils/buttons.dart';
import '../../utils/constants.dart';
import '../../utils/enums.dart';
import '../../utils/images.dart';
import '../../utils/keyboard_intents.dart';
import '../../utils/text.dart';
import '../../utils/validators.dart';
import '../main_dashboard.dart';
import 'discharge_summary.dart';
import 'e_prescriptions.dart';
import 'monitoring/patient_details_Symptoms.dart';
import 'monitoring/patient_details_consultation.dart';
import 'monitoring/patient_details_diagnosis.dart';
import 'monitoring/patient_details_followup.dart';
import 'monitoring/patient_details_prescription.dart';
import 'patient_certificate_screen.dart';
import 'patient_details_investigation.dart';
import 'monitoring/patient_details_vitals_monitoring.dart';
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
      floatingActionButton: Obx(() {
        final show = patientDetailsController.selectedMenu.value == PatientDetailsMenu.overview;

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: show
            ? Container(
                key: const ValueKey("overviewFab"),
                margin: const EdgeInsets.only(top: 100),
                child: FloatingActionButton(
                  onPressed: () {},
                  backgroundColor: AppColors.info,
                  child: const Icon(Icons.note_alt_outlined,
                      color: Colors.white),
                ),
              )
            : const SizedBox.shrink(),
        );
      }),
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
        const SizedBox(height: 10),
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
              const AppText(
                'Docnex',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3748),
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
        /// MONITORING (Expandable)
        Obx(() {
          final isExpanded = patientDetailsController.isMonitoringExpanded.value;
          final isAnyMonitoringSelected = patientDetailsController.selectedMenu.value.toString().contains('monitoring');

          return Column(
            children: [
              InkWell(
                onTap: () => patientDetailsController.toggleMonitoring(),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isAnyMonitoringSelected
                        ? AppColors.info.withValues(alpha: 0.15)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.monitor_heart_outlined,
                        color: isAnyMonitoringSelected
                            ? AppColors.info
                            : Colors.grey,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AppText(
                          "Monitoring",
                          color: isAnyMonitoringSelected
                            ? AppColors.info
                            : Colors.black87,
                        ),
                      ),
                      Icon(
                        isExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                        size: 20,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),

              /// SUB MENU
              if (isExpanded)
                _monitoringSubItem(
                  title: "Vitals",
                  menu: PatientDetailsMenu.monitoringVitals,
                ),
              if (isExpanded)
                _monitoringSubItem(
                  title: "Symptoms",
                  menu: PatientDetailsMenu.monitoringSymptoms,
                ),
              if (isExpanded)
                _monitoringSubItem(
                  title: "Follow ups",
                  menu: PatientDetailsMenu.monitoringFollowUps,
                ),
              if (isExpanded)
                _monitoringSubItem(
                  title: "Prescription",
                  menu: PatientDetailsMenu.monitoringPrescription,
                ),
              if (isExpanded)
                _monitoringSubItem(
                  title: "Consultation",
                  menu: PatientDetailsMenu.monitoringConsultation,
                ),
              if (isExpanded)
                _monitoringSubItem(
                  title: "Diagnosis",
                  menu: PatientDetailsMenu.monitoringDiagnosis,
                ),
            ],
          );
        }),
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
        _sideItem(
          title: 'E-Prescriptions',
          menu: PatientDetailsMenu.ePrescription,
          icon: Icons.list_alt,
        ),
        _sideItem(
          title: 'Discharge Summary',
          menu: PatientDetailsMenu.dischargeSummary,
          icon: Mdi.weight,
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

  Widget _monitoringSubItem({
    required String title,
    required PatientDetailsMenu menu,
  }) {
    return Obx(() {
      final isSelected = patientDetailsController.selectedMenu.value == menu;

      return InkWell(
        onTap: () => patientDetailsController.select(menu),
        child: Container(
          margin: const EdgeInsets.only(left: 28, right: 8, top: 2, bottom: 2),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
              ? AppColors.info.withValues(alpha: 0.2)
              : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            children: [
              Icon(
                Icons.circle,
                size: 6,
                color: isSelected ? AppColors.info : Colors.grey,
              ),
              const SizedBox(width: 10),
              AppText(
                title,
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? AppColors.info : Colors.black87,
              ),
            ],
          ),
        ),
      );
    });
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

        case PatientDetailsMenu.monitoringVitals:
          return PatientDetailsVitalsMonitoring(patient: patient);

        case PatientDetailsMenu.monitoringSymptoms:
          return const PatientDetailsSymptoms();

        case PatientDetailsMenu.monitoringFollowUps:
          return const PatientDetailsFollowUps();

        case PatientDetailsMenu.monitoringPrescription:
          return PatientDetailsPrescription(patient: patient);

        case PatientDetailsMenu.monitoringConsultation:
          return const PatientDetailsConsultation();

        case PatientDetailsMenu.monitoringDiagnosis:
          return PatientDetailsDiagnosis(patient: patient);

        case PatientDetailsMenu.treatment:
          return PatientDetailsTreatment(patient: patient,);

        case PatientDetailsMenu.investigation:
          return const PatientDetailsInvestigation();

        case PatientDetailsMenu.surgicalNotes:
          return const PatientDetailsSurgicalNotes();

        case PatientDetailsMenu.ePrescription:
          return const EPrescriptions();

        case PatientDetailsMenu.dischargeSummary:
          return DischargeSummary(patient: patient);
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
                  "ID: ${patient.patientId} : Age-${patient.age} : ${patient.gender}",
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
          onTap: () => Get.to(() => CertificateScreen(patient: patient)),
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
            showDialog(
              context: Get.context!,
              barrierDismissible: false,
              builder: (_) => AdmitPatientDialog(patient: patient),
            );
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
            showDialog(
              context: Get.context!,
              barrierDismissible: false,
              builder: (_) => InvestigationRequestDialog(patient: patient),
            );
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
              onFieldSubmitted: (_) => submit(),
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
          controller.text = label;
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
        "Fatigue",
        "Headache",
        "Body pain",
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

  final FocusNode medicineFocus = FocusNode();
  final FocusNode durationFocus = FocusNode();
  final FocusNode commentFocus = FocusNode();

  Widget prescriptionCard() {

    final formKey = GlobalKey<FormState>();
    final controller = patientDetailsController;

    return FocusTraversalGroup(
      policy: OrderedTraversalPolicy(),
      child: Shortcuts(
        shortcuts: {
          LogicalKeySet(LogicalKeyboardKey.enter): const ActivateIntent(),
        },
        child: Actions(
          actions: {
            ActivateIntent: CallbackAction<ActivateIntent>(
              onInvoke: (_) {
                _submitPrescription(
                  formKey: formKey,
                  controller: controller,
                );
                return null;
              },
            ),
          },
          child: Form(
            key: formKey,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ---------------- Frequently used medicines ----------------
                  const AppText(
                    "Frequently used medicines",
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  const SizedBox(height: 10),
          
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: controller.frequentlyUsedMedicines.map((e) => lightChip(e)).toList(),
                  ),
          
                  const SizedBox(height: 20),
          
                  // ---------------- Prescription details ----------------
                  const AppText(
                    "Prescription details",
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
          
                  const SizedBox(height: 14),
          
                  // ---------------- Medicine search ----------------
                  const AppText(
                    "Selected medicine",
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                  const SizedBox(height: 8),
          
                  TextFormField(
                    controller: controller.medicineCtrl,
                    textInputAction: TextInputAction.next,
                    onChanged: (v) {
                      controller.medicineError.value = null;
                      controller.searchMedicine(v);
                    },
                    validator: (_) => null,
                    decoration: InputDecoration(
                      hintText: "Search medicine (min 3 characters)",
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
          
                  Obx(() {
                    final error = controller.medicineError.value;
                    if (error == null) return const SizedBox();
                    return AppText(error, fontSize: 12, color: Colors.red);
                  }),
          
                  // ---------------- Medicine dropdown ----------------
                  Obx(() {
                    if (controller.isMedicineLoading.value) {
                      return const Padding(
                        padding: EdgeInsets.all(8),
                        child: Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      );
                    }
          
                    if (controller.medicines.isEmpty) return const SizedBox();
          
                    return Column(
                      children: [
                        const SizedBox(height: 6),
                        Container(
                          constraints: const BoxConstraints(maxHeight: 200),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: ListView.separated(
                            itemCount: controller.medicines.length,
                            separatorBuilder: (_, __) => const Divider(height: 1),
                            itemBuilder: (_, index) {
                              final med = controller.medicines[index];
                              return ListTile(
                                dense: true,
                                title: Text(med.name),
                                onTap: () {
                                  controller.medicineCtrl.text = med.name;
                                  controller.selectMedicine(med);
                                  FocusScope.of(Get.context!).unfocus();
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  }),
          
                  const SizedBox(height: 14),
          
                  // ---------------- Dosage ----------------
                  const AppText(
                    "Dosage information",
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                  const SizedBox(height: 12),
          
                  Row(
                    children: [
                      Expanded(
                        child: dosageBox(
                          title: "Morning",
                          controller: controller.morningCtrl,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: dosageBox(
                          title: "Afternoon",
                          controller: controller.afternoonCtrl,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: dosageBox(
                          title: "Night",
                          controller: controller.nightCtrl,
                        ),
                      ),
                    ],
                  ),
          
                  Obx(() {
                    final error = controller.dosageError.value;
                    if (error == null) return const SizedBox();
                    return Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: AppText(error, fontSize: 12, color: Colors.red),
                    );
                  }),
          
                  const SizedBox(height: 14),
          
                  // ---------------- Meal timing ----------------
                  Obx(() => Row(
                    children: [
                      mealButton(
                        text: "Before meal",
                        selected: controller.isBeforeMeal.value,
                        onTap: controller.selectBeforeMeal,
                      ),
                      const SizedBox(width: 10),
                      mealButton(
                        text: "After meal",
                        selected: !controller.isBeforeMeal.value,
                        onTap: controller.selectAfterMeal,
                      ),
                    ],
                  )),
          
                  const SizedBox(height: 20),
          
                  // ---------------- Duration ----------------
                  const AppText("Duration", fontSize: 13, fontWeight: FontWeight.w500),
                  const SizedBox(height: 8),
          
                  TextFormField(
                    controller: controller.durationCtrl,
                    textInputAction: TextInputAction.done,
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return "Duration is required";
                      }
                      final days = int.tryParse(v);
                      if (days == null) {
                        return "Enter valid days";
                      }
                      if (days <= 0) {
                        return "Duration must be at least 1 day";
                      }
                      if (days > 365) {
                        return "Duration cannot exceed 365 days";
                      }
                      return null;
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    onFieldSubmitted: (_) {
                      _submitPrescription(
                        formKey: formKey,
                        controller: controller,
                      );
                    },
                    decoration: InputDecoration(
                      hintText: "Enter duration",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
          
                  const SizedBox(height: 16),
          
                  // ---------------- Comment ----------------
                  const AppText("Add comment", fontSize: 13),
                  const SizedBox(height: 8),
          
                  TextFormField(
                    controller: controller.commentCtrl,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: "Enter Comments",
                      border: OutlineInputBorder(),
                    ),
                  ),
          
                  const SizedBox(height: 20),
          
                  // ---------------- Submit ----------------
                  Center(
                    child: SizedBox(
                      width: 200,
                      child: AppButton(
                        text: "Add prescription",
                        onPressed: () {
                          _submitPrescription(
                            formKey: formKey,
                            controller: controller,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _submitPrescription({
    required GlobalKey<FormState> formKey,
    required PatientDetailsControllers controller,
  }) {
    if (controller.selectedMedicine.value == null) {
      controller.medicineError.value = "Please select a medicine from the list";
      return;
    }

    final m = int.tryParse(controller.morningCtrl.text) ?? 0;
    final a = int.tryParse(controller.afternoonCtrl.text) ?? 0;
    final n = int.tryParse(controller.nightCtrl.text) ?? 0;

    final formValid = formKey.currentState!.validate();
    final dosageValid = controller.validateDosage(m, a, n);

    if (!formValid || !dosageValid) return;

    controller.createPrescription(
      patientMongoId: patient.id,
      morningQty: m,
      afternoonQty: a,
      nightQty: n,
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

  AddVitalDialog({super.key, required this.patient});

  final patientDetailsController = Get.find<PatientDetailsControllers>();
  final _formKey = GlobalKey<FormState>();
  final focusNode = FocusNode();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      patientDetailsController.createVital(patient: patient);
    }
  }

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
    return Form(
      key: _formKey,
      child: Column(
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

              _bpInput(
                label: 'BP',
                controller: patientDetailsController.bpCtrl,
                inputFormatters: [BPInputFormatter()],
                validator: bpValidator,
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: _input(
                      label: 'Pulse',
                      controller: patientDetailsController.pulseCtrl,
                      isNumeric: true,
                      min: 20,
                      max: 250,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _input(
                      label: 'Temperature (°F)',
                      controller: patientDetailsController.tempCtrl,
                      isNumeric: true,
                      min: 80,
                      max: 115,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              _input(
                label: 'SpO₂',
                controller: patientDetailsController.spo2Ctrl,
                isNumeric: true,
                min: 50,
                max: 100,
                isLast: true,
                onSubmit: _submitForm,
              ),
            ],
          ),

          /// ACTIONS
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
                  if (_formKey.currentState!.validate()) {
                    patientDetailsController.createVital(patient: patient);
                  }
                },
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _input({
    required String label,
    required TextEditingController controller,
    bool isLast = false,
    VoidCallback? onSubmit,
    bool isNumeric = false,
    double? min,
    double? max,
  }) {
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
          controller: controller,
          keyboardType: isNumeric
              ? const TextInputType.numberWithOptions(decimal: true)
              : TextInputType.text,
          inputFormatters: isNumeric
              ? [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'^\d*\.?\d*$'),
                  ),
                ]
              : [],
          validator: isNumeric
              ? (value) => doubleValidator(
                    value,
                    label: label,
                    min: min,
                    max: max,
                  )
              : (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '$label is required';
                  }
                  return null;
                },
          onFieldSubmitted: (_) {
            if (isLast) {
              onSubmit?.call();
            } else {
              FocusScope.of(Get.context!).nextFocus();
            }
          },
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

  Widget _bpInput({
    required String label,
    required TextEditingController controller,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    bool isLast = false,
    VoidCallback? onSubmit,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(label, fontSize: 12, fontWeight: FontWeight.w500),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters: inputFormatters,
          validator: validator ??
              (value) {
                if (value == null || value.trim().isEmpty) {
                  return '$label is required';
                }
                return null;
              },
          onFieldSubmitted: (_) {
            if (isLast) {
              onSubmit?.call();
            } else {
              FocusScope.of(Get.context!).nextFocus();
            }
          },
          decoration: InputDecoration(
            hintText: 'e.g. 120/80',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }
}

class BPInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;

    // Allow only digits and /
    if (!RegExp(r'^[0-9/]*$').hasMatch(text)) {
      return oldValue;
    }

    // Allow only one /
    if ('/'.allMatches(text).length > 1) {
      return oldValue;
    }

    return newValue;
  }
}

enum WardType { general, icu, others }

class AdmitPatientDialog extends StatefulWidget {
  final PatientModel patient;

  const AdmitPatientDialog({super.key, required this.patient});

  @override
  State<AdmitPatientDialog> createState() => _AdmitPatientDialogState();
}

class _AdmitPatientDialogState extends State<AdmitPatientDialog> {
  WardType selectedWard = WardType.general;
  final instructionCtrl = TextEditingController();

  final controller = Get.find<PatientDetailsControllers>();

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        backgroundColor: Colors.white,
        insetPadding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// Patient Header
                _patientHeader(),

                const SizedBox(height: 20),

                /// Admit section
                const AppText(
                  "Admit patient",
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),

                const SizedBox(height: 6),
                const AppText(
                  "Specify where patient",
                  fontSize: 13,
                  color: Colors.grey,
                ),

                const SizedBox(height: 12),

                _wardOption(WardType.general, "General ward"),
                _wardOption(WardType.icu, "ICU"),
                _wardOption(WardType.others, "Others"),

                const SizedBox(height: 18),

                const AppText(
                  "Add instructions",
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),

                const SizedBox(height: 8),

                TextField(
                  controller: instructionCtrl,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: "Add instructions here",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                /// Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AppButton(
                      text: "Close",
                      backgroundColor: Colors.grey.shade600,
                      onPressed: () => Get.back(),
                    ),
                    const SizedBox(width: 12),
                    AppButton(
                      text: "Admit",
                      onPressed: _submit,
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

  Widget _patientHeader() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.info.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: AppColors.info.withValues(alpha: 0.2),
            child: Text(widget.patient.initials),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                widget.patient.name,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
              AppText(
                "ID:${widget.patient.patientId} · Age-${widget.patient.age} · ${widget.patient.gender}",
                fontSize: 12,
                color: Colors.grey,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _wardOption(WardType type, String title) {
    final isSelected = selectedWard == type;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: () => setState(() => selectedWard = type),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? AppColors.info : Colors.grey.shade300,
            ),
          ),
          child: Row(
            children: [
              Icon(
                isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                color: AppColors.info,
              ),
              const SizedBox(width: 12),
              AppText(title),
            ],
          ),
        ),
      ),
    );
  }

  void _submit() {

    controller.makeAdmitRequest(
      patient: widget.patient,
      wardType: selectedWard,
      instructions: instructionCtrl.text,
    );
  }
}

class InvestigationRequestDialog extends StatefulWidget {
  final PatientModel patient;

  const InvestigationRequestDialog({super.key, required this.patient});

  @override
  State<InvestigationRequestDialog> createState() => _InvestigationRequestDialogState();
}

class _InvestigationRequestDialogState extends State<InvestigationRequestDialog> {
  final _formKey = GlobalKey<FormState>();

  final investigationCtrl = TextEditingController(text: "X-Ray");
  final priorityCtrl = TextEditingController(text: "Routine");
  final scheduleCtrl = TextEditingController();
  final reasonCtrl = TextEditingController();
  final historyCtrl = TextEditingController();

  @override
  void dispose() {
    investigationCtrl.dispose();
    priorityCtrl.dispose();
    scheduleCtrl.dispose();
    reasonCtrl.dispose();
    historyCtrl.dispose();
    super.dispose();
  }
  
  final controller = Get.find<PatientDetailsControllers>();

  DateTime? selectedDateTime;

  Future<void> _pickDateTime() async {
    final now = DateTime.now();

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime.now(),
      lastDate: DateTime(now.year + 5),
    );

    if (pickedDate == null) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(now),
    );

    if (pickedTime == null) return;

    final combined = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    selectedDateTime = combined;

    /// 👀 UI FORMAT
    scheduleCtrl.text = _formatForDisplay(combined);
  }

  String _formatForDisplay(DateTime dateTime) {
    final date = "${_monthName(dateTime.month)} ${dateTime.day.toString().padLeft(2, '0')}, ${dateTime.year}";
    final time = TimeOfDay.fromDateTime(dateTime).format(context);
    return "$date – $time";
  }

  String _monthName(int month) {
    const months = [
      "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];
    return months[month - 1];
  }

  String toIsoWithoutMilliseconds(DateTime dateTime) {
    final two = (int n) => n.toString().padLeft(2, '0');

    final offset = dateTime.timeZoneOffset;
    final sign = offset.isNegative ? '-' : '+';
    final hours = two(offset.inHours.abs());
    final minutes = two(offset.inMinutes.abs() % 60);

    return
      '${dateTime.year}-'
      '${two(dateTime.month)}-'
      '${two(dateTime.day)}T'
      '${two(dateTime.hour)}:'
      '${two(dateTime.minute)}:'
      '${two(dateTime.second)}'
      '$sign$hours:$minutes';
  }


  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.escape): const ActivateIntent(),
        LogicalKeySet(LogicalKeyboardKey.enter): const SubmitIntent(),
        LogicalKeySet(
          LogicalKeyboardKey.control,
          LogicalKeyboardKey.enter,
        ): const SubmitIntent(),
        LogicalKeySet(
          LogicalKeyboardKey.meta,
          LogicalKeyboardKey.enter,
        ): const SubmitIntent(),
      },
      child: Actions(
        actions: {
          ActivateIntent: CallbackAction(
            onInvoke: (_) => Get.back(),
          ),
          SubmitIntent: CallbackAction(
            onInvoke: (_) => _submit(),
          ),
        },
        child: Dialog(
          insetPadding: const EdgeInsets.all(32),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          child: SizedBox(
            width: 980,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _patientCard(),
                  const SizedBox(width: 30),
                  Expanded(child: _form()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ================= LEFT PATIENT CARD =================
  Widget _patientCard() {
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
            radius: 55,
            backgroundColor: AppColors.info.withValues(alpha: 0.15),
            child: Text(
              widget.patient.initials,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          AppText(
            widget.patient.name,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          const SizedBox(height: 4),
          AppText(
            "Pat Id : ${widget.patient.patientId}",
            fontSize: 12,
            color: AppColors.greyText,
          ),
          const SizedBox(height: 12),
          AppText("Gender : ${widget.patient.gender}", fontSize: 12),
          AppText("Age : ${widget.patient.age} years", fontSize: 12),
        ],
      ),
    );
  }

  // ================= RIGHT FORM =================
  Widget _form() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppText(
                "New investigation request",
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
              const SizedBox(height: 20),

              /// Investigation + Priority
              Row(
                children: [
                  Expanded(
                    child: _dropdown(
                      label: "Investigation type",
                      value: investigationCtrl.text,
                      items: const [
                        "X-Ray",
                        "MRI",
                        "CT Scan",
                        "Ultrasound",
                        "CT PNS",
                        "Nasal Endoscopy",
                        "Laryngoscopy",
                        "Glucose Tolerance Test",
                        "DEXA Scan",
                        "VEP",
                        "SSEP",
                        "BAER",
                        "Breath Test",
                        "Blood Test",
                        "Urine Test",
                        "Other",
                      ],
                      onChanged: (v) => investigationCtrl.text = v!,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _dropdown(
                      label: "Priority",
                      value: priorityCtrl.text,
                      items: const ["Routine", "Urgent", "STAT"],
                      onChanged: (v) => priorityCtrl.text = v!,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppText(
                    "Schedule date and time",
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: scheduleCtrl,
                    readOnly: true,
                    validator: (v) => v == null || v.isEmpty ? "Schedule date and time is required" : null,
                    onTap: _pickDateTime,
                    decoration: InputDecoration(
                      hintText: "Select date & time",
                      suffixIcon: const Icon(Icons.calendar_today_outlined),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              _input(
                label: "Reason for investigation",
                controller: reasonCtrl,
                hint: "Enter reason",
              ),

              const SizedBox(height: 16),

              _input(
                label: "Clinical history",
                controller: historyCtrl,
                hint: "Enter clinical history",
                maxLines: 3,
              ),
            ],
          ),

          /// ACTIONS
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AppButton(
                text: "Close",
                backgroundColor: Colors.grey.shade600,
                onPressed: () => Get.back(),
              ),
              const SizedBox(width: 12),
              AppButton(
                text: "Create investigation",
                onPressed: _submit,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ================= SUBMIT =================
  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    controller.createInvestigation(
      patientId: widget.patient.id,
      investigationType: investigationCtrl.text,
      priority: priorityCtrl.text,
      scheduledDateTime: toIsoWithoutMilliseconds(selectedDateTime!),
      reasonForInvestigation: reasonCtrl.text,
      clinicalHistory: historyCtrl.text,
    );
  }

  // ================= INPUT HELPERS =================
  Widget _input({
    required String label,
    required TextEditingController controller,
    String? hint,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(label, fontSize: 13, fontWeight: FontWeight.w500),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          validator: (v) => v == null || v.trim().isEmpty ? "$label is required" : null,
          textInputAction: maxLines == 1 ? TextInputAction.next : TextInputAction.done,
          onFieldSubmitted: (_) => _submit(),
          decoration: InputDecoration(
            hintText: hint,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _dropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(label, fontSize: 13, fontWeight: FontWeight.w500),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          initialValue: value,
          items: items.map(
            (e) => DropdownMenuItem(
              value: e,
              child: Text(e),
            ),
          ).toList(),
          onChanged: onChanged,
          borderRadius: BorderRadius.circular(10),
          menuMaxHeight: 400,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    );
  }
}
