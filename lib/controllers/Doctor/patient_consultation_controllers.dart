import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hms/services/api_service.dart';
import 'package:hms/services/apis.dart';
import 'package:hms/utils/overlay.dart';
import 'package:hms/utils/snackbar.dart';

class PatientConsultationController extends GetxController {
  late String patientMongoId;

  /// ================= LOADER STATE =================
  bool _isLoaderVisible = false;

  /// ================= TEXT CONTROLLERS =================
  final allergiesCtrl = TextEditingController();
  final personalHabitsCtrl = TextEditingController();
  final chiefComplaintCtrl = TextEditingController();
  final describeAllergiesCtrl = TextEditingController();
  final illnessCtrl = TextEditingController();
  final pastHistoryCtrl = TextEditingController();
  final familyHistoryCtrl = TextEditingController();
  final investigationCtrl = TextEditingController();
  final menstrualCtrl = TextEditingController();
  final visualCtrl = TextEditingController();
  final immunizationCtrl = TextEditingController();
  final pulseCtrl = TextEditingController();
  final bpCtrl = TextEditingController();
  final tempCtrl = TextEditingController();
  final oxygenCtrl = TextEditingController();
  
  /// ================= RX OBSERVABLE FOR FORM RESET =================
  final RxBool formSubmitted = false.obs;

  /// ================= SET PATIENT =================
  void setPatient(String id) {
    patientMongoId = id;
  }

  /// ================= RESET FORM FIELDS =================
  void clearFormFields() {
    allergiesCtrl.clear();
    personalHabitsCtrl.clear();
    chiefComplaintCtrl.clear();
    describeAllergiesCtrl.clear();
    illnessCtrl.clear();
    pastHistoryCtrl.clear();
    familyHistoryCtrl.clear();
    investigationCtrl.clear();
    menstrualCtrl.clear();
    visualCtrl.clear();
    immunizationCtrl.clear();
    pulseCtrl.clear();
    bpCtrl.clear();
    tempCtrl.clear();
    oxygenCtrl.clear();
    
    // Trigger UI update
    formSubmitted.toggle();
  }

  /// ================= SAFE SHOW - FIXED VERSION =================
  void _showLoader() {
    if (!_isLoaderVisible) {
      try {
        // Try to show immediately
        LoadingOverlayService.show(message: "Creating consultation...");
        _isLoaderVisible = true;
      } catch (e) {
        // If failed, try with post frame callback
        WidgetsBinding.instance.addPostFrameCallback((_) {
          try {
            LoadingOverlayService.show(message: "Creating consultation...");
            _isLoaderVisible = true;
          } catch (e) {
            print("Error showing loader: $e");
            // If still fails, just proceed without loader
            _isLoaderVisible = true;
          }
        });
      }
    }
  }

  /// ================= SAFE HIDE =================
  void _hideLoader() {
    if (_isLoaderVisible) {
      try {
        LoadingOverlayService.hide();
      } catch (_) {}
      _isLoaderVisible = false;
    }
  }

  /// ================= INIT =================
  @override
  void onInit() {
    _hideLoader(); // reset on hot restart
    super.onInit();
  }

  Future<void> submitConsultation() async {
    try {
      /// SHOW LOADER
      _showLoader();

      final helper = NetworkHelper(url: createconsultationApi);

      final response = await helper.post(
        auth: true,
        body: {
          "patientMongoId": patientMongoId,

          "allergies": allergiesCtrl.text,
          "personalHabits": personalHabitsCtrl.text,
          "chiefComplaints": chiefComplaintCtrl.text,
          "describeAllergies": describeAllergiesCtrl.text,

          "historyOfPatientIllness": illnessCtrl.text,
          "pastMedicalHistory": pastHistoryCtrl.text,
          "familyHistory": familyHistoryCtrl.text,

          "relevantPreviousInvestigations": investigationCtrl.text,
          "menstrualHistory": menstrualCtrl.text,
          "visualAnalogue": visualCtrl.text,
          "immunizationHistory": immunizationCtrl.text,

          "pulse": pulseCtrl.text,
          "bloodPressure": bpCtrl.text,
          "temperature": tempCtrl.text,
          "oxygenSaturation": oxygenCtrl.text,
        },
      );

      /// HIDE LOADER
      _hideLoader();

      /// SUCCESS
      if (response["success"] == true) {
        AppSnackbar.show(
          title: "Success",
          message: response["message"] ?? "Consultation created successfully",
          type: AppSnackType.success,
        );

        /// Clear all form fields
        clearFormFields();

        /// WAIT so user can read snackbar
        await Future.delayed(const Duration(seconds: 2));

        if (Get.isOverlaysClosed) {
          Get.back();
        }

        return;
      }

      /// FAILED
      AppSnackbar.show(
        title: "Failed",
        message: response["message"] ?? "Something went wrong",
        type: AppSnackType.error,
      );
    } catch (e) {
      /// HIDE LOADER
      _hideLoader();

      AppSnackbar.show(
        title: "Error",
        message: e.toString(),
        type: AppSnackType.error,
      );
    }
  }

  /// ================= DISPOSE =================
  @override
  void onClose() {
    _hideLoader();

    allergiesCtrl.dispose();
    personalHabitsCtrl.dispose();
    chiefComplaintCtrl.dispose();
    describeAllergiesCtrl.dispose();
    illnessCtrl.dispose();
    pastHistoryCtrl.dispose();
    familyHistoryCtrl.dispose();
    investigationCtrl.dispose();
    menstrualCtrl.dispose();
    visualCtrl.dispose();
    immunizationCtrl.dispose();
    pulseCtrl.dispose();
    bpCtrl.dispose();
    tempCtrl.dispose();
    oxygenCtrl.dispose();

    super.onClose();
  }
}