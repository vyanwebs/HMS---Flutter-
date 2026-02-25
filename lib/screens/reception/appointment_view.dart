import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hms/models/reception_panel/appointment_management_model.dart';
import '../../controllers/Reception/appointment_controller.dart';
import '../../models/appointment_model.dart';

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left Side: Doctor List
                  SizedBox(width: 350, child: _buildDoctorSidebar()),
                  const SizedBox(width: 24),
                  // Right Side: Stats and Appointments
                  Expanded(child: _buildMainDashboard()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- HEADER SECTION ---
  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Admin / Dashboard", style: TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 16),
        _buildTotalDoctorCard(),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: const Color(0xFF40A9FF), borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.assignment_ind_outlined, color: Colors.white),
              ),
              const SizedBox(width: 16),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Appointment management", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text("Complete control and appointment management", style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () => _showCreateAppointmentDialog(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF40A9FF),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                ),
                child: const Text("Create new appointment", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTotalDoctorCard() {
    return Obx(() => Container(
      width: 200,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF91D5FF), Color(0xFF40A9FF)]),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("${controller.totalDoctorCount}", style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
          const Text("Total Doctors", style: TextStyle(color: Colors.white, fontSize: 14)),
        ],
      ),
    ));
  }

  // --- DOCTOR SIDEBAR (LEFT) ---
  Widget _buildDoctorSidebar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          onChanged: (val) => controller.doctorSearchQuery.value = val,
          decoration: InputDecoration(
            hintText: "Search doctor",
            prefixIcon: const Icon(Icons.search),
            fillColor: Colors.white,
            filled: true,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
        ),
        const SizedBox(height: 20),
        const Text("Doctor", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Expanded(
          child: Obx(() {
            if (controller.isLoading.value) return const Center(child: CircularProgressIndicator());
            return ListView.builder(
              itemCount: controller.filteredDoctors.length,
              itemBuilder: (context, index) {
                final doctor = controller.filteredDoctors[index];
                return _buildDoctorListItem(doctor);
              },
            );
          }),
        ),
      ],
    );
  }

  Widget _buildDoctorListItem(dynamic doctor) {
    return Obx(() {
      bool isSelected = controller.selectedDoctorId.value == doctor.id;
      return GestureDetector(
        onTap: () => controller.selectDoctor(doctor.id),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isSelected ? const Color(0xFFB7EB8F) : Colors.transparent, width: 2),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 5)],
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundImage: doctor.avatarUrl.isNotEmpty ? NetworkImage(doctor.avatarUrl) : null,
                child: doctor.avatarUrl.isEmpty ? const Icon(Icons.person) : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(doctor.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFFF6FFED), borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFB7EB8F))),
                child: Text(doctor.specialty.capitalizeFirst!, style: const TextStyle(color: Color(0xFF52C41A), fontSize: 11)),
              ),
            ],
          ),
        ),
      );
    });
  }

  // --- MAIN DASHBOARD (RIGHT) ---
  Widget _buildMainDashboard() {
    return Column(
      children: [
        _buildStatGrid(),
        const SizedBox(height: 20),
        Expanded(child: _buildAppointmentList()),
      ],
    );
  }

  Widget _buildStatGrid() {
    return Obx(() => Row(
      children: [
        _buildStatBox("Total Logs", "${controller.stats['total']}", const [Color(0xFF40A9FF), Color(0xFF096DD9)]),
        const SizedBox(width: 12),
        _buildStatBox("Today", "${controller.stats['todayLog']}", const [Color(0xFF87E8DE), Color(0xFF5CDBD3)]),
        const SizedBox(width: 12),
        _buildStatBox("Completed", "${controller.stats['approved']}", const [Color(0xFF91D5FF), Color(0xFF40A9FF)]),
        const SizedBox(width: 12),
        _buildStatBox("Pending", "${controller.stats['pending']}", const [Color(0xFFB7EB8F), Color(0xFF73D13D)]),
        const SizedBox(width: 12),
        _buildStatBox("Cancelled", "${controller.stats['cancelled']}", const [Color(0xFFADC6FF), Color(0xFF597EF7)]),
      ],
    ));
  }

  Widget _buildStatBox(String label, String value, List<Color> colors) {
    return Expanded(
      child: Container(
        height: 100,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: colors, begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(value, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
            Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentList() {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search appointment",
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              _buildFilterDropdown(),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Obx(() {
              if (controller.isAppointmentLoading.value) return const Center(child: CircularProgressIndicator());
              if (controller.appointments.isEmpty) return const Center(child: Text("No appointments found"));
              return ListView.builder(
                itemCount: controller.appointments.length,
                itemBuilder: (context, index) => _buildAppointmentCard(controller.appointments[index]),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentCard(AppointmentModel appt) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 14, color: Color(0xFF40A9FF)),
              const SizedBox(width: 8),
              Text(appt.scheduledDate.toString().substring(0, 16), style: const TextStyle(fontWeight: FontWeight.bold)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFF91D5FF).withOpacity(0.3), borderRadius: BorderRadius.circular(4)),
                child: Text(appt.status, style: const TextStyle(color: Color(0xFF096DD9), fontSize: 11)),
              )
            ],
          ),
          const Divider(height: 24),
          Row(
            children: [
              const CircleAvatar(backgroundColor: Colors.grey, radius: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(appt.patientName, style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text("Patient id :- ${appt.patientId}", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    Text(appt.mobileNumber, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    Row(
                      children: [
                        const Icon(Icons.sick_outlined, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text("Symptoms :- ${appt.symptoms}", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(onPressed: () {}, icon: const Icon(Icons.edit_note, color: Color(0xFF40A9FF)), style: IconButton.styleFrom(backgroundColor: const Color(0xFFE6F7FF))),
              const SizedBox(width: 8),
              IconButton(onPressed: () {}, icon: const Icon(Icons.delete_outline, color: Colors.redAccent), style: IconButton.styleFrom(backgroundColor: const Color(0xFFFFF1F0))),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildFilterDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: "All",
          items: ["All", "Pending", "Completed"].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (val) {},
        ),
      ),
    );
  }

  // --- CREATE APPOINTMENT DIALOG (SECOND SCREEN UI) ---
  void _showCreateAppointmentDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: 900,
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Create new appointment", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildAppointmentForm()),
                  const SizedBox(width: 40),
                  Expanded(child: _buildDoctorAndScheduleSection()),
                ],
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(onPressed: () => Get.back(), child: const Text("Cancel", style: TextStyle(color: Colors.grey))),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF40A9FF), padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16)),
                    child: const Text("Create appointment", style: TextStyle(color: Colors.white)),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppointmentForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("fill details for appointment", style: TextStyle(color: Colors.grey)),
        const SizedBox(height: 20),
        _buildInputField("Search patient", "Patient name"),
        _buildInputField("Patient id", "Enter patient id"),
        _buildInputField("Phone number", "Enter phone number"),
        _buildInputField("Symptoms", "Enter symptoms", isMultiline: true),
        Row(
          children: [
            Checkbox(value: false, onChanged: (v) {}),
            const Text("Is this readmission"),
          ],
        ),
        Row(
          children: [
            Radio(value: true, groupValue: true, onChanged: (v) {}),
            const Text("In-person"),
            const SizedBox(width: 20),
            Radio(value: false, groupValue: true, onChanged: (v) {}),
            const Text("Teleconsultation"),
          ],
        )
      ],
    );
  }

  Widget _buildInputField(String label, String hint, {bool isMultiline = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          TextField(
            maxLines: isMultiline ? 3 : 1,
            decoration: InputDecoration(
              hintText: hint,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorAndScheduleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Doctor section", style: TextStyle(color: Colors.grey)),
        const SizedBox(height: 20),
        const Text("Select doctor", style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        _buildFilterDropdown(), // Reuse dropdown for selection
        const SizedBox(height: 20),
        const Text("Appointment schedule", style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade200), borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(Icons.calendar_month, size: 16),
                  const SizedBox(width: 8),
                  const Text("Date 26-01-2025"),
                  const Spacer(),
                  TextButton(onPressed: () {}, child: const Text("Select date")),
                ],
              ),
              const Divider(),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: ["9 a.m.", "9:30 a.m.", "10 a.m.", "10:30 a.m.", "11 a.m.", "11:30 a.m.", "12 p.m.", "12:30 p.m.", "1 p.m."].map((time) {
                  bool isSelected = time == "10 a.m.";
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF40A9FF) : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(time, style: TextStyle(color: isSelected ? Colors.white : Colors.black, fontSize: 12)),
                  );
                }).toList(),
              )
            ],
          ),
        )
      ],
    );
  }
}