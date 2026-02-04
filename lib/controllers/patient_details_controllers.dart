import 'package:get/get.dart';

import '../utils/enums.dart';

class PatientDetailsControllers extends GetxController {

  final selectedMenu = PatientDetailsMenu.overview.obs;
  
  RxBool isBeforeMeal = true.obs;
  RxList frequentlyUsedMedicines = [
    "Viral Fever",
    "Bacterial Infection",
    "Fever",
    "Chills / Rigors",
    "Fatigue",
  ].obs;

  void select(PatientDetailsMenu menu) {
    selectedMenu.value = menu;
  }

  void selectBeforeMeal() {
    isBeforeMeal.value = true;
  }

  void selectAfterMeal() {
    isBeforeMeal.value = false;
  }
}