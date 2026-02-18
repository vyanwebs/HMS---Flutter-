import 'dart:developer';

import 'package:get/get.dart';

import '../services/api_service.dart';
import '../services/apis.dart';
import '../services/storage_service.dart';
import '../utils/enums.dart';
import '../utils/snackbar.dart';
import 'panel_navigation_controller.dart';
import '../screens/panel_shell.dart';

class ModuleLoginControllers extends GetxController {
  RxBool isLoading = false.obs;

  Future<void> login({
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      isLoading.value = true;

      final api = NetworkHelper(url: staffLoginApi);

      final response = await api.postData(
        body: {
          "email": email.trim(),
          "password": password.trim(),
          "role": role.toLowerCase()
        },
      );

      if (response['success'] == true) {
        final token = response['token'];
        final data = response['data'];

        // ✅ Persist auth
        await StorageService.saveToken(token);
        await StorageService.saveUser(
          name: data['name'],
          role: data['role'],
        );

        // ✅ Switch panel based on backend role
        final navController = Get.find<PanelNavigationController>();
        navController.switchPanel(_mapRole(data['role']));

        Get.off(() => PanelShell());

        AppSnackbar.show(
          title: 'Login Successful',
          message: response['message'] ?? 'Welcome back!',
          type: AppSnackType.success,
        );
      } else {
        AppSnackbar.show(
          title: 'Login Failed',
          message: response['message'] ?? 'Invalid credentials',
          type: AppSnackType.error,
        );
      }
    } catch (e) {
      log('Login error: $e');
      AppSnackbar.show(
        title: 'Network Error',
        message: e.toString(),
        type: AppSnackType.error,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// 🔁 Backend role → App enum
  UserPanel _mapRole(String role) {
    switch (role.toLowerCase()) {
      case 'doctor':
        return UserPanel.doctor;
      case 'receptionist':
        return UserPanel.reception;
      case 'nurse':
        return UserPanel.nurse;
      case 'pharmacy':
        return UserPanel.pharmacy;
      case 'patient':
        return UserPanel.patient;
      case 'insurance':
        return UserPanel.insurance;
      case 'diagnostics':
        return UserPanel.diagnostics;
      case 'dialysis':
        return UserPanel.dialysis;
      case 'externaldoctor':
        return UserPanel.externalDoctor;
      case 'admin':
        return UserPanel.admin;
      case 'laboratory':
        return UserPanel.laboratory;
      default:
        return UserPanel.doctor;
    }
  }
}
