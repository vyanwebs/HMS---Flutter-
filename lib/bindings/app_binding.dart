import 'package:get/get.dart';
import '../controllers/all_patients_search_controllers.dart';
import '../controllers/panel_navigation_controller.dart';
import '../controllers/Doctor/patient_search_controllers.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {

    Get.put(PanelNavigationController(), permanent: true);
    Get.put(PatientSearchController(), permanent: true);

    Get.lazyPut<AllPatientSearchController>(
      () => AllPatientSearchController(),
      fenix: true,
    );
  }
}