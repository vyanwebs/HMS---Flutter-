import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mdi_icons/flutter_mdi_icons.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../controllers/Doctor/patient_details_controllers.dart';
import '../../controllers/Doctor/patient_details_diagnosis_controllers.dart';
import '../../controllers/Doctor/symptom_controllers.dart';
import '../../controllers/Doctor/vitals_controllers.dart';
import '../../helper_resposive_class/responsive_layout.dart';
import '../../models/patient_model.dart';
import '../../utils/buttons.dart';
import '../../utils/constants.dart';
import '../../utils/date_formatter.dart';
import '../../utils/enums.dart';
import '../../utils/images.dart';
import '../../utils/text.dart';
import '../../widgets/new_investigation_request.dart';
import '../main_dashboard.dart';
import 'discharge_summary.dart';
import 'e_prescriptions.dart';
import 'monitoring/patient_details_symptoms.dart';
import 'monitoring/patient_details_consultation.dart';
import 'monitoring/patient_details_diagnosis.dart';
import 'monitoring/patient_details_followup.dart';
import 'monitoring/patient_details_prescription.dart';
import 'monitoring/patient_details_vitals_monitoring.dart';
import 'patient_certificate_screen.dart';
import 'patient_details_investigation.dart';
import 'patient_details_surgical_notes.dart';
import 'patient_details_treatment.dart';

class PatientDetails extends StatefulWidget {
  final PatientModel patient;

  const PatientDetails({super.key, required this.patient});

  @override
  State<PatientDetails> createState() => _PatientDetailsState();
}

class _PatientDetailsState extends State<PatientDetails> {
  final patientDetailsController = Get.put(PatientDetailsControllers());

  final vitalsController = Get.put(VitalsControllers());
  final symptomController = Get.put(SymptomControllers());
  final diagnosisController = Get.put(DiagnosisControllers());

  @override
  void initState() {
    super.initState();
    vitalsController.fetchVitals(patientMongoId: widget.patient.id);
    symptomController.fetchSymptoms(widget.patient.id, sort: "newest");
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: desktopView(context),
      tablet: desktopView(context),
      desktop: desktopView(context),
    );
  }

  void _showInvestigationDialog() {
  showDialog(
    context: Get.context!,
    barrierDismissible: false,
    builder: (_) => InvestigationRequestDialog(patient: widget.patient),
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
                  onPressed: () => _openDoctorNotesPanel(),
                  backgroundColor: AppColors.info,
                  child: const Icon(Icons.note_alt_outlined, color: Colors.white),
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

        /// 🔵 FIXED TOP (Logo + App Name)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Row(
            children: [
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
                      return Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF2383E2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.medical_services,
                          color: Colors.white,
                          size: 24,
                        ),
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

        /// 🔵 SCROLLABLE MIDDLE SECTION
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [

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
                        Icon(Icons.home_outlined, color: Colors.grey),
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

                /// Monitoring Expandable (Your Obx stays same)
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

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),

        /// 🔵 FIXED BOTTOM BACK BUTTON
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: Colors.grey.shade200),
            ),
            color: Colors.white,
          ),
          child: InkWell(
            onTap: () => Get.back(),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.arrow_back,
                    color: AppColors.doctor, size: 22),
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
              Expanded(
                child: AppText(
                  title,
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? AppColors.info : Colors.black87,
                ),
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
              Expanded(
                child: AppText(
                  title,
                  color: isSelected ? Colors.white : Colors.black87,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
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
          return PatientDetailsVitalsMonitoring(patient: widget.patient);

        case PatientDetailsMenu.monitoringSymptoms:
          return PatientDetailsSymptoms(patient: widget.patient);

        case PatientDetailsMenu.monitoringFollowUps:
          return PatientDetailsFollowUps(patient: widget.patient,);

        case PatientDetailsMenu.monitoringPrescription:
          return PatientDetailsPrescription(patient: widget.patient);

        case PatientDetailsMenu.monitoringConsultation:
          return PatientDetailsConsultationPage(patient: widget.patient);

        case PatientDetailsMenu.monitoringDiagnosis:
          return PatientDetailsDiagnosis(patient: widget.patient);

        case PatientDetailsMenu.treatment:
          return PatientDetailsTreatment(patient: widget.patient,);

        case PatientDetailsMenu.investigation:
          return PatientDetailsInvestigationPage(patient: widget.patient,);

        case PatientDetailsMenu.surgicalNotes:
          return PatientDetailsSurgicalNotes(patient: widget.patient,);

        case PatientDetailsMenu.ePrescription:
          return PatientDetailsEPrescription(patient: widget.patient,);

        case PatientDetailsMenu.dischargeSummary:
          return DischargeSummary(patient: widget.patient);
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
                  widget.patient.name,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                AppText(
                  "ID: ${widget.patient.patientId} : Age-${widget.patient.age} : ${widget.patient.gender}",
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
                        "ID: ${widget.patient.patientId} : Age-${widget.patient.age} : ${widget.patient.gender}",
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
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: admissionCard()),
                const SizedBox(width: 16),
                Expanded(child: vitalsCard(context)),
              ],
            ),
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

          infoRow("Date", dateFromDateTime(widget.patient.createdAt)),
          infoRow("Reason", widget.patient.admissionReason),
          Obx(() {
            final records = symptomController.allSymptomRecords;

            final latestSymptom = records.isNotEmpty && records.first.symptoms.isNotEmpty
              ? records.first.symptoms.first.name
              : "No symptoms";

            return infoRow("Symptoms", latestSymptom);
          }),

          const SizedBox(height: 6),
          AppText(
            widget.patient.timeAgo,
            fontSize: 11,
            color: AppColors.greyText,
          ),

          const Spacer(),

          SizedBox(
            width: double.infinity,
            child: AppButton(
              onPressed: () {
                // Expand monitoring section
                patientDetailsController.isMonitoringExpanded.value = true;

                // Switch to Symptoms screen
                patientDetailsController.selectedMenu.value = PatientDetailsMenu.monitoringSymptoms;
              },
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
    return Obx(() {
      if (vitalsController.vitals.isEmpty) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const AppText(
            "No vitals recorded",
            fontSize: 13,
            color: AppColors.greyText,
          ),
        );
      }

      final latest = vitalsController.vitals.first;

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
              "Latest vital's",
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            const SizedBox(height: 12),

            vitalRow("BP", latest.bp),
            vitalRow("Pulse", latest.pulse.toString()),
            vitalRow("Temp", latest.temperature.toString()),
            vitalRow("SpO₂", latest.spo2.toString()),

            const SizedBox(height: 6),

            AppText(
              _formatTimeAgo(latest.recordedAt),
              fontSize: 11,
              color: AppColors.greyText,
            ),

            const SizedBox(height: 14),

            SizedBox(
              width: double.infinity,
              child: AppButton(
                onPressed: () {
                  patientDetailsController.isMonitoringExpanded.value = true;
                  patientDetailsController.selectedMenu.value =
                      PatientDetailsMenu.monitoringVitals;
                },
                text: "Add Vitals",
                iconIsLast: false,
                icon: Icons.add,
              ),
            )
          ],
        ),
      );
    });
  }

  String _formatTimeAgo(DateTime? date) {
    if (date == null) return "Just now";

    final diff = DateTime.now().difference(date);

    if (diff.inMinutes < 1) return "Just now";
    if (diff.inMinutes < 60) return "${diff.inMinutes} min ago";
    if (diff.inHours < 24) return "${diff.inHours} hr ago";
    if (diff.inDays == 1) return "1 day ago";

    return "${diff.inDays} days ago";
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
          onTap: () => Get.to(() => CertificateScreen(patient: widget.patient)),
        ),

        actionItem(
          icon: Icons.note_add_outlined,
          label: "Prescription",
          color: Colors.orange,
          onTap: () {
            // Expand monitoring section
            patientDetailsController.isMonitoringExpanded.value = true;

            // Switch to Symptoms screen
            patientDetailsController.selectedMenu.value = PatientDetailsMenu.monitoringPrescription;
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
              builder: (_) => AdmitPatientDialog(patient: widget.patient),
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
              builder: (_) => InvestigationRequestDialog(patient: widget.patient),
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
  required RxList<String> selectedList,
  required Function(String) onAdd,
  required Function(String) onToggle,
  required VoidCallback onSubmit,
}) {
  final controller = TextEditingController();
  final formKey = GlobalKey<FormState>();

  void submitSingle() {
    if (formKey.currentState!.validate()) {
      onAdd(controller.text.trim());
      controller.clear();
    }
  }

  return Obx(
    () => Container(
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
                  onPressed: onSubmit,
                  text: buttonText,
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                  borderRadius: 6,
                ),
              ],
            ),

            const SizedBox(height: 14),

            /// Input
            TextFormField(
              controller: controller,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => submitSingle(),
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return "Enter value";
                }
                return null;
              },
              decoration: InputDecoration(
                hintText: hintText,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),

            const SizedBox(height: 12),

            /// Available chips
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: chips.map((chip) {
                final isSelected = selectedList.contains(chip);

                return GestureDetector(
                  onTap: () => onToggle(chip),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isSelected
                        ? AppColors.info
                        : AppColors.info.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: AppText(
                      chip,
                      fontSize: 11,
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 14),

            /// Selected items preview
            if (selectedList.isNotEmpty)
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: selectedList.map((item) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AppText(item, fontSize: 11),
                        const SizedBox(width: 6),
                        GestureDetector(
                          onTap: () => selectedList.remove(item),
                          child: const Icon(Icons.close, size: 14),
                        )
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ));
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
    final symptomController = Get.find<SymptomControllers>();

    return managementCard(
      title: "Symptom management",
      buttonText: "Add Symptoms",
      hintText: "Enter symptom",
      chips: symptomController.availableSymptoms,
      selectedList: symptomController.selectedSymptoms,
      onAdd: symptomController.addCustomSymptom,
      onToggle: symptomController.toggleSymptom,
      onSubmit: () {
        symptomController.createSymptoms(
          patientMongoId: widget.patient.id,
          symptoms: symptomController.selectedSymptoms.toList(),
        );
      },
    );
  }

  Widget diagnosisManagement() {

    return managementCard(
      title: "Diagnosis management",
      buttonText: "Add Diagnosis",
      hintText: "Enter diagnosis",
      chips: [
        "Viral Fever",
        "Bacterial Infection",
        "Fever",
        "Chills",
        "Fatigue",
      ],
      selectedList: diagnosisController.selectedDiagnoses,
      onAdd: diagnosisController.addCustomDiagnosis,
      onToggle: diagnosisController.toggleDiagnosis,
      onSubmit: () {
        diagnosisController.createDiagnoses(
          patientMongoId: widget.patient.id,
          diagnoses:
              diagnosisController.selectedDiagnoses.toList(),
        );
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
                  "ID: ${widget.patient.patientId} : Age-${widget.patient.age} : ${widget.patient.gender}",
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
      patientMongoId: widget.patient.id,
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

  void _openDoctorNotesPanel() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "DoctorNotes",
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) {
        return Align(
          alignment: Alignment.centerRight,
          child: Container(
            width: 420,
            height: double.infinity,
            color: Colors.white,
            child: _doctorNotesPanel(),
          ),
        );
      },
      transitionBuilder: (_, animation, __, child) {
        final offset =
            Tween(begin: const Offset(1, 0), end: Offset.zero)
                .animate(animation);

        return SlideTransition(position: offset, child: child);
      },
    );
  }

  Widget _doctorNotesPanel() {
    return Column(
      children: [
        /// Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          decoration: const BoxDecoration(
            color: AppColors.info
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.edit_note,
                      color: Colors.white),
                  SizedBox(width: 10),
                  Text(
                    "Doctor Notes",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.close,color: Colors.white),
                onPressed: () => Get.back(),
              )
            ],
          ),
        ),

        /// Content
        Expanded(
          child: Center(
            child: Text(
              "No notes yet",
              style: TextStyle(
                color: Colors.grey.shade500,
              ),
            ),
          ),
        ),

        /// Floating Add Button
        Padding(
          padding: const EdgeInsets.all(20),
          child: Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              onPressed: () => _openAddDoctorNoteDialog(),
              backgroundColor: AppColors.info,
              child: const Icon(Icons.add, color: Colors.white,),
            ),
          ),
        )
      ],
    );
  }

  void _openAddDoctorNoteDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final TextEditingController noteCtrl = TextEditingController();

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          backgroundColor: Colors.white,
          child: Container(
            width: 500,
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// Header
                const Row(
                  children: [
                    Icon(Icons.note_add, color: AppColors.info),
                    SizedBox(width: 10),
                    Text(
                      "Add Doctor Note",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                /// Input
                const Text(
                  "Note Content",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),

                const SizedBox(height: 8),

                TextField(
                  controller: noteCtrl,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: "Enter your note here",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                /// Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancel"),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.info,
                      ),
                      onPressed: () {
                        if (noteCtrl.text.trim().isEmpty) return;

                        // 🔹 Call your API here
                        print(noteCtrl.text);

                        Navigator.pop(context); // close dialog
                      },
                      child: const Text("Save Note"),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
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
