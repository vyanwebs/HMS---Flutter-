import 'package:flutter/material.dart';
import 'package:hms/models/opd_appointment_model.dart';

class NewOPDAppointmentScreen extends StatefulWidget {
  final OPDAppointment? appointmentToEdit;

  const NewOPDAppointmentScreen({super.key, this.appointmentToEdit});

  @override
  State<NewOPDAppointmentScreen> createState() => _NewOPDAppointmentScreenState();
}

class _NewOPDAppointmentScreenState extends State<NewOPDAppointmentScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final TextEditingController _patientNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  String _selectedGender = 'Male';
  String _selectedDoctor = 'Dr. Sharma';
  String _selectedDepartment = 'Cardiology';
  String _selectedAppointmentType = 'New';
  String _selectedStatus = 'Confirmed';
  
  List<String> doctors = ['Dr. Sharma', 'Dr. Patel', 'Dr. Gupta', 'Dr. Singh', 'Dr. Kapoor'];
  List<String> departments = ['Cardiology', 'Orthopedics', 'Dermatology', 'Neurology', 'Pediatrics'];
  List<String> appointmentTypes = ['New', 'Follow-up', 'Consultation', 'Emergency'];
  List<String> statusList = ['Confirmed', 'Waiting', 'Completed', 'Cancelled'];

  @override
  void initState() {
    super.initState();
    if (widget.appointmentToEdit != null) {
      _loadAppointmentData();
    } else {
      _dateController.text = '2024-01-16';
      _timeController.text = '10:00 AM';
    }
  }

  void _loadAppointmentData() {
    final appointment = widget.appointmentToEdit!;
    _patientNameController.text = appointment.patientName;
    _ageController.text = appointment.age.toString();
    _contactController.text = appointment.contactNumber;
    _reasonController.text = appointment.reason;
    _selectedGender = appointment.gender;
    _selectedDoctor = appointment.doctor;
    _selectedDepartment = appointment.department;
    _selectedAppointmentType = appointment.appointmentType;
    _selectedStatus = appointment.status;
    _dateController.text = appointment.date;
    _timeController.text = appointment.time;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.appointmentToEdit != null 
            ? 'Edit Appointment' 
            : 'New OPD Appointment',
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
            icon: const Icon(Icons.save, color: Color(0xFF48BB78)),
            onPressed: _saveAppointment,
            tooltip: 'Save Appointment',
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
              // Patient Information Card
              _buildCard(
                'Patient Information',
                [
                  _buildTextField('Patient Name', _patientNameController, Icons.person, required: true),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField('Age', _ageController, Icons.cake, required: true),
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
                  _buildTextField('Contact Number', _contactController, Icons.phone, required: true),
                ],
              ),

              const SizedBox(height: 20),

              // Appointment Details Card
              _buildCard(
                'Appointment Details',
                [
                  _buildDropdown(
                    'Select Department',
                    departments,
                    _selectedDepartment,
                    (value) => setState(() {
                      _selectedDepartment = value!;
                      // Update doctor list based on department
                      if (_selectedDepartment == 'Cardiology') {
                        _selectedDoctor = 'Dr. Sharma';
                      } else if (_selectedDepartment == 'Orthopedics') {
                        _selectedDoctor = 'Dr. Patel';
                      } else if (_selectedDepartment == 'Dermatology') {
                        _selectedDoctor = 'Dr. Gupta';
                      } else if (_selectedDepartment == 'Neurology') {
                        _selectedDoctor = 'Dr. Singh';
                      } else if (_selectedDepartment == 'Pediatrics') {
                        _selectedDoctor = 'Dr. Kapoor';
                      }
                    }),
                  ),
                  const SizedBox(height: 15),
                  _buildDropdown(
                    'Select Doctor',
                    doctors.where((doctor) {
                      if (_selectedDepartment == 'Cardiology') return doctor == 'Dr. Sharma';
                      if (_selectedDepartment == 'Orthopedics') return doctor == 'Dr. Patel';
                      if (_selectedDepartment == 'Dermatology') return doctor == 'Dr. Gupta';
                      if (_selectedDepartment == 'Neurology') return doctor == 'Dr. Singh';
                      if (_selectedDepartment == 'Pediatrics') return doctor == 'Dr. Kapoor';
                      return true;
                    }).toList(),
                    _selectedDoctor,
                    (value) => setState(() => _selectedDoctor = value!),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField('Date', _dateController, Icons.calendar_today, readOnly: true, onTap: () => _selectDate(context)),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: _buildTextField('Time', _timeController, Icons.access_time, readOnly: true, onTap: () => _selectTime(context)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  _buildDropdown(
                    'Appointment Type',
                    appointmentTypes,
                    _selectedAppointmentType,
                    (value) => setState(() => _selectedAppointmentType = value!),
                  ),
                  const SizedBox(height: 15),
                  _buildDropdown(
                    'Status',
                    statusList,
                    _selectedStatus,
                    (value) => setState(() => _selectedStatus = value!),
                  ),
                  const SizedBox(height: 15),
                  _buildTextField('Reason for Visit', _reasonController, Icons.medical_services, maxLines: 3),
                ],
              ),

              const SizedBox(height: 30),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saveAppointment,
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
                          Text('Save Appointment'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
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
                      child: const Text('Cancel'),
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

  Widget _buildTextField(String label, TextEditingController controller, IconData icon, {
    bool required = false,
    bool readOnly = false,
    int maxLines = 1,
    VoidCallback? onTap,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      maxLines: maxLines,
      onTap: onTap,
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
      validator: required ? (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      } : null,
    );
  }

  Widget _buildDropdown(String label, List<String> items, String selectedValue, 
      ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label *',
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
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
            items: items.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: onChanged,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select $label';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2024, 12, 31),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _timeController.text = picked.format(context);
      });
    }
  }

  void _saveAppointment() {
    if (_formKey.currentState!.validate()) {
      final appointment = OPDAppointment(
        id: widget.appointmentToEdit?.id ?? 'A${1000 + appointments.length}',
        patientName: _patientNameController.text,
        age: int.parse(_ageController.text),
        gender: _selectedGender,
        doctor: _selectedDoctor,
        department: _selectedDepartment,
        time: _timeController.text,
        date: _dateController.text,
        status: _selectedStatus,
        contactNumber: _contactController.text,
        appointmentType: _selectedAppointmentType,
        reason: _reasonController.text,
      );
      
      Navigator.pop(context, appointment);
    }
  }

  // Mock appointments list for ID generation
  List<OPDAppointment> get appointments => [
    OPDAppointment(
      id: 'A1001',
      patientName: 'John Smith',
      age: 45,
      gender: 'Male',
      doctor: 'Dr. Sharma',
      department: 'Cardiology',
      time: '10:00 AM',
      date: '2024-01-16',
      status: 'Confirmed',
      contactNumber: '+1-555-0101',
      appointmentType: 'New',
      reason: 'Chest Pain',
    ),
  ];
}