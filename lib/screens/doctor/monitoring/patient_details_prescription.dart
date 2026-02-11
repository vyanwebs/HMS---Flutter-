import 'package:flutter/material.dart';
import 'package:flutter_mdi_icons/flutter_mdi_icons.dart';
import 'package:get/get.dart';

import '../../../controllers/patient_details_prescription_controllers.dart';
import '../../../models/patient_model.dart';
import '../../../utils/buttons.dart';
import '../../../utils/constants.dart';
import '../../../utils/text.dart';

class PatientDetailsPrescription extends StatefulWidget {
  final PatientModel patient;

  const PatientDetailsPrescription({super.key, required this.patient});

  @override
  State<PatientDetailsPrescription> createState() => _PatientDetailsPrescriptionState();
}

class _PatientDetailsPrescriptionState extends State<PatientDetailsPrescription> {

  final prescriptionCtrl = Get.put(PatientDetailsPrescriptionControllers());

  @override
  void initState() {
    super.initState();
    prescriptionCtrl.fetchPrescriptions(
      patientMongoId: widget.patient.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      children: [
        const SizedBox(height: 20),
        _header(),
        const SizedBox(height: 20),

        /// LIST
        Obx(() {
          if (prescriptionCtrl.isLoading.value) {
            return const Padding(
              padding: EdgeInsets.all(40),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          if (prescriptionCtrl.prescriptions.isEmpty) {
            return const Padding(
              padding: EdgeInsets.all(40),
              child: Center(
                child: AppText(
                  "No prescriptions added yet",
                  color: Colors.grey,
                ),
              ),
            );
          }

          return Wrap(
            spacing: 20,
            runSpacing: 20,
            children: prescriptionCtrl.prescriptions.map(
              (prescription) => SizedBox(
                width: 400,
                child: _prescriptionCard(prescription),
              ),
            ).toList(),
          );
        }),

        const SizedBox(height: 20),
      ],
    );
  }

  // ---------------- HEADER ----------------
  Widget _header() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.info.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.info,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Mdi.heartPulse,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    "Patient prescription",
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(height: 2),
                  AppText(
                    "Manage medicines and dosage instructions",
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ],
              ),
            ],
          ),
          AppButton(
            onPressed: () {},
            icon: Icons.add,
            iconIsLast: false,
            text: "Add prescription",
          ),
        ],
      ),
    );
  }

  // ---------------- PRESCRIPTION CARD ----------------
  Widget _prescriptionCard(prescription) {
    final medicineName = prescription.medicine?.name ?? "Medicine not specified";

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                medicineName,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
              IconButton(
                icon: const Icon(
                  Icons.delete_outline,
                  color: Colors.red,
                ),
                onPressed: () => _confirmDelete(prescription.id),
              ),
            ],
          ),

          const SizedBox(height: 4),

          /// DURATION
          AppText(
            "Duration: ${prescription.durationInDays} days",
            fontSize: 12,
            color: Colors.grey,
          ),

          const SizedBox(height: 12),

          /// CREATED DATE
          _infoRow(
            Icons.calendar_month,
            Colors.blue,
            _formatDate(prescription.createdAt),
            "Prescribed on",
          ),

          const SizedBox(height: 16),

          /// DOSAGE SCHEDULE
          const AppText(
            "Dosage",
            fontWeight: FontWeight.w500,
          ),
          const SizedBox(height: 8),

          ...prescription.dosageSchedule.map<Widget>((dose) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _infoRow(
                Icons.medication,
                Colors.green,
                "${dose.timeOfDay} • ${dose.quantity} tablet(s)",
                "${dose.mealRelation}",
              ),
            );
          }).toList(),

          const SizedBox(height: 14),

          /// NOTES
          const AppText(
            "Notes",
            fontWeight: FontWeight.w500,
          ),
          const SizedBox(height: 6),
          AppText(
            prescription.comment?.isNotEmpty
              ? prescription.comment
              : "No notes added",
            color: Colors.grey,
            maxLines: 4,
          ),
        ],
      ),
    );
  }

  // ---------------- DELETE CONFIRM ----------------
  void _confirmDelete(String id) {
    Get.dialog(
      AlertDialog(
        title: const Text("Delete prescription"),
        content: const Text(
          "Are you sure you want to delete this prescription?",
        ),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              prescriptionCtrl.deletePrescription(
                prescriptionId: id,
              );
            },
            child: const Text(
              "Delete",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- HELPERS ----------------
  Widget _infoRow(
    IconData icon,
    Color color,
    String value,
    String label,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(value, fontWeight: FontWeight.w500),
            const SizedBox(height: 2),
            AppText(label, fontSize: 12, color: Colors.grey),
          ],
        ),
      ],
    );
  }

  String _formatDate(DateTime d) {
    return "${d.day.toString().padLeft(2, '0')}-"
        "${d.month.toString().padLeft(2, '0')}-"
        "${d.year}  "
        "${d.hour.toString().padLeft(2, '0')}:"
        "${d.minute.toString().padLeft(2, '0')}";
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey.shade300),
    );
  }
}
