import 'dart:developer';

import 'package:get/get.dart';

import '../../models/prescription_model.dart';
import '../../services/api_service.dart';
import '../../services/apis.dart';
import '../../utils/snackbar.dart';

class PatientDetailsPrescriptionControllers extends GetxController {
  RxBool isLoading = false.obs;

  /// list of prescriptions
  RxList<PrescriptionModel> prescriptions = <PrescriptionModel>[].obs;

  /// -------------------------------
  /// FETCH PRESCRIPTIONS
  /// -------------------------------
  Future<void> fetchPrescriptions({
    required String patientMongoId,
  }) async {
    try {
      isLoading.value = true;

      // log(patientMongoId);

      final api = NetworkHelper(
        url: "$getAllPrescriptionApi/$patientMongoId",
      );

      final response = await api.get(auth: true);

      if (response['success'] == true) {
        final List list = response['data'] ?? [];

        prescriptions.value =
            list.map((e) => PrescriptionModel.fromJson(e)).toList();
      } else {
        AppSnackbar.show(
          title: "Failed",
          message: response['message'] ?? "Unable to fetch prescriptions",
          type: AppSnackType.error,
        );
      }
    } catch (e, s) {
      log("❌ fetchPrescriptions failed", error: e, stackTrace: s);

      AppSnackbar.show(
        title: "Error",
        message: "Something went wrong",
        type: AppSnackType.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// -------------------------------
  /// DELETE SINGLE PRESCRIPTION
  /// -------------------------------
  Future<void> deletePrescription({
    required String prescriptionId,
  }) async {
    try {
      final api = NetworkHelper(url: "$deletePrescriptionApi/$prescriptionId",);

      final response = await api.delete(auth: true);

      if (response['success'] == true) {
        prescriptions.removeWhere((p) => p.id == prescriptionId);

        AppSnackbar.show(
          title: "Deleted",
          message: "Prescription deleted successfully",
          type: AppSnackType.success,
        );
      } else {
        AppSnackbar.show(
          title: "Failed",
          message: response['message'] ?? "Unable to delete prescription",
          type: AppSnackType.error,
        );
      }
    } catch (e) {
      AppSnackbar.show(
        title: "Error",
        message: "Something went wrong",
        type: AppSnackType.error,
      );
    }
  }
}