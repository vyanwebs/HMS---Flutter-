import 'package:flutter/material.dart';
import 'package:hms/models/ipd_patient_model.dart';

class PatientAdmissionScreen extends StatefulWidget {
  final IPDPatient? patientToEdit;

  const PatientAdmissionScreen({super.key, this.patientToEdit});

  @override
  State<PatientAdmissionScreen> createState() => _PatientAdmissionScreenState();
}

class _PatientAdmissionScreenState extends State<PatientAdmissionScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _patientIdController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emergencyContactController =
      TextEditingController();
  final TextEditingController _diagnosisController = TextEditingController();
  final TextEditingController _insuranceProviderController =
      TextEditingController();
  final TextEditingController _insurancePolicyController =
      TextEditingController();

  String _selectedGender = 'Male';
  String _selectedWard = 'Ward A';
  String _selectedBed = 'A-101';
  String _selectedDoctor = 'Dr. Sharma';
  String _selectedStatus = 'Stable';
  DateTime _admissionDate = DateTime.now();

  List<String> wards = ['Ward A', 'Ward B', 'ICU', 'Private Rooms'];
  Map<String, List<String>> wardBeds = {
    'Ward A': ['A-101', 'A-102', 'A-103', 'A-104'],
    'Ward B': ['B-201', 'B-202', 'B-203', 'B-204', 'B-205'],
    'ICU': ['ICU-01', 'ICU-02', 'ICU-03', 'ICU-04'],
    'Private Rooms': ['PR-101', 'PR-102', 'PR-103'],
  };
  List<String> doctors = ['Dr. Sharma', 'Dr. Patel', 'Dr. Gupta', 'Dr. Verma'];
  List<String> statuses = [
    'Stable',
    'Critical',
    'Improving',
    'Under Observation'
  ];

  @override
  void initState() {
    super.initState();
    if (widget.patientToEdit != null) {
      _loadPatientData(widget.patientToEdit!);
    } else {
      _generatePatientId();
    }
  }

  void _loadPatientData(IPDPatient patient) {
    _patientIdController.text = patient.id;
    _nameController.text = patient.name;
    _ageController.text = patient.age.toString();
    _selectedGender = patient.gender;
    _selectedWard = patient.ward;
    _selectedBed = patient.bedNo;
    _selectedDoctor = patient.doctor;
    _selectedStatus = patient.status;
    _admissionDate = DateTime.parse(patient.admissionDate);
  }

  void _generatePatientId() {
    final now = DateTime.now();
    final patientId =
        'P${now.year}${now.month}${now.day}${now.hour}${now.minute}';
    _patientIdController.text = patientId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.patientToEdit != null ? 'Edit Patient' : 'Admit Patient',
          style: const TextStyle(
            fontSize: 20,
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
            icon: const Icon(Icons.save, color: Color(0xFF48BB78)),
            onPressed: _savePatient,
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
              // Patient Information Section
              _buildSectionHeader('Patient Information'),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: _buildReadOnlyField(
                      'Patient ID',
                      _patientIdController,
                      Icons.badge_outlined,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      'Full Name',
                      _nameController,
                      Icons.person_outline,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter patient name';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      'Age',
                      _ageController,
                      Icons.cake_outlined,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter age';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Please enter a valid age';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildDropdownField(
                      'Gender',
                      _selectedGender,
                      ['Male', 'Female', 'Other'],
                      Icons.transgender_outlined,
                      (value) {
                        setState(() {
                          _selectedGender = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              _buildTextField(
                'Contact Number',
                _contactController,
                Icons.phone_outlined,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),

              _buildTextField(
                'Address',
                _addressController,
                Icons.home_outlined,
                maxLines: 2,
              ),
              const SizedBox(height: 16),

              _buildTextField(
                'Emergency Contact',
                _emergencyContactController,
                Icons.emergency_outlined,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 24),

              // Medical Information Section
              _buildSectionHeader('Medical Information'),
              const SizedBox(height: 16),

              _buildTextField(
                'Diagnosis',
                _diagnosisController,
                Icons.healing_outlined,
                maxLines: 3,
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: _buildDropdownField(
                      'Ward',
                      _selectedWard,
                      wards,
                      Icons.medical_services_outlined,
                      (value) {
                        setState(() {
                          _selectedWard = value!;
                          _selectedBed = wardBeds[value]?.first ?? '';
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildDropdownField(
                      'Bed No.',
                      _selectedBed,
                      wardBeds[_selectedWard] ?? [],
                      Icons.bed_outlined,
                      (value) {
                        setState(() {
                          _selectedBed = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: _buildDropdownField(
                      'Doctor',
                      _selectedDoctor,
                      doctors,
                      Icons.person_outline,
                      (value) {
                        setState(() {
                          _selectedDoctor = value!;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildDropdownField(
                      'Status',
                      _selectedStatus,
                      statuses,
                      Icons.favorite_border_outlined,
                      (value) {
                        setState(() {
                          _selectedStatus = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              _buildDateField(
                'Admission Date',
                _admissionDate,
                Icons.calendar_today_outlined,
                (date) {
                  setState(() {
                    _admissionDate = date;
                  });
                },
              ),
              const SizedBox(height: 24),

              // Insurance Information Section
              _buildSectionHeader('Insurance Information'),
              const SizedBox(height: 16),

              _buildTextField(
                'Insurance Provider',
                _insuranceProviderController,
                Icons.security_outlined,
              ),
              const SizedBox(height: 16),

              _buildTextField(
                'Policy Number',
                _insurancePolicyController,
                Icons.description_outlined,
              ),
              const SizedBox(height: 32),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _savePatient,
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
                          Icon(Icons.save, size: 20, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            'Save Patient',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        side: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF718096),
                          fontWeight: FontWeight.w600,
                        ),
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

  Widget _buildSectionHeader(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF4299E1).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: Color(0xFF4299E1), size: 20),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    IconData icon, {
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF4299E1)),
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
      validator: validator,
    );
  }

  Widget _buildReadOnlyField(
    String label,
    TextEditingController controller,
    IconData icon,
  ) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF4299E1)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        filled: true,
        fillColor: const Color(0xFFF7FAFC),
      ),
    );
  }

  Widget _buildDropdownField(
    String label,
    String value,
    List<String> items,
    IconData icon,
    Function(String?) onChanged,
  ) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items.map((item) {
        return DropdownMenuItem(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF4299E1)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
      ),
    );
  }

  Widget _buildDateField(
    String label,
    DateTime date,
    IconData icon,
    Function(DateTime) onDateSelected,
  ) {
    return InkWell(
      onTap: () async {
        final selectedDate = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime(2023),
          lastDate: DateTime.now(),
        );
        if (selectedDate != null) {
          onDateSelected(selectedDate);
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: const Color(0xFF4299E1)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${date.day}/${date.month}/${date.year}',
              style: const TextStyle(fontSize: 16),
            ),
            const Icon(Icons.calendar_today_outlined, color: Color(0xFF718096)),
          ],
        ),
      ),
    );
  }

  void _savePatient() {
    if (_formKey.currentState!.validate()) {
      final patient = IPDPatient(
        id: _patientIdController.text,
        name: _nameController.text,
        age: int.parse(_ageController.text),
        gender: _selectedGender,
        ward: _selectedWard,
        bedNo: _selectedBed,
        admissionDate: _admissionDate.toIso8601String().split('T')[0],
        doctor: _selectedDoctor,
        status: _selectedStatus,
        diagnosis: _diagnosisController.text.isNotEmpty
            ? _diagnosisController.text
            : null,
        contactNumber:
            _contactController.text.isNotEmpty ? _contactController.text : null,
        address:
            _addressController.text.isNotEmpty ? _addressController.text : null,
        emergencyContact: _emergencyContactController.text.isNotEmpty
            ? _emergencyContactController.text
            : null,
        insuranceProvider: _insuranceProviderController.text.isNotEmpty
            ? _insuranceProviderController.text
            : null,
        insurancePolicyNo: _insurancePolicyController.text.isNotEmpty
            ? _insurancePolicyController.text
            : null,
      );

      Navigator.pop(context, patient);
    }
  }
}
