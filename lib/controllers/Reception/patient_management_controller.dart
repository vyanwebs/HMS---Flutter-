import 'package:get/get.dart';

import '../../models/patient_model.dart';
import '../../services/api_service.dart';
import '../../services/apis.dart';
import '../../utils/overlay.dart';
import '../../utils/snackbar.dart';

class PatientManagementController extends GetxController {

  /// ================= STATE =================
  final isLoading = false.obs;

  /// TAB
  final isAssignedTab = true.obs;

  /// ================= DATA =================
  final allPatients = <PatientModel>[].obs;
  final patients = <PatientModel>[].obs;

  /// ================= STATS =================
  final totalPatients = 0.obs;
  final assignedPatients = 0.obs;
  final admittedPatients = 0.obs;

  /// ================= INIT =================
  @override
  void onInit() {
    super.onInit();
    fetchOPDPatients();
  }

  /// =====================================================
  /// FETCH OPD PATIENTS
  /// =====================================================
  Future<void> fetchOPDPatients() async {
    try {
      isLoading.value = true;

      final helper = NetworkHelper(url: getAllOPDPatientsApi);

      final response = await helper.get(auth: true);

      if (response["success"] == true) {

        final List list = response["data"];

        allPatients.value = list.map((e) => PatientModel.fromJson(e)).toList();

        _calculateStats();
        _applyFilter();
      }

    } catch (e) {
      print("OPD Fetch Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // ================== TRANSFER PATIENT =================
  Future<void> transferPatient({
    required String patientMongoId,
    required String doctorName,
    required String staffId,
    String? reason,
  }) async {
    try {

      /// 🔵 LOADER
      LoadingOverlayService.show(
        message: "Transferring patient...",
      );

      final helper = NetworkHelper(
        url: transferPatientToDoctorApi,
      );

      final response = await helper.postData(
        auth: true,
        body: {
          "patientMongoId": patientMongoId,
          "doctorName": doctorName,
          "staffId": staffId,
          "doctorTransferReason": reason ?? "",
        },
      );

      /// ✅ SUCCESS
      if (response["success"] == true) {

        AppSnackbar.show(
          title: "Success",
          message: "Patient transferred successfully",
          type: AppSnackType.success,
        );

        await fetchOPDPatients(); // ✅ refresh
      } else {

        AppSnackbar.show(
          title: "Transfer Failed",
          message: response["message"] ?? "Something went wrong",
          type: AppSnackType.error,
        );
      }

    } catch (e) {

      AppSnackbar.show(
        title: "Error",
        message: e.toString(),
        type: AppSnackType.error,
      );

    } finally {
      LoadingOverlayService.hide();
    }
  }

  /// =====================================================
  /// STATS
  /// =====================================================
  void _calculateStats() {

    totalPatients.value = allPatients.length;

    assignedPatients.value = allPatients.where((p) =>
        p.currentAdmissionStatus == "PENDING" ||
        p.currentAdmissionStatus == "CONFIRMED" ||
        p.currentAdmissionStatus == "DISCHARGE_REQUESTED"
    ).length;

    admittedPatients.value = allPatients.where((p) => p.currentAdmissionStatus == "ADMITTED"
    ).length;
  }

  /// =====================================================
  /// TAB SWITCH
  /// =====================================================
  void changeTab(bool assigned) {
    isAssignedTab.value = assigned;
    _applyFilter();
  }

  void _applyFilter() {

    if (isAssignedTab.value) {

      /// Assigned Patients
      patients.assignAll(
        allPatients.where((p) => p.currentAdmissionStatus != "ADMITTED"),
      );

    } else {

      /// Admitted Patients
      patients.assignAll(
        allPatients.where((p) => p.currentAdmissionStatus == "ADMITTED"),
      );
    }
  }

  /// =====================================================
  /// SEARCH
  /// =====================================================
  void searchPatients(String query) {

    if (query.isEmpty) {
      _applyFilter();
      return;
    }

    final result = allPatients.where((p) =>
      p.name.toLowerCase().contains(query.toLowerCase()) ||
      p.patientId.toLowerCase().contains(query.toLowerCase()) ||
      p.mobileNumber.contains(query)
    ).toList();

    patients.assignAll(result);
  }

  /// =====================================================
  /// STATUS HELPERS (FOR UI BADGES)
  /// =====================================================
  bool isPending(PatientModel p) => p.currentAdmissionStatus == "PENDING";

  bool isConfirmed(PatientModel p) => p.currentAdmissionStatus == "CONFIRMED";

  bool isAdmitted(PatientModel p) => p.currentAdmissionStatus == "ADMITTED";

  bool isEmergency(PatientModel p) => p.currentAdmissionPriorityLevel == "URGENT";

  /// =====================================================
  /// ACTIONS
  /// =====================================================
  
  Future<void> admitPatient(PatientModel patient) async {
    print("Admit -> ${patient.name}");
    // TODO: Admit API
  }
}