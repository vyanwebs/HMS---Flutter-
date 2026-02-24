import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../controllers/Reception/patient_management_controller.dart';
import '../../models/patient_model.dart';
import '../../utils/buttons.dart';
import '../../utils/date_formatter.dart';
import '../../utils/snackbar.dart';
import '../../utils/string_utils.dart';
import '../../utils/text.dart';
import '../../widgets/doctor_panel/stat_card_widget.dart';
import '../../widgets/order_labs_dialog.dart';
import '../../widgets/transfer_patient_widget.dart';

class PatientManagement extends StatelessWidget {
  PatientManagement({super.key});

  final controller = Get.put(PatientManagementController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          
              /// ✅ CUSTOM STAT CARDS
              _statCards(),
          
              const SizedBox(height: 30),
          
              _tabs(),
          
              const SizedBox(height: 20),
          
              _searchBar(),
          
              const SizedBox(height: 20),
          
              Expanded(
                child: Obx(
                  () => controller.isAssignedTab.value
                    ? _assignedPatientsTable()
                    : _admittedPatientsTable(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _cards() {
    return [
      Obx(() => StatCardWidget(
        title: "Total Patients",
        value: controller.totalPatients.value.toString(),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF2C7EDB), Color(0xFFE1F0FF)],
        ),
        imagePath: 'assets/images/box1.png',
      )),

      Obx(() => StatCardWidget(
        title: "Assigned Patients",
        value: controller.assignedPatients.value.toString(),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF00B894), Color(0xFFE3FCFA)],
        ),
        imagePath: 'assets/images/box2.png',
      )),

      Obx(() => StatCardWidget(
        title: "Admitted Patients",
        value: controller.admittedPatients.value.toString(),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF00C9C9), Color(0xFFDFFFFF)],
        ),
        imagePath: 'assets/images/box3.png',
      )),
    ];
  }

  Widget _statCards() {
    return LayoutBuilder(
      builder: (context, constraints) {

        final isMobile = constraints.maxWidth < 900;

        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _cards()
              .map((card) => SizedBox(
                    width: isMobile
                        ? constraints.maxWidth
                        : (constraints.maxWidth / 3) - 12,
                    child: card,
                  ))
              .toList(),
        );
      },
    );
  }

  Widget _tabs() {
    return Obx(
      () => Row(
        children: [
          _tab(
            "Assigned Patients",
            controller.isAssignedTab.value,
            () => controller.changeTab(true),
          ),

          const SizedBox(width: 30),

          _tab(
            "Admitted Patients",
            !controller.isAssignedTab.value,
            () => controller.changeTab(false),
          ),
        ],
      ),
    );
  }

  Widget _tab(String title, bool active, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            AppText(
              title,
              fontWeight: FontWeight.w600,
              color: active ? Colors.black : Colors.grey,
            ),
            const SizedBox(height: 6),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 80,
              height: 3,
              color: active ? Colors.blue : Colors.transparent,
            )
          ],
        ),
      ),
    );
  }

  Widget _searchBar() {
    return Row(
      children: [
        Obx(
          () => Expanded(
            flex: 3,
            child: AppText(
              controller.isAssignedTab.value
                ? "Assigned Patients (${controller.patients.length})"
                : "Admitted Patients (${controller.patients.length})",
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          )
        ),
        const SizedBox(width: 14),
        Expanded(
          flex: 2,
          child: TextField(
            onChanged: controller.searchPatients,
            decoration: InputDecoration(
              hintText: "Search",
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        const SizedBox(width: 15),
        AppButton(
          onPressed: () {},
          text: "Filters",
          iconIsLast: false,
          icon: Icons.filter_list,
        )
      ],
    );
  }

  // =================== Assigned Patients ====================

  Widget _assignedPatientsTable() {
    return Obx(
      () => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          children: [
            /// HEADER BACKGROUND
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: const BoxDecoration(
                color: Color(0xffF3F4F6),
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: _tableHeader(),
            ),

            /// ROWS
            Expanded(
              child: Visibility(
                replacement: const Center(child: CircularProgressIndicator(),),
                visible: !controller.isLoading.value,
                child: Visibility(
                  replacement: const Center(child: AppText("No Data"),),
                  visible: controller.patients.isNotEmpty,
                  child: ListView.builder(
                    itemCount: controller.patients.length,
                    itemBuilder: (_, i) => _patientRow(controller.patients[i]),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tableHeader() {
    return const Row(
      children: [
        Expanded(flex: 1, child: AppText("Name")),
        SizedBox(width: 180, child: AppText("Patient ID")),
        SizedBox(width: 180, child: AppText("Age / Gender")),
        Expanded(flex: 1, child: AppText("Status")),
        Expanded(flex: 1, child: AppText("Actions")),
      ],
    );
  }

  Widget _patientRow(PatientModel p) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade200),
          ),
        ),
        child: Row(
          children: [
            /// NAME
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  AppText(
                    p.name,
                    fontWeight: FontWeight.w500,
                  ),
                ],
              ),
            ),

            /// PATIENT ID
            SizedBox(
              width: 180,
              child: AppText(p.patientId),
            ),

            /// AGE
            SizedBox(
              width: 180,
              child: AppText("${p.age}Y / ${p.gender}"),
            ),

            /// STATUS
            Expanded(
              flex: 1,
              child: _statusChip(p.currentAdmissionStatus),
            ),

            /// ACTIONS
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  AppButton(
                    text: "Transfer",
                    onPressed: () {
                      showDialog(
                        context: Get.context!,
                        barrierDismissible: false,
                        builder: (_) => TransferPatientDialog(
                          patientName: p.name,
                          patientId: p.patientId,
                          patientMongoId: p.id,
                        ),
                      );
                    },
                    isOutlined: true,
                    icon: Icons.compare_arrows,
                    iconIsLast: false,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  ),
                  const SizedBox(width: 12),
                  AppButton(
                    text: "Admit",
                    onPressed: () {
                      showDialog(
                        context: Get.context!,
                        barrierDismissible: false,
                        builder: (_) => AdmitPatientDialog(
                          patientName: p.name,
                          patientId: p.patientId,
                          patientMongoId: p.id,
                        ),
                      );
                    },
                    icon: Icons.person_add_alt,
                    iconIsLast: false,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =================== Admitted Patients ====================
  Widget _admittedPatientsTable() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        children: [
      
          /// HEADER
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: const BoxDecoration(
              color: Color(0xffF3F4F6),
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: const Row(
              children: [
                Expanded(flex: 1, child: AppText("Patient Details")),
                Expanded(child: AppText("Ward / Bed")),
                Expanded(child: AppText("Admission Date")),
                Expanded(flex: 1, child: AppText("Diagnosis")),
                Expanded(flex: 1, child: AppText("Status")),
                Expanded(flex: 2, child: AppText("Actions", textAlign: TextAlign.center,)),
              ],
            ),
          ),
      
          /// LIST
          Expanded(
            child: ListView.builder(
              itemCount: controller.patients.length,
              itemBuilder: (_, i) => _admittedPatientRow(controller.patients[i]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _admittedPatientRow(PatientModel p) {

    final ward = extractWardFromBedAssign(p.currentBedAssign);
    final bed = extractBedNumber(p.currentBedAssign);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
      
          /// PATIENT DETAILS
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(p.name, fontWeight: FontWeight.w600),
                const SizedBox(height: 4),
                AppText(
                  "${p.patientId}\n${p.age}Y • ${p.gender}",
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
      
          /// WARD BED
          Expanded(
            child: AppText("$ward / Bed $bed"),
          ),
      
          /// DATE
          Expanded(
            child: AppText(dateFromDateTime(p.registeredAt)),
          ),
      
          /// DIAGNOSIS
          Expanded(
            flex: 1,
            child: AppText(
              p.diagnosis?.diagnoses.isNotEmpty == true
                ? p.diagnosis!.diagnoses.map((e) => e.name).join(", ")
                : "-",
              maxLines: 3,
            ),
          ),
          const SizedBox(width: 4,),
      
          /// STATUS
          Expanded(flex: 1, child: _admitStatusChip(p.currentAdmissionStatus)),
      
          /// ACTIONS
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
      
                /// ORDER LABS
                InkWell(
                  onTap: () {
                    showDialog(
                      context: Get.context!,
                      builder: (_) => OrderLabsDialog(
                        patientName: p.name,
                        patientId: p.patientId,
                      ),
                    );
                  },
                  child: _actionButton("Order Labs")
                ),
      
                const SizedBox(width: 8),
      
                /// DISCHARGE
                AppButton(
                  text: "Discharge",
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  onPressed: () {},
                ),
      
                const SizedBox(width: 6),
                
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert),
                  color: Colors.white,

                  onSelected: (value) {
                    if (value == "transfer") {
                      showDialog(
                        context: Get.context!,
                        barrierDismissible: false,
                        builder: (_) => TransferPatientDialog(
                          patientName: p.name,
                          patientId: p.patientId,
                          patientMongoId: p.id,
                        ),
                      );
                    }
                  },

                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: "transfer",
                      child: Row(
                        children: [
                          Icon(Icons.compare_arrows, size: 18),
                          SizedBox(width: 10),
                          Text("Transfer Patient"),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _admitStatusChip(String? status) {

    final map = {
      "PENDING": Colors.orange,
      "ADMISSION_REQUESTED": Colors.deepPurple,
      "CONFIRMED": Colors.blue,
      "DISCHARGE_REQUESTED": Colors.green,
    };

    final color = map[status?.toUpperCase()] ?? Colors.grey;

    return Row(
      children: [
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withValues(alpha: 0.4)),
          ),
          child: AppText(
            status?.replaceAll("_", " ") ?? "-",
            fontSize: 12,
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _actionButton(String text) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: AppText(text, fontSize: 12),
    );
  }

  Widget _statusChip(String status) {
    final map = {
      "PENDING": Colors.orange,
      "EMERGENCY": Colors.red,
      "COMPLETED": Colors.green,
      "CANCELLED": Colors.grey,
    };

    final color = map[status.toUpperCase()] ?? Colors.blue;

    return Row(
      children: [
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withValues(alpha: 0.4)),
          ),
          child: AppText(
            status.capitalizeFirst ?? status,
            color: color,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

}

class AdmitPatientDialog extends StatefulWidget {
  final String patientName;
  final String patientId;
  final String patientMongoId;

  const AdmitPatientDialog({
    super.key,
    required this.patientName,
    required this.patientId,
    required this.patientMongoId,
  });

  @override
  State<AdmitPatientDialog> createState() => _AdmitPatientDialogState();
}

class _AdmitPatientDialogState extends State<AdmitPatientDialog> {

  /// CONTROLLERS
  final diagnosisController = TextEditingController();
  final bedController = TextEditingController();
  final notesController = TextEditingController();

  String? selectedWard;
  String priority = "ROUTINE";

  final wards = [
    "General Ward",
    "ICU",
    "CCU",
    "Private Room",
  ];

  /// ================= SUBMIT =================
  Future<void> _submit() async {

    if (selectedWard == null) {
      AppSnackbar.show(
        title: "Ward Required",
        message: "Please select ward",
        type: AppSnackType.warning,
      );
      return;
    }

    if (diagnosisController.text.trim().isEmpty) {
      AppSnackbar.show(
        title: "Diagnosis Required",
        message: "Enter preliminary diagnosis",
        type: AppSnackType.warning,
      );
      return;
    }

    final controller = Get.find<PatientManagementController>();

    Navigator.pop(context);

    await controller.admitPatient(
      patientMongoId: widget.patientMongoId,
      ward: selectedWard!,
      preferredBed: bedController.text,
      diagnosis: diagnosisController.text,
      priority: priority,
      notes: notesController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.enter): const ActivateIntent(),
        LogicalKeySet(LogicalKeyboardKey.escape): const DismissIntent(),
      },
      child: Actions(
        actions: {
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (_) => _submit(),
          ),
          DismissIntent: CallbackAction<DismissIntent>(
            onInvoke: (_) => Navigator.pop(context),
          ),
        },
        child: Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: SizedBox(
              width: 560,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                          
                  /// HEADER
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const AppText(
                        "Confirm IPD Admission Request",
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                      )
                    ],
                  ),
                          
                  AppText(
                    "Patient: ${widget.patientName} (${widget.patientId})",
                    color: Colors.grey,
                  ),
                          
                  const SizedBox(height: 18),
                          
                  /// INFO BOX
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.orange),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.orange),
                        SizedBox(width: 10),
                        Expanded(
                          child: AppText(
                            "This will create a pending admission request "
                            "sent to Reception for bed assignment.",
                            color: Colors.orange,
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                          
                  const SizedBox(height: 18),
                          
                  /// WARD
                  const AppText("Select Ward *"),
                  const SizedBox(height: 6),
                          
                  DropdownButtonFormField<String>(
                    value: selectedWard,
                    items: wards
                        .map((w) => DropdownMenuItem(
                              value: w,
                              child: Text(w),
                            ))
                        .toList(),
                    onChanged: (v) => setState(() => selectedWard = v),
                    decoration: const InputDecoration(
                      hintText: "Select a ward",
                    ),
                  ),
                          
                  const SizedBox(height: 16),
                          
                  /// BED
                  const AppText("Preferred Bed (Optional)"),
                  const SizedBox(height: 6),
                          
                  TextField(
                    controller: bedController,
                    decoration: const InputDecoration(
                      hintText: "e.g. CCU-101",
                    ),
                  ),
                          
                  const SizedBox(height: 16),
                          
                  /// DIAGNOSIS
                  const AppText("Preliminary Diagnosis *"),
                  const SizedBox(height: 6),
                          
                  TextField(
                    controller: diagnosisController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: "Enter preliminary diagnosis...",
                    ),
                  ),
                          
                  const SizedBox(height: 18),
                          
                  /// PRIORITY
                  const AppText("Priority Level *"),
                  const SizedBox(height: 10),
                          
                  Row(
                    children: [
                      _priorityButton("ROUTINE"),
                      _priorityButton("URGENT"),
                      _priorityButton("EMERGENCY"),
                    ],
                  ),
                          
                  const SizedBox(height: 18),
                          
                  /// NOTES
                  const AppText("Additional Notes"),
                  const SizedBox(height: 6),
                          
                  TextField(
                    controller: notesController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: "Any special instructions...",
                    ),
                  ),
                          
                  const SizedBox(height: 24),
                          
                  /// ACTIONS
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AppButton(
                        text: "Cancel",
                        onPressed: () => Navigator.pop(context),
                        isOutlined: true,
                      ),
                      const SizedBox(width: 12),
                      AppButton(
                        text: "Submit Admission Request",
                        onPressed: _submit,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// PRIORITY BUTTON
  Widget _priorityButton(String value) {
    final selected = priority == value;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(right: 8),
        child: InkWell(
          onTap: () => setState(() => priority = value),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: selected
                  ? Colors.blue.withOpacity(.15)
                  : Colors.grey.shade100,
              border: Border.all(
                color: selected ? Colors.blue : Colors.grey.shade300,
              ),
            ),
            child: AppText(
              value.capitalizeFirst!,
              color: selected ? Colors.blue : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}