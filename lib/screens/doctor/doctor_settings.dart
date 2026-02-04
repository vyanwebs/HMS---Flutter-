import 'package:flutter/material.dart';

class DoctorSettings extends StatelessWidget {
  const DoctorSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('Account Settings'),
            const SizedBox(height: 12),
            _settingsCard([
              _settingTile(
                icon: Icons.person_outline,
                title: 'Profile Information',
                subtitle: 'Update personal and professional details',
              ),
              _settingTile(
                icon: Icons.lock_outline,
                title: 'Change Password',
                subtitle: 'Update your account password',
              ),
              _settingTile(
                icon: Icons.verified_user_outlined,
                title: 'Security',
                subtitle: 'Two-factor authentication & security',
              ),
            ]),
            const SizedBox(height: 20),
            _sectionTitle('Preferences'),
            const SizedBox(height: 12),
            _settingsCard([
              _switchTile(
                icon: Icons.notifications_outlined,
                title: 'Notifications',
                subtitle: 'Appointment and system alerts',
                value: true,
              ),
              _switchTile(
                icon: Icons.mic_none,
                title: 'Voice Assistance',
                subtitle: 'Enable voice-based actions',
                value: false,
              ),
              _switchTile(
                icon: Icons.dark_mode_outlined,
                title: 'Dark Mode',
                subtitle: 'Reduce eye strain',
                value: false,
              ),
            ]),
            const SizedBox(height: 20),
            _sectionTitle('System'),
            const SizedBox(height: 12),
            _settingsCard([
              _settingTile(
                icon: Icons.language,
                title: 'Language',
                subtitle: 'English (Default)',
                trailingText: 'Change',
              ),
              _settingTile(
                icon: Icons.storage_outlined,
                title: 'Data & Storage',
                subtitle: 'Manage cached data',
              ),
              _settingTile(
                icon: Icons.help_outline,
                title: 'Help & Support',
                subtitle: 'FAQs and contact support',
              ),
            ]),
            const SizedBox(height: 20),
            _dangerCard(),
          ],
        ),
      ),
    );
  }

  // ===================== UI COMPONENTS =====================

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Color(0xFF2D3748),
      ),
    );
  }

  Widget _settingsCard(List<Widget> children) {
    return Container(
      decoration: _cardDecoration(),
      child: Column(
        children: children
            .map(
              (e) => Column(
                children: [
                  e,
                  if (e != children.last)
                    const Divider(height: 1, color: Color(0xFFE5E7EB)),
                ],
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _settingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    String? trailingText,
  }) {
    return ListTile(
      leading: _iconBox(icon),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      trailing: trailingText != null
          ? Text(
              trailingText,
              style: const TextStyle(
                color: Color(0xFF2563EB),
                fontWeight: FontWeight.w500,
              ),
            )
          : const Icon(Icons.arrow_forward_ios, size: 14),
      onTap: () {},
    );
  }

  Widget _switchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
  }) {
    return ListTile(
      leading: _iconBox(icon),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
      trailing: Switch(
        value: value,
        activeColor: const Color(0xFF2383E2),
        onChanged: (v) {},
      ),
    );
  }

  Widget _dangerCard() {
    return Container(
      decoration: _cardDecoration(),
      child: ListTile(
        leading: _iconBox(Icons.logout, color: const Color(0xFFDC2626)),
        title: const Text(
          'Logout',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFFDC2626),
          ),
        ),
        subtitle: const Text(
          'Sign out from your account',
          style: TextStyle(fontSize: 12),
        ),
        onTap: () {},
      ),
    );
  }

  Widget _iconBox(IconData icon, {Color? color}) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: (color ?? const Color(0xFF2563EB)).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        icon,
        size: 18,
        color: color ?? const Color(0xFF2563EB),
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