import 'package:get/get.dart';

import '../services/api_service.dart';
import '../services/apis.dart';
import '../utils/overlay.dart';
import '../utils/snackbar.dart';

class DischargeControllers extends GetxController {

  /// ================= CREATE DISCHARGE SUMMARY =================
  Future<void> createDischargeSummary({
    required String patientMongoId,
    required Map<String, String> formData,
  }) async {
    try {
      LoadingOverlayService.show(message: "Creating discharge summary...");

      final helper = NetworkHelper(url: createDischargeSummaryApi);

      /// API CALL
      final response = await helper.post(
        auth: true,
        body: {
          "patientMongoId": patientMongoId,
          "chiefComplaints": formData["Chief Complaints"] ?? "",
          "historyOfPatientIllness": formData["History of Present Illness"] ?? "",
          "pastMedicalHistory": formData["Past Medical History"] ?? "",
          "examinationFindings": formData["Examination Findings"] ?? "",
          "investigations": formData["Investigations"] ?? "",
          "finalDiagnosis": formData["Final Diagnosis"] ?? "",
          "treatmentGiven": formData["Treatment Given"] ?? "",
          "courseInHospital": formData["Course in Hospital"] ?? "",
          "conditionAtDischarge": formData["Condition at Discharge"] ?? "",
          "medicationOnDischarge": formData["Medications on Discharge"] ?? "",
          "followUpInstructions": formData["Follow-up Instructions"] ?? "",
          "dietAdvice": formData["Diet Advice"] ?? "",
          "activityRestrictions": formData["Activity Restrictions"] ?? "",
        },
      );

      /// hide loader
      LoadingOverlayService.hide();

      /// SUCCESS
      if (response["success"] == true) {
        AppSnackbar.show(
          title: "Success",
          message: "Discharge summary created successfully",
          type: AppSnackType.success,
        );

        return;
      }

      /// ERROR
      AppSnackbar.show(
        title: "Failed",
        message: response["message"] ?? "Something went wrong",
        type: AppSnackType.error,
      );

    } catch (e) {
      LoadingOverlayService.hide();

      AppSnackbar.show(
        title: "Error",
        message: e.toString(),
        type: AppSnackType.error,
      );
    }
  }

  /// ================= GENERATE PDF =================
  Future<String?> generateDischargePdf({
    required String patientMongoId,
    required Map<String, String> formData,
  }) async {
    try {
      LoadingOverlayService.show(message: "Generating PDF...");

      final helper = NetworkHelper(url: createDischargeSummaryApi);

      final response = await helper.post(
        auth: true,
        body: {
          "patientMongoId": patientMongoId,
          "chiefComplaints": formData["Chief Complaints"] ?? "",
          "historyOfPatientIllness": formData["History of Present Illness"] ?? "",
          "pastMedicalHistory": formData["Past Medical History"] ?? "",
          "examinationFindings": formData["Examination Findings"] ?? "",
          "investigations": formData["Investigations"] ?? "",
          "finalDiagnosis": formData["Final Diagnosis"] ?? "",
          "treatmentGiven": formData["Treatment Given"] ?? "",
          "courseInHospital": formData["Course in Hospital"] ?? "",
          "conditionAtDischarge": formData["Condition at Discharge"] ?? "",
          "medicationOnDischarge": formData["Medications on Discharge"] ?? "",
          "followUpInstructions": formData["Follow-up Instructions"] ?? "",
          "dietAdvice": formData["Diet Advice"] ?? "",
          "activityRestrictions": formData["Activity Restrictions"] ?? "",
        },
      );

      LoadingOverlayService.hide();

      if (response["success"] == true) {
        final data = response["data"];

        /// get pdf url
        final pdfUrl = data["localDriveUrl"] ?? data["googleDriveUrl"];

        if (pdfUrl != null) {
          AppSnackbar.show(
            title: "Success",
            message: "PDF generated successfully",
            type: AppSnackType.success,
          );

          return pdfUrl;
        }
      }

      AppSnackbar.show(
        title: "Failed",
        message: response["message"] ?? "Could not generate PDF",
        type: AppSnackType.error,
      );

      return null;
    } catch (e) {
      LoadingOverlayService.hide();

      AppSnackbar.show(
        title: "Error",
        message: e.toString(),
        type: AppSnackType.error,
      );

      return null;
    }
  }

  Future<String?> viewDischargePdf({
    required String patientMongoId,
    required Map<String, String> formData,
  }) async {
    try {
      LoadingOverlayService.show(message: "Loading Preview...");

      final helper = NetworkHelper(url: viewDischargeSummaryApi);

      final response = await helper.postRaw(
        auth: true,
        body: {
          "patientMongoId": patientMongoId,
          "chiefComplaints": formData["Chief Complaints"] ?? "",
          "historyOfPatientIllness": formData["History of Present Illness"] ?? "",
          "pastMedicalHistory": formData["Past Medical History"] ?? "",
          "examinationFindings": formData["Examination Findings"] ?? "",
          "investigations": formData["Investigations"] ?? "",
          "finalDiagnosis": formData["Final Diagnosis"] ?? "",
          "treatmentGiven": formData["Treatment Given"] ?? "",
          "courseInHospital": formData["Course in Hospital"] ?? "",
          "conditionAtDischarge": formData["Condition at Discharge"] ?? "",
          "medicationOnDischarge": formData["Medications on Discharge"] ?? "",
          "followUpInstructions": formData["Follow-up Instructions"] ?? "",
          "dietAdvice": formData["Diet Advice"] ?? "",
          "activityRestrictions": formData["Activity Restrictions"] ?? "",
        },
      );

      LoadingOverlayService.hide();

      if (response.statusCode == 200) {
        final htmlData = response.body;
        return htmlData;
      }

      AppSnackbar.show(
        title: "Failed",
        message: "Could not load preview",
        type: AppSnackType.error,
      );

      return null;
    } catch (e) {
      LoadingOverlayService.hide();

      AppSnackbar.show(
        title: "Error",
        message: e.toString(),
        type: AppSnackType.error,
      );

      return null;
    }
  }

}
