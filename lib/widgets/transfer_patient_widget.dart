import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../controllers/Reception/patient_management_controller.dart';
import '../utils/buttons.dart';
import '../utils/snackbar.dart';
import '../utils/text.dart';
import 'search_doctor_widget.dart';

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