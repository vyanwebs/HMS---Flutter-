import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../controllers/Reception/patient_management_controller.dart';
import '../../models/patient_model.dart';
import '../../utils/buttons.dart';
import '../../utils/snackbar.dart';
import '../../utils/text.dart';
import '../../widgets/doctor_panel/stat_card_widget.dart';
import '../../widgets/search_doctor_widget.dart';

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
          
              Expanded(child: _patientsTable()),
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

  Widget _patientsTable() {
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
                    onPressed: () {},
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

  Widget _tag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: AppText(
        text,
        fontSize: 11,
        color: color,
      ),
    );
  }

}

class TransferPatientDialog extends StatefulWidget {
  final String patientName;
  final String patientId;
  final String patientMongoId;

  const TransferPatientDialog({
    super.key,
    required this.patientName,
    required this.patientId,
    required this.patientMongoId
  });

  @override
  State<TransferPatientDialog> createState() => _TransferPatientDialogState();
}

class _TransferPatientDialogState extends State<TransferPatientDialog> {

  final TextEditingController searchController = TextEditingController();

  final TextEditingController reasonController = TextEditingController();

  int selectedDoctor = 0;
  String? doctorName;
  String? staffId;

  final FocusNode doctorFocus = FocusNode();
  final FocusNode reasonFocus = FocusNode();
  final FocusNode submitFocus = FocusNode();

  @override
  void dispose() {
    doctorFocus.dispose();
    reasonFocus.dispose();
    submitFocus.dispose();
    searchController.dispose();
    reasonController.dispose();
    super.dispose();
  }

  Future<void> _submitTransfer() async {

    if (doctorName == null || staffId == null) {
      AppSnackbar.show(
        title: "Doctor Required",
        message: "Please select doctor",
        type: AppSnackType.warning,
      );
      return;
    }

    final controller = Get.find<PatientManagementController>();

    Navigator.pop(context);

    await controller.transferPatient(
      patientMongoId: widget.patientMongoId,
      doctorName: doctorName!,
      staffId: staffId!,
      reason: reasonController.text,
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
            onInvoke: (_) => _submitTransfer(),
          ),
          DismissIntent: CallbackAction<DismissIntent>(
            onInvoke: (_) => Navigator.pop(context),
          ),
        },
        child: Focus(
          autofocus: true,
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            backgroundColor: Colors.white,
            child: SizedBox(
              width: 520,
              child: Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
          
                    /// TITLE
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const AppText(
                          "Transfer Patient to Another Doctor",
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
          
                    const SizedBox(height: 20),
          
                    /// SEARCH
                    const AppText("Search Doctor *"),
                    const SizedBox(height: 8),
          
                    DoctorSearchField(
                      focusNode: doctorFocus,
                      onDoctorSelected: (doctor) {
                        doctorName = doctor.name;
                        staffId = doctor.staffId;

                        /// auto move to reason field
                        reasonFocus.requestFocus();
                      },
                    ),
          
                    const SizedBox(height: 18),
          
                    const AppText("Reason for Transfer (Optional)"),
                    const SizedBox(height: 8),
          
                    TextField(
                      controller: reasonController,
                      focusNode: reasonFocus,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _submitTransfer(),
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: "Enter reason for transfer...",
                        filled: true,
                        fillColor: const Color(0xffF5F6F7),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
          
                    const SizedBox(height: 22),
          
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
                          text: "Transfer Patient",
                          icon: Icons.swap_horiz,
                          iconIsLast: false,
                          onPressed: _submitTransfer,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
