import 'dart:async';
import 'package:get/get.dart';

import '../models/patient_search_model.dart';
import '../services/api_service.dart';
import '../services/apis.dart';

class AllPatientSearchController extends GetxController {

  final isLoading = false.obs;
  final patients = <PatientSearchModel>[].obs;

  Timer? _debounce;

  void searchPatient(String query) {

    _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 400), () async {

      if (query.trim().length < 2) {
        patients.clear();
        return;
      }

      try {
        isLoading.value = true;

        final response = await NetworkHelper(
          url: searchPatientsByNameApi,
        ).getWithParams(
          auth: true,
          query: {"name": query},
        );

        final List list = response["data"] ?? [];

        patients.value = list.map((e) => PatientSearchModel.fromJson(e)).toList();

      } catch (e) {
        patients.clear();
      } finally {
        isLoading.value = false;
      }
    });
  }

  void clear() {
    patients.clear();
  }
}

