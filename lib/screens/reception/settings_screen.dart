// lib/screens/reception/settings_screen.dart
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _emailAlerts = true;
  bool _smsAlerts = false;
  String _selectedLanguage = 'English';
  String _selectedTheme = 'Light';

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
          const Text(
            'System Settings',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 20),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Navigation Menu
              Container(
                width: 250,
                decoration: BoxDecoration(
                  color: const Color(0xFFF7FAFC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  children: [
                    _buildSettingsMenuItem(
                        'General Settings', Icons.settings, true),
                    _buildSettingsMenuItem(
                        'Notification Settings', Icons.notifications, false),
                    _buildSettingsMenuItem(
                        'Security & Privacy', Icons.security, false),
                    _buildSettingsMenuItem(
                        'User Management', Icons.people, false),
                    _buildSettingsMenuItem(
                        'Billing Settings', Icons.receipt, false),
                    _buildSettingsMenuItem(
                        'Backup & Restore', Icons.backup, false),
                    _buildSettingsMenuItem(
                        'About & Help', Icons.help, false),
                  ],
                ),
              ),

              const SizedBox(width: 30),

              // Settings Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'General Settings',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Hospital Information
                    Container(
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
                            'Hospital Information',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2D3748),
                            ),
                          ),
                          const SizedBox(height: 20),

                          _buildSettingField('Hospital Name', 'DocNex Hospital'),
                          const SizedBox(height: 15),
                          _buildSettingField('Address', '123 Medical Street, City'),
                          const SizedBox(height: 15),
                          _buildSettingField('Contact Number', '+91 9876543210'),
                          const SizedBox(height: 15),
                          _buildSettingField('Email', 'info@docnexhospital.com'),
                          const SizedBox(height: 15),
                          _buildSettingField('License Number', 'HOSP-2024-001'),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Preferences
                    Container(
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
                            'Preferences',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2D3748),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Language Selection
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Language',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF2D3748),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF7FAFC),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: const Color(0xFFE2E8F0)),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: _selectedLanguage,
                                    isExpanded: true,
                                    items: ['English', 'Hindi', 'Spanish', 'French']
                                        .map((language) => DropdownMenuItem(
                                              value: language,
                                              child: Text(language),
                                            ))
                                        .toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedLanguage = value!;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // Theme Selection
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Theme',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF2D3748),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF7FAFC),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: const Color(0xFFE2E8F0)),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: _selectedTheme,
                                    isExpanded: true,
                                    items: ['Light', 'Dark', 'System Default']
                                        .map((theme) => DropdownMenuItem(
                                              value: theme,
                                              child: Text(theme),
                                            ))
                                        .toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedTheme = value!;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // Notification Settings
                          const Text(
                            'Notifications',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2D3748),
                            ),
                          ),
                          const SizedBox(height: 10),

                          SwitchListTile(
                            title: const Text('Enable Notifications'),
                            value: _notificationsEnabled,
                            onChanged: (value) {
                              setState(() {
                                _notificationsEnabled = value;
                              });
                            },
                            activeColor: const Color(0xFF4299E1),
                          ),
                          SwitchListTile(
                            title: const Text('Email Alerts'),
                            value: _emailAlerts,
                            onChanged: (value) {
                              setState(() {
                                _emailAlerts = value;
                              });
                            },
                            activeColor: const Color(0xFF4299E1),
                          ),
                          SwitchListTile(
                            title: const Text('SMS Alerts'),
                            value: _smsAlerts,
                            onChanged: (value) {
                              setState(() {
                                _smsAlerts = value;
                              });
                            },
                            activeColor: const Color(0xFF4299E1),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Actions
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4299E1),
                              padding: const EdgeInsets.symmetric(vertical: 15),
                            ),
                            child: const Text('Save Changes'),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              side: const BorderSide(color: Color(0xFFE2E8F0)),
                            ),
                            child: const Text(
                              'Reset to Default',
                              style: TextStyle(color: Color(0xFF718096)),
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

          const SizedBox(height: 30),

          // System Information
          Container(
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: const Color(0xFFF7FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'System Information',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Version: 2.4.1 • Last Updated: Jan 15, 2024',
                      style: TextStyle(
                        color: const Color(0xFF718096),
                      ),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF48BB78),
                  ),
                  icon: const Icon(Icons.update, size: 18),
                  label: const Text('Check for Updates'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsMenuItem(String title, IconData icon, bool active) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: active ? const Color(0xFF4299E1) : Colors.transparent,
        border: Border(
          bottom: BorderSide(color: const Color(0xFFE2E8F0)),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: active ? Colors.white : const Color(0xFF718096),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: active ? Colors.white : const Color(0xFF4A5568),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF718096),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF7FAFC),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  value,
                  style: const TextStyle(
                    color: Color(0xFF2D3748),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.edit_outlined,
                    size: 18, color: Color(0xFF4299E1)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}