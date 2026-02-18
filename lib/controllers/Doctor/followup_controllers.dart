import 'dart:developer';

import 'package:get/get.dart';

import '../../services/api_service.dart';
import '../../services/apis.dart';

class FollowupControllers extends GetxController {
  final selectedTab = 2.obs;
  final isLoading = false.obs;

  // Latest record (for patient card)
  final twoHourVital = Rxn<VitalFollowUp>();
  final fourHourVital = Rxn<VitalFollowUp>();

  // Full history (for graphs)
  final twoHourVitals = <VitalFollowUp>[].obs;
  final fourHourVitals = <VitalFollowUp>[].obs;

  void changeTab(int hour, String patientId) {
    selectedTab.value = hour;
    fetchVitals(patientId, hour);
  }

  Future<void> fetchVitals(String patientId, int hour) async {
    try {
      isLoading.value = true;

      final url = "$followupVitalsApi/${hour}hr-follow-up/$patientId";
      final helper = NetworkHelper(url: url);
      final response = await helper.get(auth: true);

      if (response["success"] == true) {
        final List data = response["data"] ?? [];

        final vitalsList = data.map((e) => VitalFollowUp.fromJson(e)).toList();

        // ✅ SORT HERE
        vitalsList.sort((a, b) {
          final aTime = a.recordedAt ?? DateTime(1970);
          final bTime = b.recordedAt ?? DateTime(1970);
          return aTime.compareTo(bTime);
        });

        if (hour == 2) {
          twoHourVitals.value = vitalsList;
          twoHourVital.value =
              vitalsList.isNotEmpty ? vitalsList.last : null; // latest
        } else {
          fourHourVitals.value = vitalsList;
          fourHourVital.value =
              vitalsList.isNotEmpty ? vitalsList.last : null; // latest
        }
      }
    } catch (e, s) {
      log("Vital fetch error: $e, $s");
    } finally {
      isLoading.value = false;
    }
  }
}

class VitalFollowUp {
  final String id;
  final String patientMongoId;
  final String bp;
  final int pulse;
  final double temperature;
  final int spo2;
  final int vitalHours;
  final String followUpId;
  final DateTime? recordedAt;

  VitalFollowUp({
    required this.id,
    required this.patientMongoId,
    required this.bp,
    required this.pulse,
    required this.temperature,
    required this.spo2,
    required this.vitalHours,
    required this.followUpId,
    this.recordedAt,
  });

  factory VitalFollowUp.fromJson(Map<String, dynamic> json) {
    return VitalFollowUp(
      id: json['_id'] ?? '',
      patientMongoId: json['patientMongoId'] ?? '',
      bp: json['bp'] ?? '',
      pulse: json['pulse'] ?? 0,
      temperature: (json['temperature'] ?? 0).toDouble(),
      spo2: json['spo2'] ?? 0,
      vitalHours: json['vitalHours'] ?? 2,
      followUpId: json['followUpId'] ?? '',
      recordedAt: json['recordedAt'] != null
          ? DateTime.tryParse(json['recordedAt'])
          : null,
    );
  }
}
