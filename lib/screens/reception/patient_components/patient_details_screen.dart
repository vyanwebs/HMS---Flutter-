import 'package:flutter/material.dart';
import 'package:hms/models/ipd_patient_model.dart';
import 'package:hms/screens/reception/patient_components/patient_admission_screen.dart';

class PatientDetailsScreen extends StatelessWidget {
  final IPDPatient patient;

  const PatientDetailsScreen({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Patient Details - ${patient.id}',
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
            icon: const Icon(Icons.edit, color: Color(0xFF4299E1)),
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PatientAdmissionScreen(
                    patientToEdit: patient,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Patient Header Card
            _buildPatientHeaderCard(),
            const SizedBox(height: 24),

            // Patient Information
            _buildSection('Patient Information', [
              _buildInfoRow('Patient ID', patient.id),
              _buildInfoRow('Name', patient.name),
              _buildInfoRow('Age', '${patient.age} years'),
              _buildInfoRow('Gender', patient.gender),
              if (patient.contactNumber != null)
                _buildInfoRow('Contact', patient.contactNumber!),
              if (patient.address != null)
                _buildInfoRow('Address', patient.address!),
              if (patient.emergencyContact != null)
                _buildInfoRow('Emergency Contact', patient.emergencyContact!),
            ]),

            const SizedBox(height: 24),

            // Medical Information
            _buildSection('Medical Information', [
              _buildInfoRow('Ward', patient.ward),
              _buildInfoRow('Bed No.', patient.bedNo),
              _buildInfoRow('Admission Date', patient.admissionDate),
              _buildInfoRow('Doctor', patient.doctor),
              _buildInfoRow('Status', patient.status),
              if (patient.diagnosis != null)
                _buildInfoRow('Diagnosis', patient.diagnosis!),
            ]),

            const SizedBox(height: 24),

            // Insurance Information
            if (patient.insuranceProvider != null ||
                patient.insurancePolicyNo != null)
              _buildSection('Insurance Information', [
                if (patient.insuranceProvider != null)
                  _buildInfoRow('Provider', patient.insuranceProvider!),
                if (patient.insurancePolicyNo != null)
                  _buildInfoRow('Policy No.', patient.insurancePolicyNo!),
              ]),

            const SizedBox(height: 24),

            // Medications
            if (patient.medications != null && patient.medications!.isNotEmpty)
              _buildSection('Current Medications', [
                ...patient.medications!
                    .map((med) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF4299E1),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  med,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF4A5568),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ))
                    .toList(),
              ]),

            const SizedBox(height: 24),

            // Lab Reports
            if (patient.labReports != null && patient.labReports!.isNotEmpty)
              _buildSection('Lab Reports', [
                ...patient.labReports!
                    .map((report) => _buildLabReportCard(report))
                    .toList(),
              ]),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientHeaderCard() {
    Color statusColor;
    switch (patient.status) {
      case 'Critical':
        statusColor = const Color(0xFFF56565);
        break;
      case 'Stable':
        statusColor = const Color(0xFF48BB78);
        break;
      case 'Improving':
        statusColor = const Color(0xFFED8936);
        break;
      default:
        statusColor = const Color(0xFF4299E1);
    }

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
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFF4299E1).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person,
              size: 40,
              color: Color(0xFF4299E1),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  patient.name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildInfoChip('ID: ${patient.id}', Icons.badge_outlined),
                    const SizedBox(width: 12),
                    _buildInfoChip('${patient.age} years', Icons.cake_outlined),
                    const SizedBox(width: 12),
                    _buildInfoChip(patient.gender, Icons.transgender_outlined),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: statusColor.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: statusColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        patient.status,
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              const Icon(
                Icons.bed_outlined,
                size: 30,
                color: Color(0xFF4299E1),
              ),
              const SizedBox(height: 4),
              Text(
                patient.bedNo,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3748),
                ),
              ),
              Text(
                patient.ward,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF718096),
                ),
              ),
            ],
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

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3748),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF718096),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF2D3748),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabReportCard(String report) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
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
              Icons.description_outlined,
              color: Color(0xFF48BB78),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  report,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Uploaded: 2024-01-15',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF718096),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.visibility_outlined,
              color: Color(0xFF4299E1),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.download_outlined,
              color: Color(0xFF48BB78),
            ),
          ),
        ],
      ),
    );
  }
}
