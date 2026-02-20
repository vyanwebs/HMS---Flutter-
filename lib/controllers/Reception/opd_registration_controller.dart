import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/doctor_model.dart';
import '../../models/patient_search_model.dart';
import '../../services/api_service.dart';
import '../../services/apis.dart';
import '../../utils/snackbar.dart';

class OPDRegistrationController extends GetxController {

  RxBool isEmergency = false.obs;

  /// ================= SELECTED PATIENT =================
  final selectedPatient = Rxn<PatientSearchModel>();

  /// ================= FORM CONTROLLERS =================
  final patientIdController = TextEditingController();
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final weightController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  final patientAvatarUrl = "".obs;

  final gender = "".obs;
  final currentAdmissionType = "".obs;

  String get reviewName => nameController.text;
  String get reviewAge => ageController.text;
  String get reviewPhone => phoneController.text;
  String get reviewAddress => addressController.text;
  String get reviewWeight => weightController.text;
  String get reviewGender => gender.value;
  String get reviewPatientId => patientIdController.text;

  bool get isExistingPatient => selectedPatient.value != null;

  // Separate step counters
  RxInt opdStep = 0.obs;
  RxInt emergencyStep = 1.obs;

  final selectedDoctor = "".obs;

  RxBool isRevisit = false.obs;
  Rx<DateTime?> selectedDate = Rx<DateTime?>(null);

  RxInt currentStep = 1.obs;

  void registerPatient() {
    print("Registering patient...");
  }

  final emergencyPersonalFormKey = GlobalKey<FormState>();

  final department = "".obs;
  final attendingStaff = "".obs;
  final triageLevel = "".obs;
  final arrivalMode = "".obs;

  final selectedWard = "General Ward (40 Beds)".obs;
  final selectedBed = "".obs;

  final totalBeds = 40.obs;
  final availableBeds = 19.obs;
  final occupiedBeds = 21.obs;

  // =====================================================
  // FORM KEY
  // =====================================================
  final opdFormKey = GlobalKey<FormState>();

  // =====================================================
  // TEXT CONTROLLERS
  // =====================================================

  /// emergency / future safe
  final guardianController = TextEditingController();
  final emailController = TextEditingController();
  final occupationController = TextEditingController();
  final educationController = TextEditingController();
  final bloodGroupController = TextEditingController();

  /// ================= EMERGENCY PERSONAL =================

  final emergencyNameController = TextEditingController();
  final emergencyPhoneController = TextEditingController();
  final emergencyAltPhoneController = TextEditingController();
  final emergencyAddressController = TextEditingController();
  final emergencyIdNumberController = TextEditingController();

  final emergencyDobController = TextEditingController();

  /// ================= EMERGENCY DETAILS =================

  final chiefComplaintController = TextEditingController();

  /// Vital Signs
  final bloodPressureController = TextEditingController();
  final heartRateController = TextEditingController();
  final temperatureController = TextEditingController();
  final oxygenController = TextEditingController();

  /// Notes
  final additionalNotesController = TextEditingController();

  // =====================================================
  // VALIDATORS
  // =====================================================

  String? validateRequired(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Required field";
    }
    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return "Phone required";
    }

    if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
      return "Invalid phone number";
    }

    return null;
  }

  String? validateAge(String? value) {
    if (value == null || value.isEmpty) {
      return "Age required";
    }

    final age = int.tryParse(value);
    if (age == null || age <= 0) {
      return "Invalid age";
    }

    return null;
  }

  String? validateWeight(String? value) {
    if (value == null || value.isEmpty) return null;

    final weight = double.tryParse(value);
    if (weight == null) {
      return "Invalid weight";
    }

    return null;
  }

  // =====================================================
  // AUTO FILL FROM SEARCH
  // =====================================================

  void setPatient(PatientSearchModel p) {

    selectedPatient.value = p;

    patientIdController.text = p.patientId;
    nameController.text = p.name;
    ageController.text = p.age.toString();
    phoneController.text = p.mobile;
    addressController.text = p.address ?? "";
    weightController.text = p.weight?.toString() ?? "";

    patientAvatarUrl.value = p.avatar.url.isNotEmpty
      ? p.avatar.url
      : p.avatar.googleDriveLink;

    gender.value = p.gender;
    currentAdmissionType.value = p.admissionType;
    isRevisit.value = true;
  }

  void clearPatient() {
    selectedPatient.value = null;

    patientIdController.clear();
    nameController.clear();
    ageController.clear();
    phoneController.clear();
    addressController.clear();
    weightController.clear();

    gender.value = "";
    patientAvatarUrl.value = "";
  }

  // =====================================================
  // SUBMIT VALIDATION
  // =====================================================

  bool validateForm() {

    if (!opdFormKey.currentState!.validate()) {
      return false;
    }

    if (gender.value.isEmpty) {
      AppSnackbar.show(
        title: "Error",
        message: "Please select gender",
        type: AppSnackType.error,
      );
      return false;
    }

    return true;
  }

  /// Selected Image
  final selectedImagePath = "".obs;
  final selectedImageBytes = Rxn<Uint8List>();

  /// ================= PICK IMAGE =================
  Future<void> pickImage() async {

    try {

      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        withData: kIsWeb,
      );

      if (result == null) return;

      final file = result.files.first;

      /// WEB
      if (kIsWeb) {
        selectedImageBytes.value = file.bytes;
      }

      /// MOBILE + DESKTOP
      else {
        selectedImagePath.value = file.path!;
      }

    } catch (e) {
      print("Image pick error: $e");
    }
  }

  // ========================== Doctors =======================

  @override
  void onInit() {
    fetchDoctors();
    super.onInit();
  }

  final doctors = <DoctorModel>[].obs;
  final isDoctorLoading = false.obs;

  Future<void> fetchDoctors() async {
    try {

      isDoctorLoading.value = true;

      final helper = NetworkHelper(
        url: getAllDoctorsApi,
      );

      final response = await helper.get(auth: true);

      if (response["success"] == true) {

        final List list = response["data"];

        doctors.value = list.map((e) => DoctorModel.fromJson(e)).toList();
      }

    } catch (e) {
      print("Doctor fetch error: $e");
    } finally {
      isDoctorLoading.value = false;
    }
  }

  @override
  void onClose() {
    patientIdController.dispose();
    nameController.dispose();
    ageController.dispose();
    weightController.dispose();
    phoneController.dispose();
    addressController.dispose();

    guardianController.dispose();
    emailController.dispose();
    occupationController.dispose();
    educationController.dispose();
    bloodGroupController.dispose();

    emergencyNameController.dispose();
    emergencyPhoneController.dispose();
    emergencyAltPhoneController.dispose();
    emergencyAddressController.dispose();
    emergencyIdNumberController.dispose();
    emergencyDobController.dispose();

    chiefComplaintController.dispose();
    bloodPressureController.dispose();
    heartRateController.dispose();
    temperatureController.dispose();
    oxygenController.dispose();
    additionalNotesController.dispose();

    super.onClose();
  }

}
