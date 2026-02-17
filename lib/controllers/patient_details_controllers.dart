import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/patient_model.dart';
import '../models/prescription_model.dart';
import '../screens/doctor/patient_details.dart';
import '../services/api_service.dart';
import '../services/apis.dart';
import '../utils/enums.dart';
import '../utils/overlay.dart';
import '../utils/snackbar.dart';

class PatientDetailsControllers extends GetxController {

  final selectedMenu = PatientDetailsMenu.overview.obs;

  final isMonitoringExpanded = false.obs;
  
  RxBool isBeforeMeal = true.obs;

  final bpCtrl = TextEditingController();
  final pulseCtrl = TextEditingController();
  final tempCtrl = TextEditingController();
  final spo2Ctrl = TextEditingController();

  RxList frequentlyUsedMedicines = [
    "Viral Fever",
    "Bacterial Infection",
    "Fever",
    "Chills / Rigors",
    "Fatigue",
  ].obs;

  void select(PatientDetailsMenu menu) {
    selectedMenu.value = menu;
  }

  void selectBeforeMeal() {
    isBeforeMeal.value = true;
  }

  void selectAfterMeal() {
    isBeforeMeal.value = false;
  }

  void toggleMonitoring() {
    isMonitoringExpanded.toggle();
  }

  /// ---------- CREATE VITAL ----------
  Future<void> createVital({
    required PatientModel patient,
  }) async {
    try {
      LoadingOverlayService.show(message: "Adding vitals...");
      log(patient.id);
      final api = NetworkHelper(url: addVitalsApi);

      final response = await api.post(
        auth: true,
        body: {
          "patientMongoId": patient.id,
          "bp": bpCtrl.text.trim(),
          "pulse": int.tryParse(pulseCtrl.text),
          "temperature": double.tryParse(tempCtrl.text),
          "spo2": int.tryParse(spo2Ctrl.text),
        },
      );

      LoadingOverlayService.hide();
      Get.back();

      if (response['success'] == true) {
        AppSnackbar.show(
          title: "Success",
          message: "Vitals added successfully",
          type: AppSnackType.success,
        );

        clearVitalForm();

      } else {
        AppSnackbar.show(
          title: "Failed",
          message: response['message'] ?? "Unable to add vitals",
          type: AppSnackType.error,
        );
      }
    } catch (e, s) {
      LoadingOverlayService.hide();

      log('❌ createVital failed', error: e, stackTrace: s);

      AppSnackbar.show(
        title: "Error",
        message: "Something went wrong",
        type: AppSnackType.error,
      );
    } 
  }

  void clearVitalForm() {
    bpCtrl.clear();
    pulseCtrl.clear();
    tempCtrl.clear();
    spo2Ctrl.clear();
  }

  Future<void> makeAdmitRequest({
    required PatientModel patient,
    required WardType wardType,
    required String instructions,
  }) async {
    try {
      LoadingOverlayService.show(message: "Admitting patient...");

      final api = NetworkHelper(url: admitPatientApi);

      final response = await api.patch(
        auth: true,
        isFormData: true,
        body: {
          "patientMongoId": patient.id,
          "currentWardType": _mapWardType(wardType),
          "admissionInstructions": instructions.trim(),
        },
      );

      LoadingOverlayService.hide();
      Get.back();

      if (response['success'] == true) {
        AppSnackbar.show(
          title: "Success",
          message: response['message'] ?? "Patient admitted successfully",
          type: AppSnackType.success,
        );
      } else {
        AppSnackbar.show(
          title: "Failed",
          message: response['message'] ?? "Admit request failed",
          type: AppSnackType.error,
        );
      }
    } catch (e, s) {
      log('❌ makeAdmitRequest failed', error: e, stackTrace: s);
      LoadingOverlayService.hide();
      AppSnackbar.show(
        title: "Error",
        message: "Something went wrong",
        type: AppSnackType.error,
      );
    }
  }

  String _mapWardType(WardType type) {
    switch (type) {
      case WardType.general:
        return "GENERAL_WARD";
      case WardType.icu:
        return "ICU";
      case WardType.others:
        return "OTHERS";
    }
  }

  Future<bool> createInvestigation({
      required String patientMongoId,
    required String patientId,
    required String investigationType,
    required String priority,
    required String scheduledDateTime,
    required String reasonForInvestigation,
    required String clinicalHistory,
    required String investigationDetails,  
      required PatientModel patient,
    // required now

  }) async {
    try {
      LoadingOverlayService.show(message: "Creating investigation...");

      final api = NetworkHelper(url: createInvestigationApi);

      final response = await api.post(
        auth: true,
        body: {
          "patientMongoId": patientId,
          "investigationType": investigationType,
          "priority": priority,
          "scheduledDateAndTime": scheduledDateTime,
          "reasonForInvestigation": reasonForInvestigation.trim(),
          "clinicalHistory": clinicalHistory.trim(),
          "investigationDetails": investigationDetails.trim(),
        },
      );

      LoadingOverlayService.hide();

      if (response['success'] == true) {
        Get.back();
        AppSnackbar.show(
          title: "Success",
          message: "Investigation request created successfully",
          type: AppSnackType.success,
        );
        return true;

      } else {
        AppSnackbar.show(
          title: "Failed",
          message: response['message'] ?? "Unable to create investigation",
          type: AppSnackType.error,
        );
        return false;
      }
    } catch (e, s) {
      log("❌ createInvestigation failed", error: e, stackTrace: s);
      LoadingOverlayService.hide();
      AppSnackbar.show(
        title: "Error",
        message: "Something went wrong",
        type: AppSnackType.error,
      );
      return false;
    }
  }

  // ===================== Search Medicine Name =======================

  final medicines = <MedicineModel>[].obs;
  final isMedicineLoading = false.obs;
  final selectedMedicine = Rxn<MedicineModel>();

  Timer? _medicineDebounce;

  Future<void> searchMedicine(String query) async {
    final trimmed = query.trim();

    if (trimmed.length < 3) {
      medicines.clear();
      isMedicineLoading.value = false;
      _medicineDebounce?.cancel();
      return;
    }

    _medicineDebounce?.cancel();

    _medicineDebounce = Timer(const Duration(milliseconds: 400), () async {
      try {
        isMedicineLoading.value = true;

        final encodedQuery = Uri.encodeQueryComponent(trimmed);

        final api = NetworkHelper(
          url: "$getMedicineApi?name=$encodedQuery",
        );

        final response = await api.get(auth: true);


        if (response.isNotEmpty) {

          final Map<String, dynamic> dataMap = Map<String, dynamic>.from(response);

          /// remove non-medicine keys (like "source")
          dataMap.removeWhere((key, value) => value is! Map);

          medicines.assignAll(dataMap.values.map((e) => MedicineModel.fromJson(e)).toList(),
          );

        } else {
          medicines.clear();
        }
      } catch (e, s) {
        log("❌ searchMedicine failed", error: e, stackTrace: s);
        medicines.clear();
      } finally {
        isMedicineLoading.value = false;
      }
    });
  }

  void selectMedicine(MedicineModel medicine) {
    selectedMedicine.value = medicine;
    medicines.clear();
    medicineError.value = null;
  }

  // ==================== Create Prescription ===========================

  // UI validation state
  final medicineError = RxnString();
  final dosageError = RxnString();

  final morningCtrl = TextEditingController(text: "0");
  final afternoonCtrl = TextEditingController(text: "0");
  final nightCtrl = TextEditingController(text: "0");

  final medicineCtrl = TextEditingController();
  final durationCtrl = TextEditingController();
  final commentCtrl = TextEditingController();

  bool validateDosage(int m, int a, int n) {
    if (m == 0 && a == 0 && n == 0) {
      dosageError.value = "Please enter at least one dosage";
      return false;
    }
    dosageError.value = null;
    return true;
  }

  Future<void> createPrescription({
    required String patientMongoId,
    required int morningQty,
    required int afternoonQty,
    required int nightQty,
  }) async {
    if (selectedMedicine.value == null) {
      AppSnackbar.show(
        title: "Missing medicine",
        message: "Please select a medicine",
        type: AppSnackType.error,
      );
      return;
    }

    final List<Map<String, dynamic>> dosage = [];

    void addDose(String time, int qty) {
      if (qty > 0) {
        dosage.add({
          "timeOfDay": time,
          "quantity": qty,
          "mealRelation": isBeforeMeal.value ? "Before Meal" : "After Meal",
        });
      }
    }

    addDose("Morning", morningQty);
    addDose("Afternoon", afternoonQty);
    addDose("Night", nightQty);

    if (dosage.isEmpty) {
      AppSnackbar.show(
        title: "Invalid dosage",
        message: "Please enter at least one dosage",
        type: AppSnackType.error,
      );
      return;
    }

    try {
      LoadingOverlayService.show(message: "Creating prescription...");

      final Map<String, dynamic> body = {
        "patientMongoId": patientMongoId,
        "medicineMongoId": selectedMedicine.value!.id,
        "comment": commentCtrl.text.trim(),
        "durationInDays": durationCtrl.text.trim(),
        "prescriptionStatus": "complete",
      };

      /// Build indexed dosageSchedule
      for (int i = 0; i < dosage.length; i++) {
        body["dosageSchedule[$i][timeOfDay]"] = dosage[i]["timeOfDay"];
        body["dosageSchedule[$i][quantity]"] = dosage[i]["quantity"].toString();
        body["dosageSchedule[$i][mealRelation]"] = dosage[i]["mealRelation"];
      }

      final api = NetworkHelper(url: createPrescriptionApi);

      final response = await api.postData(
        auth: true,
        body: body,
      );

      LoadingOverlayService.hide();

      if (response['success'] == true) {
        AppSnackbar.show(
          title: "Success",
          message: "Prescription created successfully",
          type: AppSnackType.success,
        );

        /// reset
        selectedMedicine.value = null;
        durationCtrl.clear();
        commentCtrl.clear();
        medicines.clear();

      } else {
        AppSnackbar.show(
          title: "Failed",
          message: response['message'] ?? "Unable to create prescription",
          type: AppSnackType.error,
        );
      }
    } catch (e, s) {
      LoadingOverlayService.hide();
      log("❌ createPrescription failed", error: e, stackTrace: s);

      AppSnackbar.show(
        title: "Error",
        message: "Something went wrong",
        type: AppSnackType.error,
      );
    }
  }
}
