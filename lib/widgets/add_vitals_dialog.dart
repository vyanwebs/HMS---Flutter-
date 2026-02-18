import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../controllers/Doctor/vitals_controllers.dart';
import '../models/patient_model.dart';
import '../utils/buttons.dart';
import '../utils/constants.dart';
import '../utils/text.dart';
import '../utils/validators.dart';

class AddVitalDialog extends StatelessWidget {
  final PatientModel patient;

  AddVitalDialog({super.key, required this.patient});

  final vitalsController = Get.put(VitalsControllers());
  final _formKey = GlobalKey<FormState>();
  final focusNode = FocusNode();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      vitalsController.createVital(patient: patient);
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
                controller: vitalsController.bpCtrl,
                inputFormatters: [BPInputFormatter()],
                validator: bpValidator,
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: _input(
                      label: 'Pulse',
                      controller: vitalsController.pulseCtrl,
                      isNumeric: true,
                      min: 20,
                      max: 250,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _input(
                      label: 'Temperature (°F)',
                      controller: vitalsController.tempCtrl,
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
                controller: vitalsController.spo2Ctrl,
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
                    vitalsController.createVital(patient: patient);
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