import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SurgicalNotesControllers extends GetxController {
  final surgeryDate = Rx<DateTime?>(null);
  final surgeryTime = Rx<TimeOfDay?>(null);
  final anesthesiaStart = Rx<TimeOfDay?>(null);
  final anesthesiaEnd = Rx<TimeOfDay?>(null);
  final fullDateTime = Rx<DateTime?>(null);
  final expectedRecoveryTime = Rx<TimeOfDay?>(null);

  final RxString urgency = "".obs;
  final RxString outcome = "".obs;

  final RxString documentationType = "".obs; 

  final RxList<String> assistantSurgeons = <String>[].obs;

}