// lib/screens/reception/new_appointment_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hms/models/appointment_model.dart'; // Add this import

class NewAppointmentScreen extends StatefulWidget {
  final void Function(Appointment)? onAppointmentAdded;

  const NewAppointmentScreen({
    super.key,
    this.onAppointmentAdded,
  });

  @override
  State<NewAppointmentScreen> createState() => _NewAppointmentScreenState();
}

class _NewAppointmentScreenState extends State<NewAppointmentScreen> {
  final _formKey = GlobalKey<FormState>();

  // Form controllers
  final TextEditingController _patientNameController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _existingPatientController =
      TextEditingController();

  // Selected values
  String? _selectedPatientType = 'new';
  String? _selectedDoctor;
  String? _selectedDepartment;
  String? _selectedAppointmentType = 'OPD';
  String? _selectedPriority = 'Normal';
  String? _selectedGender;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  // Lists for dropdowns
  final List<String> _departments = [
    'Cardiology',
    'Orthopedics',
    'Dermatology',
    'Neurology',
    'Pediatrics',
    'General Medicine',
    'Gynecology',
    'ENT',
    'Ophthalmology',
    'Dentistry',
  ];

  final Map<String, List<String>> _departmentDoctors = {
    'Cardiology': ['Dr. Sharma - Cardiology'],
    'Orthopedics': ['Dr. Patel - Orthopedics'],
    'Dermatology': ['Dr. Gupta - Dermatology'],
    'Neurology': ['Dr. Singh - Neurology'],
    'Pediatrics': ['Dr. Kumar - Pediatrics'],
    'General Medicine': ['Dr. Reddy - General Medicine'],
    'Gynecology': ['Dr. Mehta - Gynecology'],
    'ENT': ['Dr. Joshi - ENT'],
    'Ophthalmology': ['Dr. Nair - Ophthalmology'],
    'Dentistry': ['Dr. Kapoor - Dentistry'],
  };

  final List<String> _appointmentTypes = [
    'OPD',
    'Follow-up',
    'Emergency',
    'Consultation',
    'Procedure',
  ];

  final List<String> _priorities = [
    'Normal',
    'High',
    'Emergency',
  ];

  final List<String> _existingPatients = [
    'John Smith (ID: P1001)',
    'Sarah Johnson (ID: P1002)',
    'Michael Brown (ID: P1003)',
    'Emily Davis (ID: P1004)',
    'Robert Wilson (ID: P1005)',
  ];

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _selectedTime = TimeOfDay.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'New Appointment',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF4299E1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save, color: Colors.white),
            onPressed: _saveAppointment,
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
              // Header
              const Text(
                'Schedule New Appointment',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3748),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Fill in the details to create a new appointment',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF718096),
                ),
              ),
              const SizedBox(height: 30),

              // Patient Type Selection
              _buildSectionHeader('Patient Type'),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildPatientTypeCard(
                      'New Patient',
                      Icons.person_add,
                      const Color(0xFF4299E1),
                      'new',
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: _buildPatientTypeCard(
                      'Existing Patient',
                      Icons.person_outline,
                      const Color(0xFF48BB78),
                      'existing',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Patient Information
              _buildSectionHeader('Patient Information'),
              const SizedBox(height: 20),

              // Two Column Layout for Form
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth > 1000) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              if (_selectedPatientType == 'existing')
                                _buildExistingPatientSearch(),
                              if (_selectedPatientType == 'new') ...[
                                _buildFormField(
                                  controller: _patientNameController,
                                  label: 'Patient Name',
                                  hint: 'Enter full name',
                                  prefixIcon: Icons.person_outline,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter patient name';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 20),
                                _buildFormField(
                                  controller: _contactController,
                                  label: 'Contact Number',
                                  hint: 'Enter phone number',
                                  prefixIcon: Icons.phone,
                                  keyboardType: TextInputType.phone,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(10),
                                  ],
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter contact number';
                                    }
                                    if (value.length < 10) {
                                      return 'Enter valid 10-digit number';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 20),
                                _buildFormField(
                                  controller: _emailController,
                                  label: 'Email Address',
                                  hint: 'Enter email address',
                                  prefixIcon: Icons.email_outlined,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    if (value != null && value.isNotEmpty) {
                                      if (!RegExp(
                                              r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                          .hasMatch(value)) {
                                        return 'Enter valid email address';
                                      }
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 20),
                                _buildFormField(
                                  controller: _ageController,
                                  label: 'Age',
                                  hint: 'Enter age',
                                  prefixIcon: Icons.cake_outlined,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(3),
                                  ],
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter age';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(width: 30),
                        Expanded(
                          child: Column(
                            children: [
                              if (_selectedPatientType == 'new') ...[
                                _buildFormField(
                                  controller: _addressController,
                                  label: 'Address',
                                  hint: 'Enter full address',
                                  prefixIcon: Icons.location_on_outlined,
                                  maxLines: 3,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter address';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 20),

                                // Gender Selection
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Gender',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF2D3748),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: _buildGenderButton(
                                              'Male', 'male'),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: _buildGenderButton(
                                              'Female', 'female'),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: _buildGenderButton(
                                              'Other', 'other'),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Column(
                      children: [
                        if (_selectedPatientType == 'existing')
                          _buildExistingPatientSearch(),
                        if (_selectedPatientType == 'new') ...[
                          _buildFormField(
                            controller: _patientNameController,
                            label: 'Patient Name',
                            hint: 'Enter full name',
                            prefixIcon: Icons.person_outline,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter patient name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),

                          _buildFormField(
                            controller: _contactController,
                            label: 'Contact Number',
                            hint: 'Enter phone number',
                            prefixIcon: Icons.phone,
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10),
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter contact number';
                              }
                              if (value.length < 10) {
                                return 'Enter valid 10-digit number';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),

                          _buildFormField(
                            controller: _emailController,
                            label: 'Email Address',
                            hint: 'Enter email address',
                            prefixIcon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value != null && value.isNotEmpty) {
                                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                    .hasMatch(value)) {
                                  return 'Enter valid email address';
                                }
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),

                          _buildFormField(
                            controller: _ageController,
                            label: 'Age',
                            hint: 'Enter age',
                            prefixIcon: Icons.cake_outlined,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(3),
                            ],
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter age';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),

                          _buildFormField(
                            controller: _addressController,
                            label: 'Address',
                            hint: 'Enter full address',
                            prefixIcon: Icons.location_on_outlined,
                            maxLines: 3,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter address';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),

                          // Gender Selection
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Gender',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF2D3748),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildGenderButton('Male', 'male'),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child:
                                        _buildGenderButton('Female', 'female'),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: _buildGenderButton('Other', 'other'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ],
                    );
                  }
                },
              ),
              const SizedBox(height: 30),

              // Appointment Details
              _buildSectionHeader('Appointment Details'),
              const SizedBox(height: 20),

              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth > 800) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              // Department Dropdown
                              _buildDropdown(
                                label: 'Department',
                                value: _selectedDepartment,
                                items: _departments,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedDepartment = value;
                                    _selectedDoctor = null;
                                  });
                                },
                                hint: 'Select Department',
                                prefixIcon: Icons.business_outlined,
                              ),
                              const SizedBox(height: 20),

                              // Doctor Dropdown
                              _buildDropdown(
                                label: 'Doctor',
                                value: _selectedDoctor,
                                items: _selectedDepartment != null
                                    ? _departmentDoctors[_selectedDepartment] ??
                                        []
                                    : [],
                                onChanged: (value) {
                                  setState(() {
                                    _selectedDoctor = value;
                                  });
                                },
                                hint: 'Select Doctor',
                                prefixIcon: Icons.medical_services_outlined,
                                enabled: _selectedDepartment != null,
                              ),
                              const SizedBox(height: 20),

                              // Appointment Type
                              _buildDropdown(
                                label: 'Appointment Type',
                                value: _selectedAppointmentType,
                                items: _appointmentTypes,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedAppointmentType = value;
                                  });
                                },
                                hint: 'Select Type',
                                prefixIcon: Icons.calendar_today_outlined,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 30),
                        Expanded(
                          child: Column(
                            children: [
                              // Date Picker
                              _buildDateTimePicker(
                                label: 'Appointment Date',
                                value: _selectedDate != null
                                    ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                                    : 'Select Date',
                                icon: Icons.calendar_today_outlined,
                                onTap: () => _selectDate(context),
                              ),
                              const SizedBox(height: 20),

                              // Time Picker
                              _buildDateTimePicker(
                                label: 'Appointment Time',
                                value: _selectedTime != null
                                    ? _selectedTime!.format(context)
                                    : 'Select Time',
                                icon: Icons.access_time_outlined,
                                onTap: () => _selectTime(context),
                              ),
                              const SizedBox(height: 20),

                              // Priority
                              _buildDropdown(
                                label: 'Priority',
                                value: _selectedPriority,
                                items: _priorities,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedPriority = value;
                                  });
                                },
                                hint: 'Select Priority',
                                prefixIcon: Icons.priority_high_outlined,
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Column(
                      children: [
                        // Department Dropdown
                        _buildDropdown(
                          label: 'Department',
                          value: _selectedDepartment,
                          items: _departments,
                          onChanged: (value) {
                            setState(() {
                              _selectedDepartment = value;
                              _selectedDoctor = null;
                            });
                          },
                          hint: 'Select Department',
                          prefixIcon: Icons.business_outlined,
                        ),
                        const SizedBox(height: 20),

                        // Doctor Dropdown
                        _buildDropdown(
                          label: 'Doctor',
                          value: _selectedDoctor,
                          items: _selectedDepartment != null
                              ? _departmentDoctors[_selectedDepartment] ?? []
                              : [],
                          onChanged: (value) {
                            setState(() {
                              _selectedDoctor = value;
                            });
                          },
                          hint: 'Select Doctor',
                          prefixIcon: Icons.medical_services_outlined,
                          enabled: _selectedDepartment != null,
                        ),
                        const SizedBox(height: 20),

                        // Appointment Type
                        _buildDropdown(
                          label: 'Appointment Type',
                          value: _selectedAppointmentType,
                          items: _appointmentTypes,
                          onChanged: (value) {
                            setState(() {
                              _selectedAppointmentType = value;
                            });
                          },
                          hint: 'Select Type',
                          prefixIcon: Icons.calendar_today_outlined,
                        ),
                        const SizedBox(height: 20),

                        // Date Picker
                        _buildDateTimePicker(
                          label: 'Appointment Date',
                          value: _selectedDate != null
                              ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                              : 'Select Date',
                          icon: Icons.calendar_today_outlined,
                          onTap: () => _selectDate(context),
                        ),
                        const SizedBox(height: 20),

                        // Time Picker
                        _buildDateTimePicker(
                          label: 'Appointment Time',
                          value: _selectedTime != null
                              ? _selectedTime!.format(context)
                              : 'Select Time',
                          icon: Icons.access_time_outlined,
                          onTap: () => _selectTime(context),
                        ),
                        const SizedBox(height: 20),

                        // Priority
                        _buildDropdown(
                          label: 'Priority',
                          value: _selectedPriority,
                          items: _priorities,
                          onChanged: (value) {
                            setState(() {
                              _selectedPriority = value;
                            });
                          },
                          hint: 'Select Priority',
                          prefixIcon: Icons.priority_high_outlined,
                        ),
                      ],
                    );
                  }
                },
              ),
              const SizedBox(height: 30),

              // Additional Information
              _buildSectionHeader('Additional Information'),
              const SizedBox(height: 20),

              _buildFormField(
                controller: _reasonController,
                label: 'Reason for Visit',
                hint: 'Describe the reason for appointment',
                prefixIcon: Icons.note_add_outlined,
                maxLines: 3,
              ),
              const SizedBox(height: 20),

              _buildFormField(
                controller: _notesController,
                label: 'Additional Notes',
                hint: 'Any additional notes or instructions',
                prefixIcon: Icons.notes_outlined,
                maxLines: 3,
              ),
              const SizedBox(height: 40),

              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 12,
                      ),
                      side: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: Color(0xFF718096),
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  ElevatedButton(
                    onPressed: _saveAppointment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4299E1),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Schedule Appointment',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFF2D3748),
      ),
    );
  }

  Widget _buildPatientTypeCard(
      String title, IconData icon, Color color, String type) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPatientType = type;
          if (type == 'existing') {
            // Auto-fill with existing patient data
            _patientNameController.text = 'John Smith';
            _contactController.text = '9876543210';
            _emailController.text = 'john.smith@email.com';
            _ageController.text = '35';
            _addressController.text = '123 Main St, New York';
            _selectedGender = 'male';
          } else {
            // Clear form for new patient
            _patientNameController.clear();
            _contactController.clear();
            _emailController.clear();
            _ageController.clear();
            _addressController.clear();
            _selectedGender = null;
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: _selectedPatientType == type
              ? color.withValues(alpha: 0.1)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                _selectedPatientType == type ? color : const Color(0xFFE2E8F0),
            width: _selectedPatientType == type ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: _selectedPatientType == type
                  ? color
                  : const Color(0xFF718096),
              size: 32,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: _selectedPatientType == type
                    ? color
                    : const Color(0xFF2D3748),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    required String hint,
    IconData? prefixIcon,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF2D3748),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFFA0AEC0)),
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, color: const Color(0xFF718096))
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF4299E1)),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: maxLines > 1 ? 16 : 0,
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildGenderButton(String label, String value) {
    bool isSelected = _selectedGender == value;
    return OutlinedButton(
      onPressed: () {
        setState(() {
          _selectedGender = value;
        });
      },
      style: OutlinedButton.styleFrom(
        side: BorderSide(
          color: isSelected ? const Color(0xFF4299E1) : const Color(0xFFE2E8F0),
        ),
        backgroundColor: isSelected
            ? const Color(0xFF4299E1).withValues(alpha: 0.1)
            : Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? const Color(0xFF4299E1) : const Color(0xFF718096),
        ),
      ),
    );
  }

  Widget _buildExistingPatientSearch() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Search Existing Patient',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF2D3748),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 50,
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE2E8F0)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _existingPatientController,
                  decoration: const InputDecoration(
                    hintText: 'Search by name, ID, or contact...',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    hintStyle: TextStyle(color: Color(0xFFA0AEC0)),
                  ),
                  onChanged: (value) {
                    // Implement search functionality
                  },
                ),
              ),
              Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  color: Color(0xFFF7FAFC),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                ),
                child: const Icon(
                  Icons.search,
                  color: Color(0xFF718096),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        if (_existingPatientController.text.isEmpty)
          ..._existingPatients.map((patient) => ListTile(
                title: Text(patient),
                leading: const Icon(Icons.person_outline, size: 20),
                onTap: () {
                  _existingPatientController.text = patient;
                  // Auto-fill patient data based on selection
                  setState(() {
                    _patientNameController.text = patient.split(' (')[0];
                    _contactController.text = '9876543210';
                    _emailController.text =
                        '${patient.split(' (')[0].toLowerCase().replaceAll(' ', '.')}@email.com';
                    _ageController.text = '35';
                    _addressController.text = '123 Main St, New York';
                    _selectedGender = 'male';
                  });
                },
              )),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
    required String hint,
    required IconData prefixIcon,
    bool enabled = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF2D3748),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 50,
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE2E8F0)),
            borderRadius: BorderRadius.circular(8),
            color: enabled ? Colors.white : const Color(0xFFF7FAFC),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Icon(prefixIcon, color: const Color(0xFF718096)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: value,
                    items: items.map((item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Text(
                          item,
                          style: TextStyle(
                            fontSize: 14,
                            color: enabled
                                ? const Color(0xFF2D3748)
                                : const Color(0xFFA0AEC0),
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: enabled ? onChanged : null,
                    hint: Text(
                      hint,
                      style: const TextStyle(color: Color(0xFFA0AEC0)),
                    ),
                    isExpanded: true,
                    disabledHint: Text(
                      'Select department first',
                      style: const TextStyle(color: Color(0xFFA0AEC0)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDateTimePicker({
    required String label,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF2D3748),
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE2E8F0)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Icon(icon, color: const Color(0xFF718096)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    value,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Icon(
                    Icons.arrow_drop_down,
                    color: const Color(0xFF718096),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: const Color(0xFF4299E1),
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF4299E1),
            ),
            buttonTheme: const ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: const Color(0xFF4299E1),
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF4299E1),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _saveAppointment() {
    if (_formKey.currentState!.validate()) {
      // Validate required fields
      if (_selectedDepartment == null) {
        _showError('Please select a department');
        return;
      }

      if (_selectedDoctor == null) {
        _showError('Please select a doctor');
        return;
      }

      if (_selectedDate == null) {
        _showError('Please select appointment date');
        return;
      }

      if (_selectedTime == null) {
        _showError('Please select appointment time');
        return;
      }

      // Generate new appointment ID
      final newId = 'A${1000 + DateTime.now().millisecondsSinceEpoch ~/ 1000}';

      // Create new appointment
      final newAppointment = Appointment(
        id: newId,
        patientName: _patientNameController.text,
        doctor: _selectedDoctor!,
        department: _selectedDepartment!,
        date:
            '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}',
        time: _selectedTime!.format(context),
        type: _selectedAppointmentType ?? 'OPD',
        status: 'Scheduled',
        contact: _contactController.text,
        email: _emailController.text,
        age: _ageController.text,
        address: _addressController.text,
        gender: _selectedGender ?? 'Male',
        reason: _reasonController.text,
        notes: _notesController.text,
        priority: _selectedPriority ?? 'Normal',
      );

      // Show success message
      _showSuccessDialog(newAppointment);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFFF56565),
      ),
    );
  }

  void _showSuccessDialog(Appointment appointment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Color(0xFF48BB78)),
            SizedBox(width: 10),
            Text('Appointment Scheduled'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Appointment has been successfully scheduled!',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF2D3748),
                ),
              ),
              const SizedBox(height: 20),
              _buildAppointmentDetailRow(
                'Appointment ID',
                appointment.id,
              ),
              _buildAppointmentDetailRow(
                'Patient',
                appointment.patientName,
              ),
              _buildAppointmentDetailRow(
                'Doctor',
                appointment.doctor,
              ),
              _buildAppointmentDetailRow(
                'Date & Time',
                '${appointment.date} at ${appointment.time}',
              ),
              _buildAppointmentDetailRow(
                'Type',
                appointment.type,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Close',
              style: TextStyle(color: Color(0xFF718096)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Callback to add appointment to list
              widget.onAppointmentAdded?.call(appointment);

              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Return to appointments screen
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4299E1),
            ),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF718096),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Color(0xFF2D3748),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _patientNameController.dispose();
    _contactController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    _addressController.dispose();
    _reasonController.dispose();
    _notesController.dispose();
    _existingPatientController.dispose();
    super.dispose();
  }
}
