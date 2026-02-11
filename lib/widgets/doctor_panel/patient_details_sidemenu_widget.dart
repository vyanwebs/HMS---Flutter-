// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import '../../controllers/patient_details_controllers.dart';
// import '../../screens/main_dashboard.dart';
// import '../../utils/constants.dart';
// import '../../utils/enums.dart';
// import '../../utils/text.dart';

// class PatientDetailsSidebar extends StatelessWidget {
//   PatientDetailsSidebar({super.key});

//   final patientDetailsController = Get.put(PatientDetailsControllers());
  
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 260,
//       color: Colors.white,
//       child: Column(
//         children: [
//           /// LOGO HEADER
//           _logoHeader(),

//           const SizedBox(height: 10),

//           /// MENU ITEMS
//           _menuItem(
//             title: 'Home',
//             icon: Icons.home_outlined,
//             onTap: () => Get.offAll(() => const MainDashboard()),
//           ),

//           _menuItem(
//             title: 'Overview',
//             icon: Icons.description_outlined,
//             menu: PatientDetailsMenu.overview,
//           ),

//           _menuItem(
//             title: 'Monitoring',
//             icon: Icons.monitor_heart_outlined,
//             menu: PatientDetailsMenu.monitoring,
//           ),

//           _menuItem(
//             title: 'Treatment',
//             icon: Icons.water_drop_outlined,
//             menu: PatientDetailsMenu.treatment,
//           ),

//           _menuItem(
//             title: 'Investigation',
//             icon: Icons.content_paste_search,
//             menu: PatientDetailsMenu.investigation,
//           ),

//           _menuItem(
//             title: 'Surgical notes',
//             icon: Icons.edit_note_outlined,
//             menu: PatientDetailsMenu.surgicalNotes,
//           ),

//           const Spacer(),

//           /// FOOTER
//           _footer(),
//         ],
//       ),
//     );
//   }

//   Widget _logoHeader() {
//   return Padding(
//     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
//     child: Row(
//       children: [
//         Container(
//           width: 38,
//           height: 38,
//           decoration: BoxDecoration(
//             color: AppColors.info,
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: const Icon(
//             Icons.favorite,
//             color: Colors.white,
//           ),
//         ),
//         const SizedBox(width: 12),
//         const Text(
//           "Docnex",
//           style: TextStyle(
//             fontSize: 22,
//             fontWeight: FontWeight.bold,
//             color: Color(0xFF2D3748),
//           ),
//         ),
//       ],
//     ),
//   );
// }
// Widget _menuItem({
//   required String title,
//   required IconData icon,
//   PatientDetailsMenu? menu,
//   VoidCallback? onTap,
// }) {
//   return Obx(() {
//     final isSelected =
//         menu != null && patientDetailsController.selectedMenu.value == menu;

//     return InkWell(
//       onTap: onTap ?? () => patientDetailsController.select(menu!),
//       child: Container(
//         margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//         decoration: BoxDecoration(
//           color: isSelected ? AppColors.info.withOpacity(0.15) : Colors.transparent,
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Row(
//           children: [
//             Icon(
//               icon,
//               size: 20,
//               color: isSelected ? AppColors.info : Colors.grey,
//             ),
//             const SizedBox(width: 14),
//             AppText(
//               title,
//               fontWeight: FontWeight.w500,
//               color: isSelected ? AppColors.info : Colors.black87,
//             ),
//           ],
//         ),
//       ),
//     );
//   });
// }
// Widget _footer() {
//   return Container(
//     padding: const EdgeInsets.all(16),
//     decoration: BoxDecoration(
//       border: Border(
//         top: BorderSide(color: Colors.grey.shade200),
//       ),
//     ),
//     child: InkWell(
//       onTap: () => Get.back(),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: const [
//           Icon(Icons.arrow_back, color: AppColors.info),
//           SizedBox(width: 8),
//           AppText(
//             "Back",
//             fontWeight: FontWeight.w500,
//             color: AppColors.info,
//           ),
//         ],
//       ),
//     ),
//   );
// }

// }
