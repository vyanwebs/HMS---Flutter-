// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import '../../../controllers/Reception/doctor_management_controller.dart';
// import '../../models/reception_panel/doctor_model.dart';


// class DoctorManagementScreen extends StatelessWidget {
//   const DoctorManagementScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(DoctorManagementController());

//     return Scaffold(
//       backgroundColor: const Color(0xFFF7FAFC),
//       body: Padding(
//         padding: const EdgeInsets.all(30.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text("Admin / Dashboard", style: TextStyle(color: Colors.grey, fontSize: 13)),
//             const SizedBox(height: 15),
//             _buildStatCard(controller),
//             const SizedBox(height: 30),
//             _buildTableContainer(controller),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildStatCard(DoctorManagementController controller) {
//     return Container(
//       width: 320,
//       height: 140,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(12),
//         gradient: const LinearGradient(
//           colors: [Color(0xFF91D5FF), Color(0xFF40A9FF)],
//           begin: Alignment.topLeft, end: Alignment.bottomRight,
//         ),
//       ),
//       child: Stack(
//         children: [
//           Positioned(
//             right: 0, bottom: 0,
//             child: Opacity(
//               opacity: 0.3,
//               child: Image.asset('assets/images/box1.png', width: 140), // Your UI pattern
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(24),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Obx(() => Text("${controller.allDoctors.length}", 
//                   style: const TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: Colors.black87))),
//                 const SizedBox(height: 10),
//                 const Text("Total Doctors", style: TextStyle(fontSize: 18, color: Color(0xFF1A365D), fontWeight: FontWeight.w500)),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTableContainer(DoctorManagementController controller) {
//     return Expanded(
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: Colors.grey.shade200),
//         ),
//         child: Column(
//           children: [
//             _buildToolbar(controller),
//             _buildTableHeader(),
//             Expanded(
//               child: Obx(() => controller.isLoading.value 
//                 ? const Center(child: CircularProgressIndicator())
//                 : ListView.separated(
//                     itemCount: controller.filteredDoctors.length,
//                     separatorBuilder: (_, __) => const Divider(height: 1),
//                     itemBuilder: (context, index) => _buildDataRow(controller.filteredDoctors[index]),
//                   )),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildToolbar(DoctorManagementController controller) {
//     return Padding(
//       padding: const EdgeInsets.all(20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text("Available doctors", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//           const SizedBox(height: 20),
//           Row(
//             children: [
//               SizedBox(
//                 width: 380, height: 45,
//                 child: TextField(
//                   onChanged: controller.updateSearch,
//                   decoration: InputDecoration(
//                     hintText: "Search",
//                     prefixIcon: const Icon(Icons.search, size: 20),
//                     filled: true, fillColor: const Color(0xFFF7FAFC),
//                     border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 16),
//               _buildDropdown(controller),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDropdown(DoctorManagementController controller) {
//     return Container(
//       height: 45,
//       padding: const EdgeInsets.symmetric(horizontal: 12),
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.grey.shade300),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Obx(() => DropdownButton<String>(
//         value: controller.selectedStatus.value,
//         underline: const SizedBox(),
//         items: ["All", "ACTIVE", "INACTIVE"].map((val) => DropdownMenuItem(value: val, child: Text(val))).toList(),
//         onChanged: controller.updateStatus,
//       )),
//     );
//   }

//   Widget _buildTableHeader() {
//     return Container(
//       color: const Color(0xFFEDF2F7),
//       padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
//       child: const Row(
//         children: [
//           Expanded(flex: 3, child: Text("User", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))),
//           Expanded(flex: 2, child: Text("Department", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))),
//           Expanded(flex: 2, child: Text("Experience", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))),
//           Expanded(flex: 2, child: Text("Contact", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))),
//           Expanded(flex: 1, child: Text("Action", textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))),
//         ],
//       ),
//     );
//   }

//   Widget _buildDataRow(Doctor doc) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
//       child: Row(
//         children: [
//           Expanded(flex: 3, child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(doc.name, style: const TextStyle(fontWeight: FontWeight.bold)),
//               Text(doc.email, style: const TextStyle(color: Colors.grey, fontSize: 12)),
//             ],
//           )),
//           Expanded(flex: 2, child: UnconstrainedBox(
//             alignment: Alignment.centerLeft,
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//               decoration: BoxDecoration(color: const Color(0xFFE6FFFA), borderRadius: BorderRadius.circular(6)),
//               child: Text(doc.department.toUpperCase(), style: const TextStyle(color: Color(0xFF38B2AC), fontSize: 12, fontWeight: FontWeight.bold)),
//             ),
//           )),
//           const Expanded(flex: 2, child: Text("2 years")),
//           Expanded(flex: 2, child: Text(doc.phone)),
//           const Expanded(flex: 1, child: Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               Icon(Icons.chat_bubble_outline, size: 20, color: Colors.grey),
//               SizedBox(width: 10),
//               Icon(Icons.delete_outline, size: 20, color: Colors.redAccent),
//             ],
//           )),
//         ],
//       ),
//     );
//   }
// }
//
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart'; // <-- Added for email

import '../../../controllers/Reception/doctor_management_controller.dart';
import '../../models/reception_panel/doctor_model.dart';

class DoctorManagementScreen extends StatelessWidget {
  const DoctorManagementScreen({super.key});

  // Helper to launch email client
  Future<void> _launchEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=Query regarding your appointment&body=Dear Doctor,', // optional subject & body
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      Get.snackbar('Error', 'Could not launch email client');
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DoctorManagementController());

    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Admin / Dashboard", style: TextStyle(color: Colors.grey, fontSize: 13)),
            const SizedBox(height: 15),
            _buildStatCard(controller),
            const SizedBox(height: 30),
            _buildTableContainer(controller),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(DoctorManagementController controller) {
    return Container(
      width: 320,
      height: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          colors: [Color(0xFF91D5FF), Color(0xFF40A9FF)],
          begin: Alignment.topLeft, end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 0, bottom: 0,
            child: Opacity(
              opacity: 0.3,
              child: Image.asset('assets/images/box1.png', width: 140),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(() => Text("${controller.allDoctors.length}", 
                  style: const TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: Colors.black87))),
                const SizedBox(height: 10),
                const Text("Total Doctors", style: TextStyle(fontSize: 18, color: Color(0xFF1A365D), fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableContainer(DoctorManagementController controller) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            _buildToolbar(controller),
            _buildTableHeader(),
            Expanded(
              child: Obx(() => controller.isLoading.value 
                ? const Center(child: CircularProgressIndicator())
                : ListView.separated(
                    itemCount: controller.filteredDoctors.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) => _buildDataRow(controller.filteredDoctors[index], controller),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolbar(DoctorManagementController controller) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Available doctors", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Row(
            children: [
              SizedBox(
                width: 380, height: 45,
                child: TextField(
                  onChanged: controller.updateSearch,
                  decoration: InputDecoration(
                    hintText: "Search",
                    prefixIcon: const Icon(Icons.search, size: 20),
                    filled: true, fillColor: const Color(0xFFF7FAFC),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              _buildDropdown(controller),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(DoctorManagementController controller) {
    return Container(
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Obx(() => DropdownButton<String>(
        value: controller.selectedStatus.value,
        underline: const SizedBox(),
        items: ["All", "ACTIVE", "INACTIVE"].map((val) => DropdownMenuItem(value: val, child: Text(val))).toList(),
        onChanged: controller.updateStatus,
      )),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      color: const Color(0xFFEDF2F7),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      child: const Row(
        children: [
          Expanded(flex: 3, child: Text("User", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))),
          Expanded(flex: 2, child: Text("Department", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))),
          Expanded(flex: 2, child: Text("Experience", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))),
          Expanded(flex: 2, child: Text("Contact", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))),
          Expanded(flex: 1, child: Text("Action", textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey))),
        ],
      ),
    );
  }

  Widget _buildDataRow(Doctor doc, DoctorManagementController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      child: Row(
        children: [
          Expanded(flex: 3, child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(doc.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(doc.email, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          )),
          Expanded(flex: 2, child: UnconstrainedBox(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: const Color(0xFFE6FFFA), borderRadius: BorderRadius.circular(6)),
              child: Text(doc.department.toUpperCase(), style: const TextStyle(color: Color(0xFF38B2AC), fontSize: 12, fontWeight: FontWeight.bold)),
            ),
          )),
          const Expanded(flex: 2, child: Text("2 years")),
          Expanded(flex: 2, child: Text(doc.phone)),
          Expanded(flex: 1, child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Tooltip(
                message: "Send email",
                child: GestureDetector(
                  onTap: () => _launchEmail(doc.email),
                  child: const Icon(Icons.email_outlined, size: 20, color: Colors.grey),
                ),
              ),
              const SizedBox(width: 10),
              Tooltip(
                message: "Delete doctor",
                child: GestureDetector(
                  onTap: () => controller.deleteDoctor(doc.id),
                  child: const Icon(Icons.delete_outline, size: 20, color: Colors.redAccent),
                ),
              ),
            ],
          )),
        ],
      ),
    );
  }
}