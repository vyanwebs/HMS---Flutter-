import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/Doctor/symptom_controllers.dart';
import '../models/patient_model.dart';
import '../utils/buttons.dart';
import '../utils/constants.dart';
import '../utils/text.dart';

class AddSymptomsDialog extends StatefulWidget {
  final PatientModel patient;

  const AddSymptomsDialog({
    super.key,
    required this.patient,
  });

  @override
  State<AddSymptomsDialog> createState() => _AddSymptomsDialogState();
}

class _AddSymptomsDialogState extends State<AddSymptomsDialog> {

  final TextEditingController symptomCtrl = TextEditingController();
  final symptomController = Get.find<SymptomControllers>();

  final _formKey = GlobalKey<FormState>();
  final FocusNode _symptomFocus = FocusNode();

  final List<String> symptoms = [];

  final List<String> quickChips = const [
    "Fever",
    "Chills / Rigors",
    "Fatigue",
    "Headache",
    "Body pain",
  ];

  // ================= ADD =================
  void _addSymptom() {
    final text = symptomCtrl.text.trim();
    if (text.isEmpty) return;

    if (!symptoms.contains(text)) {
      setState(() {
        symptoms.add(text);
      });
    }

    symptomCtrl.clear();
    FocusScope.of(context).requestFocus(_symptomFocus);
  }

  // ================= REMOVE =================
  void _removeSymptom(String value) {
    setState(() {
      symptoms.remove(value);
    });
  }

  @override
  void dispose() {
    symptomCtrl.dispose();
    _symptomFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      backgroundColor: Colors.white,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ================= PATIENT HEADER =================
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.info.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: AppColors.info.withValues(alpha: 0.2),
                      child: Text(
                        widget.patient.initials,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold
                        ),
                      ),
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
                          "ID:${widget.patient.patientId} · "
                          "Age-${widget.patient.age} · "
                          "${widget.patient.gender}",
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ================= TITLE =================
              const AppText(
                "Manual symptom entry",
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              const SizedBox(height: 6),
              const AppText(
                "Enter symptoms manually",
                fontSize: 12,
                color: Colors.grey,
              ),

              const SizedBox(height: 14),

              // ================= INPUT =================
              Form(
                key: _formKey,
                child: TextFormField(
                  controller: symptomCtrl,
                  focusNode: _symptomFocus,
                  autofocus: true,
                  textInputAction: TextInputAction.done,

                  onFieldSubmitted: (_) {
                    final text = symptomCtrl.text.trim();
                    if (text.isEmpty) {
                      _submitForm();
                    } else {
                      _addSymptom();
                    }
                  },

                  validator: (_) {
                    if (symptoms.isEmpty) {
                      return "Please add at least one symptom";
                    }
                    return null;
                  },

                  decoration: InputDecoration(
                    hintText: "Type symptom and press Enter",
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: _addSymptom,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),

              // ================= SELECTED SYMPTOMS =================
              if (symptoms.isNotEmpty) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: symptoms.map((s) {
                    return Chip(
                      label: Text(s),
                      deleteIcon: const Icon(Icons.close, size: 18),
                      onDeleted: () => _removeSymptom(s),
                    );
                  }).toList(),
                ),
              ],

              const SizedBox(height: 12),

              // ================= QUICK CHIPS =================
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: quickChips.map((chip) {
                  return InkWell(
                    onTap: () {
                      symptomCtrl.text = chip;
                      _addSymptom();
                    },
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.info.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: AppText(
                        chip,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),

              // ================= ACTIONS =================
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AppButton(
                    text: "Close",
                    backgroundColor: Colors.grey.shade500,
                    onPressed: () => Get.back(),
                  ),
                  const SizedBox(width: 12),
                  AppButton(
                    text: "Add symptoms",
                    icon: Icons.add,
                    onPressed: _submitForm,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= SUBMIT =================
  void _submitForm() async {
    final isValid = _formKey.currentState!.validate();

    if (!isValid) {
      FocusScope.of(context).requestFocus(_symptomFocus);
      return;
    }

    final status = await symptomController.createSymptoms(
      patientMongoId: widget.patient.id,
      symptoms: symptoms,
    );

    if (status && mounted) {
      Navigator.of(context).pop();
    }
  }
}