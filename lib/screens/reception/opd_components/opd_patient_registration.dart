import 'package:flutter/material.dart';

class OPDPatientRegistrationScreen extends StatefulWidget {
  const OPDPatientRegistrationScreen({super.key});

  @override
  State<OPDPatientRegistrationScreen> createState() =>
      _OPDPatientRegistrationScreenState();
}

class _OPDPatientRegistrationScreenState
    extends State<OPDPatientRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emergencyContactController =
      TextEditingController();
  final TextEditingController _bloodGroupController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _allergiesController = TextEditingController();
  final TextEditingController _medicalHistoryController =
      TextEditingController();

  String _selectedGender = 'Male';
  String _selectedMaritalStatus = 'Single';
  String _selectedBloodGroup = 'O+';

  List<String> bloodGroups = ['O+', 'O-', 'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-'];
  List<String> maritalStatuses = ['Single', 'Married', 'Divorced', 'Widowed'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Register New OPD Patient',
          style: TextStyle(
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
            icon: const Icon(Icons.save, color: Color(0xFF48BB78)),
            onPressed: _registerPatient,
            tooltip: 'Save Patient',
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
              // Personal Information
              _buildCard(
                'Personal Information',
                [
                  _buildTextField(
                      'Full Name', _fullNameController, Icons.person,
                      required: true),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                            'Age', _ageController, Icons.cake,
                            required: true),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: _buildDropdown(
                          'Gender',
                          ['Male', 'Female', 'Other'],
                          _selectedGender,
                          (value) => setState(() => _selectedGender = value!),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  _buildTextField(
                      'Contact Number', _contactController, Icons.phone,
                      required: true),
                  const SizedBox(height: 15),
                  _buildDropdown(
                    'Marital Status',
                    maritalStatuses,
                    _selectedMaritalStatus,
                    (value) => setState(() => _selectedMaritalStatus = value!),
                  ),
                  const SizedBox(height: 15),
                  _buildTextField(
                      'Address', _addressController, Icons.location_on,
                      maxLines: 3),
                  const SizedBox(height: 15),
                  _buildTextField('Emergency Contact',
                      _emergencyContactController, Icons.emergency),
                ],
              ),

              const SizedBox(height: 20),

              // Medical Information
              _buildCard(
                'Medical Information',
                [
                  _buildDropdown(
                    'Blood Group',
                    bloodGroups,
                    _selectedBloodGroup,
                    (value) => setState(() => _selectedBloodGroup = value!),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                            'Height (cm)', _heightController, Icons.height),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: _buildTextField('Weight (kg)', _weightController,
                            Icons.monitor_weight),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  _buildTextField(
                      'Allergies (if any)', _allergiesController, Icons.warning,
                      maxLines: 2),
                  const SizedBox(height: 15),
                  _buildTextField('Medical History', _medicalHistoryController,
                      Icons.history,
                      maxLines: 4),
                ],
              ),

              const SizedBox(height: 20),

              // Additional Information
              _buildCard(
                'Additional Information',
                [
                  _buildCheckboxField('Has Insurance', false),
                  const SizedBox(height: 10),
                  _buildCheckboxField('Is Senior Citizen', false),
                  const SizedBox(height: 10),
                  _buildCheckboxField('Is Physically Challenged', false),
                  const SizedBox(height: 10),
                  _buildCheckboxField('Requires Wheelchair', false),
                ],
              ),

              const SizedBox(height: 30),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _registerPatient,
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
                          Icon(Icons.person_add, size: 18),
                          SizedBox(width: 8),
                          Text('Register Patient'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _registerAndCreateAppointment,
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
                          Icon(Icons.add, size: 18),
                          SizedBox(width: 8),
                          Text('Register & Create Appointment'),
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
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
            ),
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

  Widget _buildDropdown(String label, List<String> items, String selectedValue,
      ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF4A5568),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE2E8F0)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonFormField<String>(
            value: selectedValue,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
            items: items.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildCheckboxField(String label, bool value) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: (bool? newValue) {
            setState(() {});
          },
          activeColor: const Color(0xFF4299E1),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF4A5568),
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  void _registerPatient() {
    if (_formKey.currentState!.validate()) {
      // Here you would save to database
      final patientId =
          'P${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Patient $_fullNameController.text registered successfully (ID: $patientId)'),
          backgroundColor: const Color(0xFF48BB78),
        ),
      );

      // Return mock appointment data
      final appointment = {
        'patientName': _fullNameController.text,
        'patientId': patientId,
        'age': int.parse(_ageController.text),
        'gender': _selectedGender,
      };

      Navigator.pop(context, appointment);
    }
  }

  void _registerAndCreateAppointment() {
    if (_formKey.currentState!.validate()) {
      final patientId =
          'P${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Patient $_fullNameController.text registered. Creating appointment...'),
          backgroundColor: const Color(0xFF48BB78),
        ),
      );

      // Navigate to appointment screen with pre-filled data
      final patientData = {
        'patientName': _fullNameController.text,
        'patientId': patientId,
        'age': int.parse(_ageController.text),
        'gender': _selectedGender,
        'contactNumber': _contactController.text,
        'bloodGroup': _selectedBloodGroup,
      };

      Navigator.pop(context, patientData);
    }
  }
}
