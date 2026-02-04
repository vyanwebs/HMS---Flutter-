import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  final VoidCallback onBack;

  const SettingsScreen({super.key, required this.onBack});

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
                    'Settings',
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
                  // Settings Categories
                  const Text(
                    'System Settings',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Notification Settings
                  _buildSettingsSection(
                    title: 'Notifications',
                    icon: Icons.notifications_outlined,
                    children: [
                      _buildSettingsItem(
                        title: 'Push Notifications',
                        subtitle: 'Receive push notifications for alerts',
                        value: true,
                        onChanged: (value) {},
                      ),
                      _buildSettingsItem(
                        title: 'Email Notifications',
                        subtitle: 'Receive email updates',
                        value: true,
                        onChanged: (value) {},
                      ),
                      _buildSettingsItem(
                        title: 'SMS Alerts',
                        subtitle: 'Receive SMS for critical alerts',
                        value: false,
                        onChanged: (value) {},
                      ),
                      _buildSettingsItem(
                        title: 'Sound Alerts',
                        subtitle: 'Play sound for notifications',
                        value: true,
                        onChanged: (value) {},
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Display Settings
                  _buildSettingsSection(
                    title: 'Display',
                    icon: Icons.display_settings_outlined,
                    children: [
                      _buildSettingsItem(
                        title: 'Dark Mode',
                        subtitle: 'Use dark theme',
                        value: false,
                        onChanged: (value) {},
                      ),
                      _buildSettingsItem(
                        title: 'Font Size',
                        subtitle: 'Adjust text size',
                        value: 'Medium',
                        isDropdown: true,
                        dropdownItems: ['Small', 'Medium', 'Large'],
                        onChanged: (value) {},
                      ),
                      _buildSettingsItem(
                        title: 'Language',
                        subtitle: 'App language',
                        value: 'English',
                        isDropdown: true,
                        dropdownItems: ['English', 'Hindi', 'Spanish', 'French'],
                        onChanged: (value) {},
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Security Settings
                  _buildSettingsSection(
                    title: 'Security',
                    icon: Icons.security_outlined,
                    children: [
                      _buildSettingsItem(
                        title: 'Two-Factor Authentication',
                        subtitle: 'Add an extra layer of security',
                        value: false,
                        onChanged: (value) {},
                      ),
                      _buildSettingsItem(
                        title: 'Auto-Lock',
                        subtitle: 'Lock app after inactivity',
                        value: '5 minutes',
                        isDropdown: true,
                        dropdownItems: ['Never', '1 minute', '5 minutes', '15 minutes'],
                        onChanged: (value) {},
                      ),
                      ListTile(
                        contentPadding: const EdgeInsets.all(0),
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFF0094FE).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.lock_reset,
                            color: Color(0xFF0094FE),
                            size: 20,
                          ),
                        ),
                        title: const Text(
                          'Change Password',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF2D3748),
                          ),
                        ),
                        subtitle: const Text(
                          'Update your account password',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF718096),
                          ),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Color(0xFFA0AEC0),
                        ),
                        onTap: () {},
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Data & Storage
                  _buildSettingsSection(
                    title: 'Data & Storage',
                    icon: Icons.storage_outlined,
                    children: [
                      ListTile(
                        contentPadding: const EdgeInsets.all(0),
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFF0094FE).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.cloud_download,
                            color: Color(0xFF0094FE),
                            size: 20,
                          ),
                        ),
                        title: const Text(
                          'Data Usage',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF2D3748),
                          ),
                        ),
                        subtitle: const Text(
                          '2.4 GB used of 5 GB',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF718096),
                          ),
                        ),
                        trailing: SizedBox(
                          width: 100,
                          child: LinearProgressIndicator(
                            value: 0.48,
                            backgroundColor: const Color(0xFFE2E8F0),
                            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF0094FE)),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                      _buildSettingsItem(
                        title: 'Auto-Sync',
                        subtitle: 'Sync data automatically',
                        value: true,
                        onChanged: (value) {},
                      ),
                      _buildSettingsItem(
                        title: 'Cache Data',
                        subtitle: 'Store temporary data',
                        value: true,
                        onChanged: (value) {},
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // About & Support
                  _buildSettingsSection(
                    title: 'About & Support',
                    icon: Icons.info_outline,
                    children: [
                      ListTile(
                        contentPadding: const EdgeInsets.all(0),
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFF0094FE).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.help_outline,
                            color: Color(0xFF0094FE),
                            size: 20,
                          ),
                        ),
                        title: const Text(
                          'Help & Support',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF2D3748),
                          ),
                        ),
                        subtitle: const Text(
                          'Get help and contact support',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF718096),
                          ),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Color(0xFFA0AEC0),
                        ),
                        onTap: () {},
                      ),
                      ListTile(
                        contentPadding: const EdgeInsets.all(0),
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFF0094FE).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.description_outlined,
                            color: Color(0xFF0094FE),
                            size: 20,
                          ),
                        ),
                        title: const Text(
                          'Terms & Conditions',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF2D3748),
                          ),
                        ),
                        subtitle: const Text(
                          'Read our terms of service',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF718096),
                          ),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Color(0xFFA0AEC0),
                        ),
                        onTap: () {},
                      ),
                      ListTile(
                        contentPadding: const EdgeInsets.all(0),
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFF0094FE).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.shield_outlined,
                            color: Color(0xFF0094FE),
                            size: 20,
                          ),
                        ),
                        title: const Text(
                          'Privacy Policy',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF2D3748),
                          ),
                        ),
                        subtitle: const Text(
                          'Read our privacy policy',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF718096),
                          ),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Color(0xFFA0AEC0),
                        ),
                        onTap: () {},
                      ),
                      ListTile(
                        contentPadding: const EdgeInsets.all(0),
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFF0094FE).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.update,
                            color: Color(0xFF0094FE),
                            size: 20,
                          ),
                        ),
                        title: const Text(
                          'App Version',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF2D3748),
                          ),
                        ),
                        subtitle: const Text(
                          'Version 2.1.0',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF718096),
                          ),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Color(0xFFA0AEC0),
                        ),
                        onTap: () {},
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Danger Zone
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red.withValues(alpha: 0.2)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.warning_amber, color: Colors.red),
                            const SizedBox(width: 12),
                            const Text(
                              'Danger Zone',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'These actions are irreversible. Please proceed with caution.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.delete_outline, size: 18),
                                label: const Text('Clear All Data'),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Colors.red),
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Logout'),
                                      content: const Text('Are you sure you want to logout?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context),
                                          child: const Text('Cancel'),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            onBack();
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                          ),
                                          child: const Text('Logout'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.logout, size: 18),
                                label: const Text('Logout'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
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

  Widget _buildSettingsSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF0094FE)),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2D3748),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSettingsItem({
    required String title,
    required String subtitle,
    required dynamic value,
    bool isDropdown = false,
    List<String>? dropdownItems,
    required Function(dynamic) onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF718096),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          if (isDropdown && dropdownItems != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF7FAFC),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: value,
                  icon: const Icon(Icons.keyboard_arrow_down, size: 20),
                  items: dropdownItems.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: onChanged,
                ),
              ),
            )
          else
            Switch(
              value: value as bool,
              onChanged: onChanged,
              activeColor: const Color(0xFF0094FE),
            ),
        ],
      ),
    );
  }
}