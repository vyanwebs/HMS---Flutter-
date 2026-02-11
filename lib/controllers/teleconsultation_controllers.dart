import 'dart:developer';

import 'package:get/get.dart';
import '../models/teleconsultation_model.dart';
import '../services/api_service.dart';
import '../services/apis.dart';

class TeleconsultationControllers extends GetxController {
  final isLoading = false.obs;

  final teleconsultations = <TeleconsultationModel>[].obs;
  final todaysTeleconsultations = <TeleconsultationModel>[].obs;

  // ===================== STATS =====================
  final totalSchedule = 0.obs;
  final todaySchedule = 0.obs;
  final completed = 0.obs;
  final cancelled = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTeleconsultations();
    fetchTodaysTeleconsultations();
  }

  Future<void> fetchTeleconsultations() async {
    try {
      isLoading(true);

      final helper = NetworkHelper(url: getTeleconsultationApi);

      final response = await helper.get(auth: true);

      if (response['success'] != true) {
        log(
          '❌ Teleconsultation API returned failure',
          error: response,
        );
        return;
      }

      final List data = response['data'];

      final parsed = data.map((e) => TeleconsultationModel.fromJson(e)).toList();

      teleconsultations.assignAll(parsed);

      _calculateStats(parsed);
    } catch (e, stackTrace) {
      log(
        '❌ Teleconsultation API exception',
        error: e,
        stackTrace: stackTrace,
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchTodaysTeleconsultations() async {
    try {
      isLoading(true);

      final helper = NetworkHelper(
        url: getTodayTeleconsultationApi,
      );

      final response = await helper.get(auth: true);

      if (response['success'] != true) {
        return;
      }

      final List data = response['data'];

      final parsed =
          data.map((e) => TeleconsultationModel.fromJson(e)).toList();

      todaysTeleconsultations.assignAll(parsed);
    } catch (e, stackTrace) {
      log(
        '❌ Today Teleconsultation API error',
        error: e,
        stackTrace: stackTrace,
      );
    } finally {
      isLoading(false);
    }
  }

  void _calculateStats(List<TeleconsultationModel> list) {
    final today = DateTime.now();

    totalSchedule.value = list.length;

    todaySchedule.value = list.where((e) =>
        e.startTime.year == today.year &&
        e.startTime.month == today.month &&
        e.startTime.day == today.day).length;

    completed.value = list.where((e) => e.status == 'COMPLETED').length;

    cancelled.value = list.where((e) => e.status == 'CANCELLED').length;
  }
}
