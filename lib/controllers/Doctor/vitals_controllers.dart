import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../models/patient_model.dart';
import '../../models/patient_vitals_model.dart';
import '../../models/vital_graph_point.dart';
import '../../services/api_service.dart';
import '../../services/apis.dart';
import '../../utils/enums.dart';
import '../../utils/labels.dart';
import '../../utils/overlay.dart';
import '../../utils/snackbar.dart';

class VitalsControllers extends GetxController {

  // =====================================================
  // 🔹 FORM (CREATE VITAL)
  // =====================================================

  final bpCtrl = TextEditingController();
  final pulseCtrl = TextEditingController();
  final tempCtrl = TextEditingController();
  final spo2Ctrl = TextEditingController();

  final isCreating = false.obs;

  Future<void> createVital({
    required PatientModel patient,
  }) async {
    try {
      isCreating.value = true;
      LoadingOverlayService.show(message: "Adding vitals...");

      final api = NetworkHelper(url: addVitalsApi);

      final response = await api.post(
        auth: true,
        body: {
          "patientMongoId": patient.id,
          "bp": bpCtrl.text.trim(),
          "pulse": int.tryParse(pulseCtrl.text),
          "temperature": double.tryParse(tempCtrl.text),
          "spo2": int.tryParse(spo2Ctrl.text),
        },
      );

      LoadingOverlayService.hide();
      isCreating.value = false;

      if (response['success'] == true) {

        clearVitalForm();

        await fetchVitals(patientMongoId: patient.id);

        if (viewMode.value == VitalsViewMode.analysis) {
          await fetchVitalGraph(patientMongoId: patient.id);
        }

        Get.back();

        AppSnackbar.show(
          title: "Success",
          message: "Vitals added successfully",
          type: AppSnackType.success,
        );

      } else {
        AppSnackbar.show(
          title: "Failed",
          message: response['message'] ?? "Unable to add vitals",
          type: AppSnackType.error,
        );
      }

    } catch (e, s) {
      isCreating.value = false;
      LoadingOverlayService.hide();
      log('❌ createVital failed', error: e, stackTrace: s);

      AppSnackbar.show(
        title: "Error",
        message: "Something went wrong",
        type: AppSnackType.error,
      );
    }
  }

  void clearVitalForm() {
    bpCtrl.clear();
    pulseCtrl.clear();
    tempCtrl.clear();
    spo2Ctrl.clear();
  }

  // =====================================================
  // 🔹 TABLE + SELECTION
  // =====================================================

  RxBool isLoading = false.obs;
  RxList<PatientVitalsModel> vitals = <PatientVitalsModel>[].obs;
  RxSet<String> selectedVitalIds = <String>{}.obs;

  bool get hasSelection => selectedVitalIds.isNotEmpty;

  bool isSelected(String id) => selectedVitalIds.contains(id);

  void toggleSelection(String id) {
    selectedVitalIds.contains(id)
        ? selectedVitalIds.remove(id)
        : selectedVitalIds.add(id);
  }

  void clearSelection() => selectedVitalIds.clear();

  Future<void> fetchVitals({
    required String patientMongoId,
  }) async {
    try {
      isLoading.value = true;
      log(patientMongoId);

      final api = NetworkHelper(url: "$getAllVitalsApi/$patientMongoId");
      final response = await api.get(auth: true);

      if (response['success'] == true) {
        final List list = response['data'];
        vitals.value =
            list.map((e) => PatientVitalsModel.fromJson(e)).toList();
      } else {
        AppSnackbar.show(
          title: "Failed",
          message: response['message'] ?? "Unable to fetch vitals",
          type: AppSnackType.error,
        );
      }

    } catch (e, s) {
      log('❌ fetchVitals failed', error: e, stackTrace: s);
      AppSnackbar.show(
        title: "Error",
        message: "Something went wrong",
        type: AppSnackType.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // =====================================================
  // 🔹 VIEW MODE + ANALYSIS
  // =====================================================

  Rx<VitalsViewMode> viewMode = VitalsViewMode.table.obs;
  Rx<VitalType> selectedVital = VitalType.temperature.obs;
  Rx<TimeRange> selectedRange = TimeRange.days7.obs;

  RxBool isGraphLoading = false.obs;
  RxList<VitalGraphPoint> graphPoints = <VitalGraphPoint>[].obs;

  void showAnalysis(String patientMongoId) {
    viewMode.value = VitalsViewMode.analysis;
    fetchVitalGraph(patientMongoId: patientMongoId);
  }

  void showTable() {
    viewMode.value = VitalsViewMode.table;
  }

  void changeVital(VitalType v, String patientMongoId) {
    selectedVital.value = v;
    fetchVitalGraph(patientMongoId: patientMongoId);
  }

  void changeRange(TimeRange r, String patientMongoId) {
    selectedRange.value = r;
    fetchVitalGraph(patientMongoId: patientMongoId);
  }

  Future<void> fetchVitalGraph({
    required String patientMongoId,
  }) async {
    try {
      isGraphLoading.value = true;

      final type = vitalTypeToApi(selectedVital.value);
      final days = rangeToDays(selectedRange.value);

      final uri = Uri.parse(getVitalsGraphApi).replace(
        queryParameters: {
          "patientMongoId": patientMongoId,
          "type": type,
          if (days != null) "days": days.toString(),
        },
      );

      final api = NetworkHelper(url: uri.toString());
      final response = await api.get(auth: true);

      if (response['success'] == true) {
        final List list = response['data'] ?? [];

        graphPoints.value = list.map(
          (e) => VitalGraphPoint.fromJson(
            e as Map<String, dynamic>,
            type,
          ),
        ).toList();
      } else {
        graphPoints.clear();
      }

    } catch (e) {
      graphPoints.clear();
    } finally {
      isGraphLoading.value = false;
    }
  }

  // =====================================================
  // 🔹 COMPUTED VALUES (STATS)
  // =====================================================

  bool get isBp => selectedVital.value == VitalType.bp;

  List<double> get numericValues {
    if (isBp) {
      return graphPoints
          .where((p) => p.systolic != null)
          .map((p) => p.systolic!)
          .toList();
    }

    return graphPoints
        .where((p) => p.value != null)
        .map((p) => p.value!)
        .toList();
  }

  List<double> get systolicValues =>
      graphPoints.where((p) => p.systolic != null).map((p) => p.systolic!).toList();

  List<double> get diastolicValues =>
      graphPoints.where((p) => p.diastolic != null).map((p) => p.diastolic!).toList();

  double get average =>
      numericValues.isEmpty
          ? 0
          : numericValues.reduce((a, b) => a + b) / numericValues.length;

  double get minValue =>
      numericValues.isEmpty
          ? 0
          : numericValues.reduce((a, b) => a < b ? a : b);

  double get maxValue =>
      numericValues.isEmpty
          ? 0
          : numericValues.reduce((a, b) => a > b ? a : b);

  double get avgSystolic =>
      systolicValues.isEmpty
          ? 0
          : systolicValues.reduce((a, b) => a + b) / systolicValues.length;

  double get avgDiastolic =>
      diastolicValues.isEmpty
          ? 0
          : diastolicValues.reduce((a, b) => a + b) / diastolicValues.length;

  double get bpMin {
    final all = [...systolicValues, ...diastolicValues];
    return all.isEmpty ? 0 : all.reduce((a, b) => a < b ? a : b);
  }

  double get bpMax {
    final all = [...systolicValues, ...diastolicValues];
    return all.isEmpty ? 0 : all.reduce((a, b) => a > b ? a : b);
  }

  // =====================================================
  // 🔹 DELETE
  // =====================================================

  Future<void> deleteVital({
    required String vitalId,
    required String patientMongoId,
  }) async {
    try {
      LoadingOverlayService.show(message: "Deleting Vitals...");

      final api = NetworkHelper(
        url: "$deleteSingleVitalApi/$vitalId",
      );

      final response = await api.delete(auth: true);

      LoadingOverlayService.hide();

      if (response['success'] == true) {
        await fetchVitals(patientMongoId: patientMongoId);

        if (viewMode.value == VitalsViewMode.analysis) {
          await fetchVitalGraph(patientMongoId: patientMongoId);
        }

        AppSnackbar.show(
          title: "Deleted",
          message: "Vital record deleted successfully",
          type: AppSnackType.success,
        );
      }

    } catch (e) {
      LoadingOverlayService.hide();
    }
  }

  Future<void> deleteMultipleVitals({
    required List<String> vitalIds,
    required String patientMongoId,
  }) async {
    if (vitalIds.isEmpty) return;

    try {
      LoadingOverlayService.show(message: "Deleting Vitals...");

      final api = NetworkHelper(url: deleteMultipleVitalsApi);

      final response = await api.post(
        auth: true,
        body: {"ids": vitalIds},
      );

      LoadingOverlayService.hide();

      if (response['success'] == true) {
        selectedVitalIds.clear();
        await fetchVitals(patientMongoId: patientMongoId);

        AppSnackbar.show(
          title: "Deleted",
          message: "${vitalIds.length} vitals deleted successfully",
          type: AppSnackType.success,
        );
      }

    } catch (e) {
      LoadingOverlayService.hide();
    }
  }

  // =====================================================
  // 🔹 PRINT
  // =====================================================

  Future<void> printAnalysis(PatientModel patient) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text("Patient Vitals Report",
                style: pw.TextStyle(
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            pw.Text("Patient: ${patient.name}"),
            pw.Text("Patient ID: ${patient.patientId}"),
            pw.Text("Vital: ${vitalLabel(selectedVital.value)}"),
            pw.Text("Average: ${average.toStringAsFixed(1)} ${vitalUnit(selectedVital.value)}"),
            pw.Text("Min - Max: ${minValue.toStringAsFixed(1)} - ${maxValue.toStringAsFixed(1)}"),
          ],
        ),
      ),
    );

    await Printing.layoutPdf(onLayout: (_) => pdf.save());
  }

  // =====================================================
  // 🔹 HELPERS
  // =====================================================

  String vitalTypeToApi(VitalType v) {
    switch (v) {
      case VitalType.bp:
        return "bp";
      case VitalType.pulse:
        return "pulse";
      case VitalType.respiration:
        return "respirationRate";
      case VitalType.temperature:
        return "temperature";
      case VitalType.spo2:
        return "spo2";
      case VitalType.weight:
        return "weight";
      case VitalType.sugar:
        return "bloodSugarLevel";
    }
  }

  int? rangeToDays(TimeRange t) {
    switch (t) {
      case TimeRange.days7:
        return 7;
      case TimeRange.days14:
        return 14;
      case TimeRange.days30:
        return 30;
      case TimeRange.all:
        return null;
    }
  }

  String vitalUnit(VitalType type) {
    switch (type) {
      case VitalType.pulse:
        return "bpm";
      case VitalType.temperature:
        return "°F";
      case VitalType.spo2:
        return "%";
      case VitalType.bp:
        return "mmHg";
      case VitalType.respiration:
        return "breaths/min";
      case VitalType.weight:
        return "kg";
      case VitalType.sugar:
        return "mg/dl";
    }
  }

  // =====================================================
  // 🔹 CLEANUP
  // =====================================================

  @override
  void onClose() {
    bpCtrl.dispose();
    pulseCtrl.dispose();
    tempCtrl.dispose();
    spo2Ctrl.dispose();
    super.onClose();
  }
}
