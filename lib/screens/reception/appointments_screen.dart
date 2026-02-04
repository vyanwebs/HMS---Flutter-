import 'package:flutter/material.dart';
import 'package:hms/models/appointment_model.dart';  // Add this import
import 'new_appointment_screen.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override 
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  String _selectedFilter = 'Today';
  String _selectedStatus = 'All';
  String _searchQuery = '';
  String? _selectedGender;
  TextEditingController _reminderMessageController = TextEditingController();

  final List<Appointment> appointments = [
    Appointment(
      id: 'A1001',
      patientName: 'John Smith',
      doctor: 'Dr. Sharma',
      department: 'Cardiology',
      date: '2024-01-16',
      time: '10:00 AM',
      type: 'OPD',
      status: 'Confirmed',
      contact: '+91 9876543210',
      email: 'john.smith@email.com',
      age: '35',
      address: '123 Main St, New York',
      gender: 'Male',
      reason: 'Chest pain',
      notes: 'Regular checkup',
      priority: 'Normal',
    ),
    Appointment(
      id: 'A1002',
      patientName: 'Sarah Johnson',
      doctor: 'Dr. Patel',
      department: 'Orthopedics',
      date: '2024-01-16',
      time: '11:30 AM',
      type: 'OPD',
      status: 'Waiting',
      contact: '+91 8765432109',
      email: 'sarah.j@email.com',
      age: '42',
      address: '456 Oak Ave, Boston',
      gender: 'Female',
      reason: 'Knee pain',
      notes: 'Follow up',
      priority: 'Normal',
    ),
    Appointment(
      id: 'A1003',
      patientName: 'Michael Brown',
      doctor: 'Dr. Gupta',
      department: 'Dermatology',
      date: '2024-01-16',
      time: '02:00 PM',
      type: 'Follow-up',
      status: 'Confirmed',
      contact: '+91 7654321098',
      email: 'michael.b@email.com',
      age: '28',
      address: '789 Pine Rd, Chicago',
      gender: 'Male',
      reason: 'Skin allergy',
      notes: 'Prescription refill',
      priority: 'Normal',
    ),
    Appointment(
      id: 'A1004',
      patientName: 'Emily Davis',
      doctor: 'Dr. Singh',
      department: 'Neurology',
      date: '2024-01-16',
      time: '03:30 PM',
      type: 'OPD',
      status: 'Cancelled',
      contact: '+91 6543210987',
      email: 'emily.d@email.com',
      age: '55',
      address: '321 Elm St, Seattle',
      gender: 'Female',
      reason: 'Headache',
      notes: 'MRI scheduled',
      priority: 'High',
    ),
    Appointment(
      id: 'A1005',
      patientName: 'Robert Wilson',
      doctor: 'Dr. Kumar',
      department: 'Pediatrics',
      date: '2024-01-17',
      time: '09:00 AM',
      type: 'OPD',
      status: 'Scheduled',
      contact: '+91 5432109876',
      email: 'robert.w@email.com',
      age: '8',
      address: '654 Maple Dr, Miami',
      gender: 'Male',
      reason: 'Fever',
      notes: 'Child patient',
      priority: 'Emergency',
    ),
    Appointment(
      id: 'A1006',
      patientName: 'Lisa Anderson',
      doctor: 'Dr. Reddy',
      department: 'General Medicine',
      date: '2024-01-17',
      time: '10:30 AM',
      type: 'OPD',
      status: 'Confirmed',
      contact: '+91 4321098765',
      email: 'lisa.a@email.com',
      age: '30',
      address: '987 Cedar Ln, Austin',
      gender: 'Female',
      reason: 'General checkup',
      notes: 'Annual physical',
      priority: 'Normal',
    ),
    Appointment(
      id: 'A1007',
      patientName: 'David Miller',
      doctor: 'Dr. Mehta',
      department: 'Gynecology',
      date: '2024-01-17',
      time: '01:00 PM',
      type: 'Consultation',
      status: 'Waiting',
      contact: '+91 3210987654',
      email: 'david.m@email.com',
      age: '45',
      address: '147 Birch St, Denver',
      gender: 'Male',
      reason: 'Spouse consultation',
      notes: 'Accompanying patient',
      priority: 'Normal',
    ),
    Appointment(
      id: 'A1008',
      patientName: 'Emma Thompson',
      doctor: 'Dr. Joshi',
      department: 'ENT',
      date: '2024-01-18',
      time: '11:00 AM',
      type: 'OPD',
      status: 'Scheduled',
      contact: '+91 2109876543',
      email: 'emma.t@email.com',
      age: '25',
      address: '258 Walnut Ave, Phoenix',
      gender: 'Female',
      reason: 'Ear infection',
      notes: 'Recurring issue',
      priority: 'High',
    ),
  ];

  List<Appointment> get filteredAppointments {
    List<Appointment> filtered = List.from(appointments);

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((appointment) {
        return appointment.patientName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
               appointment.doctor.toLowerCase().contains(_searchQuery.toLowerCase()) ||
               appointment.id.toLowerCase().contains(_searchQuery.toLowerCase()) ||
               appointment.contact.contains(_searchQuery);
      }).toList();
    }

    // Apply status filter
    if (_selectedStatus != 'All') {
      filtered = filtered.where((appointment) {
        return appointment.status == _selectedStatus;
      }).toList();
    }

    // Apply date filter
    if (_selectedFilter == 'Today') {
      filtered = filtered.where((appointment) {
        return appointment.date == '2024-01-16';
      }).toList();
    } else if (_selectedFilter == 'This Week') {
      // Filter for this week's appointments
      filtered = filtered.where((appointment) {
        return ['2024-01-16', '2024-01-17', '2024-01-18'].contains(appointment.date);
      }).toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // In the Row widget with main title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Appointments Management',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3748),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewAppointmentScreen(
                        onAppointmentAdded: (newAppointment) {
                          setState(() {
                            appointments.add(newAppointment);
                          });
                        },
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4299E1),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('New Appointment'),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Stats Cards
          Row(
            children: [
              _buildAppointmentStatCard('Today\'s Appointments', '24',
                  Icons.calendar_today, const Color(0xFF4299E1)),
              const SizedBox(width: 20),
              _buildAppointmentStatCard('Pending Confirmation', '8',
                  Icons.pending, const Color(0xFFED8936)),
              const SizedBox(width: 20),
              _buildAppointmentStatCard('Completed Today', '16',
                  Icons.check_circle, const Color(0xFF48BB78)),
              const SizedBox(width: 20),
              _buildAppointmentStatCard(
                  'Cancelled', '3', Icons.cancel, const Color(0xFFF56565)),
            ],
          ),

          const SizedBox(height: 30),

          // Filters
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFF7FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              children: [
                // Date Filter
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Date Filter',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF718096),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedFilter,
                          items: ['Today', 'This Week', 'This Month', 'All']
                              .map((filter) => DropdownMenuItem(
                                    value: filter,
                                    child: Text(filter),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedFilter = value!;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 20),

                // Status Filter
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Status',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF718096),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedStatus,
                          items: [
                            'All',
                            'Confirmed',
                            'Waiting',
                            'Scheduled',
                            'Cancelled'
                          ]
                              .map((status) => DropdownMenuItem(
                                    value: status,
                                    child: Text(status),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedStatus = value!;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 20),

                // Search Bar
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Search',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF718096),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 12),
                            const Icon(Icons.search,
                                color: Color(0xFF718096), size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                decoration: const InputDecoration(
                                  hintText: 'Search by patient or doctor...',
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(
                                    color: Color(0xFFA0AEC0),
                                    fontSize: 14,
                                  ),
                                ),
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF2D3748),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _searchQuery = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // Appointments List
          const Text(
            'Appointments List',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 20),

          Container(
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE2E8F0)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                // Table Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF7FAFC),
                    border:
                        Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
                  ),
                  child: const Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Appointment ID',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2D3748),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Patient',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2D3748),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Doctor',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2D3748),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Date & Time',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2D3748),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Type',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2D3748),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Status',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2D3748),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Actions',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2D3748),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Table Rows
                ...filteredAppointments.map((appointment) => Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: const Color(0xFFE2E8F0)),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              appointment.id,
                              style: const TextStyle(
                                color: Color(0xFF4299E1),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  appointment.patientName,
                                  style: const TextStyle(
                                    color: Color(0xFF2D3748),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  appointment.contact,
                                  style: const TextStyle(
                                    color: Color(0xFF718096),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  appointment.doctor,
                                  style: const TextStyle(
                                    color: Color(0xFF4299E1),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  appointment.department,
                                  style: const TextStyle(
                                    color: Color(0xFF718096),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  appointment.date,
                                  style: const TextStyle(
                                    color: Color(0xFF2D3748),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  appointment.time,
                                  style: const TextStyle(
                                    color: Color(0xFF718096),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: appointment.type == 'OPD'
                                    ? const Color(0xFF4299E1).withValues(alpha: 0.1)
                                    : appointment.type == 'Follow-up'
                                    ? const Color(0xFF48BB78).withValues(alpha: 0.1)
                                    : const Color(0xFFED8936).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                appointment.type,
                                style: TextStyle(
                                  color: appointment.type == 'OPD'
                                      ? const Color(0xFF4299E1)
                                      : appointment.type == 'Follow-up'
                                      ? const Color(0xFF48BB78)
                                      : const Color(0xFFED8936),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: appointment.status == 'Confirmed'
                                    ? const Color(0xFF48BB78).withValues(alpha: 0.1)
                                    : appointment.status == 'Waiting'
                                        ? const Color(0xFFED8936)
                                            .withValues(alpha: 0.1)
                                        : appointment.status == 'Scheduled'
                                            ? const Color(0xFF4299E1)
                                                .withValues(alpha: 0.1)
                                            : const Color(0xFFF56565)
                                                .withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                appointment.status,
                                style: TextStyle(
                                  color: appointment.status == 'Confirmed'
                                      ? const Color(0xFF48BB78)
                                      : appointment.status == 'Waiting'
                                          ? const Color(0xFFED8936)
                                          : appointment.status == 'Scheduled'
                                              ? const Color(0xFF4299E1)
                                              : const Color(0xFFF56565),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () => _showViewDialog(appointment),
                                  icon: const Icon(Icons.visibility_outlined,
                                      size: 18, color: Color(0xFF4299E1)),
                                ),
                                IconButton(
                                  onPressed: () => _showEditDialog(appointment),
                                  icon: const Icon(Icons.edit_outlined,
                                      size: 18, color: Color(0xFF48BB78)),
                                ),
                                IconButton(
                                  onPressed: () => _showNotificationDialog(appointment),
                                  icon: const Icon(Icons.notifications_outlined,
                                      size: 18, color: Color(0xFFED8936)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // Calendar View
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Calendar View',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D3748),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Calendar Header
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7FAFC),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.chevron_left, color: Color(0xFF718096)),
                            Text(
                              'January 2024',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2D3748),
                              ),
                            ),
                            Icon(Icons.chevron_right, color: Color(0xFF718096)),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Days of Week
                      const Row(
                        children: [
                          Expanded(
                            child: Center(
                              child: Text(
                                'Sun',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF718096),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                'Mon',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF718096),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                'Tue',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF718096),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                'Wed',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF718096),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                'Thu',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF718096),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                'Fri',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF718096),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                'Sat',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF718096),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // Calendar Grid
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 7,
                          childAspectRatio: 1,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                        ),
                        itemCount: 42, // 6 weeks
                        itemBuilder: (context, index) {
                          final day = index - 1; // Adjust for start day
                          final isCurrentMonth = day >= 1 && day <= 31;
                          final isToday = day == 16;

                          return Container(
                            decoration: BoxDecoration(
                              color: isToday
                                  ? const Color(0xFF4299E1)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: isToday
                                    ? const Color(0xFF4299E1)
                                    : const Color(0xFFE2E8F0),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                isCurrentMonth ? '$day' : '',
                                style: TextStyle(
                                  color: isToday
                                      ? Colors.white
                                      : const Color(0xFF2D3748),
                                  fontWeight: isToday
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 30),

              // Upcoming Appointments & Quick Actions
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Upcoming Appointments',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Column(
                        children: [
                          _buildUpcomingAppointment(
                            'Dr. Sharma',
                            'Cardiology',
                            '10:00 AM',
                            'John Smith',
                            const Color(0xFF4299E1),
                          ),
                          const SizedBox(height: 15),
                          _buildUpcomingAppointment(
                            'Dr. Patel',
                            'Orthopedics',
                            '11:30 AM',
                            'Sarah Johnson',
                            const Color(0xFF48BB78),
                          ),
                          const SizedBox(height: 15),
                          _buildUpcomingAppointment(
                            'Dr. Gupta',
                            'Dermatology',
                            '02:00 PM',
                            'Michael Brown',
                            const Color(0xFFED8936),
                          ),
                          const SizedBox(height: 15),
                          _buildUpcomingAppointment(
                            'Dr. Singh',
                            'Neurology',
                            '03:30 PM',
                            'Emily Davis',
                            const Color(0xFF9F7AEA),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Quick Actions',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    const SizedBox(height: 20),
                    GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      childAspectRatio: 1.5,
                      children: [
                        _buildQuickActionCard(
                          'Send Reminder',
                          Icons.notifications,
                          const Color(0xFF4299E1),
                              () => _showQuickActionDialog('Send Reminder'),
                        ),
                        _buildQuickActionCard(
                          'Reschedule',
                          Icons.schedule,
                          const Color(0xFF48BB78),
                              () => _showQuickActionDialog('Reschedule'),
                        ),
                        _buildQuickActionCard(
                          'Cancel Appointment',
                          Icons.cancel,
                          const Color(0xFFF56565),
                              () => _showQuickActionDialog('Cancel Appointment'),
                        ),
                        _buildQuickActionCard(
                          'Print Schedule',
                          Icons.print,
                          const Color(0xFFED8936),
                              () => _showQuickActionDialog('Print Schedule'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentStatCard(
      String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 15),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF718096),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingAppointment(String doctor, String department,
      String time, String patient, Color color) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.person, color: color, size: 20),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doctor,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2D3748),
                  ),
                ),
                Text(
                  department,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF718096),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$time • $patient',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFFA0AEC0),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF48BB78).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Confirmed',
              style: TextStyle(
                color: Color(0xFF48BB78),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2D3748),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // View Dialog
  void _showViewDialog(Appointment appointment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.visibility, color: Color(0xFF4299E1)),
            const SizedBox(width: 10),
            Text(
              'Appointment Details',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF2D3748),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Appointment ID:', appointment.id),
              _buildDetailRow('Patient Name:', appointment.patientName),
              _buildDetailRow('Contact:', appointment.contact),
              _buildDetailRow('Email:', appointment.email),
              _buildDetailRow('Age:', appointment.age),
              _buildDetailRow('Gender:', appointment.gender),
              _buildDetailRow('Address:', appointment.address),
              _buildDetailRow('Doctor:', appointment.doctor),
              _buildDetailRow('Department:', appointment.department),
              _buildDetailRow('Date:', appointment.date),
              _buildDetailRow('Time:', appointment.time),
              _buildDetailRow('Type:', appointment.type),
              _buildDetailRow('Status:', appointment.status),
              _buildDetailRow('Priority:', appointment.priority),
              _buildDetailRow('Reason:', appointment.reason),
              _buildDetailRow('Notes:', appointment.notes),
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
              Navigator.pop(context);
              _showEditDialog(appointment);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4299E1),
            ),
            child: const Text('Edit'),
          ),
        ],
      ),
    );
  }

  // Edit Dialog
  void _showEditDialog(Appointment appointment) {
    final TextEditingController patientNameController = TextEditingController(text: appointment.patientName);
    final TextEditingController dateController = TextEditingController(text: appointment.date);
    final TextEditingController timeController = TextEditingController(text: appointment.time);
    String? selectedStatus = appointment.status;
    String? selectedType = appointment.type;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Row(
              children: [
                const Icon(Icons.edit, color: Color(0xFF48BB78)),
                const SizedBox(width: 10),
                Text(
                  'Edit Appointment',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2D3748),
                  ),
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildEditField('Patient Name', patientNameController),
                  const SizedBox(height: 15),
                  
                  // Date Picker
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Date',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF2D3748),
                        ),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(const Duration(days: 365)),
                          );
                          if (picked != null) {
                            setState(() {
                              dateController.text = '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
                            });
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_today, size: 20, color: Color(0xFF718096)),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  dateController.text,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 15),
                  
                  // Time Picker
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Time',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF2D3748),
                        ),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () async {
                          final TimeOfDay? picked = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (picked != null) {
                            setState(() {
                              timeController.text = picked.format(context);
                            });
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.access_time, size: 20, color: Color(0xFF718096)),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  timeController.text,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 15),
                  
                  // Status Dropdown
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Status',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF2D3748),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedStatus,
                            items: ['Confirmed', 'Waiting', 'Scheduled', 'Cancelled']
                                .map((status) => DropdownMenuItem(
                                      value: status,
                                      child: Text(status),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedStatus = value;
                              });
                            },
                            isExpanded: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 15),
                  
                  // Type Dropdown
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Type',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF2D3748),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedType,
                            items: ['OPD', 'Follow-up', 'Consultation', 'Procedure']
                                .map((type) => DropdownMenuItem(
                                      value: type,
                                      child: Text(type),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedType = value;
                              });
                            },
                            isExpanded: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
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
                  // Update appointment using copyWith
                  final index = appointments.indexWhere((a) => a.id == appointment.id);
                  if (index != -1) {
                    setState(() {
                      appointments[index] = appointment.copyWith(
                        patientName: patientNameController.text,
                        date: dateController.text,
                        time: timeController.text,
                        type: selectedType ?? appointment.type,
                        status: selectedStatus ?? appointment.status,
                      );
                    });
                    
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Appointment ${appointment.id} updated successfully'),
                        backgroundColor: const Color(0xFF48BB78),
                      ),
                    );
                  }
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF48BB78),
                ),
                child: const Text('Save Changes'),
              ),
            ],
          );
        },
      ),
    );
  }

  // Notification Dialog
  void _showNotificationDialog(Appointment appointment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.notifications, color: Color(0xFFED8936)),
            const SizedBox(width: 10),
            Text(
              'Send Notification',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF2D3748),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Send a reminder notification to the patient:',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF718096),
                ),
              ),
              const SizedBox(height: 15),
              Text(
                'Patient: ${appointment.patientName}',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2D3748),
                ),
              ),
              Text(
                'Appointment: ${appointment.date} at ${appointment.time}',
                style: const TextStyle(
                  color: Color(0xFF718096),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _reminderMessageController,
                decoration: const InputDecoration(
                  labelText: 'Custom Message (Optional)',
                  hintText: 'E.g., Please arrive 15 minutes early...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 15),
              const Text(
                'Notification will be sent via:',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF718096),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.sms, size: 16, color: Color(0xFF48BB78)),
                  const SizedBox(width: 5),
                  Text(
                    'SMS: ${appointment.contact}',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  const Icon(Icons.email, size: 16, color: Color(0xFF4299E1)),
                  const SizedBox(width: 5),
                  Text(
                    'Email: ${appointment.email}',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
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
              // Send notification logic
              final message = _reminderMessageController.text.isNotEmpty
                  ? _reminderMessageController.text
                  : 'Reminder: Your appointment with ${appointment.doctor} is scheduled for ${appointment.date} at ${appointment.time}.';
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Notification sent to ${appointment.patientName}'),
                  backgroundColor: const Color(0xFF48BB78),
                ),
              );
              _reminderMessageController.clear();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFED8936),
            ),
            child: const Text('Send Notification'),
          ),
        ],
      ),
    );
  }

  // Quick Action Dialog
  void _showQuickActionDialog(String action) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              _getActionIcon(action),
              color: _getActionColor(action),
            ),
            const SizedBox(width: 10),
            Text(
              action,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF2D3748),
              ),
            ),
          ],
        ),
        content: Text(
          _getActionMessage(action),
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF718096),
          ),
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
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$action action completed successfully'),
                  backgroundColor: const Color(0xFF48BB78),
                ),
              );
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _getActionColor(action),
            ),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  // Helper methods
  IconData _getActionIcon(String action) {
    switch (action) {
      case 'Send Reminder':
        return Icons.notifications;
      case 'Reschedule':
        return Icons.schedule;
      case 'Cancel Appointment':
        return Icons.cancel;
      case 'Print Schedule':
        return Icons.print;
      default:
        return Icons.info;
    }
  }

  Color _getActionColor(String action) {
    switch (action) {
      case 'Send Reminder':
        return const Color(0xFF4299E1);
      case 'Reschedule':
        return const Color(0xFF48BB78);
      case 'Cancel Appointment':
        return const Color(0xFFF56565);
      case 'Print Schedule':
        return const Color(0xFFED8936);
      default:
        return const Color(0xFF718096);
    }
  }

  String _getActionMessage(String action) {
    switch (action) {
      case 'Send Reminder':
        return 'Send appointment reminders to all patients with upcoming appointments for tomorrow?';
      case 'Reschedule':
        return 'Open the rescheduling interface to manage appointment changes?';
      case 'Cancel Appointment':
        return 'Cancel selected appointments and notify patients?';
      case 'Print Schedule':
        return 'Generate and print today\'s appointment schedule?';
      default:
        return 'Perform this action?';
    }
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF718096),
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Color(0xFF2D3748),
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditField(String label, TextEditingController controller) {
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
        TextField(
          controller: controller,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _reminderMessageController.dispose();
    super.dispose();
  }
}