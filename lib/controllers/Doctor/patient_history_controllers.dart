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
