import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/prescription_model.dart';
import '../../services/api_service.dart';
import '../../services/apis.dart';
import '../../utils/overlay.dart';
import '../../utils/snackbar.dart';

/// ======================================================
/// ADVANCED PRESCRIPTION CONTROLLER (NEW FLOW ONLY)
/// Does NOT affect old prescription pages
/// ======================================================
class AdvancedPrescriptionController extends GetxController {
  // ================== STATES ==================
  final RxBool isLoading = false.obs;
  final RxBool isSearching = false.obs;
  final RxBool isLoadingCommonMeds = false.obs;
  final RxBool isLoadingAISuggestions = false.obs;

  // ================== PATIENT ==================
  final RxString patientMongoId = ''.obs;

  void setPatient(String id) {
    patientMongoId.value = id;
  }

  // ================== DIAGNOSIS ==================
  final TextEditingController diagnosisCtrl = TextEditingController();
  final RxString diagnosisError = ''.obs;

  // ================== MEDICINE SEARCH ==================
  final RxList<MedicineModel> medicines = <MedicineModel>[].obs;
  final Rxn<MedicineModel> selectedMedicine = Rxn<MedicineModel>();

  final TextEditingController medicineSearchCtrl = TextEditingController();

  Timer? _debounce;

  // ================== COMMON MEDICINES ==================
  final RxList<MedicineModel> commonMedicines = <MedicineModel>[].obs;
  
  // ================== AI MEDICINE SUGGESTIONS ==================
  final RxList<MedicineModel> aiSuggestions = <MedicineModel>[].obs;
  final RxString aiCondition = ''.obs; // e.g., "hypertension", "diabetes", etc.

  // ================== DOSAGE ==================
  final TextEditingController morningCtrl = TextEditingController();
  final TextEditingController afternoonCtrl = TextEditingController();
  final TextEditingController nightCtrl = TextEditingController();

  final RxBool isBeforeMeal = true.obs;

  // ================== OTHER ==================
  final TextEditingController durationCtrl = TextEditingController();
  final TextEditingController commentCtrl = TextEditingController();

  // ================== LIST ==================
  final RxList<PrescriptionItem> items = <PrescriptionItem>[].obs;

  // ================== ERRORS ==================
  final RxString medicineError = ''.obs;
  final RxString dosageError = ''.obs;

  // ======================================================
  // LIFECYCLE
  // ======================================================

  @override
  void onInit() {
    super.onInit();
    // Load common medicines when controller initializes
    fetchCommonMedicines();
  }

  @override
  void onClose() {
    diagnosisCtrl.dispose();
    medicineSearchCtrl.dispose();
    morningCtrl.dispose();
    afternoonCtrl.dispose();
    nightCtrl.dispose();
    durationCtrl.dispose();
    commentCtrl.dispose();

    _debounce?.cancel();

    super.onClose();
  }

  // ======================================================
  // FETCH COMMON MEDICINES FROM API
  // ======================================================
// ======================================================
// FETCH COMMON MEDICINES FROM API - FIXED FOR YOUR API FORMAT
// ======================================================
Future<void> fetchCommonMedicines() async {
  try {
    isLoadingCommonMeds.value = true;
    
    log("📡 Fetching common medicines from: $getMedicinelistApi");
    
    final api = NetworkHelper(
      url: getMedicinelistApi,
    );

    final response = await api.get(auth: true);
    
    log("📦 Response received: $response");

    // Clear existing data
    commonMedicines.clear();

    if (response != null && response.isNotEmpty) {
      
      // Your API returns a Map with 'success' and 'data' fields
      if (response is Map<String, dynamic>) {
        
        // Check if success is true and data exists
        if (response['success'] == true && response.containsKey('data')) {
          
          final dataList = response['data'];
          
          // Check if data is a List
          if (dataList is List) {
            log("✅ Found ${dataList.length} medicines in data array");
            
            final List<MedicineModel> medicinesList = [];
            
            for (var item in dataList) {
              try {
                if (item is Map<String, dynamic>) {
                  // Convert your API response format to MedicineModel
                  medicinesList.add(MedicineModel(
                    id: item['_id'] ?? '',  // API uses _id, not id
                    name: item['name'] ?? 'Unknown',
                    category: item['stockStatus'], // Use stockStatus as category
                    // Add other fields as needed
                  ));
                }
              } catch (e) {
                log("❌ Error parsing medicine item: $e");
              }
            }
            
            commonMedicines.assignAll(medicinesList);
            log("✅ Successfully loaded ${commonMedicines.length} common medicines");
          } else {
            log("⚠️ 'data' field is not a List: ${dataList.runtimeType}");
          }
        } else {
          log("⚠️ API response missing success flag or data field");
        }
      } else {
        log("⚠️ Response is not a Map: ${response.runtimeType}");
      }
    } else {
      log("⚠️ Response is null or empty");
    }
    
    // If still no medicines, show a user-friendly message
    if (commonMedicines.isEmpty) {
      log("⚠️ No medicines loaded from API");
    }
    
  } catch (e, s) {
    log("❌ fetchCommonMedicines error", error: e, stackTrace: s);
  } finally {
    isLoadingCommonMeds.value = false;
  }
}
  // ======================================================
  // FETCH AI MEDICINE SUGGESTIONS BASED ON DIAGNOSIS
  // ======================================================
  Future<void> fetchAISuggestions(String diagnosis) async {
    if (diagnosis.trim().isEmpty) {
      aiSuggestions.clear();
      return;
    }

    try {
      isLoadingAISuggestions.value = true;
      aiCondition.value = diagnosis;

      // Search for medicines related to the diagnosis
      final api = NetworkHelper(
        url: "$getMedicineApi?name=${Uri.encodeQueryComponent(diagnosis)}",
      );

      final response = await api.get(auth: true);

      if (response.isNotEmpty) {
        final map = Map<String, dynamic>.from(response);

        map.removeWhere(
          (k, v) => v is! Map,
        );

        // Take only first 3-5 suggestions
        final suggestions = map.values
            .map((e) => MedicineModel.fromJson(e))
            .take(5)
            .toList();

        aiSuggestions.assignAll(suggestions);
        log("✅ Loaded ${aiSuggestions.length} AI suggestions for: $diagnosis");
      } else {
        aiSuggestions.clear();
      }
    } catch (e, s) {
      log("❌ fetchAISuggestions", error: e, stackTrace: s);
      aiSuggestions.clear();
    } finally {
      isLoadingAISuggestions.value = false;
    }
  }

  // ======================================================
  // MEAL
  // ======================================================

  void selectBeforeMeal() => isBeforeMeal.value = true;
  void selectAfterMeal() => isBeforeMeal.value = false;

  // ======================================================
  // MEDICINE SEARCH
  // ======================================================

  Future<void> searchMedicine(String query) async {
    final q = query.trim();

    if (q.length <= 3) {
      medicines.clear();
      return;
    }

    _debounce?.cancel();

    _debounce = Timer(
      const Duration(milliseconds: 400),
      () async {
        try {
          isSearching.value = true;

          final api = NetworkHelper(
            url: "$getMedicineApi?name=${Uri.encodeQueryComponent(q)}",
          );

          final res = await api.get(auth: true);

          if (res.isNotEmpty) {
            final map = Map<String, dynamic>.from(res);

            map.removeWhere(
              (k, v) => v is! Map,
            );

            medicines.assignAll(
              map.values
                  .map((e) => MedicineModel.fromJson(e))
                  .toList(),
            );
          } else {
            medicines.clear();
          }
        } catch (e, s) {
          log("❌ searchMedicine", error: e, stackTrace: s);
          medicines.clear();
        } finally {
          isSearching.value = false;
        }
      },
    );
  }

  void selectMedicine(MedicineModel med) {
    selectedMedicine.value = med;
    medicineSearchCtrl.text = med.name;
    medicines.clear();
    medicineError.value = '';
  }

  // ======================================================
  // VALIDATION
  // ======================================================

  bool _validateDiagnosis() {
    if (diagnosisCtrl.text.trim().isEmpty) {
      diagnosisError.value = "Enter diagnosis";
      return false;
    }
    diagnosisError.value = '';
    return true;
  }

  bool _validateDosage() {
    final m = int.tryParse(morningCtrl.text) ?? 0;
    final a = int.tryParse(afternoonCtrl.text) ?? 0;
    final n = int.tryParse(nightCtrl.text) ?? 0;

    if (m == 0 && a == 0 && n == 0) {
      dosageError.value = "Enter dosage";
      return false;
    }
    dosageError.value = '';
    return true;
  }

  // ======================================================
  // ADD MEDICINE
  // ======================================================

  bool addMedicine() {
    if (selectedMedicine.value == null) {
      medicineError.value = "Select medicine";
      return false;
    }

    if (!_validateDosage()) return false;

    if (durationCtrl.text.trim().isEmpty) {
      AppSnackbar.show(
        title: "Missing",
        message: "Enter duration",
        type: AppSnackType.error,
      );
      return false;
    }

    // Prevent duplicates
    if (items.any((e) => e.medicine.id == selectedMedicine.value!.id)) {
      AppSnackbar.show(
        title: "Duplicate",
        message: "Medicine already added",
        type: AppSnackType.warning,
      );
      return false;
    }

    items.add(
      PrescriptionItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        medicine: selectedMedicine.value!,
        morning: int.tryParse(morningCtrl.text) ?? 0,
        afternoon: int.tryParse(afternoonCtrl.text) ?? 0,
        night: int.tryParse(nightCtrl.text) ?? 0,
        isBeforeMeal: isBeforeMeal.value,
        duration: int.tryParse(durationCtrl.text) ?? 1,
        comment: commentCtrl.text.trim(),
      ),
    );

    _clearMedicineForm();
    return true;
  }

  void removeMedicine(int index) {
    items.removeAt(index);
  }

    // ======================================================
  // SUBMIT - FIXED FOR MONGODB SCHEMA (WITH PROPER OVERLAY)
  // ======================================================
  // ======================================================
  // SUBMIT - FIXED FOR MONGODB SCHEMA (WITHOUT OVERLAY)
  // ======================================================
  Future<bool> submitPrescription() async {
    if (patientMongoId.value.isEmpty || items.isEmpty) {
      return false;
    }

    if (!_validateDiagnosis()) {
      return false;
    }

    try {
      isLoading.value = true;

      // OVERLAY REMOVED - No longer trying to show overlay

      bool allSuccess = true;
      int successCount = 0;
      int failCount = 0;
      List<String> failedMedicines = [];

      // Submit EACH medicine as a SEPARATE prescription document
      for (var item in items) {
        // Build dosage schedule for this medicine
        final List<Map<String, dynamic>> dosageSchedule = [];
        
        if (item.morning > 0) {
          dosageSchedule.add({
            "timeOfDay": "Morning",
            "quantity": item.morning,
            "mealRelation": item.isBeforeMeal ? "Before Meal" : "After Meal",
          });
        }
        
        if (item.afternoon > 0) {
          dosageSchedule.add({
            "timeOfDay": "Afternoon",
            "quantity": item.afternoon,
            "mealRelation": item.isBeforeMeal ? "Before Meal" : "After Meal",
          });
        }
        
        if (item.night > 0) {
          dosageSchedule.add({
            "timeOfDay": "Night",
            "quantity": item.night,
            "mealRelation": item.isBeforeMeal ? "Before Meal" : "After Meal",
          });
        }

        // Single prescription document per medicine - MATCHES YOUR SCHEMA
        final body = {
          "patientMongoId": patientMongoId.value,
          "primaryDiagnosis": diagnosisCtrl.text.trim(),
          "medicineMongoId": item.medicine.id,
          "dosageSchedule": dosageSchedule,
          "durationInDays": item.duration,
          "comment": item.comment,
          "prescriptionStatus": "complete",
        };

        log("📤 Submitting prescription for medicine: ${item.medicine.name}");
        log("📤 BODY: $body");

        final api = NetworkHelper(url: createPrescriptionApi);
        final response = await api.post(auth: true, body: body);

        if (response['success'] == true) {
          successCount++;
          log("✅ Success: ${item.medicine.name}");
        } else {
          allSuccess = false;
          failCount++;
          failedMedicines.add(item.medicine.name);
          log("❌ Failed: ${item.medicine.name} - ${response['error'] ?? response['message']}");
        }
      }

      // OVERLAY REMOVED - No longer trying to hide overlay

      // Show appropriate message based on results
      if (allSuccess) {
        clearAll();
        AppSnackbar.show(
          title: "Success",
          message: "$successCount prescription${successCount > 1 ? 's' : ''} saved successfully",
          type: AppSnackType.success,
        );
        return true;
      } else {
        String message;
        if (successCount > 0) {
          message = "$successCount saved, $failCount failed: ${failedMedicines.join(', ')}";
        } else {
          message = "Failed to save: ${failedMedicines.join(', ')}";
        }
        
        AppSnackbar.show(
          title: "Partial Success",
          message: message,
          type: AppSnackType.error,
        );
        return false;
      }

    } catch (e, s) {
      log("❌ submit error", error: e, stackTrace: s);

      // OVERLAY REMOVED - No longer trying to hide overlay on error

      AppSnackbar.show(
        title: "Error",
        message: "Server error. Please try again.",
        type: AppSnackType.error,
      );
      return false;

    } finally {
      isLoading.value = false;
    }
  }







  // HELPERS
  // ======================================================

  void _clearMedicineForm() {
    selectedMedicine.value = null;
    medicineSearchCtrl.clear();
    morningCtrl.clear();
    afternoonCtrl.clear();
    nightCtrl.clear();
    durationCtrl.clear();
    commentCtrl.clear();
    medicines.clear();
  }

  void clearAll() {
    diagnosisCtrl.clear();
    items.clear();
    _clearMedicineForm();
    diagnosisError.value = '';
    aiSuggestions.clear();
    aiCondition.value = '';
  }
}

/// ======================================================
/// ITEM MODEL (LOCAL)
/// ======================================================
class PrescriptionItem {
  final String id;
  final MedicineModel medicine;
  final int morning;
  final int afternoon;
  final int night;
  final bool isBeforeMeal;
  final int duration;
  final String comment;

  PrescriptionItem({
    required this.id,
    required this.medicine,
    required this.morning,
    required this.afternoon,
    required this.night,
    required this.isBeforeMeal,
    required this.duration,
    required this.comment,
  });

  String get summary => "M:$morning A:$afternoon N:$night";
}