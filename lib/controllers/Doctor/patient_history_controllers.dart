import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/api_service.dart';
import '../../services/apis.dart';

class PatientHistoryControllers extends GetxController {

  final historyList = <PatientHistoryModel>[].obs;
  final isHistoryLoading = false.obs;

  Future<void> fetchPatientHistory(String uhid) async {
    try {
      isHistoryLoading.value = true;

      final url = "$getPatientHistoryByUHIDApi/$uhid";

      final helper = NetworkHelper(url: url);
      final response = await helper.get(auth: true);

      if (response['success'] == true) {
        final List data = response['data'] ?? [];

        final parsed = data.map((e) => PatientHistoryModel.fromJson(e)).toList();

        parsed.sort((a, b) => b.createdAt.compareTo(a.createdAt));

        historyList.assignAll(parsed);
      } else {
        historyList.clear();
      }
    } catch (e) {
      historyList.clear();
      debugPrint("History fetch error: $e");
    } finally {
      isHistoryLoading.value = false;
    }
  }
}

class PatientHistoryModel {
  final String id;
  final String eventType;
  final String title;
  final String note;
  final DateTime createdAt;
  final String? admissionCode;
  final String? admissionType;

  PatientHistoryModel({
    required this.id,
    required this.eventType,
    required this.title,
    required this.note,
    required this.createdAt,
    this.admissionCode,
    this.admissionType,
  });

  factory PatientHistoryModel.fromJson(Map<String, dynamic> json) {
    return PatientHistoryModel(
      id: json['_id'] ?? '',
      eventType: json['eventType'] ?? '',
      title: json['title'] ?? '',
      note: json['note'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      admissionCode: json['admissionCode'],
      admissionType: json['admissionType'],
    );
  }
}

// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import '../services/api_service.dart';
// import '../services/apis.dart';

// class PatientHistoryControllers extends GetxController {
//   final patients = <PatientModel>[].obs;
//   final selectedPatient = Rxn<PatientModel>();

//   final searchText = ''.obs;
//   final searchController = TextEditingController();

//   final isLoading = false.obs;

//   Timer? _debounce;

//   @override
//   void onInit() {
//     super.onInit();
    
//     patients.value = [];
    
//     // Add listener
//     searchController.addListener(() {
//       print("🔍 Search text changed: '${searchController.text}'"); // DEBUG
//       _onSearchChanged(searchController.text);
//     });
    
//     print("✅ Controller initialized"); // DEBUG
//   }

//   void _onSearchChanged(String value) {
//     print("📝 _onSearchChanged called with: '$value'"); // DEBUG
    
//     if (_debounce?.isActive ?? false) _debounce!.cancel();

//     // Update search text for filtering
//     searchText.value = value;

//     // Only clear selection if search is modified
//     if (selectedPatient.value != null && 
//         !selectedPatient.value!.name.toLowerCase().contains(value.toLowerCase())) {
//       selectedPatient.value = null;
//     }

//     _debounce = Timer(const Duration(milliseconds: 500), () {
//       print("⏱️ Debounce timer fired. Length: ${value.trim().length}"); // DEBUG
      
//       if (value.trim().length >= 2) {
//         print("🚀 Calling fetchPatients with: '${value.trim()}'"); // DEBUG
//         fetchPatients(value.trim());
//       } else {
//         print("❌ Search text too short, clearing patients"); // DEBUG
//         patients.clear();
//       }
//     });
//   }

//   Future<void> fetchPatients(String name) async {
//     try {
//       print("🌐 Starting API call for: '$name'"); // DEBUG
//       isLoading(true);

//       final encodedName = Uri.encodeQueryComponent(name);
//       final url = "$getPatientByNameApi?name=$encodedName";
      
//       print("📡 API URL: $url"); // DEBUG

//       final helper = NetworkHelper(url: url);
//       final response = await helper.get(auth: true);

//       print("📥 API Response: $response"); // DEBUG

//       if (response['success'] == true) {
//         final List data = response['data'];
//         print("✅ Found ${data.length} patients"); // DEBUG
        
//         final parsed = data.map((e) => PatientModel.fromJson(e)).toList();
        
//         patients.assignAll(parsed);
//         print("✅ Patients assigned: ${patients.length}"); // DEBUG
//       } else {
//         print("⚠️ API returned success=false"); // DEBUG
//         patients.clear();
//       }
//     } catch (e) {
//       print("❌ Patient search error: $e"); // DEBUG
//       patients.clear();
//     } finally {
//       isLoading(false);
//       print("🏁 Loading finished. Total patients: ${patients.length}"); // DEBUG
//     }
//   }

//   @override
//   void onClose() {
//     searchController.dispose();
//     _debounce?.cancel();
//     super.onClose();
//   }
// }

// class PatientModel {
//   final String id;
//   final String name;
//   final String patientId;

//   PatientModel({
//     required this.id,
//     required this.name,
//     required this.patientId,
//   });

//   factory PatientModel.fromJson(Map<String, dynamic> json) {
//     return PatientModel(
//       id: json['_id'],
//       name: json['name'],
//       patientId: json['patientId'],
//     );
//   }

//   String get displayName => '$name - $patientId';
// }