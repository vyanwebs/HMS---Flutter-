import 'package:flutter/material.dart';

class InboxScreen extends StatelessWidget {
  final VoidCallback onBack;

  const InboxScreen({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFC),
      body: Column(
        children: [
          // Top Bar
          Container(
            height: 70,
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 30),
            child: Row(
              children: [
                if (isMobile)
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Color(0xFF2383E2)),
                    onPressed: onBack,
                  ),
                Expanded(
                  child: Text(
                    'Inbox',
                    style: TextStyle(
                      fontSize: isMobile ? 18 : 24,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2D3748),
                    ),
                  ),
                ),
                if (!isMobile)
                  ElevatedButton(
                    onPressed: onBack,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0094FE),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                    child: const Text('Back to Dashboard'),
                  ),
              ],
            ),
          ),

          // Divider
          Container(height: 1, color: const Color(0xFFE2E8F0)),

          // Main Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(isMobile ? 16 : 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Messages & Notifications',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Inbox Items
                  ..._buildInboxItems(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildInboxItems() {
    return [
      _buildInboxItem(
        title: 'New Lab Results Available',
        message: 'Lab results for Patient ID: P10023 are now available',
        sender: 'Laboratory Department',
        time: '10:30 AM',
        isRead: false,
        isImportant: true,
      ),
      _buildInboxItem(
        title: 'Medication Schedule Update',
        message: 'Updated medication schedule for Ward 3 patients',
        sender: 'Pharmacy Department',
        time: 'Yesterday, 2:45 PM',
        isRead: true,
        isImportant: false,
      ),
      _buildInboxItem(
        title: 'Critical Patient Alert',
        message: 'Patient in ICU-A Bed 01 requires immediate attention',
        sender: 'ICU Head Nurse',
        time: 'Yesterday, 11:20 AM',
        isRead: true,
        isImportant: true,
      ),
      _buildInboxItem(
        title: 'Staff Meeting Reminder',
        message: 'Monthly nursing staff meeting scheduled for tomorrow',
        sender: 'Nursing Superintendent',
        time: 'Jan 1, 4:00 PM',
        isRead: true,
        isImportant: false,
      ),
      _buildInboxItem(
        title: 'Supply Restock Notice',
        message: 'Medical supplies have been restocked in Ward 2',
        sender: 'Inventory Department',
        time: 'Dec 31, 10:15 AM',
        isRead: true,
        isImportant: false,
      ),
      _buildInboxItem(
        title: 'Training Session Invitation',
        message: 'New equipment training session next week',
        sender: 'HR Department',
        time: 'Dec 30, 3:30 PM',
        isRead: true,
        isImportant: false,
      ),
    ];
  }

  Widget _buildInboxItem({
    required String title,
    required String message,
    required String sender,
    required String time,
    required bool isRead,
    required bool isImportant,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Unread Indicator
          if (!isRead)
            Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.only(top: 8, right: 12),
              decoration: const BoxDecoration(
                color: Color(0xFF0094FE),
                shape: BoxShape.circle,
              ),
            )
          else
            const SizedBox(width: 20),

          // Important Icon
          if (isImportant)
            Container(
              margin: const EdgeInsets.only(right: 12, top: 4),
              child: const Icon(
                Icons.warning_amber,
                color: Colors.orange,
                size: 18,
              ),
            ),

          // Message Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isRead ? FontWeight.w500 : FontWeight.w600,
                    color: const Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF718096),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      sender,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFFA0AEC0),
                      ),
                    ),
                    Text(
                      time,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFFA0AEC0),
                      ),
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
}