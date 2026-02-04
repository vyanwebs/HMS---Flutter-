import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/patient_model.dart';
import '../screens/doctor/patient_details.dart';
import '../services/api_service.dart';
import '../services/apis.dart';
import '../utils/enums.dart';
import '../utils/overlay.dart';
import '../utils/snackbar.dart';

class PatientDetailsControllers extends GetxController {

  final selectedMenu = PatientDetailsMenu.overview.obs;
  
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

  /// ---------- CREATE VITAL ----------
  Future<void> createVital({
    required PatientModel patient,
  }) async {
    try {
      LoadingOverlayService.show(message: "Adding vitals...");

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

  Future<void> createInvestigation({
    required String patientId,
    required String investigationType,
    required String priority,
    required String scheduledDateTime,
    required String reasonForInvestigation,
    required String clinicalHistory,
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

      } else {
        AppSnackbar.show(
          title: "Failed",
          message: response['message'] ?? "Unable to create investigation",
          type: AppSnackType.error,
        );
      }
    } catch (e, s) {
      log("❌ createInvestigation failed", error: e, stackTrace: s);
      LoadingOverlayService.hide();
      AppSnackbar.show(
        title: "Error",
        message: "Something went wrong",
        type: AppSnackType.error,
      );
    }
  }
}
