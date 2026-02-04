import 'package:get/get.dart';

import '../utils/enums.dart';
import '../utils/panel_menu.dart';

class PanelNavigationController extends GetxController {
  /// Active panel
  final Rx<UserPanel?> activePanel = Rx<UserPanel?>(null);

  PanelMenu? _previousMenu;

  /// Active menu (ANY panel menu)
  final Rx<PanelMenu?> selectedMenu = Rx<PanelMenu?>(null);

  /// Call this BEFORE opening PatientDetails
  void rememberCurrentMenu() {
    _previousMenu = selectedMenu.value;
  }

  /// Restore when coming back
  void restorePreviousMenu() {
    if (_previousMenu != null) {
      selectedMenu.value = _previousMenu;
    }
  }

  /// Switch panel after login
  void switchPanel(UserPanel panel) {
    activePanel.value = panel;

    // Default menu per panel
    switch (panel) {
      case UserPanel.doctor:
        selectedMenu.value = DoctorPanelMenu.dashboard;
        break;
      case UserPanel.reception:
      case UserPanel.nurse:
      case UserPanel.pharmacy:
      case UserPanel.laboratory:
      case UserPanel.admin:
      case UserPanel.patient:
      case UserPanel.insurance:
      case UserPanel.diagnostics:
      case UserPanel.dialysis:
      case UserPanel.externalDoctor:
        selectedMenu.value = null;
        break;
    }
  }

  /// Change sidebar menu
  void changeMenu(PanelMenu menu) {
    selectedMenu.value = menu;
  }

  /// Logout
  void reset() {
    activePanel.value = null;
    selectedMenu.value = null;
  }

  // Helpers
  bool get isDoctor => activePanel.value == UserPanel.doctor;
  bool get isNurse => activePanel.value == UserPanel.nurse;
}
