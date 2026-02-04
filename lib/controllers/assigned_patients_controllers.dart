import 'dart:developer';

import 'package:get/get.dart';

import '../models/patient_model.dart';
import '../models/teleconsultation_queue_model.dart';
import '../services/api_service.dart';
import '../services/apis.dart';
import '../utils/enums.dart';
import '../utils/overlay.dart';
import '../utils/snackbar.dart';

class AssignedPatientsControllers extends GetxController {
  RxBool isLoading = false.obs;

  RxInt todaysAppointments = 0.obs;
  RxInt totalOPDPatients = 0.obs;
  RxInt activeIPDPatients = 0.obs;
  RxInt teleconsultation = 0.obs;

  RxList<PatientModel> opdPatients = <PatientModel>[].obs;
  RxList<PatientModel> ipdPatients = <PatientModel>[].obs;
  RxList<TeleconsultationQueueModel> telePatients = <TeleconsultationQueueModel>[].obs;

  @override
  void onInit() {
    getAllData();
    super.onInit();
  }

  Future<void> getAllData() async {
    isLoading.value = true;
    await Future.wait([
      fetchStatCardData(),
      fetchOpdPatients(),
      fetchIpdPatients(),
      fetchTelePatients(),
    ]);
    isLoading.value = false;
  }

  Future<void> fetchStatCardData() async {

    final api = NetworkHelper(url: getStatCardApi);
    final response = await api.get(auth: true);

    if (response['success'] == true) {
      final data = response['data'];

      todaysAppointments.value = data['todayAdmissions'] ?? 0;
      activeIPDPatients.value = data['ipdPatients'] ?? 0;
      totalOPDPatients.value = data['opdPatients'] ?? 0;
      teleconsultation.value = data['teleconsultation'] ?? 0;
    }
  }

  Future<void> fetchOpdPatients() async {
    try {
      final api = NetworkHelper(url: getOPDPatientsApi);
      final response = await api.get(auth: true);

      if (response['success'] == true) {
        final List list = response['data'];

        opdPatients.assignAll(
          list.map((e) => PatientModel.fromJson(e)).toList(),
        );
      } else {
        opdPatients.clear();
      }
    } catch (e) {
      opdPatients.clear();
      log(e.toString());
    }
  }

  Future<void> fetchIpdPatients() async {
    try {
      final api = NetworkHelper(url: getIPDPatientsApi);
      final response = await api.get(auth: true);

      if (response['success'] == true) {
        final List list = response['data'];

        ipdPatients.assignAll(
          list.map((e) => PatientModel.fromJson(e)).toList(),
        );
      } else {
        ipdPatients.clear();
      }
    } catch (e) {
      ipdPatients.clear();
      log(e.toString());
    }
  }

  Future<void> fetchTelePatients() async {
    try {
      final api = NetworkHelper(url: getTelePatientsApi);
      final response = await api.get(auth: true);

      if (response['success'] == true) {
        final List list = response['data'];

        telePatients.assignAll(
          list.map((e) => TeleconsultationQueueModel.fromJson(e)).toList(),
        );
      } else {
        telePatients.clear();
      }
    } catch (e) {
      telePatients.clear();
      log(e.toString());
    }
  }

  Future<void> makeAdmitRequest({
    required String patientMongoId,
  }) async {
    try {
      LoadingOverlayService.show(message: 'Admitting patient...');
      final api = NetworkHelper(url: makeAdmitRequestApi);

      final response = await api.patch(
        auth: true,
        body: {
          'patientMongoId': patientMongoId,
        },
        isFormData: true,
      );

      if (response['success'] == true) {
        /// Refresh lists after successful admit request
        await Future.wait([
          fetchOpdPatients(),
          fetchIpdPatients(),
          fetchStatCardData(),
        ]);
        AppSnackbar.show(
          title: "Success",
          message: "Admit request sent successfully",
          type: AppSnackType.success,
        );
      } else {
        AppSnackbar.show(
          title: "Failed",
          message: "${response['message'] ?? "Unable to send admit request"}",
          type: AppSnackType.error,
        );
      }
    } catch (e, s) {
      log('❌ makeAdmitRequest failed', error: e, stackTrace: s);
      AppSnackbar.show(
        title: "Error",
        message: "Something went wrong",
        type: AppSnackType.error,
      );
      LoadingOverlayService.hide();
    } finally {
      LoadingOverlayService.hide();
    }
  }

  Future<void> makeDischargeRequest({required String patientMongoId}) async {
    try {
      LoadingOverlayService.show(message: 'Discharging patient...');

      final api = NetworkHelper(url: makeDischargeRequestApi);

      final response = await api.patch(
        auth: true,
        isFormData: true,
        body: {
          'patientMongoId': patientMongoId,
        },
      );

      if (response['success'] == true) {

        AppSnackbar.show(
          title: "Success",
          message: "${response['message'] ?? "Patient discharged successfully"}",
          type: AppSnackType.success,
        );

        /// Refresh lists
        await fetchOpdPatients();
        await fetchIpdPatients();
        await fetchStatCardData();
      } else {

        AppSnackbar.show(
          title: "Error",
          message: "${response['message'] ?? "Discharge request failed"}",
          type: AppSnackType.error,
        );
        
      }
    } catch (e) {
      log('❌ makeDischargeRequest failed: $e');
      AppSnackbar.show(
        title: "Error",
        message: "Network error",
        type: AppSnackType.error,
      );
      LoadingOverlayService.hide();
    } finally {
      LoadingOverlayService.hide();
    }
  }

  Future<void> updateTeleconsultationStatus({
    required String callId,
    required TeleconsultationStatus status,
  }) async {
    try {
      LoadingOverlayService.show(
        message: status == TeleconsultationStatus.ongoing
            ? 'Accepting call...'
            : 'Cancelling call...',
      );

      final api = NetworkHelper(url: makeTeleStatusApi);

      final response = await api.patch(
        auth: true,
        isFormData: true,
        body: {
          'callId': callId,
          'status': status.value,
        },
      );

      if (response['success'] == true) {
        AppSnackbar.show(
          title: "Success",
          message: response['message'] ?? (status == TeleconsultationStatus.ongoing
            ? "Teleconsultation accepted"
            : "Teleconsultation cancelled"),
          type: AppSnackType.success,
        );

        await Future.wait([
          fetchTelePatients(),
          fetchStatCardData(),
        ]);
      } else {
        AppSnackbar.show(
          title: "Failed",
          message: response['message'] ?? "Unable to update status",
          type: AppSnackType.error,
        );
      }
    } catch (e, s) {
      log('❌ updateTeleconsultationStatus failed', error: e, stackTrace: s);
      AppSnackbar.show(
        title: "Error",
        message: "Something went wrong",
        type: AppSnackType.error,
      );
      LoadingOverlayService.hide();
    } finally {
      LoadingOverlayService.hide();
    }
  }

}