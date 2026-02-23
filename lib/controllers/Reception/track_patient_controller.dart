// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../models/reception_panel/patient_management_model.dart';
// import '../../services/api_service.dart'; // Your NetworkHelper file
// import '../../services/apis.dart';      // Your API route strings

// class TrackPatientsController extends GetxController {
//   final RxBool isLoading = false.obs;
//   final RxString searchText = ''.obs;
//   final RxString selectedStatus = "All".obs;

//   final List<String> statusOptions = [
//     "All", "PENDING", "CONFIRMED", "REJECTED", "ADMITTED", 
//     "DISCHARGED", "TRANSFERRED", "ADMISSION_REQUESTED", "DISCHARGE_REQUESTED"
//   ];

//   final RxList<PatientRowModel> patients = <PatientRowModel>[].obs;
//   final RxSet<String> selectedIds = <String>{}.obs;

//   // Stats
//   final RxInt totalPatients = 0.obs;
//   final RxInt ipdCount = 0.obs;
//   final RxInt opdCount = 0.obs;
//   final RxInt todayAdmissions = 0.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     refreshData();
//     debounce(searchText, (_) => fetchPatients(), time: const Duration(milliseconds: 500));
//   }

//   void refreshData() {
//     fetchStats();
//     fetchPatients();
//   }

//   /// 1. GET STATS (Using NetworkHelper)
//   Future<void> fetchStats() async {
//     try {
//       final api = NetworkHelper(url: trackpatientcardsApi);
//       final response = await api.get(auth: true);

//       if (response != null && response['success'] == true) {
//         final data = response['data'];
//         totalPatients.value = data['totalPatients'] ?? 0;
//         ipdCount.value = data['totalIPDPatients'] ?? 0;
//         opdCount.value = data['totalOPDPatients'] ?? 0;
//         todayAdmissions.value = data['totalTodayAdmission'] ?? 0;
//       }
//     } catch (e) {
//       log("❌ fetchStats Error: $e");
//     }
//   }

//   /// 2. GET PATIENTS (Using NetworkHelper)
//   Future<void> fetchPatients() async {
//     try {
//       isLoading(true);
//       String url = "$getallpatientApi?";
//       if (selectedStatus.value != "All") url += "status=${selectedStatus.value}&";
//       if (searchText.value.isNotEmpty) url += "name=${searchText.value}";

//       final api = NetworkHelper(url: url);
//       final response = await api.get(auth: true);

//       if (response != null && response['success'] == true) {
//         final List dataList = response['data'] ?? [];
//         patients.assignAll(dataList.map((e) => PatientRowModel.fromJson(e)).toList());
//       }
//     } catch (e) {
//       log("❌ fetchPatients Error: $e");
//     } finally {
//       isLoading(false);
//     }
//   }

//   /// 3. DELETE SELECTED (Using NetworkHelper)
//   Future<void> deleteSelected() async {
//     if (selectedIds.isEmpty) return;

//     try {
//       isLoading(true);
//       final api = NetworkHelper(url: deletepatientsApi);
//       final response = await api.delete(
//         auth: true, 
//         body: {"patientIds": selectedIds.toList()}
//       );

//       if (response != null && response['success'] == true) {
//         selectedIds.clear();
//         refreshData();
//         _showSnackbar("Success", "Patients deleted successfully", isError: false);
//       } else {
//         _showSnackbar("Error", response?['message'] ?? "Delete failed", isError: true);
//       }
//     } catch (e) {
//       log("❌ deleteSelected Error: $e");
//       _showSnackbar("Error", "An unexpected error occurred", isError: true);
//     } finally {
//       isLoading(false);
//     }
//   }

//   void updateSearch(String val) => searchText.value = val;
  
//   void updateStatusFilter(String? val) {
//     if (val != null) {
//       selectedStatus.value = val;
//       fetchPatients();
//     }
//   }

//   void toggleSelection(String id) => selectedIds.contains(id) ? selectedIds.remove(id) : selectedIds.add(id);
  
//   void selectAll(bool? checked) {
//     if (checked == true) {
//       selectedIds.addAll(patients.map((p) => p.id));
//     } else {
//       selectedIds.clear();
//     }
//   }

//   bool get allSelected => patients.isNotEmpty && patients.every((p) => selectedIds.contains(p.id));

//   void _showSnackbar(String title, String message, {required bool isError}) {
//     Get.snackbar(
//       title, message,
//       backgroundColor: isError ? Colors.red : Colors.green,
//       colorText: Colors.white,
//       snackPosition: SnackPosition.TOP,
//       duration: const Duration(seconds: 2),
//     );
//   }
// }


import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/reception_panel/patient_management_model.dart';
import '../../services/api_service.dart'; // Your NetworkHelper file
import '../../services/apis.dart';      // Your API route strings

class TrackPatientsController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxString searchText = ''.obs;
  final RxString selectedStatus = "All".obs;

  final List<String> statusOptions = [
    "All", "PENDING", "CONFIRMED", "REJECTED", "ADMITTED", 
    "DISCHARGED", "TRANSFERRED", "ADMISSION_REQUESTED", "DISCHARGE_REQUESTED"
  ];

  final RxList<PatientRowModel> patients = <PatientRowModel>[].obs;
  final RxSet<String> selectedIds = <String>{}.obs;

  // Primary color for consistency with your other controller
  final Color primaryBlue = const Color(0xFF40A9FF);

  // Stats
  final RxInt totalPatients = 0.obs;
  final RxInt ipdCount = 0.obs;
  final RxInt opdCount = 0.obs;
  final RxInt todayAdmissions = 0.obs;

  @override
  void onInit() {
    super.onInit();
    refreshData();
    // Debounce search to prevent excessive API calls
    debounce(searchText, (_) => fetchPatients(), time: const Duration(milliseconds: 500));
  }

  void refreshData() {
    fetchStats();
    fetchPatients();
  }

  /// 1. GET STATS
  Future<void> fetchStats() async {
    try {
      final api = NetworkHelper(url: trackpatientcardsApi);
      final response = await api.get(auth: true);

      if (response != null && response['success'] == true) {
        final data = response['data'];
        totalPatients.value = data['totalPatients'] ?? 0;
        ipdCount.value = data['totalIPDPatients'] ?? 0;
        opdCount.value = data['totalOPDPatients'] ?? 0;
        todayAdmissions.value = data['totalTodayAdmission'] ?? 0;
      }
    } catch (e) {
      log("❌ fetchStats Error: $e");
    }
  }

  /// 2. GET PATIENTS
  Future<void> fetchPatients() async {
    try {
      isLoading(true);
      String url = "$getallpatientApi?";
      if (selectedStatus.value != "All") url += "status=${selectedStatus.value}&";
      if (searchText.value.isNotEmpty) url += "name=${searchText.value}";

      final api = NetworkHelper(url: url);
      final response = await api.get(auth: true);

      if (response != null && response['success'] == true) {
        final List dataList = response['data'] ?? [];
        patients.assignAll(dataList.map((e) => PatientRowModel.fromJson(e)).toList());
      } else {
        _showSnackbar("Error", "Failed to load patients", isError: true);
      }
    } catch (e) {
      log("❌ fetchPatients Error: $e");
      _showSnackbar("Error", "Connection error", isError: true);
    } finally {
      isLoading(false);
    }
  }

  /// 3. DELETE SELECTED (Updated with Confirmation Dialog and Snackbar)
  Future<void> deleteSelected() async {
    if (selectedIds.isEmpty) {
      _showSnackbar("Warning", "Please select at least one patient", isError: true);
      return;
    }

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange[700]),
            const SizedBox(width: 8),
            const Text('Confirm Delete', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text('Are you sure you want to delete ${selectedIds.length} selected patient(s)?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            style: TextButton.styleFrom(foregroundColor: Colors.grey[600]),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back(); // close dialog
              try {
                isLoading(true);
                final api = NetworkHelper(url: deletepatientsApi);
                final response = await api.delete(
                  auth: true, 
                  body: {"patientIds": selectedIds.toList()}
                );

                if (response != null && response['success'] == true) {
                  selectedIds.clear();
                  refreshData();
                  _showSnackbar("Success", "Patients deleted successfully", isError: false);
                } else {
                  _showSnackbar("Error", response?['message'] ?? "Delete failed", isError: true);
                }
              } catch (e) {
                log("❌ deleteSelected Error: $e");
                _showSnackbar("Error", "An unexpected error occurred", isError: true);
              } finally {
                isLoading(false);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryBlue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void updateSearch(String val) => searchText.value = val;
  
  void updateStatusFilter(String? val) {
    if (val != null) {
      selectedStatus.value = val;
      fetchPatients();
    }
  }

  void toggleSelection(String id) => selectedIds.contains(id) ? selectedIds.remove(id) : selectedIds.add(id);
  
  void selectAll(bool? checked) {
    if (checked == true) {
      selectedIds.addAll(patients.map((p) => p.id));
    } else {
      selectedIds.clear();
    }
  }

  bool get allSelected => patients.isNotEmpty && patients.every((p) => selectedIds.contains(p.id));

  /// Private helper for uniform Snackbars (Matched to ExternalDoctorController)
  void _showSnackbar(String title, String message, {required bool isError}) {
    Get.snackbar(
      title,
      message,
      backgroundColor: isError ? Colors.red : Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(10),
      borderRadius: 8,
      maxWidth: 330,
      duration: const Duration(seconds: 2),
    );
  }
}