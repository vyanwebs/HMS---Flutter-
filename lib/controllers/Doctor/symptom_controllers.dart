import 'dart:developer';

import 'package:get/get.dart';

import '../../models/symptoms_model.dart';
import '../../screens/doctor/monitoring/patient_details_symptoms.dart';
import '../../services/api_service.dart';
import '../../services/apis.dart';
import '../../utils/overlay.dart';
import '../../utils/snackbar.dart';

class SymptomControllers extends GetxController {

  final isLoading = false.obs;

  final allSymptomRecords = <SymptomRecord>[].obs;
  
  final symptomRecords = <SymptomRecord>[].obs;

  /// Available master list (can come from API later)
  final availableSymptoms = <String>[
    "Fever",
    "Chills / Rigors",
    "Fatigue",
    "Cough",
    "Headache",
  ].obs;

  /// Selected symptoms
  final selectedSymptoms = <String>[].obs;

  /// Add or remove symptom
  void toggleSymptom(String symptom) {
    if (selectedSymptoms.contains(symptom)) {
      selectedSymptoms.remove(symptom);
    } else {
      selectedSymptoms.add(symptom);
    }
  }

  /// Add custom symptom
  void addCustomSymptom(String symptom) {
    if (symptom.trim().isEmpty) return;

    selectedSymptoms.add(symptom.trim());

    if (!availableSymptoms.contains(symptom.trim())) {
      availableSymptoms.add(symptom.trim());
    }
  }

  /// Clear all
  void clearSelection() {
    selectedSymptoms.clear();
  }

  Future<bool> createSymptoms({
    required String patientMongoId,
    required List<String> symptoms,
  }) async {
    try {
      if (symptoms.isEmpty) {
        AppSnackbar.show(
          title: "Validation",
          message: "Please add at least one symptom",
          type: AppSnackType.warning,
        );
        return false;
      }

      LoadingOverlayService.show(message: "Adding symptoms...");

      final helper = NetworkHelper(url: createSymptomsApi);

      /// Build x-www-form-urlencoded body
      final Map<String, dynamic> body = {
        "patientMongoId": patientMongoId,
      };

      for (int i = 0; i < symptoms.length; i++) {
        body["symptoms[$i][name]"] = symptoms[i];
        // body["symptoms[$i][severity]"] = "moderate"; // default
        // body["symptoms[$i][duration]"] = "1 day"; // default
        // body["symptoms[$i][message]"] = "";
      }

      final response = await helper.postData(
        auth: true,
        body: body,
      );

      LoadingOverlayService.hide();

      if (response["success"] == true) {
        fetchSymptoms(patientMongoId);
        AppSnackbar.show(
          title: "Success",
          message: "Symptoms added successfully",
          type: AppSnackType.success,
        );

        clearSelection();
        return true;
      } else {
        AppSnackbar.show(
          title: "Failed",
          message: "Unable to add symptoms",
          type: AppSnackType.error,
        );
        return false;
      }

    } catch (e, s) {
      LoadingOverlayService.hide();
      log("$e, $s");

      AppSnackbar.show(
        title: "Error",
        message: e.toString(),
        type: AppSnackType.error,
      );
      return false;
    }
  }

  Future<void> fetchSymptoms(
    String patientMongoId, {
    String sort = "newest",
  }) async {
    try {
      isLoading.value = true;

      final uri = Uri.parse("$fetchAllSymptomsApi/$patientMongoId")
          .replace(queryParameters: {
        "search": "", // always empty
        "sort": sort,
      });

      final helper = NetworkHelper(url: uri.toString());

      final response = await helper.get(auth: true);

      if (response['success'] == true) {
        final List data = response['data'] ?? [];

        final records = data
            .map((e) => SymptomRecord.fromJson(e))
            .where((r) => r.symptoms.isNotEmpty)
            .toList();

        allSymptomRecords.assignAll(records);
        symptomRecords.assignAll(records); // initially full list
      } else {
        allSymptomRecords.clear();
        symptomRecords.clear();
      }
    } catch (e, s) {
      log("Fetch error: $e, $s");
      allSymptomRecords.clear();
      symptomRecords.clear();
    } finally {
      isLoading.value = false;
    }
  }

  final currentSearch = "".obs;
  final currentSort = "newest".obs;

  void applyLocalSearch(String query) {
    currentSearch.value = query;

    if (query.isEmpty) {
      symptomRecords.assignAll(allSymptomRecords);
      return;
    }

    final lowerQuery = query.toLowerCase();

    final filteredRecords = allSymptomRecords.map((record) {
      final matchedSymptoms = record.symptoms
          .where((symptom) =>
              symptom.name.toLowerCase().contains(lowerQuery))
          .toList();

      if (matchedSymptoms.isEmpty) return null;

      return record.copyWith(symptoms: matchedSymptoms);

    }).whereType<SymptomRecord>().toList();

    symptomRecords.assignAll(filteredRecords);
  }

  /// Selected rows for deletion
  final selectedRows = <SymptomTableRow>[].obs;

  /// Toggle selection
  void toggleRowSelection(SymptomTableRow row) {
    if (selectedRows.contains(row)) {
      selectedRows.remove(row);
    } else {
      selectedRows.add(row);
    }
  }

  /// Check if selected
  bool isRowSelected(SymptomTableRow row) {
    return selectedRows.contains(row);
  }

  /// Clear selected
  void clearSelectedRows() {
    selectedRows.clear();
  }

  Future<void> deleteSymptoms({
    required String patientMongoId,
    required String recordId,
    required List<String> symptomIds,
  }) async {
    try {
      if (symptomIds.isEmpty) return;

      LoadingOverlayService.show(message: "Deleting symptom(s)...");

      final helper = NetworkHelper(
        url: "$deleteSymptomsApi/$recordId/symptoms",
      );

      final response = await helper.patch(
        auth: true,
        body: {
          "symptomIds": symptomIds,
        },
      );

      LoadingOverlayService.hide();

      if (response["success"] == true) {
        fetchSymptoms(patientMongoId);

        AppSnackbar.show(
          title: "Success",
          message: "Symptom(s) deleted successfully",
          type: AppSnackType.success,
        );

        selectedRows.clear();
      } else {
        AppSnackbar.show(
          title: "Failed",
          message: response["message"] ?? "Delete failed",
          type: AppSnackType.error,
        );
      }

    } catch (e, s) {
      LoadingOverlayService.hide();
      log("$e, $s");

      AppSnackbar.show(
        title: "Error",
        message: e.toString(),
        type: AppSnackType.error,
      );
    }
  }
}
