import 'package:flutter/material.dart';
import 'package:hms/models/opd_appointment_model.dart';

class PrescriptionScreen extends StatefulWidget {
  final OPDAppointment? appointment;

  const PrescriptionScreen({super.key, this.appointment});

  @override
  State<PrescriptionScreen> createState() => _PrescriptionScreenState();
}

class _PrescriptionScreenState extends State<PrescriptionScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _diagnosisController = TextEditingController();
  final TextEditingController _symptomsController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _followUpController = TextEditingController();

  List<Medication> medications = [];
  List<LabTest> labTests = [];

  final TextEditingController _medNameController = TextEditingController();
  final TextEditingController _medDosageController = TextEditingController();
  final TextEditingController _medDurationController = TextEditingController();
  final TextEditingController _medInstructionsController =
      TextEditingController();

  final TextEditingController _testNameController = TextEditingController();
  final TextEditingController _testInstructionsController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.appointment != null) {
      _diagnosisController.text = widget.appointment!.reason;
      _followUpController.text = '7 days';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.appointment != null
              ? 'Prescription - ${widget.appointment!.patientName}'
              : 'Create Prescription',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3748),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF4299E1)),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.print, color: Color(0xFFED8936)),
            onPressed: _printPrescription,
            tooltip: 'Print Prescription',
          ),
          IconButton(
            icon: const Icon(Icons.save, color: Color(0xFF48BB78)),
            onPressed: _savePrescription,
            tooltip: 'Save Prescription',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Patient Information
              if (widget.appointment != null) _buildPatientCard(),

              const SizedBox(height: 20),

              // Diagnosis & Symptoms
              _buildCard(
                'Diagnosis & Symptoms',
                [
                  _buildTextField(
                      'Diagnosis', _diagnosisController, Icons.medical_services,
                      required: true),
                  const SizedBox(height: 15),
                  _buildTextField(
                      'Symptoms', _symptomsController, Icons.warning,
                      maxLines: 3),
                  const SizedBox(height: 15),
                  _buildTextField('Follow-up After', _followUpController,
                      Icons.calendar_today),
                  const SizedBox(height: 15),
                  _buildTextField(
                      'Additional Notes', _notesController, Icons.notes,
                      maxLines: 4),
                ],
              ),

              const SizedBox(height: 20),

              // Medications
              _buildCard(
                'Medications',
                [
                  ...medications
                      .map((med) => _buildMedicationItem(med))
                      .toList(),
                  const SizedBox(height: 15),
                  _buildAddMedicationForm(),
                ],
              ),

              const SizedBox(height: 20),

              // Lab Tests
              _buildCard(
                'Lab Tests',
                [
                  ...labTests.map((test) => _buildLabTestItem(test)).toList(),
                  const SizedBox(height: 15),
                  _buildAddLabTestForm(),
                ],
              ),

              const SizedBox(height: 30),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _savePrescription,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4299E1),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.save, size: 18),
                          SizedBox(width: 8),
                          Text('Save Prescription'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _printPrescription,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFED8936),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.print, size: 18),
                          SizedBox(width: 8),
                          Text('Print Prescription'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _sendToPharmacy,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF48BB78),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.local_pharmacy, size: 18),
                          SizedBox(width: 8),
                          Text('Send to Pharmacy'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPatientCard() {
    final appointment = widget.appointment!;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFF4299E1).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person,
              size: 30,
              color: Color(0xFF4299E1),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  appointment.patientName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    _buildPatientInfoChip('${appointment.age} yrs'),
                    const SizedBox(width: 10),
                    _buildPatientInfoChip(appointment.gender),
                    const SizedBox(width: 10),
                    _buildPatientInfoChip(appointment.id),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  '${appointment.doctor} • ${appointment.department}',
                  style: const TextStyle(
                    color: Color(0xFF718096),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientInfoChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          color: Color(0xFF4A5568),
        ),
      ),
    );
  }

  Widget _buildCard(String title, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3748),
                ),
              ),
              if (title == 'Medications' || title == 'Lab Tests')
                Text(
                  '(${title == 'Medications' ? medications.length : labTests.length})',
                  style: const TextStyle(
                    color: Color(0xFF718096),
                    fontSize: 14,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 15),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    IconData icon, {
    bool required = false,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: '$label${required ? ' *' : ''}',
        prefixIcon: Icon(icon, color: const Color(0xFF718096), size: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF4299E1)),
        ),
      ),
      validator: required
          ? (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter $label';
              }
              return null;
            }
          : null,
    );
  }

  Widget _buildMedicationItem(Medication med) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF48BB78).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.medication,
              color: Color(0xFF48BB78),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  med.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${med.dosage} • ${med.duration}',
                  style: const TextStyle(
                    color: Color(0xFF718096),
                    fontSize: 12,
                  ),
                ),
                if (med.instructions.isNotEmpty)
                  Text(
                    med.instructions,
                    style: const TextStyle(
                      color: Color(0xFF4A5568),
                      fontSize: 11,
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                medications.remove(med);
              });
            },
            icon: const Icon(Icons.delete, size: 18, color: Color(0xFFF56565)),
            tooltip: 'Remove',
          ),
        ],
      ),
    );
  }

  Widget _buildAddMedicationForm() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _medNameController,
                  decoration: const InputDecoration(
                    labelText: 'Medication Name',
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  controller: _medDosageController,
                  decoration: const InputDecoration(
                    labelText: 'Dosage',
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _medDurationController,
                  decoration: const InputDecoration(
                    labelText: 'Duration',
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  controller: _medInstructionsController,
                  decoration: const InputDecoration(
                    labelText: 'Instructions',
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _addMedication,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4299E1),
              minimumSize: const Size(double.infinity, 40),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add, size: 16),
                SizedBox(width: 8),
                Text('Add Medication'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabTestItem(LabTest test) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFED8936).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.science,
              color: Color(0xFFED8936),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  test.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3748),
                  ),
                ),
                if (test.instructions.isNotEmpty)
                  Text(
                    test.instructions,
                    style: const TextStyle(
                      color: Color(0xFF718096),
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                labTests.remove(test);
              });
            },
            icon: const Icon(Icons.delete, size: 18, color: Color(0xFFF56565)),
            tooltip: 'Remove',
          ),
        ],
      ),
    );
  }

  Widget _buildAddLabTestForm() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          TextFormField(
            controller: _testNameController,
            decoration: const InputDecoration(
              labelText: 'Lab Test Name',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _testInstructionsController,
            maxLines: 2,
            decoration: const InputDecoration(
              labelText: 'Instructions (Optional)',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _addLabTest,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4299E1),
              minimumSize: const Size(double.infinity, 40),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add, size: 16),
                SizedBox(width: 8),
                Text('Add Lab Test'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _addMedication() {
    if (_medNameController.text.isNotEmpty &&
        _medDosageController.text.isNotEmpty) {
      setState(() {
        medications.add(Medication(
          name: _medNameController.text,
          dosage: _medDosageController.text,
          duration: _medDurationController.text,
          instructions: _medInstructionsController.text,
        ));
        _medNameController.clear();
        _medDosageController.clear();
        _medDurationController.clear();
        _medInstructionsController.clear();
      });
    }
  }

  void _addLabTest() {
    if (_testNameController.text.isNotEmpty) {
      setState(() {
        labTests.add(LabTest(
          name: _testNameController.text,
          instructions: _testInstructionsController.text,
        ));
        _testNameController.clear();
        _testInstructionsController.clear();
      });
    }
  }

  void _savePrescription() {
    if (_formKey.currentState!.validate()) {
      final prescriptionId =
          'RX${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Prescription saved successfully (ID: $prescriptionId)'),
          backgroundColor: const Color(0xFF48BB78),
        ),
      );

      Navigator.pop(context);
    }
  }

  void _printPrescription() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Prescription sent to printer'),
          backgroundColor: Color(0xFFED8936),
        ),
      );
    }
  }

  void _sendToPharmacy() {
    if (medications.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No medications to send'),
          backgroundColor: Color(0xFFF56565),
        ),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Prescription sent to pharmacy'),
          backgroundColor: Color(0xFF48BB78),
        ),
      );
    }
  }
}

class Medication {
  final String name;
  final String dosage;
  final String duration;
  final String instructions;

  Medication({
    required this.name,
    required this.dosage,
    required this.duration,
    required this.instructions,
  });
}

class LabTest {
  final String name;
  final String instructions;

  LabTest({
    required this.name,
    required this.instructions,
  });
}
