// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';

// import '../../models/patient_model.dart';
// import '../../utils/buttons.dart';
// import '../../utils/constants.dart';
// import '../../utils/snackbar.dart';
// import '../../utils/text.dart';
// import '../controllers/Doctor/investigation_controller.dart';

// class InvestigationRequestDialog extends StatefulWidget {
//   final PatientModel patient;
//   final String? doctorMongoId;

//   const InvestigationRequestDialog({
//     super.key,
//     required this.patient,
//     this.doctorMongoId,
//   });

//   @override
//   State<InvestigationRequestDialog> createState() => _InvestigationRequestDialogState();
// }

// class _InvestigationRequestDialogState extends State<InvestigationRequestDialog> {
//   final _formKey = GlobalKey<FormState>();
//   final InvestigationController investigationController = Get.put(InvestigationController());

//   // Use dedicated variables for dropdowns instead of TextEditingController
//   String _investigationType = 'X-Ray';
//   String _priority = 'Routine';
//   String _insuranceStatus = 'Pending';
//   String _paymentStatus = 'Pending';

//   // Text controllers for free-text fields
//   final reasonCtrl = TextEditingController();
//   final historyCtrl = TextEditingController();
//   final tagsCtrl = TextEditingController();
//   final investigationDetailsCtrl = TextEditingController();
//   final scheduleCtrl = TextEditingController();

//   bool insuranceCovered = false;
//   DateTime? selectedDateTime;

//   @override
//   void dispose() {
//     reasonCtrl.dispose();
//     historyCtrl.dispose();
//     tagsCtrl.dispose();
//     investigationDetailsCtrl.dispose();
//     scheduleCtrl.dispose();
//     super.dispose();
//   }

//   Future<void> _pickDateTime() async {
//     final now = DateTime.now();

//     final pickedDate = await showDatePicker(
//       context: context,
//       initialDate: now,
//       firstDate: DateTime.now(),
//       lastDate: DateTime(now.year + 5),
//     );

//     if (pickedDate == null) return;

//     final pickedTime = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.fromDateTime(now),
//     );

//     if (pickedTime == null) return;

//     // If the selected date is today, ensure time is in the future
//     if (pickedDate.year == now.year &&
//         pickedDate.month == now.month &&
//         pickedDate.day == now.day) {
//       final selectedTimeInMinutes = pickedTime.hour * 60 + pickedTime.minute;
//       final currentTimeInMinutes = now.hour * 60 + now.minute;

//       if (selectedTimeInMinutes <= currentTimeInMinutes) {
//         AppSnackbar.show(
//           title: "Invalid Time",
//           message: "Please select a future time",
//           type: AppSnackType.error,
//         );
//         return;
//       }
//     }

//     final combined = DateTime(
//       pickedDate.year,
//       pickedDate.month,
//       pickedDate.day,
//       pickedTime.hour,
//       pickedTime.minute,
//     );

//     setState(() {
//       selectedDateTime = combined;
//       scheduleCtrl.text = _formatForDisplay(combined);
//     });
//   }

//   String _formatForDisplay(DateTime dateTime) {
//     final date = "${_monthName(dateTime.month)} ${dateTime.day.toString().padLeft(2, '0')}, ${dateTime.year}";
//     final time = TimeOfDay.fromDateTime(dateTime).format(context);
//     return "$date – $time";
//   }

//   String _monthName(int month) {
//     const months = [
//       "Jan", "Feb", "Mar", "Apr", "May", "Jun",
//       "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
//     ];
//     return months[month - 1];
//   }

//   String _getDoctorMongoId() {
//     if (widget.doctorMongoId != null && widget.doctorMongoId!.isNotEmpty) {
//       return widget.doctorMongoId!;
//     }
//     // Fallback – you might want to get this from a user session instead
//     return "697c929c30e0981185ef355e";
//   }

//   String formatDateWithOffset(DateTime dateTime) {
//     final local = dateTime.toLocal();
//     final offset = local.timeZoneOffset;

//     final sign = offset.isNegative ? '-' : '+';
//     final hours = offset.inHours.abs().toString().padLeft(2, '0');
//     final minutes = (offset.inMinutes.abs() % 60).toString().padLeft(2, '0');

//     return '${local.year.toString().padLeft(4, '0')}-'
//         '${local.month.toString().padLeft(2, '0')}-'
//         '${local.day.toString().padLeft(2, '0')}T'
//         '${local.hour.toString().padLeft(2, '0')}:'
//         '${local.minute.toString().padLeft(2, '0')}:00'
//         '$sign$hours:$minutes';
//   }


//   void _submit() async {
//     if (!_formKey.currentState!.validate()) return;

//     if (selectedDateTime == null) {
//       AppSnackbar.show(
//         title: "Error",
//         message: "Please select schedule date & time",
//         type: AppSnackType.error,
//       );
//       return;
//     }

//     final doctorMongoId = _getDoctorMongoId();
//     if (doctorMongoId.isEmpty) {
//       AppSnackbar.show(
//         title: "Error",
//         message: "Doctor ID is missing",
//         type: AppSnackType.error,
//       );
//       return;
//     }

//     final String formattedDate = formatDateWithOffset(selectedDateTime!);

//     print("🔵 Original selected DateTime: $selectedDateTime");
//     print("🔵 Formatted date being sent: $formattedDate");

//     final success = await investigationController.createInvestigation(
//       patientMongoId: widget.patient.id,
//       patientId: widget.patient.patientId,
//       doctorMongoId: doctorMongoId,
//       investigationType: _investigationType,
//       priority: _priority,
//       scheduledDateAndTime: formattedDate,
//       reasonForInvestigation: reasonCtrl.text,
//       clinicalHistory: historyCtrl.text,
//       investigationDetails: investigationDetailsCtrl.text,
//       tags: tagsCtrl.text,
//       insuranceStatus: _insuranceStatus,
//       paymentStatus: _paymentStatus,
//       insuranceCovered: insuranceCovered,
//     );

//     if (success && mounted) {
//       Get.back();
//     }
//   }


//   @override
//   Widget build(BuildContext context) {
//     return Shortcuts(
//       shortcuts: {
//         LogicalKeySet(LogicalKeyboardKey.escape):  EscapeIntent(),
//         LogicalKeySet(LogicalKeyboardKey.enter):  AcceptIntent(),
//       },
//       child: Actions(
//         actions: {
//           EscapeIntent: CallbackAction<EscapeIntent>(
//             onInvoke: (_) {
//               Get.back();
//               return null;
//             },
//           ),
//           AcceptIntent: CallbackAction<AcceptIntent>(
//             onInvoke: (_) {
//               _submit();
//               return null;
//             },
//           ),
//         },
//         child: Dialog(
//           insetPadding: const EdgeInsets.all(32),
//           backgroundColor: Colors.white,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
//           child: SizedBox(
//             width: 980,
//             child: Padding(
//               padding: const EdgeInsets.all(24),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _patientCard(),
//                   const SizedBox(width: 30),
//                   Expanded(child: _form()),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _patientCard() {
//     return Container(
//       width: 260,
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.grey.shade300),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           CircleAvatar(
//             radius: 55,
//             backgroundColor: AppColors.info.withValues(alpha: 0.15),
//             child: Text(
//               widget.patient.initials,
//               style: const TextStyle(
//                 fontSize: 28,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           const SizedBox(height: 16),
//           AppText(
//             widget.patient.name,
//             fontSize: 18,
//             fontWeight: FontWeight.w600,
//           ),
//           const SizedBox(height: 4),
//           AppText(
//             "Pat Id : ${widget.patient.patientId}",
//             fontSize: 12,
//             color: AppColors.greyText,
//           ),
//           if (widget.patient.currentAdmissionCode != null)
//             AppText(
//               "Adm Id : ${widget.patient.currentAdmissionCode}",
//               fontSize: 12,
//               color: AppColors.greyText,
//             ),
//           const SizedBox(height: 12),
//           AppText("Gender : ${widget.patient.gender}", fontSize: 12),
//           AppText("Age : ${widget.patient.age} years", fontSize: 12),
//         ],
//       ),
//     );
//   }

//   Widget _form() {
//     return Form(
//       key: _formKey,
//       child: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const AppText(
//                   "New investigation request",
//                   fontSize: 20,
//                   fontWeight: FontWeight.w600,
//                 ),
//                 const SizedBox(height: 20),

//                 Row(
//                   children: [
//                     Expanded(
//                       child: _dropdown(
//                         label: "Investigation type",
//                         value: _investigationType,
//                         items: const [
//                           "X-Ray",
//                           "MRI",
//                           "CT Scan",
//                           "Ultrasound",
//                           "CT PNS",
//                           "Nasal Endoscopy",
//                           "Laryngoscopy",
//                           "Glucose Tolerance Test",
//                           "DEXA Scan",
//                           "VEP",
//                           "SSEP",
//                           "BAER",
//                           "Breath Test",
//                           "Blood Test",
//                           "Urine Test",
//                           "Other",
//                         ],
//                         onChanged: (v) {
//                           if (v != null) {
//                             setState(() => _investigationType = v);
//                           }
//                         },
//                       ),
//                     ),
//                     const SizedBox(width: 16),
//                     Expanded(
//                       child: _dropdown(
//                         label: "Priority",
//                         value: _priority,
//                         items: const ["Routine", "Urgent", "STAT"],
//                         onChanged: (v) {
//                           if (v != null) {
//                             setState(() => _priority = v);
//                           }
//                         },
//                       ),
//                     ),
//                   ],
//                 ),

//                 const SizedBox(height: 16),

//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const AppText(
//                       "Schedule date and time",
//                       fontSize: 13,
//                       fontWeight: FontWeight.w500,
//                     ),
//                     const SizedBox(height: 6),
//                     TextFormField(
//                       controller: scheduleCtrl,
//                       readOnly: true,
//                       validator: (v) =>
//                           v == null || v.isEmpty ? "Schedule date and time is required" : null,
//                       onTap: _pickDateTime,
//                       decoration: InputDecoration(
//                         hintText: "Select date & time",
//                         suffixIcon: const Icon(Icons.calendar_today_outlined),
//                         contentPadding:
//                             const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),

//                 const SizedBox(height: 16),

//                 _input(
//                   label: "Reason for investigation",
//                   controller: reasonCtrl,
//                   hint: "Enter reason",
//                 ),

//                 const SizedBox(height: 16),

//                 _input(
//                   label: "Clinical history",
//                   controller: historyCtrl,
//                   hint: "Enter clinical history",
//                   maxLines: 3,
//                 ),

//                 const SizedBox(height: 16),

//                 _input(
//                   label: "Investigation Details",
//                   controller: investigationDetailsCtrl,
//                   hint: "Enter investigation details",
//                   maxLines: 2,
//                 ),

//                 const SizedBox(height: 16),

//                 _input(
//                   label: "Tags (comma separated)",
//                   controller: tagsCtrl,
//                   hint: "eg Cancer, Blood, Infection",
//                   maxLines: 2,
//                 ),

//                 const SizedBox(height: 16),

//                 // _dropdown(
//                 //   label: "Insurance Status",
//                 //   value: _insuranceStatus,
//                 //   items: const ["Pending", "Approved", "Rejected", "Scheduled"],
//                 //   onChanged: (v) {
//                 //     if (v != null) {
//                 //       setState(() => _insuranceStatus = v);
//                 //     }
//                 //   },
//                 // ),

//                 // const SizedBox(height: 16),

//                 // _dropdown(
//                 //   label: "Payment Status",
//                 //   value: _paymentStatus,
//                 //   items: const ["Pending", "Paid", "Cancelled", "Refunded"],
//                 //   onChanged: (v) {
//                 //     if (v != null) {
//                 //       setState(() => _paymentStatus = v);
//                 //     }
//                 //   },
//                 // ),

//                 // const SizedBox(height: 16),

//                 // Row(
//                 //   children: [
//                 //     Checkbox(
//                 //       value: insuranceCovered,
//                 //       onChanged: (value) {
//                 //         setState(() {
//                 //           insuranceCovered = value ?? false;
//                 //         });
//                 //       },
//                 //       activeColor: AppColors.info,
//                 //     ),
//                 //     const SizedBox(width: 8),
//                 //     const AppText(
//                 //       "Insurance Covered",
//                 //       fontSize: 14,
//                 //     ),
//                 //   ],
//                 // ),
//               ],
//             ),

//             const SizedBox(height: 24),

//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 AppButton(
//                   text: "Close",
//                   backgroundColor: Colors.grey.shade600,
//                   onPressed: () => Get.back(),
//                 ),
//                 const SizedBox(width: 12),
//                 Obx(
//                   () => AppButton(
//                     text: investigationController.isLoading.value
//                         ? "Creating..."
//                         : "Create investigation",
//                     backgroundColor: AppColors.info,
//                     textColor: Colors.white,
//                     onPressed: investigationController.isLoading.value
//                         ? () {} // disabled
//                         : _submit,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _input({
//     required String label,
//     required TextEditingController controller,
//     String? hint,
//     int maxLines = 1,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         AppText(label, fontSize: 13, fontWeight: FontWeight.w500),
//         const SizedBox(height: 6),
//         TextFormField(
//           controller: controller,
//           maxLines: maxLines,
//           validator: (v) => v == null || v.trim().isEmpty ? "$label is required" : null,
//           textInputAction: maxLines == 1 ? TextInputAction.next : TextInputAction.done,
//           onFieldSubmitted: (_) {
//             if (maxLines == 1) {
//               FocusScope.of(context).nextFocus();
//             } else {
//               _submit();
//             }
//           },
//           decoration: InputDecoration(
//             hintText: hint,
//             contentPadding:
//                 const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _dropdown({
//     required String label,
//     required String value,
//     required List<String> items,
//     required ValueChanged<String?> onChanged,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         AppText(label, fontSize: 13, fontWeight: FontWeight.w500),
//         const SizedBox(height: 6),
//         DropdownButtonFormField<String>(
//           value: value,
//           items: items.map(
//             (e) => DropdownMenuItem(
//               value: e,
//               child: Text(e),
//             ),
//           ).toList(),
//           onChanged: onChanged,
//           borderRadius: BorderRadius.circular(10),
//           menuMaxHeight: 400,
//           decoration: InputDecoration(
//             border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class EscapeIntent extends Intent {}
// class AcceptIntent extends Intent {}


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../models/investigation_model.dart';          // new import
import '../../models/patient_model.dart';
import '../../utils/buttons.dart';
import '../../utils/constants.dart';
import '../../utils/snackbar.dart';
import '../../utils/text.dart';
import '../controllers/Doctor/investigation_controller.dart';

class InvestigationRequestDialog extends StatefulWidget {
  final PatientModel patient;
  final String? doctorMongoId;
  final InvestigationModel? investigation;   // new optional parameter

  const InvestigationRequestDialog({
    super.key,
    required this.patient,
    this.doctorMongoId,
    this.investigation,                       // new
  });

  @override
  State<InvestigationRequestDialog> createState() => _InvestigationRequestDialogState();
}

class _InvestigationRequestDialogState extends State<InvestigationRequestDialog> {
  final _formKey = GlobalKey<FormState>();
  final InvestigationController investigationController = Get.find<InvestigationController>();

  // Determine if we are in edit mode
  bool get isEditMode => widget.investigation != null;

  // Use dedicated variables for dropdowns
  String _investigationType = 'X-Ray';
  String _priority = 'Routine';
  String _insuranceStatus = 'Pending';
  String _paymentStatus = 'Pending';

  // Text controllers for free-text fields
  final reasonCtrl = TextEditingController();
  final historyCtrl = TextEditingController();
  final tagsCtrl = TextEditingController();
  final investigationDetailsCtrl = TextEditingController();
  final scheduleCtrl = TextEditingController();

  bool insuranceCovered = false;
  DateTime? selectedDateTime;

@override
void initState() {
  super.initState();
  if (isEditMode) {
    _populateFields();
    // Set the schedule text after the first frame to avoid context issues
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && selectedDateTime != null) {
        scheduleCtrl.text = _formatForDisplay(selectedDateTime!);
      }
    });
  }
}

void _populateFields() {
  final inv = widget.investigation!;
  _investigationType = inv.investigationType;
  _priority = inv.priority;
  _insuranceStatus = inv.insuranceStatus;
  _paymentStatus = inv.paymentStatus ?? 'Pending';
  insuranceCovered = inv.insuranceCovered;
  reasonCtrl.text = inv.reasonForInvestigation ?? '';
  historyCtrl.text = inv.clinicalHistory ?? '';
  tagsCtrl.text = inv.tags ?? '';
  investigationDetailsCtrl.text = inv.investigationDetails ?? '';

  // scheduledDateAndTime is a DateTime, assign directly
  if (inv.scheduledDateAndTime != null) {
    selectedDateTime = inv.scheduledDateAndTime;               // ✅ no parsing
  }
}


  @override
  void dispose() {
    reasonCtrl.dispose();
    historyCtrl.dispose();
    tagsCtrl.dispose();
    investigationDetailsCtrl.dispose();
    scheduleCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final now = DateTime.now();

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDateTime ?? now,
      firstDate: DateTime.now(),
      lastDate: DateTime(now.year + 5),
    );

    if (pickedDate == null) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedDateTime != null
          ? TimeOfDay.fromDateTime(selectedDateTime!)
          : TimeOfDay.fromDateTime(now),
    );

    if (pickedTime == null) return;

    // If the selected date is today, ensure time is in the future
    if (pickedDate.year == now.year &&
        pickedDate.month == now.month &&
        pickedDate.day == now.day) {
      final selectedTimeInMinutes = pickedTime.hour * 60 + pickedTime.minute;
      final currentTimeInMinutes = now.hour * 60 + now.minute;

      if (selectedTimeInMinutes <= currentTimeInMinutes) {
        AppSnackbar.show(
          title: "Invalid Time",
          message: "Please select a future time",
          type: AppSnackType.error,
        );
        return;
      }
    }

    final combined = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    setState(() {
      selectedDateTime = combined;
      scheduleCtrl.text = _formatForDisplay(combined);
    });
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

  String _getDoctorMongoId() {
    if (widget.doctorMongoId != null && widget.doctorMongoId!.isNotEmpty) {
      return widget.doctorMongoId!;
    }
    // Fallback – you might want to get this from a user session instead
    return "697c929c30e0981185ef355e";
  }

  String formatDateWithOffset(DateTime dateTime) {
    final local = dateTime.toLocal();
    final offset = local.timeZoneOffset;

    final sign = offset.isNegative ? '-' : '+';
    final hours = offset.inHours.abs().toString().padLeft(2, '0');
    final minutes = (offset.inMinutes.abs() % 60).toString().padLeft(2, '0');

    return '${local.year.toString().padLeft(4, '0')}-'
        '${local.month.toString().padLeft(2, '0')}-'
        '${local.day.toString().padLeft(2, '0')}T'
        '${local.hour.toString().padLeft(2, '0')}:'
        '${local.minute.toString().padLeft(2, '0')}:00'
        '$sign$hours:$minutes';
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (selectedDateTime == null) {
      AppSnackbar.show(
        title: "Error",
        message: "Please select schedule date & time",
        type: AppSnackType.error,
      );
      return;
    }

    final doctorMongoId = _getDoctorMongoId();
    if (doctorMongoId.isEmpty) {
      AppSnackbar.show(
        title: "Error",
        message: "Doctor ID is missing",
        type: AppSnackType.error,
      );
      return;
    }

    final String formattedDate = formatDateWithOffset(selectedDateTime!);

    bool success;
    if (isEditMode) {
      // EDIT: call update API
      success = await investigationController.updateInvestigation(
        investigationId: widget.investigation!.id,
        patientMongoId: widget.patient.id,
        data: {
          'investigationType': _investigationType,
          'priority': _priority,
          'scheduledDateAndTime': formattedDate,
          'reasonForInvestigation': reasonCtrl.text,
          'clinicalHistory': historyCtrl.text,
          'investigationDetails': investigationDetailsCtrl.text,
          'tags': tagsCtrl.text,
          'insuranceStatus': _insuranceStatus,
          'paymentStatus': _paymentStatus,
          'insuranceCovered': insuranceCovered,
          // doctorMongoId is usually not changed, but you can include it if needed
          'doctorMongoId': doctorMongoId,
        },
      );
    } else {
      // CREATE: call create API
      success = await investigationController.createInvestigation(
        patientMongoId: widget.patient.id,
        patientId: widget.patient.patientId,
        doctorMongoId: doctorMongoId,
        investigationType: _investigationType,
        priority: _priority,
        scheduledDateAndTime: formattedDate,
        reasonForInvestigation: reasonCtrl.text,
        clinicalHistory: historyCtrl.text,
        investigationDetails: investigationDetailsCtrl.text,
        tags: tagsCtrl.text,
        insuranceStatus: _insuranceStatus,
        paymentStatus: _paymentStatus,
        insuranceCovered: insuranceCovered,
      );
    }

    if (success && mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
      shortcuts: {
        LogicalKeySet(LogicalKeyboardKey.escape): EscapeIntent(),
        LogicalKeySet(LogicalKeyboardKey.enter): AcceptIntent(),
      },
      child: Actions(
        actions: {
          EscapeIntent: CallbackAction<EscapeIntent>(
            onInvoke: (_) {
              Get.back();
              return null;
            },
          ),
          AcceptIntent: CallbackAction<AcceptIntent>(
            onInvoke: (_) {
              _submit();
              return null;
            },
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
          if (widget.patient.currentAdmissionCode != null)
            AppText(
              "Adm Id : ${widget.patient.currentAdmissionCode}",
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

  Widget _form() {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title changes based on mode
                AppText(
                  isEditMode ? "Edit investigation request" : "New investigation request",
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: _dropdown(
                        label: "Investigation type",
                        value: _investigationType,
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
                        onChanged: (v) {
                          if (v != null) {
                            setState(() => _investigationType = v);
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _dropdown(
                        label: "Priority",
                        value: _priority,
                        items: const ["Routine", "Urgent", "STAT"],
                        onChanged: (v) {
                          if (v != null) {
                            setState(() => _priority = v);
                          }
                        },
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
                      validator: (v) =>
                          v == null || v.isEmpty ? "Schedule date and time is required" : null,
                      onTap: _pickDateTime,
                      decoration: InputDecoration(
                        hintText: "Select date & time",
                        suffixIcon: const Icon(Icons.calendar_today_outlined),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
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

                const SizedBox(height: 16),

                _input(
                  label: "Investigation Details",
                  controller: investigationDetailsCtrl,
                  hint: "Enter investigation details",
                  maxLines: 2,
                ),

                const SizedBox(height: 16),

                _input(
                  label: "Tags (comma separated)",
                  controller: tagsCtrl,
                  hint: "eg Cancer, Blood, Infection",
                  maxLines: 2,
                ),

                const SizedBox(height: 16),

                // _dropdown(
                //   label: "Insurance Status",
                //   value: _insuranceStatus,
                //   items: const ["Pending", "Approved", "Rejected", "Scheduled"],
                //   onChanged: (v) {
                //     if (v != null) {
                //       setState(() => _insuranceStatus = v);
                //     }
                //   },
                // ),

                // const SizedBox(height: 16),

                // _dropdown(
                //   label: "Payment Status",
                //   value: _paymentStatus,
                //   items: const ["Pending", "Paid", "Cancelled", "Refunded"],
                //   onChanged: (v) {
                //     if (v != null) {
                //       setState(() => _paymentStatus = v);
                //     }
                //   },
                // ),

                // const SizedBox(height: 16),

                // Row(
                //   children: [
                //     Checkbox(
                //       value: insuranceCovered,
                //       onChanged: (value) {
                //         setState(() {
                //           insuranceCovered = value ?? false;
                //         });
                //       },
                //       activeColor: AppColors.info,
                //     ),
                //     const SizedBox(width: 8),
                //     const AppText(
                //       "Insurance Covered",
                //       fontSize: 14,
                //     ),
                //   ],
                // ),
              ],
            ),

            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AppButton(
                  text: "Close",
                  backgroundColor: Colors.grey.shade600,
                  onPressed: () => Get.back(),
                ),
                const SizedBox(width: 12),
                Obx(
                  () => AppButton(
                    // Button text adapts to mode
                    text: investigationController.isLoading.value
                        ? (isEditMode ? "Updating..." : "Creating...")
                        : (isEditMode ? "Update investigation" : "Create investigation"),
                    backgroundColor: AppColors.info,
                    textColor: Colors.white,
                    onPressed: investigationController.isLoading.value
                        ? () {} // disabled
                        : _submit,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

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
          onFieldSubmitted: (_) {
            if (maxLines == 1) {
              FocusScope.of(context).nextFocus();
            } else {
              _submit();
            }
          },
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
          value: value,
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

class EscapeIntent extends Intent {}
class AcceptIntent extends Intent {}