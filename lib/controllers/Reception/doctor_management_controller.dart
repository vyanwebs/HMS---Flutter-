// import 'dart:developer';

// import 'package:get/get.dart';

// import '../../models/reception_panel/doctor_model.dart';
// import '../../services/api_service.dart';
// import '../../services/apis.dart';

// class DoctorManagementController extends GetxController {
//   final RxList<Doctor> allDoctors = <Doctor>[].obs;
//   final RxList<Doctor> filteredDoctors = <Doctor>[].obs;
//   final RxBool isLoading = false.obs;

//   final RxString searchQuery = "".obs;
//   final RxString selectedStatus = "All".obs;

//   @override
//   void onInit() {
//     super.onInit();
//     fetchDoctors();
//   }

//   Future<void> fetchDoctors() async {
//     try {
//       isLoading.value = true;
//       log("📡 Fetching doctors from: $getalldoctorApi");

//       // Using your existing NetworkHelper pattern
//       final api = NetworkHelper(url: getalldoctorApi);
//       final response = await api.get(auth: true);

//       if (response != null && response['success'] == true) {
//         final dataList = response['data'];

//         if (dataList is List) {
//           final List<Doctor> loadedDoctors = dataList
//               .map((json) => Doctor.fromJson(json))
//               .toList();

//           allDoctors.assignAll(loadedDoctors);
//           applyFilters();
//           log("✅ Successfully loaded ${allDoctors.length} doctors");
//         }
//       }
//     } catch (e, s) {
//       log("❌ fetchDoctors Error", error: e, stackTrace: s);
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   void updateSearch(String query) {
//     searchQuery.value = query;
//     applyFilters();
//   }

//   void updateStatus(String? status) {
//     selectedStatus.value = status ?? "All";
//     applyFilters();
//   }

//   void applyFilters() {
//     filteredDoctors.assignAll(allDoctors.where((doc) {
//       final matchesSearch = doc.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
//                            doc.staffId.toLowerCase().contains(searchQuery.value.toLowerCase());

//       final matchesStatus = selectedStatus.value == "All" ||
//                            doc.staffStatus.toUpperCase() == selectedStatus.value.toUpperCase();

//       return matchesSearch && matchesStatus;
//     }).toList());
//   }
// }import 'dart:developer';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/reception_panel/doctor_model.dart';
import '../../services/api_service.dart';
import '../../services/apis.dart';

class DoctorManagementController extends GetxController {
  final RxList<Doctor> allDoctors = <Doctor>[].obs;
  final RxList<Doctor> filteredDoctors = <Doctor>[].obs;
  final RxBool isLoading = false.obs;

  final RxString searchQuery = "".obs;
  final RxString selectedStatus = "All".obs;

  // App's primary blue color (from the gradient in the stat card)
  final Color primaryBlue = const Color(0xFF40A9FF);

  @override
  void onInit() {
    super.onInit();
    fetchDoctors();
  }

  Future<void> fetchDoctors() async {
    try {
      isLoading.value = true;
      log("📡 Fetching doctors from: $getalldoctorApi");

      final api = NetworkHelper(url: getalldoctorApi);
      final response = await api.get(auth: true);

      if (response != null && response['success'] == true) {
        final dataList = response['data'];

        if (dataList is List) {
          final List<Doctor> loadedDoctors =
              dataList.map((json) => Doctor.fromJson(json)).toList();

          allDoctors.assignAll(loadedDoctors);
          applyFilters();
          log("✅ Successfully loaded ${allDoctors.length} doctors");
        }
      }
    } catch (e, s) {
      log("❌ fetchDoctors Error", error: e, stackTrace: s);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteDoctor(String id) async {
    // Enhanced confirmation dialog with custom styling
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange[700]),
            const SizedBox(width: 8),
            const Text('Confirm Delete',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: const Text(
            'Are you sure you want to delete this doctor? This action cannot be undone.'),
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
                isLoading.value = true;
                final api = NetworkHelper(url: "$deletedoctorApi/$id");
                final response = await api.delete(auth: true);

                if (response != null && response['success'] == true) {
                  allDoctors.removeWhere((doc) => doc.id == id);
                  applyFilters();
                  Get.snackbar(
                    "Success",
                    "Doctor deleted successfully",
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                    snackPosition: SnackPosition.TOP, // <-- changed to top
                    margin: const EdgeInsets.all(10), // <-- adds space around
                    borderRadius: 8, // <-- rounded corners
                    maxWidth: 330,
                    duration:
                        const Duration(seconds: 2), // <-- auto dismiss after 2s
                  );
                } else {
                  Get.snackbar(
                    "Error",
                    "Failed to delete doctor",
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                    snackPosition: SnackPosition.TOP,
                    margin: const EdgeInsets.all(10),
                    borderRadius: 8,
                    maxWidth: 330,
                    duration: const Duration(seconds: 2),
                  );
                }
              } catch (e, s) {
                log("❌ deleteDoctor Error", error: e, stackTrace: s);
                Get.snackbar(
                  "Error",
                  "An error occurred",
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                  snackPosition: SnackPosition.TOP,
                  margin: const EdgeInsets.all(10),
                  borderRadius: 8,
                  duration: const Duration(seconds: 2),
                );
              } finally {
                isLoading.value = false;
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryBlue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void updateSearch(String query) {
    searchQuery.value = query;
    applyFilters();
  }

  void updateStatus(String? status) {
    selectedStatus.value = status ?? "All";
    applyFilters();
  }

  void applyFilters() {
    filteredDoctors.assignAll(allDoctors.where((doc) {
      final matchesSearch = doc.name
              .toLowerCase()
              .contains(searchQuery.value.toLowerCase()) ||
          doc.staffId.toLowerCase().contains(searchQuery.value.toLowerCase());

      final matchesStatus = selectedStatus.value == "All" ||
          doc.staffStatus.toUpperCase() == selectedStatus.value.toUpperCase();

      return matchesSearch && matchesStatus;
    }).toList());
  }
}
