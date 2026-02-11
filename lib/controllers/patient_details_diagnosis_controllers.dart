import 'dart:developer';

import 'package:get/get.dart';

import '../models/diagnosis_model.dart';
import '../services/api_service.dart';
import '../services/apis.dart';
import '../utils/overlay.dart';
import '../utils/snackbar.dart';

class PatientDetailsDiagnosisControllers extends GetxController {
  RxBool isLoading = false.obs;
  final diagnosisList = <DiagnosisModel>[].obs;

  /// GET: Fetch all diagnosis of a patient
  Future<void> fetchDiagnoses(String patientMongoId) async {
    try {
      isLoading.value = true;

      final api = NetworkHelper(
        url: "$fetchAllDiagnosisApi/$patientMongoId",
      );

      final response = await api.get(auth: true);

      if (response['success'] == true && response['data'] != null) {
        diagnosisList.assignAll((response['data'] as List).map((e) => DiagnosisModel.fromJson(e)).toList());
      } else {
        diagnosisList.clear();
      }
    } catch (e, s) {
      log("❌ fetchDiagnoses failed", error: e, stackTrace: s);
      diagnosisList.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteDiagnosis({
    required String diagnosisId,
  }) async {
    try {

      final api = NetworkHelper(
        url: "$deleteDiagnosisApi/$diagnosisId",
      );

      final response = await api.delete(auth: true);

      if (response['success'] == true) {
        diagnosisList.removeWhere((e) => e.id == diagnosisId);

        AppSnackbar.show(
          title: "Deleted",
          message: "Diagnosis deleted successfully",
          type: AppSnackType.success
        );
      } else {
        AppSnackbar.show(
          title: "Failed",
          message: response['message'] ?? "Unable to delete diagnosis",
          type: AppSnackType.error
        );
      }
    } catch (e, s) {
      log("❌ deleteDiagnosis failed", error: e, stackTrace: s);

      AppSnackbar.show(
        title: "Error",
        message: "Something went wrong",
        type: AppSnackType.error
      );
    }
  }

  Future<void> deleteDiagnosisItem({
    required String diagnosisRecordId,
    required String diagnosisItemId,
    required String patientMongoId
  }) async {
    try {
      LoadingOverlayService.show(message: "Deleting diagnosis...");

      final api = NetworkHelper(
        url: "$deleteDiagnosisApi/$diagnosisRecordId/item/$diagnosisItemId",
      );

      final response = await api.delete(auth: true);

      if (response['success'] == true) {
        await fetchDiagnoses(patientMongoId);

        AppSnackbar.show(
          title: "Deleted",
          message: "Diagnosis removed successfully",
          type: AppSnackType.success,
        );
      }
    } catch (e) {
      AppSnackbar.show(
        title: "Error",
        message: "Unable to delete diagnosis",
        type: AppSnackType.error,
      );
    } finally {
      LoadingOverlayService.hide();
    }
  }

  Future<void> createDiagnoses({
    required String patientMongoId,
    required List<String> diagnoses,
  }) async {
    try {
      LoadingOverlayService.show(message: "Adding diagnoses...");

      final api = NetworkHelper(
        url: createDiagnosisApi,
      );

      final Map<String, dynamic> body = {
        "patientMongoId": patientMongoId,
      };

      for (int i = 0; i < diagnoses.length; i++) {
        body["diagnoses[$i][name]"] = diagnoses[i].trim();
      }

      final response = await api.postData(
        auth: true,
        body: body,
      );

      if (response['success'] == true) {
        await fetchDiagnoses(patientMongoId);
        Get.back();

        AppSnackbar.show(
          title: "Success",
          message: "Diagnoses added successfully",
          type: AppSnackType.success,
        );
      } else {
        AppSnackbar.show(
          title: "Failed",
          message: response['message'] ?? "Unable to add diagnoses",
          type: AppSnackType.error,
        );
      }
    } catch (e, s) {
      log("❌ createDiagnoses failed", error: e, stackTrace: s);

      AppSnackbar.show(
        title: "Error",
        message: "Something went wrong",
        type: AppSnackType.error,
      );
    } finally {
      LoadingOverlayService.hide();
    }
  }
}