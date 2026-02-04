import 'package:flutter/material.dart';

class DoctorProfile extends StatelessWidget {
  const DoctorProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _profileHeader(),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _personalInfo()),
                const SizedBox(width: 16),
                Expanded(child: _professionalInfo()),
              ],
            ),
            const SizedBox(height: 16),
            _scheduleCard(),
          ],
        ),
      ),
    );
  }

  // ===================== HEADER =====================

  Widget _profileHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 36,
            backgroundColor: Color(0xFFE5E7EB),
            child: Icon(Icons.person, size: 40, color: Colors.black54),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dr. Sarah Williams',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 4),
                Text('Cardiologist • MBBS, MD'),
                SizedBox(height: 4),
                Text(
                  '10+ Years Experience',
                  style: TextStyle(color: Colors.black54),
                ),
              ],
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            icon: const Icon(Icons.edit, size: 16),
            label: const Text('Edit Profile'),
          ),
        ],
      ),
    );
  }

  // ===================== PERSONAL =====================

  Widget _personalInfo() {
    return _infoCard(
      title: 'Personal Information',
      items: const {
        'Gender': 'Female',
        'Date of Birth': '12 Aug 1985',
        'Phone': '+91 98765 43210',
        'Email': 'sarah.williams@hospital.com',
        'Address': 'New Delhi, India',
      },
    );
  }

  // ===================== PROFESSIONAL =====================

  Widget _professionalInfo() {
    return _infoCard(
      title: 'Professional Information',
      items: const {
        'Department': 'Cardiology',
        'Designation': 'Senior Consultant',
        'License No': 'MED-458921',
        'Hospital': 'City Care Hospital',
        'Status': 'Active',
      },
      badgeColor: const Color(0xFFDCFCE7),
      badgeTextColor: const Color(0xFF16A34A),
    );
  }

  // ===================== SCHEDULE =====================

  Widget _scheduleCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Weekly Schedule',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          _scheduleRow('Monday - Friday', '10:00 AM - 4:00 PM'),
          _scheduleRow('Saturday', '10:00 AM - 1:00 PM'),
          _scheduleRow('Sunday', 'Off'),
        ],
      ),
    );
  }

  Widget _scheduleRow(String day, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(child: Text(day)),
          Text(
            time,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  // ===================== SHARED =====================

  Widget _infoCard({
    required String title,
    required Map<String, String> items,
    Color badgeColor = const Color(0xFFEFF6FF),
    Color badgeTextColor = const Color(0xFF2563EB),
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          ...items.entries.map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      e.key,
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: badgeColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      e.value,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: badgeTextColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: const Color(0xFFE2E8F0)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}
