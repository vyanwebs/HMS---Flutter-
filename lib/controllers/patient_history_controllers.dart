import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/api_service.dart';
import '../services/apis.dart';

class PatientHistoryControllers extends GetxController {
  final patients = <PatientModel>[].obs;
  final selectedPatient = Rxn<PatientModel>();

  final searchText = ''.obs;
  final searchController = TextEditingController();

  final isLoading = false.obs;

  Timer? _debounce;

  @override
  void onInit() {
    super.onInit();

    // Listen to search controller directly
    searchController.addListener(() {
      _onSearchChanged(searchController.text);
    });
  }

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    // Update search text for filtering
    searchText.value = value;

    // Only clear selection if search is modified
    if (selectedPatient.value != null && 
        !selectedPatient.value!.name.toLowerCase().contains(value.toLowerCase())) {
      selectedPatient.value = null;
    }

    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (value.trim().length >= 2) {
        fetchPatients(value.trim());
      } else {
        patients.clear();
      }
    });
  }

  Future<void> fetchPatients(String name) async {
    try {
      isLoading(true);

      final encodedName = Uri.encodeQueryComponent(name);

      final helper = NetworkHelper(
        url: "$getPatientByNameApi?name=$encodedName",
      );

      final response = await helper.get(auth: true);

      if (response['success'] == true) {
        final List data = response['data'];
        final parsed = data.map((e) => PatientModel.fromJson(e)).toList();

        patients.assignAll(parsed);
      } else {
        patients.clear();
      }
    } catch (e) {
      print("Patient search error: $e");
      patients.clear();
    } finally {
      isLoading(false);
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    _debounce?.cancel();
    super.onClose();
  }
}

class PatientModel {
  final String id;
  final String name;
  final String patientId;

  PatientModel({
    required this.id,
    required this.name,
    required this.patientId,
  });

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    return PatientModel(
      id: json['_id'],
      name: json['name'],
      patientId: json['patientId'],
    );
  }

  String get displayName => '$name - $patientId';
}
