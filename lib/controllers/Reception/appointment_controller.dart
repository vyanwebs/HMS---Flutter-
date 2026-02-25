import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/api_service.dart';
import '../../services/apis.dart';
import '../../models/reception_panel/appointment_management_model.dart';

// --- CONTROLLER ---
class AppointmentController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxBool isAppointmentLoading = false.obs;
  
  final RxList<DoctorModel> allDoctors = <DoctorModel>[].obs;
  final RxList<DoctorModel> filteredDoctors = <DoctorModel>[].obs;
  final RxList<AppointmentModel> appointments = <AppointmentModel>[].obs;
  
  final RxString selectedDoctorId = ''.obs;
  final RxString doctorSearchQuery = ''.obs;

  final RxInt totalDoctorCount = 0.obs;
  final RxMap<String, dynamic> stats = {
    "total": 0,
    "todayLog": 0,
    "approved": 0,
    "pending": 0,
    "cancelled": 0,
  }.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDoctors();
    debounce(doctorSearchQuery, (_) => filterDoctors(), time: 500.milliseconds);
  }

  Future<void> fetchDoctors() async {
    try {
      isLoading(true);
      final api = NetworkHelper(url: "$baseUrl/api/doctor/getDoctorByName");
      final response = await api.get(auth: true);

      if (response != null && response['success'] == true) {
        final List dataList = response['data'] ?? [];
        var docs = dataList.map((e) => DoctorModel.fromJson(e)).toList();
        allDoctors.assignAll(docs);
        filteredDoctors.assignAll(docs);
        totalDoctorCount.value = response['count'] ?? docs.length;
        
        if (docs.isNotEmpty) selectDoctor(docs.first.id);
      }
    } catch (e) { log("Error: $e"); } 
    finally { isLoading(false); }
  }

  void filterDoctors() {
    if (doctorSearchQuery.isEmpty) {
      filteredDoctors.assignAll(allDoctors);
    } else {
      filteredDoctors.assignAll(allDoctors.where((doc) => 
        doc.name.toLowerCase().contains(doctorSearchQuery.value.toLowerCase())));
    }
  }

  Future<void> selectDoctor(String id) async {
    selectedDoctorId.value = id;
    fetchAppointmentsForDoctor(id);
    fetchStatsForDoctor(id);
  }

  Future<void> fetchAppointmentsForDoctor(String doctorId) async {
    try {
      isAppointmentLoading(true);
      final api = NetworkHelper(url: "$getappointmentbydoctorApi?doctorId=$doctorId");
      final response = await api.get(auth: true);
      if (response != null && response['success'] == true) {
        final List dataList = response['data'] ?? [];
        appointments.assignAll(dataList.map((e) => AppointmentModel.fromJson(e)).toList());
      }
    } catch (e) { log("Appt Error: $e"); } 
    finally { isAppointmentLoading(false); }
  }

  Future<void> fetchStatsForDoctor(String doctorId) async {
    try {
      final api = NetworkHelper(url: "$baseUrl/api/appointment/getStats?doctorId=$doctorId");
      final response = await api.get(auth: true);
      if (response != null && response['success'] == true) {
        final data = response['data'];
        stats.value = {
          "total": data['total'] ?? 0,
          "todayLog": data['todayLog'] ?? 0,
          "approved": data['approved'] ?? 0,
          "pending": data['pending'] ?? 0,
          "cancelled": data['Cancelled'] ?? 0,
        };
      }
    } catch (e) { log("Stats Error: $e"); }
  }
}

// --- VIEW ---
class AppointmentManagementView extends StatelessWidget {
  final AppointmentController controller = Get.put(AppointmentController());

  AppointmentManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            _buildTopStats(),
            const SizedBox(height: 24),
            Expanded(
              child: Row(
                children: [
                  _buildSidebar(),
                  const SizedBox(width: 24),
                  _buildDashboardBody(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopStats() {
    return Row(
      children: [
        Obx(() => _buildTotalCard("Total Doctors", "${controller.totalDoctorCount}")),
        const SizedBox(width: 20),
        Expanded(child: _buildActionHeader()),
      ],
    );
  }

  Widget _buildTotalCard(String label, String value) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF91D5FF), Color(0xFF40A9FF)]),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white)),
          Text(label, style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _buildActionHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          const Icon(Icons.assignment, color: Color(0xFF40A9FF), size: 32),
          const SizedBox(width: 12),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Appointment management", style: TextStyle(fontWeight: FontWeight.bold)),
              Text("Manage doctor schedules and logs", style: TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () {}, // Trigger Dialog
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF40A9FF)),
            child: const Text("Create new appointment", style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return SizedBox(
      width: 300,
      child: Column(
        children: [
          TextField(
            onChanged: (v) => controller.doctorSearchQuery.value = v,
            decoration: InputDecoration(hintText: "Search doctor", prefixIcon: const Icon(Icons.search), fillColor: Colors.white, filled: true, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none)),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Obx(() => ListView.builder(
              itemCount: controller.filteredDoctors.length,
              itemBuilder: (context, index) {
                final doc = controller.filteredDoctors[index];
                bool isSelected = controller.selectedDoctorId.value == doc.id;
                // FIXED: Capitalization logic here
                String specialty = doc.specialty.isNotEmpty 
                    ? "${doc.specialty[0].toUpperCase()}${doc.specialty.substring(1)}" 
                    : "General";
                
                return GestureDetector(
                  onTap: () => controller.selectDoctor(doc.id),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFFF6FFED) : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: isSelected ? const Color(0xFFB7EB8F) : Colors.transparent),
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(child: Icon(Icons.person)),
                        const SizedBox(width: 10),
                        Expanded(child: Text(doc.name, style: const TextStyle(fontWeight: FontWeight.bold))),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(color: const Color(0xFFE6F7FF), borderRadius: BorderRadius.circular(4)),
                          child: Text(specialty, style: const TextStyle(fontSize: 10, color: Color(0xFF1890FF))),
                        )
                      ],
                    ),
                  ),
                );
              },
            )),
          )
        ],
      ),
    );
  }

  Widget _buildDashboardBody() {
    return Expanded(
      child: Column(
        children: [
          Obx(() => Row(
            children: [
              _buildStatBox("Total Logs", "${controller.stats['total']}", const Color(0xFF40A9FF)),
              _buildStatBox("Today", "${controller.stats['todayLog']}", const Color(0xFF5CDBD3)),
              _buildStatBox("Completed", "${controller.stats['approved']}", const Color(0xFF40A9FF)),
              _buildStatBox("Pending", "${controller.stats['pending']}", const Color(0xFF73D13D)),
              _buildStatBox("Cancelled", "${controller.stats['cancelled']}", const Color(0xFF597EF7)),
            ],
          )),
          const SizedBox(height: 20),
          Expanded(
            child: Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: Obx(() => controller.isAppointmentLoading.value 
                ? const Center(child: CircularProgressIndicator()) 
                : ListView.builder(
                    itemCount: controller.appointments.length,
                    itemBuilder: (context, index) => ListTile(title: Text(controller.appointments[index].patientName)),
                  )),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildStatBox(String label, String value, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
            Text(label, style: const TextStyle(fontSize: 11, color: Colors.white70)),
          ],
        ),
      ),
    );
  }
}