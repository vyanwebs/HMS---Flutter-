import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/doctor_model.dart';
import '../services/api_service.dart';
import '../services/apis.dart';

class DoctorSearchController extends GetxController {

  final isLoading = false.obs;

  /// ✅ STRONG TYPING
  final doctors = <DoctorModel>[].obs;

  final selectedDoctor = Rxn<DoctorModel>();

  final searchController = TextEditingController();

  Timer? _debounce;

  final highlightedIndex = 0.obs;

  void selectHighlightedDoctor() {
    if (doctors.isEmpty) return;

    final doctor = doctors[highlightedIndex.value];

    selectDoctor(doctor);
  }

  void clearResults() {
    doctors.clear();
  }

  /// ================= SEARCH =================

  void onSearchChanged(String value) {
    _debounce?.cancel();

    _debounce = Timer(
      const Duration(milliseconds: 500),
      () => searchDoctor(value),
    );
  }

  Future<void> searchDoctor(String name) async {
    if (name.trim().isEmpty) {
      doctors.clear();
      return;
    }

    try {
      isLoading.value = true;

      final helper = NetworkHelper(url: getDoctorByNameApi);

      final response = await helper.getWithParams(
        auth: true,
        query: {"name": name},
      );

      if (response["success"] == true) {
        doctors.value = (response["data"] as List).map((e) => DoctorModel.fromJson(e)).toList();
      } else {
        doctors.clear();
      }
    } catch (_) {
      doctors.clear();
    } finally {
      isLoading.value = false;
    }
  }

  /// ================= SELECT =================

  void selectDoctor(DoctorModel doctor) {
    /// ❌ BLOCK UNAVAILABLE DOCTOR
    if (!doctor.isAvailableToday ||
        doctor.staffStatus != "ACTIVE" ||
        doctor.hasLeftHospital) {
      return;
    }

    selectedDoctor.value = doctor;
    searchController.text = doctor.name;
    doctors.clear();
  }

  void moveDown() {
    if (highlightedIndex.value < doctors.length - 1) {
      highlightedIndex.value++;
    }
  }

  void moveUp() {
    if (highlightedIndex.value > 0) {
      highlightedIndex.value--;
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    searchController.clear();
    _debounce?.cancel();
    super.onClose();
  }
}