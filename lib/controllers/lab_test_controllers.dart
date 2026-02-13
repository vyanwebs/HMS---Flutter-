import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/lab_test_request_model.dart';
import '../services/api_service.dart';
import '../services/apis.dart';
import '../utils/overlay.dart';
import '../utils/snackbar.dart';

class LabTestControllers extends GetxController {

  final isLoading = false.obs;

  final totalPatients = 0.obs;
  final completed = 0.obs;
  final waiting = 0.obs;
  final cancelled = 0.obs;

  final labTests = <LabTestRequestModel>[].obs;

  final selectedIds = <String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchLabTests();
  }

  Future<void> fetchLabTests() async {
    try {
      isLoading.value = true;

      final helper = NetworkHelper(url: getLabTestRequestDoctorApi);
      final response = await helper.get(auth: true);

      if (response['success'] == true) {
        final List data = response['data'] ?? [];

        final parsed = data.map((e) => LabTestRequestModel.fromJson(e)).toList();

        labTests.assignAll(parsed);

        _calculateStats();
      }
    } catch (e) {
      print("Lab Test Fetch Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> createLabTestRequest({
    required String patientMongoId,
    required String patientId,
    required String patientName,
    required int age,
    required String bloodGroup,
    required String bloodPressure,
    required String sugar,
    required String testName,
    required String testCategory,
    // required String priority,
    // required String status,
    String? additionalRequest,
  }) async {
    try {
      isLoading.value = true;

      /// 🔥 SHOW LOADING OVERLAY
      LoadingOverlayService.show(message: "Creating lab test request...");

      final helper = NetworkHelper(url: createLabTestRequestApi);

      final response = await helper.post(
        auth: true,
        body: {
          "patientMongoId": patientMongoId,
          "patientId": patientId,
          "patientName": patientName,
          "age": age,
          "bloodGroup": bloodGroup,
          "bloodPressure": bloodPressure,
          "sugar": sugar,
          "testName": testName,
          "testCategory": testCategory,
          // "priority": priority,
          // "status": status,
          "additionalRequest": additionalRequest ?? "",
        },
      );

      /// 🔥 HIDE LOADING
      LoadingOverlayService.hide();
      Get.back();

      if (response['success'] == true) {
        await fetchLabTests();

        /// ✅ SUCCESS SNACKBAR
        AppSnackbar.show(
          title: "Success",
          message: "Lab test request created successfully",
          type: AppSnackType.success,
        );

        return true;
      } else {
        AppSnackbar.show(
          title: "Error",
          message: response['message'] ?? "Something went wrong",
          type: AppSnackType.error,
        );

        return false;
      }
    } catch (e) {
      LoadingOverlayService.hide();

      debugPrint("Create Lab Test Error: $e");

      AppSnackbar.show(
        title: "Error",
        message: "Failed to create lab test request",
        type: AppSnackType.error,
      );

      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteSelectedRequests() async {
    if (selectedIds.isEmpty) {
      AppSnackbar.show(
        title: "Warning",
        message: "Please select at least one request",
        type: AppSnackType.warning,
      );
      return;
    }

    try {
      LoadingOverlayService.show(message: "Deleting selected requests...");

      /// 🔥 Collect selected Mongo IDs
      final ids = selectedIds.toList();

      final helper = NetworkHelper(url: deleteMultiLabTestRequestApi);

      final response = await helper.post(
        auth: true,
        body: {
          "ids": ids,
        },
      );

      LoadingOverlayService.hide();

      if (response['success'] == true) {
        selectedIds.clear();

        await fetchLabTests();

        AppSnackbar.show(
          title: "Success",
          message: "Selected requests deleted successfully",
          type: AppSnackType.success,
        );
      } else {
        AppSnackbar.show(
          title: "Error",
          message: response['message'] ?? "Delete failed",
          type: AppSnackType.error,
        );
      }
    } catch (e) {
      LoadingOverlayService.hide();

      debugPrint("Delete Multiple Error: $e");

      AppSnackbar.show(
        title: "Error",
        message: "Failed to delete requests",
        type: AppSnackType.error,
      );
    }
  }

  void _calculateStats() {
    totalPatients.value = labTests.length;

    completed.value = labTests.where((e) => e.status == "Completed").length;

    waiting.value = labTests.where((e) => e.status == "Waiting").length;

    cancelled.value = labTests.where((e) => e.status == "Cancelled").length;
  }

  // ================= SELECTION =================

  void toggleSelection(String id) {
    if (selectedIds.contains(id)) {
      selectedIds.remove(id);
    } else {
      selectedIds.add(id);
    }
  }

  bool isSelected(String id) {
    return selectedIds.contains(id);
  }

  void deleteSelected() {
    labTests.removeWhere(
      (element) => selectedIds.contains(labTests.indexOf(element)),
    );

    selectedIds.clear();
    _calculateStats();
  }

  // Filters
  final selectedPriority = "All".obs;
  final selectedStatus = "All".obs;

  List<String> priorityOptions = [
    "All",
    "Urgent",
    "Routine",
  ];

  List<String> statusOptions = [
    "All",
    "Waiting",
    "Completed",
    "Cancelled",
  ];

  // 🔎 Search
  final searchQuery = "".obs;

  List<LabTestRequestModel> get filteredLabTests {
    return labTests.where((test) {
      final priorityMatch = selectedPriority.value == "All" || test.priority == selectedPriority.value;

      final statusMatch = selectedStatus.value == "All" || test.status == selectedStatus.value;

      final searchMatch = searchQuery.value.isEmpty ||
        test.testName.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
        test.patientName.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
        test.testCategory.toLowerCase().contains(searchQuery.value.toLowerCase());

      return priorityMatch && statusMatch && searchMatch;
    }).toList();
  }
}
