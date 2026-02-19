import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/api_service.dart';
import '../../services/apis.dart';

class PatientSearchController extends GetxController {

  final patients = <PatientModel>[].obs;
  final selectedPatient = Rxn<PatientModel>();

  final searchController = TextEditingController();
  final isLoading = false.obs;

  Timer? _debounce;

  @override
  void onInit() {
    super.onInit();

    searchController.addListener(() {
      _onSearchChanged(searchController.text);
    });
  }

  void initializeSearch() {
    if (patients.isEmpty) {
      fetchPatients('');
    }
  }

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) {
      _debounce!.cancel();
    }

    _debounce = Timer(const Duration(milliseconds: 400), () {
      final query = value.trim();

      if (query.length >= 2) {
        fetchPatients(query);
      } else if (query.isEmpty) {
        fetchPatients('');
      }
    });
  }

  Future<void> fetchPatients(String name) async {
    try {
      isLoading.value = true;

      final encoded = Uri.encodeQueryComponent(name);
      final url = name.isEmpty
        ? getPatientByNameApi
        : "$getPatientByNameApi?name=$encoded";

      final helper = NetworkHelper(url: url);
      final response = await helper.get(auth: true);

      if (response['success'] == true) {
        final List data = response['data'] ?? [];

        final parsed = data.map((e) => PatientModel.fromJson(e)).toList();

        patients.assignAll(parsed);
      } else {
        patients.clear();
      }
    } catch (e) {
      patients.clear();
      debugPrint("Patient search error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void selectPatient(PatientModel patient) {
    selectedPatient.value = patient;
  }

  void clearSearch() {
    searchController.clear();
    patients.clear();
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
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      patientId: json['patientId'] ?? json['patient_id'] ?? '',
    );
  }

  String get displayName => '$name - $patientId';

  @override
  bool operator ==(Object other) => other is PatientModel && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

