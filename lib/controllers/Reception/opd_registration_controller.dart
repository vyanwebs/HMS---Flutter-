import 'package:get/get.dart';

class OPDRegistrationController extends GetxController {

  RxBool isEmergency = false.obs;

  // Separate step counters
  RxInt opdStep = 0.obs;
  RxInt emergencyStep = 1.obs;

  final selectedDoctor = "".obs;

  RxString gender = "Male".obs;
  RxBool isRevisit = false.obs;
  Rx<DateTime?> selectedDate = Rx<DateTime?>(null);

  RxInt currentStep = 1.obs;

  void registerPatient() {
    print("Registering patient...");
  }

  void pickImage() {
    print("Pick image");
  }

}
