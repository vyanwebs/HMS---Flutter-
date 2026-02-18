import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../controllers/Doctor/advanced_prescription_controllers.dart';
import '../../models/patient_model.dart';
import '../../utils/buttons.dart';
import '../../utils/constants.dart';
import '../../utils/text.dart';

class PatientDetailsEPrescription extends StatefulWidget {
  final PatientModel patient;

  const PatientDetailsEPrescription({super.key, required this.patient});

  @override
  State<PatientDetailsEPrescription> createState() => _PatientDetailsEPrescriptionState();
}

class _PatientDetailsEPrescriptionState extends State<PatientDetailsEPrescription> {
  late final AdvancedPrescriptionController controller;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    controller = Get.put(AdvancedPrescriptionController());
    controller.setPatient(widget.patient.id);
    
    // Listen to diagnosis changes to update AI suggestions
    controller.diagnosisCtrl.addListener(() {
      controller.fetchAISuggestions(controller.diagnosisCtrl.text);
    });
  }

  @override
  void dispose() {
    controller.diagnosisCtrl.removeListener(() {});
    Get.delete<AdvancedPrescriptionController>();
    super.dispose();
  }

  // ========== METHOD TO CHECK AND ADD PENDING MEDICINE ==========
  void _handleSubmitPrescription() async {
    // Check if there's unsaved medicine in the form
    final hasSelectedMedicine = controller.selectedMedicine.value != null;
    final hasDosage = 
        (int.tryParse(controller.morningCtrl.text) ?? 0) > 0 ||
        (int.tryParse(controller.afternoonCtrl.text) ?? 0) > 0 ||
        (int.tryParse(controller.nightCtrl.text) ?? 0) > 0;
    final hasDuration = controller.durationCtrl.text.trim().isNotEmpty;
    
    // If there's unsaved medicine data, prompt user
    if (hasSelectedMedicine || hasDosage || hasDuration) {
      final shouldAdd = await Get.dialog<bool>(
        AlertDialog(
          title: const Text('Unsaved Medicine'),
          content: const Text(
            'You have unsaved medicine details. Do you want to add it before submitting?',
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('Discard'),
            ),
            TextButton(
              onPressed: () => Get.back(result: true),
              child: const Text('Add'),
            ),
          ],
        ),
      );
      
      if (shouldAdd == true) {
        final added = controller.addMedicine();
        if (!added) {
          return; // If add failed, don't proceed
        }
      }
    }
    
    // Proceed with submission
    await controller.submitPrescription();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),
            const AppText('E-Prescription',
                fontSize: 20, fontWeight: FontWeight.w700),
            const SizedBox(height: 16),

            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Main column
                  Expanded(
                    flex: 3,
                    child: SingleChildScrollView(
                      primary: true,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// ================= PATIENT =================
                          _buildCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const AppText('Patient information',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const AppText('Select patient',
                                              fontSize: 12,
                                              color: AppColors.greyText),
                                          const SizedBox(height: 8),
                                          TextFormField(
                                            initialValue:
                                                '${widget.patient.name} - ${widget.patient.patientId}',
                                            enabled: false,
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor:
                                                  AppColors.cardBackground,
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                borderSide: BorderSide(
                                                    color: AppColors.border),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const AppText('Primary diagnosis',
                                              fontSize: 12,
                                              color: AppColors.greyText),
                                          const SizedBox(height: 8),
                                          Obx(() => Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  TextFormField(
                                                    controller: controller
                                                        .diagnosisCtrl,
                                                    decoration: InputDecoration(
                                                      hintText:
                                                          'Primary diagnosis',
                                                      filled: true,
                                                      fillColor: AppColors
                                                          .cardBackground,
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                8),
                                                        borderSide: BorderSide(
                                                            color: AppColors
                                                                .border),
                                                      ),
                                                    ),
                                                  ),
                                                  if (controller
                                                      .diagnosisError.isNotEmpty)
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 4),
                                                      child: AppText(
                                                        controller
                                                            .diagnosisError.value,
                                                        fontSize: 11,
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                ],
                                              )),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 14),

                          /// ================= MEDICATION =================
                          _buildCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const AppText('Medication',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700),
                                    Row(
                                      children: [
                                        AppButton(
                                          text: '+ Add medication',
                                          onPressed: () {
                                            controller.addMedicine();
                                          },
                                          backgroundColor: AppColors.info,
                                          textColor: Colors.white,
                                          fontSize: 12,
                                        ),
                                        const SizedBox(width: 12),
                                        AppButton(
                                          text: 'Submit Prescription',
                                          onPressed: _handleSubmitPrescription,
                                          backgroundColor:
                                              AppColors.success ?? Colors.green,
                                          textColor: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),

                                /// ========== MEDICINE SEARCH ==========
                                const AppText('Selected medicine',
                                    fontSize: 12, color: AppColors.greyText),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: controller.medicineSearchCtrl,
                                  onChanged: controller.searchMedicine,
                                  decoration: InputDecoration(
                                    hintText: 'Enter medicine name',
                                    filled: true,
                                    fillColor: AppColors.cardBackground,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide:
                                          BorderSide(color: AppColors.border),
                                    ),
                                  ),
                                ),

                                /// ========== SEARCH RESULT ==========
                                Obx(() {
                                  if (controller.medicines.isEmpty) {
                                    return const SizedBox();
                                  }
                                  return Container(
                                    margin: const EdgeInsets.only(top: 6),
                                    decoration: BoxDecoration(
                                      color: AppColors.cardBackground,
                                      border: Border.all(color: AppColors.border),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      children: controller.medicines.map((m) {
                                        return ListTile(
                                          title: AppText(m.name),
                                          onTap: () {
                                            controller.selectMedicine(m);
                                          },
                                        );
                                      }).toList(),
                                    ),
                                  );
                                }),
                                Obx(() {
                                  if (controller.medicineError.isEmpty) {
                                    return const SizedBox();
                                  }
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: AppText(
                                      controller.medicineError.value,
                                      fontSize: 11,
                                      color: Colors.red,
                                    ),
                                  );
                                }),
                                const SizedBox(height: 12),

                                /// ========== DOSAGE ==========
                                const AppText('Dosage information',
                                    fontSize: 12, color: AppColors.greyText),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    _dosageItem(
                                        'Morning', controller.morningCtrl),
                                    const SizedBox(width: 8),
                                    _dosageItem(
                                        'Afternoon', controller.afternoonCtrl),
                                    const SizedBox(width: 8),
                                    _dosageItem('Night', controller.nightCtrl),
                                  ],
                                ),
                                Obx(() {
                                  if (controller.dosageError.isEmpty) {
                                    return const SizedBox();
                                  }
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: AppText(
                                      controller.dosageError.value,
                                      fontSize: 11,
                                      color: Colors.red,
                                    ),
                                  );
                                }),
                                const SizedBox(height: 10),

                                /// ========== MEAL ==========
                                Obx(() => Row(
                                      children: [
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: controller.selectBeforeMeal,
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12),
                                              decoration: BoxDecoration(
                                                color: controller.isBeforeMeal
                                                        .value
                                                    ? AppColors.info
                                                    : AppColors.cardBackground,
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                border: Border.all(
                                                    color: AppColors.border),
                                              ),
                                              child: Center(
                                                child: AppText(
                                                  'Before meal',
                                                  color: controller
                                                          .isBeforeMeal.value
                                                      ? Colors.white
                                                      : AppColors.greyText,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: controller.selectAfterMeal,
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12),
                                              decoration: BoxDecoration(
                                                color: !controller
                                                        .isBeforeMeal.value
                                                    ? AppColors.info
                                                    : AppColors.cardBackground,
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                border: Border.all(
                                                    color: AppColors.border),
                                              ),
                                              child: Center(
                                                child: AppText(
                                                  'After meal',
                                                  color: !controller
                                                          .isBeforeMeal.value
                                                      ? Colors.white
                                                      : AppColors.greyText,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )),
                                const SizedBox(height: 12),

                                /// ========== DURATION ==========
                                const AppText('Duration',
                                    fontSize: 12, color: AppColors.greyText),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: controller.durationCtrl,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  decoration: InputDecoration(
                                    hintText: '3 dys',
                                    filled: true,
                                    fillColor: AppColors.cardBackground,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide:
                                          BorderSide(color: AppColors.border),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),

                                /// ========== COMMENT ==========
                                const AppText('Add comment',
                                    fontSize: 12, color: AppColors.greyText),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: controller.commentCtrl,
                                  minLines: 2,
                                  maxLines: 4,
                                  decoration: InputDecoration(
                                    hintText: 'Enter Comments',
                                    filled: true,
                                    fillColor: AppColors.cardBackground,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide:
                                          BorderSide(color: AppColors.border),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),

                                /// ========== ADDED ==========
                                Obx(() {
                                  if (controller.items.isEmpty) {
                                    return const SizedBox();
                                  }
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const AppText('Added medications',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600),
                                      const SizedBox(height: 8),
                                      Column(
                                        children: List.generate(
                                            controller.items.length, (i) {
                                          final m = controller.items[i];
                                          return ListTile(
                                            contentPadding: EdgeInsets.zero,
                                            title: AppText(m.medicine.name),
                                            subtitle: AppText(
                                              'M: ${m.morning}  A: ${m.afternoon}  N: ${m.night} • ${m.duration} dys',
                                              fontSize: 12,
                                              color: AppColors.greyText,
                                            ),
                                            trailing: TextButton(
                                              onPressed: () {
                                                controller.removeMedicine(i);
                                              },
                                              child: const Text(
                                                'Remove',
                                                style: TextStyle(
                                                    color: Colors.red),
                                              ),
                                            ),
                                          );
                                        }),
                                      ),
                                    ],
                                  );
                                }),
                              ],
                            ),
                          ),
                          const SizedBox(height: 14),

                          /// ================= AI MEDICINE SUGGESTIONS (DYNAMIC) =================
                          Obx(() {
                            if (controller.aiSuggestions.isEmpty) {
                              return const SizedBox();
                            }
                            
                            return _buildCard(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const AppText('AI Medicine Suggestions',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: AppColors.info.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: AppText(
                                          'Based on: ${controller.aiCondition.value}',
                                          fontSize: 11,
                                          color: AppColors.info,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  const AppText(
                                      'Recommended for your diagnosis',
                                      fontSize: 12,
                                      color: AppColors.greyText),
                                  const SizedBox(height: 12),
                                  if (controller.isLoadingAISuggestions.value)
                                    const Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(16.0),
                                        child: CircularProgressIndicator(),
                                      ),
                                    )
                                  else
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        border:
                                            Border.all(color: AppColors.border),
                                        color: AppColors.cardBackground,
                                      ),
                                      child: Column(
                                        children: controller.aiSuggestions.map((medicine) {
                                          return ListTile(
                                            title: AppText(medicine.name),
                                            subtitle: medicine.category != null
                                                ? AppText(
                                                    medicine.category!,
                                                    fontSize: 11,
                                                    color: AppColors.greyText,
                                                  )
                                                : null,
                                            trailing: TextButton(
                                              onPressed: () {
                                                controller.selectMedicine(medicine);
                                              },
                                              child: const Text('+ Add'),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  /// ================= RIGHT - COMMON MEDICATIONS (FROM API) =================
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        Expanded(
                          child: _buildCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const AppText('Common Medication',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700),
                                const SizedBox(height: 12),
                                Obx(() {
                                  if (controller.isLoadingCommonMeds.value) {
                                    return const Expanded(
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    );
                                  }
                                  
                                  if (controller.commonMedicines.isEmpty) {
                                    return const Expanded(
                                      child: Center(
                                        child: AppText(
                                          'No medicines found',
                                          color: AppColors.greyText,
                                        ),
                                      ),
                                    );
                                  }
                                  
                                  return Expanded(
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: List.generate(
                                            controller.commonMedicines.length > 20 
                                                ? 20 
                                                : controller.commonMedicines.length, 
                                            (index) {
                                          final medicine = controller.commonMedicines[index];
                                          return Column(
                                            children: [
                                              ListTile(
                                                dense: true,
                                                title: AppText(
                                                  medicine.name,
                                                  fontSize: 13,
                                                ),
                                                subtitle: medicine.category != null
                                                    ? AppText(
                                                        medicine.category!,
                                                        fontSize: 11,
                                                        color: AppColors.greyText,
                                                      )
                                                    : null,
                                                trailing: IconButton(
                                                  icon: const Icon(
                                                    Icons.add_circle_outline,
                                                    size: 20,
                                                    color: AppColors.info,
                                                  ),
                                                  onPressed: () {
                                                    controller.selectMedicine(medicine);
                                                  },
                                                ),
                                              ),
                                              if (index != 
                                                  (controller.commonMedicines.length > 20 
                                                      ? 20 
                                                      : controller.commonMedicines.length) - 1)
                                                const Divider(height: 1),
                                            ],
                                          );
                                        }),
                                      ),
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ),
                        ),
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
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 8,
              offset: const Offset(0, 4)),
        ],
      ),
      child: child,
    );
  }

  Widget _dosageItem(String label, TextEditingController controller) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.solitude.withValues(alpha: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            AppText(label, fontSize: 12, color: AppColors.greyText),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: TextFormField(
                controller: controller,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: const InputDecoration(
                  isCollapsed: true,
                  border: InputBorder.none,
                  hintText: '0',
                  hintStyle: TextStyle(color: AppColors.greyText),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 6, horizontal: 6),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}