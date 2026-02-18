import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../models/certificate_response_model.dart';
import '../../models/certificate_type_model.dart';
import '../../services/api_service.dart';
import '../../services/apis.dart';
import '../../utils/overlay.dart';
import '../../utils/snackbar.dart';

class CertificateControllers extends GetxController {

  RxBool isLoading = false.obs;
  RxBool isAddingType = false.obs;

  final diagnosisCtrl = TextEditingController();
  final medicalLeaveStartDateCtrl = TextEditingController();
  final expecteRestDurationCtrl = TextEditingController();
  final expectedReturnDateCtrl = TextEditingController();
  final additionalNotesCtrl = TextEditingController();

  final certificateNameCtrl = TextEditingController();
  final certificateDescriptionCtrl = TextEditingController();

  final PdfViewerController pdfViewerController = PdfViewerController();

  DateTime? medicalLeaveStartDate;
  DateTime? expectedReturnDate;

  Future<void> pickDate({
    required BuildContext context,
    required bool isStartDate,
  }) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      final formatted = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";

      if (isStartDate) {
        medicalLeaveStartDate = picked;
        medicalLeaveStartDateCtrl.text = formatted;
      } else {
        expectedReturnDate = picked;
        expectedReturnDateCtrl.text = formatted;
      }
    }
  }
  
  final RxString selectedCertificate = "Illness Certificate".obs;

  final certificateResponse = Rxn<CertificateResponse>();

  final List<CertificateType> fixedCertificates = const [
    CertificateType(
      id: "fixed_illness",
      certificateName: "Illness Certificate",
      description: "",
      icon: HugeIcon(icon: HugeIcons.strokeRoundedDocumentAttachment),
      isFixed: true,
    ),
    CertificateType(
      id: "fixed_fitness",
      certificateName: "Fitness Certificate",
      description: "",
      icon: Icon(Icons.fitness_center),
      isFixed: true,
    ),
    CertificateType(
      id: "fixed_disability",
      certificateName: "Disability Certificate",
      description: "",
      icon: HugeIcon(icon: HugeIcons.strokeRoundedDisability01),
      isFixed: true,
    ),
    CertificateType(
      id: "fixed_vaccination",
      certificateName: "Vaccination Certificate",
      description: "",
      icon: HugeIcon(icon: HugeIcons.strokeRoundedVaccine),
      isFixed: true,
    ),
  ];

  final RxList<CertificateType> certificates = <CertificateType>[].obs;

  void selectCertificate(String value) {
    selectedCertificate.value = value;
  }

  @override
  void onInit() {
    super.onInit();
    getCertificateTypes();
  }

  Future<void> generateCertificate({
    required String patientMongoId,
    required String diagnosis,
    required String medicalLeaveStartDate,
    required String expectedRestDuration,
    required String expectedReturnDate,
    required String additionalNotes,
  }) async {
    try {
      
      isLoading.value = true;

      LoadingOverlayService.show(message: "Generating Certificate...");

      final helper = NetworkHelper(url: generateCertificateApi);

      final response = await helper.postData(
        body: {
          "patientMongoId": patientMongoId,
          "diagnosis": diagnosis,
          "medicalLeaveStartDate": medicalLeaveStartDate,
          "expectedRestDuration": expectedRestDuration,
          "expectedReturnDate": expectedReturnDate,
          "additionalNotes": additionalNotes,
          "certificateType": selectedCertificate.value,
        },
        auth: true
      );

      if (response["success"] == true) {
        certificateResponse.value = CertificateResponse.fromJson(response["data"]);

        clearForm();
        LoadingOverlayService.hide();

        AppSnackbar.show(
          title: "Success",
          message: "Certificate generated successfully",
          type: AppSnackType.success
        );
      } else {
        throw response["message"] ?? "Something went wrong";
      }
    } catch (e, s) {
      log("❌ generateCertificate failed", error: e, stackTrace: s);
      LoadingOverlayService.hide();
      AppSnackbar.show(
        title: "Error",
        message: e.toString(),
        type: AppSnackType.error
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addCustomCertificateType() async {
    try {
      isAddingType.value = true;

      final helper = NetworkHelper(url: addCertificateTypeApi);

      final response = await helper.postData(
        auth: true,
        body: {
          "certificateName": certificateNameCtrl.text.trim(),
          "description": certificateDescriptionCtrl.text.trim(),
        },
      );

      if (response["success"] == true) {
        certificateNameCtrl.clear();
        certificateDescriptionCtrl.clear();

        /// REFRESH from server
        await getCertificateTypes();

        AppSnackbar.show(
          title: "Success",
          message: "Certificate type added successfully",
          type: AppSnackType.success,
        );
      } else {
        throw response["message"] ?? "Failed to add certificate type";
      }
    } catch (e, s) {
      log("❌ addCustomCertificateType failed", error: e, stackTrace: s);

      AppSnackbar.show(
        title: "Error",
        message: e.toString(),
        type: AppSnackType.error,
      );
    } finally {
      isAddingType.value = false;
    }
  }

  Future<void> getCertificateTypes() async {
    try {
      isLoading.value = true;

      final helper = NetworkHelper(url: getCertificateTypeApi);

      final response = await helper.get(auth: true);

      if (response["success"] == true) {
        final List list = response["data"] ?? [];

        /// Start fresh with fixed certificates
        certificates
          ..clear()
          ..addAll(fixedCertificates)
          ..addAll(
            list.map((e) => CertificateType.fromJson(e)),
          );
      } else {
        throw response["message"] ?? "Failed to load certificate types";
      }
    } catch (e, s) {
      log("❌ getCertificateTypes failed", error: e, stackTrace: s);

      AppSnackbar.show(
        title: "Error",
        message: e.toString(),
        type: AppSnackType.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteCertificateType(String id) async {
    try {
      LoadingOverlayService.show(message: "Deleting certificate type...");

      final helper = NetworkHelper(url: "$getCertificateTypeApi/$id",);

      final response = await helper.delete(auth: true);

      if (response["success"] == true) {
        await getCertificateTypes();

        AppSnackbar.show(
          title: "Deleted",
          message: "Certificate type deleted successfully",
          type: AppSnackType.success,
        );
      } else {
        throw response["message"] ?? "Failed to delete certificate type";
      }
    } catch (e, s) {
      log("❌ deleteCertificateType failed", error: e, stackTrace: s);

      AppSnackbar.show(
        title: "Error",
        message: e.toString(),
        type: AppSnackType.error,
      );
    } finally {
      LoadingOverlayService.hide();
    }
  }

  void clearForm() {
    diagnosisCtrl.clear();
    medicalLeaveStartDateCtrl.clear();
    expecteRestDurationCtrl.clear();
    expectedReturnDateCtrl.clear();
    additionalNotesCtrl.clear();

    medicalLeaveStartDate = null;
    expectedReturnDate = null;

    selectedCertificate.value = "Illness Certificate";
  }

  @override
  void onClose() {
    medicalLeaveStartDateCtrl.dispose();
    expectedReturnDateCtrl.dispose();
    super.onClose();
  }
}
