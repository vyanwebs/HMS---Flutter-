import 'package:flutter/material.dart';
import 'package:hms/models/ipd_patient_model.dart';

class PatientDischargeScreen extends StatefulWidget {
  final IPDPatient patient;

  const PatientDischargeScreen({super.key, required this.patient});

  @override
  State<PatientDischargeScreen> createState() => _PatientDischargeScreenState();
}

class _PatientDischargeScreenState extends State<PatientDischargeScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dischargeSummaryController =
      TextEditingController();
  final TextEditingController _finalDiagnosisController =
      TextEditingController();
  final TextEditingController _medicationsController = TextEditingController();
  final TextEditingController _followupInstructionsController =
      TextEditingController();

  DateTime _dischargeDate = DateTime.now();
  String _dischargeType = 'Regular Discharge';
  String _paymentStatus = 'Pending';
  bool _generateBill = true;

  List<String> dischargeTypes = [
    'Regular Discharge',
    'Against Medical Advice',
    'Transferred to Another Facility',
    'Expired',
  ];

  List<String> paymentStatuses = [
    'Pending',
    'Partial',
    'Completed',
    'Insurance'
  ];

  @override
  Widget build(BuildContext context) {
    final admissionDate = DateTime.parse(widget.patient.admissionDate);
    final stayDuration = _dischargeDate.difference(admissionDate).inDays;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Discharge Patient - ${widget.patient.name}',
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
            onPressed: _processDischarge,
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
              // Patient Summary Card
              _buildPatientSummaryCard(admissionDate, stayDuration),
              const SizedBox(height: 24),

              // Discharge Information
              _buildSectionHeader('Discharge Information'),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: _buildDateField(
                      'Discharge Date',
                      _dischargeDate,
                      Icons.calendar_today_outlined,
                      (date) {
                        setState(() {
                          _dischargeDate = date;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildDropdownField(
                      'Discharge Type',
                      _dischargeType,
                      dischargeTypes,
                      Icons.exit_to_app_outlined,
                      (value) {
                        setState(() {
                          _dischargeType = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              _buildDropdownField(
                'Payment Status',
                _paymentStatus,
                paymentStatuses,
                Icons.payment_outlined,
                (value) {
                  setState(() {
                    _paymentStatus = value!;
                  });
                },
              ),
              const SizedBox(height: 16),

              _buildTextField(
                'Final Diagnosis',
                _finalDiagnosisController,
                Icons.healing_outlined,
                maxLines: 2,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter final diagnosis';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              _buildTextField(
                'Discharge Summary',
                _dischargeSummaryController,
                Icons.description_outlined,
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter discharge summary';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              _buildTextField(
                'Medications at Discharge',
                _medicationsController,
                Icons.medication_outlined,
                maxLines: 3,
              ),
              const SizedBox(height: 16),

              _buildTextField(
                'Follow-up Instructions',
                _followupInstructionsController,
                Icons.notifications_outlined,
                maxLines: 3,
              ),
              const SizedBox(height: 16),

              // Bill Generation Toggle
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7FAFC),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.receipt_outlined,
                        color: Color(0xFFED8936)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Generate Bill',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2D3748),
                            ),
                          ),
                          Text(
                            _generateBill
                                ? 'Bill will be generated automatically'
                                : 'No bill will be generated',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF718096),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: _generateBill,
                      onChanged: (value) {
                        setState(() {
                          _generateBill = value;
                        });
                      },
                      activeColor: const Color(0xFF48BB78),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _processDischarge,
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
                          Icon(Icons.check_circle_outline,
                              size: 20, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            'Process Discharge',
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
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPatientSummaryCard(DateTime admissionDate, int stayDuration) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
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
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.patient.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    _buildInfoChip(
                        'ID: ${widget.patient.id}', Icons.badge_outlined),
                    _buildInfoChip('Ward: ${widget.patient.ward}',
                        Icons.medical_services_outlined),
                    _buildInfoChip(
                        'Bed: ${widget.patient.bedNo}', Icons.bed_outlined),
                    _buildInfoChip('Doctor: ${widget.patient.doctor}',
                        Icons.person_outline),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildStatCard(
                      'Stay Duration',
                      '$stayDuration days',
                      Icons.calendar_today_outlined,
                      const Color(0xFF4299E1),
                    ),
                    const SizedBox(width: 16),
                    _buildStatCard(
                      'Admission Date',
                      widget.patient.admissionDate,
                      Icons.date_range_outlined,
                      const Color(0xFF48BB78),
                    ),
                    const SizedBox(width: 16),
                    _buildStatCard(
                      'Current Status',
                      widget.patient.status,
                      Icons.health_and_safety_outlined,
                      widget.patient.status == 'Critical'
                          ? const Color(0xFFF56565)
                          : const Color(0xFFED8936),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FAFC),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: const Color(0xFF718096)),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF4A5568),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xFF718096),
                    ),
                  ),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF48BB78).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: Color(0xFF48BB78), size: 20),
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
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
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

  void _processDischarge() {
    if (_formKey.currentState!.validate()) {
      final dischargedPatient = widget.patient.copyWith(
        dischargeDate: _dischargeDate.toIso8601String().split('T')[0],
        status: 'Discharged',
      );

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Discharge Confirmation'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle_outline,
                size: 60,
                color: Color(0xFF48BB78),
              ),
              const SizedBox(height: 20),
              Text(
                'Discharge ${widget.patient.name}?',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2D3748),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Patient will be discharged from ${widget.patient.ward} - ${widget.patient.bedNo}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF718096),
                ),
              ),
              if (_generateBill) ...[
                const SizedBox(height: 10),
                const Text(
                  'A bill will be generated automatically',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFFED8936),
                  ),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Color(0xFF718096)),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(
                    context, dischargedPatient); // Return to IPD screen
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF48BB78),
              ),
              child: const Text('Confirm Discharge'),
            ),
          ],
        ),
      );
    }
  }
}
