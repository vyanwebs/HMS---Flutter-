// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import '../../controllers/Reception/track_patient_controller.dart';
// import '../../models/reception_panel/patient_management_model.dart';

// class _StatCardWidget extends StatelessWidget {
//   final String title;
//   final String value;
//   final Gradient gradient;
//   final String imagePath;

//   const _StatCardWidget({
//     Key? key,
//     required this.title,
//     required this.value,
//     required this.gradient,
//     required this.imagePath,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 120,
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(12),
//         gradient: gradient,
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.end,
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     value,
//                     style: const TextStyle(
//                       fontSize: 28,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.black,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     title,
//                     style: const TextStyle(
//                       fontSize: 14,
//                       color: Colors.black87,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Image.asset(
//             imagePath,
//             width: 100,
//             height: 100,
//             fit: BoxFit.contain,
//           ),
//         ],
//       ),
//     );
//   }
// }

// class TrackPatientsScreen extends StatelessWidget {
//   const TrackPatientsScreen({super.key});

//   // -------------------------------------------------------------------------
//   // Show patient details dialog - Pixel Perfect Implementation
//   // -------------------------------------------------------------------------
//   void _showPatientDetails(BuildContext context, PatientRowModel patient) {
//     showDialog(
//       context: context,
//       builder: (ctx) {
//         return Dialog(
//           backgroundColor: Colors.white,
//           insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//           child: Container(
//             width: 850,
//             padding: const EdgeInsets.all(32),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Top Header: Breadcrumb & Close
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Text(
//                       "Admin / view",
//                       style: TextStyle(color: Colors.grey, fontSize: 13),
//                     ),
//                     IconButton(
//                       onPressed: () => Navigator.pop(ctx),
//                       icon: const Icon(Icons.close, color: Colors.grey),
//                     ),
//                   ],
//                 ),
//                 Text(
//                   "Patient details- ${patient.name}",
//                   style: const TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black,
//                   ),
//                 ),
//                 const SizedBox(height: 24),
                
//                 // Middle Section: Profile and Basic Info cards
//                 Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Left Profile Card
//                     Expanded(
//                       flex: 4,
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(vertical: 32),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(12),
//                           border: Border.all(color: Colors.grey.shade200),
//                         ),
//                         child: Column(
//                           children: [
//                             CircleAvatar(
//                               radius: 60,
//                               backgroundColor: Colors.grey.shade100,
//                               // Replace with actual model image if available
//                               backgroundImage: const NetworkImage('https://via.placeholder.com/150'), 
//                             ),
//                             const SizedBox(height: 16),
//                             Text(
//                               patient.name,
//                               style: const TextStyle(
//                                 fontSize: 26,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             const SizedBox(height: 16),
//                             // Status Chip (Active)
//                             Container(
//                               width: 120,
//                               padding: const EdgeInsets.symmetric(vertical: 8),
//                               decoration: BoxDecoration(
//                                 color: const Color(0xFFC6F6D5), // Light green
//                                 borderRadius: BorderRadius.circular(6),
//                               ),
//                               child: Center(
//                                 child: Text(
//                                   patient.status,
//                                   style: const TextStyle(
//                                     color: Color(0xFF2F855A), // Dark green
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(height: 10),
//                             // Type Chip (OPD)
//                             Container(
//                               width: 120,
//                               padding: const EdgeInsets.symmetric(vertical: 8),
//                               decoration: BoxDecoration(
//                                 color: const Color(0xFFFFEBD2), // Light orange
//                                 borderRadius: BorderRadius.circular(6),
//                               ),
//                               child: Center(
//                                 child: Text(
//                                   patient.type,
//                                   style: const TextStyle(
//                                     color: Color(0xFFC05621), // Dark orange
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 24),
                    
//                     // Right Basic Information Card
//                     Expanded(
//                       flex: 6,
//                       child: Container(
//                         height: 310,
//                         padding: const EdgeInsets.all(28),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(12),
//                           border: Border.all(color: Colors.grey.shade200),
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Text(
//                               "Basic information",
//                               style: TextStyle(
//                                 fontSize: 22,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             const SizedBox(height: 24),
//                             _buildInfoLine("Age :-", "${patient.ageGender.split('/').last.isEmpty ? '0' : patient.ageGender.split('/').last} years"),
//                             _buildInfoLine("Gender :-", patient.ageGender.split('/').first),
//                             _buildInfoLine("Contact :-", patient.contact),
//                             _buildInfoLine("Address :-", "FGAGJDHDJJD"),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 24),
                
//                 // Bottom Navigation Section
//                 Container(
//                   padding: const EdgeInsets.symmetric(vertical: 20),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(color: Colors.grey.shade200),
//                   ),
//                   child: Row(
//                     children: [
//                       // Medical History Navigation
//                       Expanded(
//                         child: InkWell(
//                           onTap: () {
//                             Navigator.pop(ctx);
//                             // Add navigation logic: Get.to(() => MedicalHistoryPage());
//                             print("Navigate to Medical History for ${patient.name}");
//                           },
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Container(
//                                 padding: const EdgeInsets.all(10),
//                                 decoration: BoxDecoration(
//                                   color: const Color(0xFF3182CE),
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                                 child: const Icon(Icons.history, color: Colors.white, size: 24),
//                               ),
//                               const SizedBox(width: 16),
//                               const Text(
//                                 "Medical history",
//                                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       // Vertical Divider
//                       Container(width: 1, height: 50, color: Colors.grey.shade200),
//                       // IPD Admission Navigation
//                       Expanded(
//                         child: InkWell(
//                           onTap: () {
//                             Navigator.pop(ctx);
//                             // Add navigation logic: Get.to(() => IpdAdmissionPage());
//                             print("Navigate to IPD Admission for ${patient.name}");
//                           },
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Container(
//                                 padding: const EdgeInsets.all(10),
//                                 decoration: BoxDecoration(
//                                   color: const Color(0xFF3182CE),
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                                 child: const Icon(Icons.person_add_alt_1, color: Colors.white, size: 24),
//                               ),
//                               const SizedBox(width: 16),
//                               const Text(
//                                 "IPD admission",
//                                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   // Helper for consistent info layout in dialog
//   Widget _buildInfoLine(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 18),
//       child: Row(
//         children: [
//           Text(label, style: const TextStyle(color: Colors.grey, fontSize: 16)),
//           const SizedBox(width: 10),
//           Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(TrackPatientsController());

//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F7FB),
//       body: Padding(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _breadcrumb(),
//             const SizedBox(height: 20),
//             _statsRow(controller),
//             const SizedBox(height: 24),
//             Expanded(child: _tableContainer(context, controller)),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _breadcrumb() {
//     return const Text(
//       "Admin / Dashboard",
//       style: TextStyle(color: Colors.grey, fontSize: 13),
//     );
//   }

//   Widget _statsRow(TrackPatientsController controller) {
//     return Obx(() => Row(
//           children: [
//             Expanded(
//               child: _StatCardWidget(
//                 title: "Total patients",
//                 value: controller.totalPatients.value.toString(),
//                 gradient: const LinearGradient(
//                   colors: [Color(0xFF4A90E2), Color(0xFFBFE0FF)],
//                 ),
//                 imagePath: 'assets/images/box1.png',
//               ),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: _StatCardWidget(
//                 title: "IPD",
//                 value: controller.ipdCount.value.toString(),
//                 gradient: const LinearGradient(
//                   colors: [Color(0xFF00B894), Color(0xFFB8F1E8)],
//                 ),
//                 imagePath: 'assets/images/box2.png',
//               ),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: _StatCardWidget(
//                 title: "OPD",
//                 value: controller.opdCount.value.toString(),
//                 gradient: const LinearGradient(
//                   colors: [Color(0xFF00C9C9), Color(0xFFCFFFFF)],
//                 ),
//                 imagePath: 'assets/images/box3.png',
//               ),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: _StatCardWidget(
//                 title: "Today admission",
//                 value: controller.todayAdmissions.value.toString(),
//                 gradient: const LinearGradient(
//                   colors: [Color(0xFF22C55E), Color(0xFFD9FBE6)],
//                 ),
//                 imagePath: 'assets/images/box4.png',
//               ),
//             ),
//           ],
//         ));
//   }

//   Widget _tableContainer(BuildContext context, TrackPatientsController controller) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.grey.shade200),
//       ),
//       child: Column(
//         children: [
//           _toolbar(controller),
//           _tableHeader(controller),
//           Expanded(
//             child: Obx(() {
//               if (controller.isLoading.value) {
//                 return const Center(child: CircularProgressIndicator());
//               }

//               return ListView.separated(
//                 itemCount: controller.filteredPatients.length,
//                 separatorBuilder: (_, __) =>
//                     Divider(height: 1, color: Colors.grey.shade200),
//                 itemBuilder: (_, index) =>
//                     _tableRow(context, controller, controller.filteredPatients[index]),
//               );
//             }),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _toolbar(TrackPatientsController controller) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
//       child: Row(
//         children: [
//           const Text(
//             "Patients management",
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           const Spacer(),
//           SizedBox(
//             width: 240,
//             height: 40,
//             child: TextField(
//               onChanged: controller.updateSearch,
//               decoration: InputDecoration(
//                 hintText: "Search",
//                 prefixIcon: const Icon(Icons.search, size: 18),
//                 filled: true,
//                 fillColor: const Color(0xFFF5F7FB),
//                 contentPadding: EdgeInsets.zero,
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(8),
//                   borderSide: BorderSide.none,
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(width: 12),
//           Container(
//             height: 40,
//             padding: const EdgeInsets.symmetric(horizontal: 10),
//             decoration: BoxDecoration(
//               color: const Color(0xFFF5F7FB),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Obx(() => DropdownButtonHideUnderline(
//                   child: DropdownButton<String>(
//                     value: controller.selectedStatus.value,
//                     hint: const Text("Status"),
//                     items: const [
//                       DropdownMenuItem(
//                         value: "All",
//                         child: Text("Status"),
//                       ),
//                       DropdownMenuItem(
//                         value: "Active",
//                         child: Text("Active"),
//                       ),
//                       DropdownMenuItem(
//                         value: "Inactive",
//                         child: Text("Inactive"),
//                       ),
//                     ],
//                     onChanged: controller.updateStatusFilter,
//                   ),
//                 )),
//           ),
//           const SizedBox(width: 12),
//           SizedBox(
//             height: 40,
//             child: ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.red,
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 22, vertical: 0),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//               onPressed: controller.deleteSelected,
//               child: const Text(
//                 "Delete",
//                 style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _tableHeader(TrackPatientsController controller) {
//     return Container(
//       color: const Color(0xFFF1F5F9),
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//       child: Row(
//         children: [
//           SizedBox(
//             width: 40,
//             child: Obx(() => Checkbox(
//                   value: controller.allSelected,
//                   tristate: true,
//                   onChanged: controller.selectAll,
//                 )),
//           ),
//           const Expanded(flex: 3, child: Text("Patient")),
//           const Expanded(flex: 2, child: Text("Patient id")),
//           const Expanded(flex: 2, child: Text("Age&gender")),
//           const Expanded(flex: 3, child: Text("Contact")),
//           const Expanded(flex: 2, child: Text("Type")),
//           const Expanded(flex: 2, child: Text("Status")),
//           const Expanded(flex: 1, child: Text("Visit")),
//           const Expanded(
//             flex: 1,
//             child: Align(
//               alignment: Alignment.centerRight,
//               child: Text("Action"),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _tableRow(BuildContext context, TrackPatientsController controller, PatientRowModel model) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
//       child: Row(
//         children: [
//           SizedBox(
//             width: 40,
//             child: Obx(() => Checkbox(
//                   value: controller.isSelected(model.id),
//                   onChanged: (_) => controller.toggleSelection(model.id),
//                 )),
//           ),
//           Expanded(flex: 3, child: Text(model.name)),
//           Expanded(flex: 2, child: Text(model.patientId)),
//           Expanded(flex: 2, child: Text(model.ageGender)),
//           Expanded(flex: 3, child: Text(model.contact)),
//           Expanded(flex: 2, child: Text(model.type)),
//           Expanded(flex: 2, child: Text(model.status)),
//           Expanded(flex: 1, child: Text("${model.visit}")),
//           Expanded(
//             flex: 1,
//             child: Align(
//               alignment: Alignment.centerRight,
//               child: GestureDetector(
//                 onTap: () => _showPatientDetails(context, model),
//                 child: const Icon(Icons.remove_red_eye_outlined),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/reception_panel/patient_management_model.dart';
import '../../services/api_service.dart';
import '../../services/apis.dart';

// -------------------------------------------------------------------------
// CONTROLLER (Logic with NetworkHelper)
// -------------------------------------------------------------------------
class TrackPatientsController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxString searchText = ''.obs;
  final RxString selectedStatus = "All".obs;

  final RxList<PatientRowModel> allPatients = <PatientRowModel>[].obs;
  final RxList<PatientRowModel> filteredPatients = <PatientRowModel>[].obs;
  final RxSet<String> selectedIds = <String>{}.obs;

  final RxInt totalPatients = 0.obs;
  final RxInt ipdCount = 0.obs;
  final RxInt opdCount = 0.obs;
  final RxInt todayAdmissions = 0.obs;

  @override
  void onInit() {
    super.onInit();
    refreshData();
  }

  void refreshData() {
    fetchStats();
    fetchPatients();
  }

  Future<void> fetchStats() async {
    try {
      final api = NetworkHelper(url: trackpatientcardsApi);
      final response = await api.get(auth: true);
      if (response != null && response['success'] == true) {
        final data = response['data'];
        totalPatients.value = data['totalPatients'] ?? 0;
        ipdCount.value = data['totalIPDPatients'] ?? 0;
        opdCount.value = data['totalOPDPatients'] ?? 0;
        todayAdmissions.value = data['totalTodayAdmission'] ?? 0;
      }
    } catch (e) { log("❌ fetchStats Error: $e"); }
  }

  Future<void> fetchPatients() async {
    try {
      isLoading(true);
      final api = NetworkHelper(url: getallpatientApi);
      final response = await api.get(auth: true);
      if (response != null && response['success'] == true) {
        final List list = response['data'] ?? [];
        allPatients.assignAll(list.map((e) => PatientRowModel.fromJson(e)).toList());
        applyFilters();
      }
    } catch (e) { log("❌ fetchPatients Error: $e"); } 
    finally { isLoading(false); }
  }

  void applyFilters() {
    var list = allPatients.where((p) {
      final matchesName = p.name.toLowerCase().contains(searchText.value.toLowerCase());
      final matchesStatus = selectedStatus.value == "All" || p.status == selectedStatus.value;
      return matchesName && matchesStatus;
    }).toList();
    filteredPatients.assignAll(list);
  }

  void updateSearch(String val) { searchText.value = val; applyFilters(); }
  void updateStatusFilter(String? val) { if (val != null) { selectedStatus.value = val; applyFilters(); } }

  Future<void> deleteSelected() async {
    if (selectedIds.isEmpty) return;
    try {
      isLoading(true);
      final api = NetworkHelper(url: deletepatientsApi);
      final response = await api.delete(auth: true, body: {"patientIds": selectedIds.toList()});
      if (response != null && response['success'] == true) {
        selectedIds.clear();
        refreshData();
        Get.snackbar("Success", "Deleted successfully", backgroundColor: Colors.green, colorText: Colors.white);
      }
    } catch (e) { log("❌ Delete Error: $e"); } 
    finally { isLoading(false); }
  }

  void toggleSelection(String id) => selectedIds.contains(id) ? selectedIds.remove(id) : selectedIds.add(id);
  bool isSelected(String id) => selectedIds.contains(id);
  bool get allSelected => filteredPatients.isNotEmpty && filteredPatients.every((p) => selectedIds.contains(p.id));
  
  void selectAll(bool? checked) {
    if (checked == true) {
      selectedIds.addAll(filteredPatients.map((p) => p.id));
    } else {
      selectedIds.clear();
    }
  }
}

// -------------------------------------------------------------------------
// UI COMPONENTS
// -------------------------------------------------------------------------
class _StatCardWidget extends StatelessWidget {
  final String title;
  final String value;
  final Gradient gradient;
  final String imagePath;

  const _StatCardWidget({
    required this.title,
    required this.value,
    required this.gradient,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: gradient,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(value, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black)),
                  const SizedBox(height: 4),
                  Text(title, style: const TextStyle(fontSize: 14, color: Colors.black87)),
                ],
              ),
            ),
          ),
          Image.asset(imagePath, width: 100, height: 100, fit: BoxFit.contain),
        ],
      ),
    );
  }
}

class TrackPatientsScreen extends StatelessWidget {
  const TrackPatientsScreen({super.key});

  void _showPatientDetails(BuildContext context, PatientRowModel patient) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.white,
        insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          width: 850,
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Admin / view", style: TextStyle(color: Colors.grey, fontSize: 13)),
                  IconButton(onPressed: () => Navigator.pop(ctx), icon: const Icon(Icons.close, color: Colors.grey)),
                ],
              ),
              Text("Patient details - ${patient.name}", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 32),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
                        child: Column(
                          children: [
                            CircleAvatar(radius: 60, backgroundColor: Colors.grey.shade100, backgroundImage: const NetworkImage('https://via.placeholder.com/150')),
                            const SizedBox(height: 16),
                            Text(patient.name, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 16),
                            _buildChip(patient.status, const Color(0xFFC6F6D5), const Color(0xFF2F855A)),
                            const SizedBox(height: 10),
                            _buildChip(patient.type, const Color(0xFFFFEBD2), const Color(0xFFC05621)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      flex: 6,
                      child: Container(
                        height: 310,
                        padding: const EdgeInsets.all(28),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Basic information", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 24),
                            _infoLine("Age :-", "${patient.ageGender.split('/').last} years"),
                            _infoLine("Gender :-", patient.ageGender.split('/').first),
                            _infoLine("Contact :-", patient.contact),
                            _infoLine("Address :-", patient.address),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _bottomNav(ctx, patient),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChip(String label, Color bg, Color text) {
    return Container(
      width: 140, padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6)),
      child: Center(child: Text(label, style: TextStyle(color: text, fontWeight: FontWeight.w600))),
    );
  }

  Widget _infoLine(String label, String val) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 16)),
        const SizedBox(width: 10),
        Text(val, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      ]),
    );
  }

  Widget _bottomNav(BuildContext ctx, PatientRowModel patient) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
      child: Row(children: [
        _navBtn(Icons.history, "Medical history", () => Navigator.pop(ctx)),
        Container(width: 1, height: 50, color: Colors.grey.shade200),
        _navBtn(Icons.person_add_alt_1, "IPD admission", () => Navigator.pop(ctx)),
      ]),
    );
  }

  Widget _navBtn(IconData icon, String label, VoidCallback tap) {
    return Expanded(
      child: InkWell(
        onTap: tap,
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: const Color(0xFF3182CE), borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: Colors.white)),
          const SizedBox(width: 16),
          Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TrackPatientsController());
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Admin / Dashboard", style: TextStyle(color: Colors.grey, fontSize: 13)),
            const SizedBox(height: 20),
            _statsRow(controller),
            const SizedBox(height: 24),
            Expanded(child: _tableContainer(context, controller)),
          ],
        ),
      ),
    );
  }

  Widget _statsRow(TrackPatientsController controller) {
    return Obx(() => Row(children: [
      Expanded(child: _StatCardWidget(title: "Total patients", value: controller.totalPatients.value.toString(), gradient: const LinearGradient(colors: [Color(0xFF4A90E2), Color(0xFFBFE0FF)]), imagePath: 'assets/images/box1.png')),
      const SizedBox(width: 16),
      Expanded(child: _StatCardWidget(title: "IPD", value: controller.ipdCount.value.toString(), gradient: const LinearGradient(colors: [Color(0xFF00B894), Color(0xFFB8F1E8)]), imagePath: 'assets/images/box2.png')),
      const SizedBox(width: 16),
      Expanded(child: _StatCardWidget(title: "OPD", value: controller.opdCount.value.toString(), gradient: const LinearGradient(colors: [Color(0xFF00C9C9), Color(0xFFCFFFFF)]), imagePath: 'assets/images/box3.png')),
      const SizedBox(width: 16),
      Expanded(child: _StatCardWidget(title: "Today admission", value: controller.todayAdmissions.value.toString(), gradient: const LinearGradient(colors: [Color(0xFF22C55E), Color(0xFFD9FBE6)]), imagePath: 'assets/images/box4.png')),
    ]));
  }

  Widget _tableContainer(BuildContext context, TrackPatientsController controller) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
      child: Column(children: [
        _toolbar(controller),
        _tableHeader(controller),
        Expanded(child: Obx(() {
          if (controller.isLoading.value) return const Center(child: CircularProgressIndicator());
          return ListView.separated(
            itemCount: controller.filteredPatients.length,
            separatorBuilder: (_, __) => Divider(height: 1, color: Colors.grey.shade200),
            itemBuilder: (_, index) => _tableRow(context, controller, controller.filteredPatients[index]),
          );
        })),
      ]),
    );
  }

  Widget _toolbar(TrackPatientsController controller) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
      child: Row(children: [
        const Text("Patients management", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        const Spacer(),
        SizedBox(width: 240, height: 40, child: TextField(onChanged: controller.updateSearch, decoration: InputDecoration(hintText: "Search", prefixIcon: const Icon(Icons.search, size: 18), filled: true, fillColor: const Color(0xFFF5F7FB), border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none)))),
        const SizedBox(width: 12),
        _statusDropdown(controller),
        const SizedBox(width: 12),
        ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.red, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))), onPressed: controller.deleteSelected, child: const Text("Delete", style: TextStyle(color: Colors.white))),
      ]),
    );
  }

  Widget _statusDropdown(TrackPatientsController controller) {
    return Container(
      height: 40, padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(color: const Color(0xFFF5F7FB), borderRadius: BorderRadius.circular(8)),
      child: Obx(() => DropdownButtonHideUnderline(child: DropdownButton<String>(
        value: controller.selectedStatus.value,
        items: ["All", "PENDING", "CONFIRMED", "ADMITTED", "DISCHARGED","ADMISSION_REQUESTED", "DISCHARGE_REQUESTED"].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
        onChanged: controller.updateStatusFilter,
      ))),
    );
  }

  Widget _tableHeader(TrackPatientsController controller) {
    return Container(
      color: const Color(0xFFF1F5F9), padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(children: [
        SizedBox(width: 40, child: Obx(() => Checkbox(value: controller.allSelected, onChanged: controller.selectAll))),
        const Expanded(flex: 3, child: Text("Patient")),
        const Expanded(flex: 2, child: Text("Patient id")),
        const Expanded(flex: 2, child: Text("Age&gender")),
        const Expanded(flex: 3, child: Text("Contact")),
        const Expanded(flex: 2, child: Text("Type")),
        const Expanded(flex: 2, child: Text("Status")),
        const Expanded(flex: 1, child: Text("Visit")),
        const Expanded(flex: 1, child: Align(alignment: Alignment.centerRight, child: Text("Action"))),
      ]),
    );
  }

  Widget _tableRow(BuildContext context, TrackPatientsController controller, PatientRowModel model) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(children: [
        SizedBox(width: 40, child: Obx(() => Checkbox(value: controller.isSelected(model.id), onChanged: (_) => controller.toggleSelection(model.id)))),
        Expanded(flex: 3, child: Text(model.name)),
        Expanded(flex: 2, child: Text(model.patientId)),
        Expanded(flex: 2, child: Text(model.ageGender)),
        Expanded(flex: 3, child: Text(model.contact)),
        Expanded(flex: 2, child: Text(model.type)),
        Expanded(flex: 2, child: Text(model.status)),
        Expanded(flex: 1, child: Text("${model.visit}")),
        Expanded(flex: 1, child: Align(alignment: Alignment.centerRight, child: GestureDetector(onTap: () => _showPatientDetails(context, model), child: const Icon(Icons.remove_red_eye_outlined)))),
      ]),
    );
  }
}