import 'dart:developer';

import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../models/broadcast_model.dart';
import '../../models/patient_model.dart';
import '../../models/pending_task_model.dart';
import '../../models/teleconsultation_queue_model.dart';
import '../../models/weekly_patients_chart_model.dart';
import '../../services/api_service.dart';
import '../../services/apis.dart';
import '../../utils/images.dart';

class DoctorDashboardControllers extends GetxController {

  RxBool isLoading = false.obs;

  RxInt todaysAppointments = 0.obs;
  RxInt pendingLabReports = 0.obs;
  RxInt activeIPDPatients = 0.obs;
  RxInt teleconsultation = 0.obs;

  RxList<String> chartLabels = <String>[].obs;
  RxList<PatientChartData> chartData = <PatientChartData>[].obs;

  // =========== Today's Schedule ==========
  final RxList<PatientModel> schedules = <PatientModel>[].obs;

  // =========== Recent Patients ===========
  final RxList<PatientModel> patients = <PatientModel>[].obs;

  // =========== Broadcast =================
  final RxList<BroadcastModel> broadcasts = <BroadcastModel>[].obs;

  // =========== Pending Task ==============
  RxBool isTasksLoading = false.obs;
  final RxList<PendingTaskModel> tasks = <PendingTaskModel>[].obs;

  //============= IPD Vitals =================
  RxBool isVitalsLoading = false.obs;
  final RxList<PatientModel> vitals = <PatientModel>[].obs;

  // ============ Teleconsulation Queue ============
  final RxList<TeleconsultationQueueModel> queue = <TeleconsultationQueueModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllData();
  }

  Future<void> fetchAllData() async {
    isLoading.value = true;
    await fetchStatCardData();
    await fetchTodaysSchedule();
    await fetchRecentPatients();
    await fetchPendingTasks();
    _loadBroadcasts();
    await fetchVitals();
    await fetchTeleQueue();
    isLoading.value = false;
  }

  Future<void> fetchStatCardData() async {
    // isLoading.value = true;

    final api = NetworkHelper(url: getStatCardApi);
    final response = await api.get(auth: true);

    if (response['success'] == true) {
      final data = response['data'];

      todaysAppointments.value = data['todayAdmissions'] ?? 0;
      activeIPDPatients.value = data['ipdPatients'] ?? 0;
      pendingLabReports.value = data['totalPendingReports'] ?? 0;
      teleconsultation.value = data['teleconsultation'] ?? 0;
      mapWeeklyAdmissions(data['weeklyAdmissions']);
    }

    // isLoading.value = false;
  }

  void mapWeeklyAdmissions(Map<String, dynamic> weeklyAdmissions) {
    final List<String> orderedDays = [
      'Sun',
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
    ];

    chartLabels.clear();
    chartData.clear();

    for (final day in orderedDays) {
      final dayData = weeklyAdmissions[day] ?? {};

      chartLabels.add(day);

      chartData.add(
        PatientChartData(
          opd: dayData['OPD'] ?? 0,
          ipd: dayData['IPD'] ?? 0,
          emergency: dayData['EMERGENCY'] ?? 0,
        ),
      );
    }
  }

  Future<void> fetchTodaysSchedule() async {
    try {
      final api = NetworkHelper(url: getTodaysPatientsApi);
      final response = await api.get(auth: true);

      if (response['success'] == true) {
        final List list = response['data'];

        schedules.assignAll(
          list.where((e) => e['isTodayConfirmed'] == true).map(
            (e) => PatientModel.fromJson(e).copyWith(
              image: userImage,
            ),
          ).toList(),
        );
      } else {
        schedules.clear();
      }
    } catch (e, s) {
      log('❌ fetchTodaySchedules failed', error: e, stackTrace: s);
      schedules.clear();
    }
  }

  Future<void> fetchRecentPatients() async {
    try {
      // isLoading.value = true;

      final api = NetworkHelper(url: getRecentPatientsApi);
      final response = await api.get(auth: true);

      if (response['success'] == true) {
        final List list = response['data'];

        patients.assignAll(list.map((e) => PatientModel.fromJson(e)).toList());
      } else {
        patients.clear();
      }
    } catch (e, s) {
      log('❌ fetchRecentPatients failed', error: e, stackTrace: s);
      patients.clear();
    } finally {
      // isLoading.value = false;
    }
  }

  void _loadBroadcasts() {
    broadcasts.assignAll([
      BroadcastModel(
        title: 'General Announcement',
        imageName: 'general.png',
        fallbackIcon: Icons.campaign_outlined,
      ),
      BroadcastModel(
        title: 'Emergency announcement',
        imageName: 'emergency.png',
        fallbackIcon: Icons.warning_outlined,
      ),
      BroadcastModel(
        title: 'For reception message',
        imageName: 'reception.png',
        fallbackIcon: Icons.desk_outlined,
      ),
      BroadcastModel(
        title: 'For pharmacy message',
        imageName: 'pharmacy.png',
        fallbackIcon: Icons.local_pharmacy_outlined,
      ),
      BroadcastModel(
        title: 'For laboratory message',
        imageName: 'lab.png',
        fallbackIcon: Icons.science_outlined,
      ),
      BroadcastModel(
        title: 'For nurse message',
        imageName: 'nurse.png',
        fallbackIcon: Icons.medical_services_outlined,
      ),
    ]);
  }

  Future<void> fetchPendingTasks() async {
    try {
      isTasksLoading.value = true;
      final api = NetworkHelper(url: getTaskApi);
      final response = await api.get(auth: true);

      if (response['success'] == true) {
        final List list = response['tasks'];

        tasks.assignAll(
          list.map((e) => PendingTaskModel.fromJson(e)).toList()..sort(
            (a, b) => b.priorityOrder.compareTo(a.priorityOrder),
          ),
        );
      } else {
        tasks.clear();
      }
    } catch (e, s) {
      log('❌ fetchPendingTasks failed', error: e, stackTrace: s);
      tasks.clear();
    } finally {
      isTasksLoading.value = false;
    }
  }

  Future<void> fetchVitals() async {
    try {
      isVitalsLoading.value = true;
      final api = NetworkHelper(url: getIPDVitalsApi);
      final response = await api.get(auth: true);

      if (response['success'] == true) {
        final List list = response['data'];

        vitals.assignAll(list.map((e) => PatientModel.fromJson(e))
          .where(
            (patient) =>
              patient.currentAdmissionType == 'IPD' &&
              patient.currentVitalsReport != null,
          ).toList(),
        );
      } else {
        vitals.clear();
      }
    } catch (e, s) {
      log('❌ fetchVitals failed', error: e, stackTrace: s);
      vitals.clear();
    } finally {
      isVitalsLoading.value = false;
    }
  }

  Future<void> fetchTeleQueue() async {
    try {
      final api = NetworkHelper(url: getTeleQueueApi);
      final response = await api.get(auth: true);

      if (response['success'] == true) {
        final List list = response['data'];

        queue.assignAll(list.map((e) => TeleconsultationQueueModel.fromJson(e)).toList());
      } else {
        queue.clear();
      }
    } catch (e, s) {
      log('❌ fetchTeleQueue failed', error: e, stackTrace: s);
      queue.clear();
    }
  }
}
