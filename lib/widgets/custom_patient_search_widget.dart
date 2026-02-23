import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/all_patients_search_controllers.dart';
import '../models/patient_search_model.dart';
import '../utils/text.dart';
import 'patient_avatar_widget.dart';

class CustomAllPatientSearchField extends StatefulWidget {
  final Function(PatientSearchModel?) onChanged;
  final String label;

  const CustomAllPatientSearchField({
    super.key,
    required this.onChanged,
    this.label = "Search patient",
  });

  @override
  State<CustomAllPatientSearchField> createState() => _CustomAllPatientSearchFieldState();
}

class _CustomAllPatientSearchFieldState extends State<CustomAllPatientSearchField> {
  late final dynamic controller;
  
  @override
  void initState() {
    super.initState();
    controller = Get.find<AllPatientSearchController>();
  }
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        /// SEARCH FIELD
        TextField(
          controller: textController,
          decoration: InputDecoration(
            hintText: widget.label,
            prefixIcon: const Icon(Icons.search),
            filled: true,
            fillColor: const Color(0xFFF7F9FC),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onChanged: controller.searchPatient,
        ),

        /// RESULT LIST
        Obx(() {

          if (controller.isLoading.value) {
            return const Padding(
              padding: EdgeInsets.all(12),
              child: CircularProgressIndicator(),
            );
          }

          if (controller.patients.isEmpty) {
            return const SizedBox();
          }

          return Container(
            margin: const EdgeInsets.only(top: 8),
            constraints: const BoxConstraints(maxHeight: 300),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: ListView.builder(
              itemCount: controller.patients.length,
              itemBuilder: (_, index) {

                final patient = controller.patients[index];

                return ListTile(
                  leading: PatientAvatar(
                    name: patient.name,
                    imageUrl: patient.avatar.url,
                    googleDriveLink: patient.avatar.googleDriveLink,
                  ),
                  title: AppText(patient.name),

                  subtitle: AppText(
                    "${patient.gender} • ${patient.age} yr\n"
                    "${patient.admissionType} • ${patient.admissionStatus}",
                    fontSize: 11,
                    color: Colors.grey,
                  ),

                  trailing: AppText(
                    patient.patientId,
                    fontSize: 11,
                  ),

                  onTap: () {
                    textController.text = patient.name;
                    controller.clear();
                    widget.onChanged(patient);
                  },
                );
              },
            ),
          );
        }),
      ],
    );
  }
}
