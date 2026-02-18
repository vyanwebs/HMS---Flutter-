import 'dart:async';
import 'dart:developer';

import 'package:get/get.dart';

import '../../models/prescription_model.dart';
import '../../models/traetment_model.dart';
import '../../services/api_service.dart';
import '../../services/apis.dart';
import '../../utils/overlay.dart';
import '../../utils/snackbar.dart';

class PatientDetailsTreatmentControllers extends GetxController {

  // ---------------- TAB STATE ----------------
  final activeTab = 0.obs;

  // ---------------- LOADING ----------------
  final isMedicationLoading = false.obs;
  final isIVFluidLoading = false.obs;
  final isProcedureLoading = false.obs;
  final isInstructionLoading = false.obs;
  
  // ---------------- DATA ----------------
  final medicationList = <TreatmentMedicationModel>[].obs;
  final ivFluidList = <IvFluidTreatmentModel>[].obs;
  final procedureList = <ProcedureTreatmentModel>[].obs;
  final instructionList = <InstructionTreatmentModel>[].obs;

  final isMedicineLoading = false.obs;
  final medicines = <MedicineModel>[].obs;
  final selectedMedicine = Rxn<MedicineModel>();
  Timer? _medicineDebounce;

  // ---------------- TAB CHANGE HANDLER ----------------
  void changeTab(int index, String patientId) {
    if (activeTab.value == index) return;

    activeTab.value = index;

    if (index == 0 && medicationList.isEmpty) {
      fetchMedicationTreatments(patientId);
    }

    if (index == 1 && ivFluidList.isEmpty) {
      fetchIvFluidTreatments(patientId);
    }

    if (index == 2 && procedureList.isEmpty) {
      fetchProcedureTreatments(patientId);
    }

    if (index == 3 && instructionList.isEmpty) {
      fetchInstructionTreatments(patientId);
    }

  }

  // ---------------- REFRESH ----------------
  Future<void> refreshCurrentTab(String patientId) async {
    if (activeTab.value == 0) {
      await fetchMedicationTreatments(patientId);
    } else if (activeTab.value == 1) {
      await fetchIvFluidTreatments(patientId);
    } else if (activeTab.value == 2) {
      await fetchProcedureTreatments(patientId);
    } else if (activeTab.value == 3) {
      await fetchInstructionTreatments(patientId);
    }
  }

  // ================== Medication ======================

  Future<void> fetchMedicationTreatments(String patientMongoId) async {
    try {
      isMedicationLoading.value = true;

      final api = NetworkHelper(
        url: "$getMedicationByPatientIdApi/$patientMongoId",
      );

      final response = await api.get(auth: true);

      if (response['success'] == true && response['data'] != null) {
        medicationList.assignAll((response['data'] as List).map((e) => TreatmentMedicationModel.fromJson(e)).toList());
      } else {
        medicationList.clear();
      }
    } catch (e, s) {
      log(
        "❌ fetchMedicationTreatments failed",
        error: e,
        stackTrace: s,
      );
      medicationList.clear();
    } finally {
      isMedicationLoading.value = false;
    }
  }

  Future<bool> createMedicationTreatment({
    required String patientMongoId,
    required String medicationName,
    required String dosages,
    required String medicationType,
  }) async {
    try {
      LoadingOverlayService.show(message: "Adding treatment...");

      final api = NetworkHelper(
        url: createMedicationTreatmentApi,
      );

      final response = await api.post(
        auth: true,
        body: {
          "patientMongoId": patientMongoId,
          "medicationName": medicationName.trim(),
          "dosages": dosages.trim(),
          "medicationType": medicationType.trim(),
          "status": "Pending",
        },
      );

      final isSuccess = response['success'] == true;

      if (isSuccess) {
        await fetchMedicationTreatments(patientMongoId);

        AppSnackbar.show(
          title: "Success",
          message: "Treatment added successfully",
          type: AppSnackType.success,
        );
        return true;
      }

      AppSnackbar.show(
        title: "Failed",
        message: response['message'] ?? "Unable to add treatment",
        type: AppSnackType.error,
      );
      return false;
    } catch (e, s) {
      log("❌ createMedicationTreatment failed", error: e, stackTrace: s);

      AppSnackbar.show(
        title: "Error",
        message: "Something went wrong",
        type: AppSnackType.error,
      );
      return false;
    } finally {
      LoadingOverlayService.hide();
    }
  }
  
  Future<bool> deleteMedicationTreatment({
    required String medicationId,
    required String patientMongoId,
  }) async {
    try {
      LoadingOverlayService.show(message: "Deleting treatment...");

      final api = NetworkHelper(
        url: "$deleteMedicationTreatmentApi/$medicationId",
      );

      final response = await api.delete(auth: true);

      if (response['success']) {
        await fetchMedicationTreatments(patientMongoId);

        AppSnackbar.show(
          title: "Deleted",
          message: "Treatment deleted successfully",
          type: AppSnackType.success,
        );
        return true;
      }

      AppSnackbar.show(
        title: "Failed",
        message: response['message'] ?? "Unable to delete treatment",
        type: AppSnackType.error,
      );
      return false;
    } catch (e, s) {
      log(
        "❌ deleteMedicationTreatment failed",
        error: e,
        stackTrace: s,
      );

      AppSnackbar.show(
        title: "Error",
        message: "Something went wrong",
        type: AppSnackType.error,
      );
      return false;
    } finally {
      LoadingOverlayService.hide();
    }
  }
  
  Future<bool> updateMedicationTreatment({
    required String medicationId,
    required String medicationName,
    required String dosages,
    required String medicationType,
    required String status,
    required String patientMongoId,
  }) async {
    try {
      LoadingOverlayService.show(message: "Updating treatment...");

      final api = NetworkHelper(
        url: "$updateMedicationTreatmentApi/$medicationId",
      );

      final response = await api.patch(
        auth: true,
        isFormData: true,
        body: {
          "medicationName": medicationName.trim(),
          "dosages[timeOfDay]": dosages.trim(),
          "medicationType": medicationType.trim(),
          "status": status.trim(),
        },
      );

      if (response['success']) {
        await fetchMedicationTreatments(patientMongoId);

        AppSnackbar.show(
          title: "Updated",
          message: "Treatment updated successfully",
          type: AppSnackType.success,
        );
        return true;
      }

      AppSnackbar.show(
        title: "Failed",
        message: response['message'] ?? "Unable to update treatment",
        type: AppSnackType.error,
      );
      return false;
    } catch (e, s) {
      log("❌ updateMedicationTreatment failed", error: e, stackTrace: s);

      AppSnackbar.show(
        title: "Error",
        message: "Something went wrong",
        type: AppSnackType.error,
      );
      return false;
    } finally {
      LoadingOverlayService.hide();
    }
  }

  // ================== IV FLUID ======================

  Future<bool> createIvFluidTreatment({
    required String patientMongoId,
    required String ivFluidName,
    required String quantity,
    required String duration,
  }) async {
    try {
      LoadingOverlayService.show(message: "Adding IV fluid...");

      final api = NetworkHelper(url: createIVFluidTreatmentApi);

      final response = await api.post(
        auth: true,
        body: {
          "patientMongoId": patientMongoId,
          "ivFluidName": ivFluidName.trim(),
          "quantity": quantity.trim(),
          "duration": duration.trim(),
          "status": "Pending",
        },
      );


      if (response['success']) {
        fetchIvFluidTreatments(patientMongoId);
        AppSnackbar.show(
          title: "Success",
          message: "IV fluid added successfully",
          type: AppSnackType.success,
        );
        return true;
      }
      LoadingOverlayService.hide();
      AppSnackbar.show(
        title: "Failed",
        message: response['message'] ?? "Unable to add IV fluid",
        type: AppSnackType.error,
      );
      return false;
    } catch (e, s) {
      log("❌ createIvFluidTreatment failed", error: e, stackTrace: s);
      LoadingOverlayService.hide();
      AppSnackbar.show(
        title: "Error",
        message: "Something went wrong",
        type: AppSnackType.error,
      );
      return false;
    } finally {
      LoadingOverlayService.hide();
    }
  }

  Future<void> fetchIvFluidTreatments(String patientMongoId) async {
    try {
      isIVFluidLoading.value = true;

      final api = NetworkHelper(
        url: "$getIVFluidTreatmentApi/$patientMongoId",
      );

      final response = await api.get(auth: true);

      if (response['success'] == true && response['data'] != null) {
        ivFluidList.assignAll((response['data'] as List).map((e) => IvFluidTreatmentModel.fromJson(e)).toList());
      } else {
        ivFluidList.clear();
      }
    } catch (e, s) {
      log(
        "❌ fetchIvFluidTreatments failed",
        error: e,
        stackTrace: s,
      );
      ivFluidList.clear();
    } finally {
      isIVFluidLoading.value = false;
    }
  }

  Future<bool> deleteIvFluidTreatment({
    required String ivFluidId,
    required String patientMongoId,
  }) async {
    try {
      LoadingOverlayService.show(message: "Deleting IV fluid...");

      final api = NetworkHelper(
        url: "$deleteIVFluidTreatmentApi/$ivFluidId",
      );

      final response = await api.delete(auth: true);

      if (response['success'] == true) {
        await fetchIvFluidTreatments(patientMongoId);

        AppSnackbar.show(
          title: "Deleted",
          message: "IV fluid deleted successfully",
          type: AppSnackType.success,
        );
        return true;
      }

      AppSnackbar.show(
        title: "Failed",
        message: response['message'] ?? "Unable to delete IV fluid",
        type: AppSnackType.error,
      );
      return false;
    } catch (e, s) {
      log("❌ deleteIvFluidTreatment failed", error: e, stackTrace: s);
      LoadingOverlayService.hide();
      AppSnackbar.show(
        title: "Error",
        message: "Something went wrong",
        type: AppSnackType.error,
      );
      return false;
    } finally {
      LoadingOverlayService.hide();
    }
  }

  Future<bool> updateIvFluidTreatment({
    required String ivFluidId,
    required String patientMongoId,
    required String ivFluidName,
    required String quantity,
    required String duration,
    required String status,
  }) async {
    try {
      LoadingOverlayService.show(message: "Updating IV fluid...");

      final api = NetworkHelper(
        url: "$updateIVFluidTreatmentApi/$ivFluidId",
      );

      final response = await api.patch(
        auth: true,
        isFormData: true,
        body: {
          "patientMongoId": patientMongoId,
          "ivFluidName": ivFluidName.trim(),
          "quantity": quantity.trim(),
          "duration": duration.trim(),
          "status": status.trim(),
        },
      );

      if (response['success'] == true) {
        await fetchIvFluidTreatments(patientMongoId);

        AppSnackbar.show(
          title: "Updated",
          message: "IV fluid updated successfully",
          type: AppSnackType.success,
        );
        return true;
      }

      AppSnackbar.show(
        title: "Failed",
        message: response['message'] ?? "Unable to update IV fluid",
        type: AppSnackType.error,
      );
      return false;
    } catch (e, s) {
      log("❌ updateIvFluidTreatment failed", error: e, stackTrace: s);
      LoadingOverlayService.hide();
      AppSnackbar.show(
        title: "Error",
        message: "Something went wrong",
        type: AppSnackType.error,
      );
      return false;
    } finally {
      LoadingOverlayService.hide();
    }
  }

  // =================== Procedure =====================

  Future<bool> createProcedureTreatment({
    required String patientMongoId,
    required String procedure,
    required String frequency,
  }) async {
    try {
      LoadingOverlayService.show(message: "Adding procedure...");

      final api = NetworkHelper(
        url: createProcedureTreatmentApi,
      );

      final response = await api.postData(
        auth: true,
        body: {
          "patientMongoId": patientMongoId,
          "procedure": procedure.trim(),
          "frequency": frequency.trim(),
          "status": "Pending",
        },
      );

      if (response['success']) {
        fetchProcedureTreatments(patientMongoId);
        AppSnackbar.show(
          title: "Success",
          message: "Procedure added successfully",
          type: AppSnackType.success,
        );
        return true;
      }

      AppSnackbar.show(
        title: "Failed",
        message: response['message'] ?? "Unable to add procedure",
        type: AppSnackType.error,
      );
      return false;
    } catch (e, s) {
      log(
        "❌ createProcedureTreatment failed",
        error: e,
        stackTrace: s,
      );

      AppSnackbar.show(
        title: "Error",
        message: "Something went wrong",
        type: AppSnackType.error,
      );
      return false;
    } finally {
      LoadingOverlayService.hide();
    }
  }

  Future<void> fetchProcedureTreatments(String patientMongoId) async {
    try {
      isProcedureLoading.value = true;

      final api = NetworkHelper(
        url: "$getProcedureTreatmentApi/$patientMongoId",
      );

      final response = await api.get(auth: true);

      if (response['success'] == true && response['data'] != null) {
        procedureList.assignAll((response['data'] as List).map((e) => ProcedureTreatmentModel.fromJson(e)).toList());
      } else {
        procedureList.clear();
      }
    } catch (e, s) {
      log(
        "❌ fetchProcedureTreatments failed",
        error: e,
        stackTrace: s,
      );
      procedureList.clear();
    } finally {
      isProcedureLoading.value = false;
    }
  }

  Future<bool> updateProcedureTreatment({
    required String procedureId,
    required String patientMongoId,
    required String procedure,
    required String frequency,
    required String status,
  }) async {
    try {
      LoadingOverlayService.show(message: "Updating procedure...");

      final api = NetworkHelper(
        url: "$updateProcedureTreatmentApi/$procedureId",
      );

      final response = await api.patch(
        auth: true,
        isFormData: true,
        body: {
          "patientMongoId": patientMongoId,
          "procedure": procedure.trim(),
          "frequency": frequency.trim(),
          "status": status.trim(),
        },
      );

      if (response['success'] == true) {
        await fetchProcedureTreatments(patientMongoId);

        AppSnackbar.show(
          title: "Updated",
          message: "Procedure updated successfully",
          type: AppSnackType.success,
        );
        return true;
      }

      AppSnackbar.show(
        title: "Failed",
        message: response['message'] ?? "Unable to update procedure",
        type: AppSnackType.error,
      );
      return false;
    } catch (e, s) {
      log("❌ updateProcedureTreatment failed", error: e, stackTrace: s);

      AppSnackbar.show(
        title: "Error",
        message: "Something went wrong",
        type: AppSnackType.error,
      );
      return false;
    } finally {
      LoadingOverlayService.hide();
    }
  }

  Future<bool> deleteProcedureTreatment({
    required String procedureId,
    required String patientMongoId,
  }) async {
    try {
      LoadingOverlayService.show(message: "Deleting procedure...");

      final api = NetworkHelper(
        url: "$deleteProcedureTreatmentApi/$procedureId",
      );

      final response = await api.delete(auth: true);

      if (response['success'] == true) {
        await fetchProcedureTreatments(patientMongoId);

        AppSnackbar.show(
          title: "Deleted",
          message: "Procedure deleted successfully",
          type: AppSnackType.success,
        );
        return true;
      }

      AppSnackbar.show(
        title: "Failed",
        message: response['message'] ?? "Unable to delete procedure",
        type: AppSnackType.error,
      );
      return false;
    } catch (e, s) {
      log("❌ deleteProcedureTreatment failed", error: e, stackTrace: s);

      AppSnackbar.show(
        title: "Error",
        message: "Something went wrong",
        type: AppSnackType.error,
      );
      return false;
    } finally {
      LoadingOverlayService.hide();
    }
  }

  // =================== INSTRUCTION =====================

  Future<void> fetchInstructionTreatments(String patientMongoId) async {
    try {
      isInstructionLoading.value = true;

      final api = NetworkHelper(
        url: "$getInstructionTreatmentApi/$patientMongoId",
      );

      final response = await api.get(auth: true);

      if (response['success'] == true && response['data'] != null) {
        instructionList.assignAll((response['data'] as List).map((e) => InstructionTreatmentModel.fromJson(e)).toList());
      } else {
        instructionList.clear();
      }
    } catch (e, s) {
      log(
        "❌ fetchInstructionTreatments failed",
        error: e,
        stackTrace: s,
      );
      instructionList.clear();
    } finally {
      isInstructionLoading.value = false;
    }
  }

  Future<bool> createInstructionTreatment({
    required String patientMongoId,
    required String specialInstruction,
  }) async {
    try {
      LoadingOverlayService.show(message: "Adding instruction...");

      final api = NetworkHelper(
        url: createInstructionTreatmentApi,
      );

      final response = await api.post(
        auth: true,
        body: {
          "patientMongoId": patientMongoId,
          "specialInstruction": specialInstruction.trim(),
          "status": "Pending",
        },
      );

      if (response['success'] == true) {
        AppSnackbar.show(
          title: "Success",
          message: "Instruction added successfully",
          type: AppSnackType.success,
        );
        return true;
      }

      AppSnackbar.show(
        title: "Failed",
        message: response['message'] ?? "Unable to add instruction",
        type: AppSnackType.error,
      );
      return false;
    } catch (e, s) {
      log(
        "❌ createInstructionTreatment failed",
        error: e,
        stackTrace: s,
      );
      LoadingOverlayService.hide();

      AppSnackbar.show(
        title: "Error",
        message: "Something went wrong",
        type: AppSnackType.error,
      );
      return false;
    } finally {
      LoadingOverlayService.hide();
    }
  }

  Future<bool> updateInstructionTreatment({
    required String instructionId,
    required String patientMongoId,
    required String specialInstruction,
    required String status,
  }) async {
    try {
      LoadingOverlayService.show(message: "Updating instruction...");

      final api = NetworkHelper(
        url: "$updateInstructionTreatmentApi/$instructionId",
      );

      final response = await api.patch(
        auth: true,
        isFormData: true,
        body: {
          "patientMongoId": patientMongoId,
          "specialInstruction": specialInstruction.trim(),
          "status": status.trim(),
        },
      );

      if (response['success'] == true) {
        await fetchInstructionTreatments(patientMongoId);

        AppSnackbar.show(
          title: "Updated",
          message: "Instruction updated successfully",
          type: AppSnackType.success,
        );
        return true;
      }

      AppSnackbar.show(
        title: "Failed",
        message: response['message'] ?? "Unable to update instruction",
        type: AppSnackType.error,
      );
      return false;
    } catch (e, s) {
      log("❌ updateInstructionTreatment failed", error: e, stackTrace: s);
      AppSnackbar.show(
        title: "Error",
        message: "Something went wrong",
        type: AppSnackType.error,
      );
      return false;
    } finally {
      LoadingOverlayService.hide();
    }
  }

  Future<bool> deleteInstructionTreatment({
    required String instructionId,
    required String patientMongoId,
  }) async {
    try {
      LoadingOverlayService.show(message: "Deleting instruction...");

      final api = NetworkHelper(
        url: "$deleteInstructionTreatmentApi/$instructionId",
      );

      final response = await api.delete(auth: true);

      if (response['success'] == true) {
        await fetchInstructionTreatments(patientMongoId);

        AppSnackbar.show(
          title: "Deleted",
          message: "Instruction deleted successfully",
          type: AppSnackType.success,
        );
        return true;
      }

      AppSnackbar.show(
        title: "Failed",
        message: response['message'] ?? "Unable to delete instruction",
        type: AppSnackType.error,
      );
      return false;
    } catch (e, s) {
      log("❌ deleteInstructionTreatment failed", error: e, stackTrace: s);
      AppSnackbar.show(
        title: "Error",
        message: "Something went wrong",
        type: AppSnackType.error,
      );
      return false;
    } finally {
      LoadingOverlayService.hide();
    }
  }

  void searchMedicine(String query) {
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
          dataMap.removeWhere((key, value) => value is! Map);
          medicines.assignAll(
            dataMap.values.map((e) => MedicineModel.fromJson(e)).toList(),
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
  }

  @override
  void onClose() {
    _medicineDebounce?.cancel();
    super.onClose();
  }
}

