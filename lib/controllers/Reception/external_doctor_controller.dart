import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/reception_panel/external_doctor_model.dart';
import '../../services/api_service.dart';
import '../../services/apis.dart';

class ExternalDoctorController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxList<ExternalDoctor> doctors = <ExternalDoctor>[].obs;
  final RxList<ExternalDoctor> allDoctors = <ExternalDoctor>[].obs;
  final RxString selectedDepartment = "All".obs;
  final RxString searchText = "".obs;

  // Primary color for buttons/dialogs
  final Color primaryBlue = const Color(0xFF40A9FF);

  int get totalDoctorsCount => allDoctors.length;

  final List<String> departments = [
    "All", "cardiology", "neurology", "orthopedic", "dermatology",
    "pediatrics", "gynecology", "oncology", "radiology", "emergency",
    "icu", "general medicine", "general surgery", "urology",
    "nephrology", "gastroenterology", "pulmonology", "ophthalmology",
    "dental", "laboratory",
  ];

  @override
  void onInit() {
    super.onInit();
    fetchAllDoctors();
  }

  /// Helper to format experience display
  String formatExperience(String? exp) {
    if (exp == null || exp.isEmpty) return "N/A";
    String cleanExp = exp.toLowerCase();
    if (cleanExp.contains("year")) {
      return exp;
    }
    return "$exp years";
  }

  Future<void> fetchAllDoctors() async {
    try {
      isLoading(true);
      final api = NetworkHelper(url: getallexternaldoctorApi);
      final response = await api.get(auth: true);

      if (response != null && response['success'] == true) {
        final List list = response['data'] ?? [];
        final parsed = list.map((e) => ExternalDoctor.fromJson(e)).toList();
        allDoctors.assignAll(parsed);
        applyFilters();
      }
    } catch (e) {
      log("❌ fetchAllDoctors Error: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> registerDoctor({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String confirmPassword,
    required String specialty,
    required String experience,
    required String department,
  }) async {
    if (password != confirmPassword) {
      _showSnackbar("Error", "Passwords do not match", isError: true);
      return;
    }

    try {
      isLoading(true);
      String formattedExp = experience.toLowerCase().contains("year") 
          ? experience 
          : "$experience years";

      final Map<String, dynamic> body = {
        "name": name,
        "email": email,
        "phone": phone,
        "password": password,
        "confirmPassword": confirmPassword,
        "doctorType": "external",
        "specialty": specialty.toLowerCase(),
        "experience": formattedExp,
        "department": department.toLowerCase(),
      };

      final api = NetworkHelper(url: createexternaldoctorApi);
      final response = await api.post(body: body, auth: true);

      if (response != null && response['success'] == true) {
        Get.back();
        _showSnackbar("Success", "Doctor registered successfully", isError: false);
        fetchAllDoctors();
      } else {
        _showSnackbar("Error", response?['message'] ?? "Registration failed", isError: true);
      }
    } catch (e) {
      log("❌ registerDoctor Error: $e");
      _showSnackbar("Error", "An unexpected error occurred", isError: true);
    } finally {
      isLoading(false);
    }
  }

  void applyFilters() {
    List<ExternalDoctor> filtered = allDoctors;
    if (selectedDepartment.value != "All") {
      filtered = filtered.where((d) => (d.department ?? "").toLowerCase() == selectedDepartment.value.toLowerCase()).toList();
    }
    if (searchText.value.isNotEmpty) {
      final q = searchText.value.toLowerCase();
      filtered = filtered.where((d) => (d.name ?? "").toLowerCase().contains(q) || (d.email ?? "").toLowerCase().contains(q)).toList();
    }
    doctors.assignAll(filtered);
  }

  void updateSearch(String value) { searchText.value = value; applyFilters(); }
  void updateDepartment(String? value) { if (value != null) { selectedDepartment.value = value; applyFilters(); } }

  Future<void> deleteDoctor(String id) async {
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
        content: const Text('Are you sure you want to delete this doctor? This action cannot be undone.'),
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
                  _showSnackbar("Success", "Doctor deleted successfully", isError: false);
                } else {
                  _showSnackbar("Error", "Failed to delete doctor", isError: true);
                }
              } catch (e) {
                log("❌ deleteDoctor Error: $e");
                _showSnackbar("Error", "An error occurred during deletion", isError: true);
              } finally {
                isLoading.value = false;
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

  /// Private helper for uniform Snackbars
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