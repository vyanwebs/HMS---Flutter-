import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/module_login_controllers.dart';
import '../utils/constants.dart';
import '../utils/enums.dart';

class ModuleLoginScreen extends StatefulWidget {
  final UserPanel panel;

  const ModuleLoginScreen({
    super.key,
    required this.panel,
  });

  @override
  State<ModuleLoginScreen> createState() => _ModuleLoginScreenState();
}

class _ModuleLoginScreenState extends State<ModuleLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController(text: "jatin@gmail.com");
  final TextEditingController _passwordController = TextEditingController(text: "password");
  bool _obscurePassword = true;

  // Controller only
  final ModuleLoginControllers controller = Get.put(ModuleLoginControllers());

  // Module information
  final Map<UserPanel, Map<String, dynamic>> _moduleInfo = {
    UserPanel.doctor: {
      'color': AppColors.doctor,
      'icon': Icons.person_outline,
      'title': 'Doctor',
      'description': 'Patient management and medical records',
    },

    UserPanel.externalDoctor: {
      'color': AppColors.externalDoctor,
      'icon': Icons.people_outline,
      'title': 'External Doctor',
      'description': 'External consultations and referrals',
    },

    UserPanel.reception: {
      'color': AppColors.reception,
      'icon': Icons.desktop_mac_outlined,
      'title': 'Reception',
      'description': 'Patient registration & billing',
    },

    UserPanel.nurse: {
      'color': AppColors.nurses,
      'icon': Icons.medical_services_outlined,
      'title': 'Nurse',
      'description': 'Patient care and ward monitoring',
    },

    UserPanel.pharmacy: {
      'color': AppColors.pharmacy,
      'icon': Icons.local_pharmacy_outlined,
      'title': 'Pharmacy',
      'description': 'Medicine dispensing & inventory',
    },

    UserPanel.laboratory: {
      'color': AppColors.laboratory,
      'icon': Icons.science_outlined,
      'title': 'Laboratory',
      'description': 'Lab tests and report management',
    },

    UserPanel.diagnostics: {
      'color': AppColors.diagnostics,
      'icon': Icons.monitor_heart_outlined,
      'title': 'Diagnostics',
      'description': 'Radiology and diagnostic services',
    },

    UserPanel.dialysis: {
      'color': AppColors.dialysis,
      'icon': Icons.water_drop_outlined,
      'title': 'Dialysis',
      'description': 'Dialysis treatment management',
    },

    UserPanel.insurance: {
      'color': AppColors.insurance,
      'icon': Icons.security_outlined,
      'title': 'Insurance',
      'description': 'Insurance claims & approvals',
    },

    UserPanel.patient: {
      'color': AppColors.patient,
      'icon': Icons.accessibility_new_outlined,
      'title': 'Patient',
      'description': 'Personal health records & appointments',
    },

    UserPanel.admin: {
      'color': AppColors.admin,
      'icon': Icons.admin_panel_settings_outlined,
      'title': 'Admin',
      'description': 'System configuration and user management',
    },
  };

  @override
  Widget build(BuildContext context) {
    final moduleInfo = _moduleInfo[widget.panel]!;
    final moduleColor = moduleInfo['color'] as Color;
    final moduleIcon = moduleInfo['icon'] as IconData;
    final moduleTitle = moduleInfo['title'] as String;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 450,
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, size: 28),
                    color: AppColors.textPrimary,
                  ),

                  const SizedBox(height: 20),

                  // ================= HEADER =================
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: moduleColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(moduleIcon, size: 32, color: moduleColor),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '$moduleTitle Portal',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                moduleInfo['description'],
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 36),

                  // ================= LOGIN CARD =================
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            // Badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18, vertical: 10),
                              decoration: BoxDecoration(
                                color: moduleColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(22),
                              ),
                              child: Text(
                                moduleTitle.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: moduleColor,
                                ),
                              ),
                            ),

                            const SizedBox(height: 28),

                            // Username
                            TextFormField(
                              controller: _usernameController,
                              decoration: _inputDecoration(
                                label: 'Username',
                                icon: Icons.person_outline,
                                color: moduleColor,
                              ),
                              validator: (v) =>
                                  v!.isEmpty ? 'Enter username' : null,
                            ),

                            const SizedBox(height: 20),

                            // Password
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              decoration: _inputDecoration(
                                label: 'Password',
                                icon: Icons.lock_outline,
                                color: moduleColor,
                                suffix: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                              ),
                              validator: (v) =>
                                  v!.length < 6 ? 'Min 6 characters' : null,
                            ),

                            const SizedBox(height: 24),

                            // ================= LOGIN BUTTON =================
                            Obx(
                              () => SizedBox(
                                width: double.infinity,
                                height: 48,
                                child: ElevatedButton(
                                  onPressed: controller.isLoading.value
                                      ? null
                                      : () {
                                          if (_formKey.currentState!.validate()) {
                                            controller.login(
                                              email: _usernameController.text.trim(),
                                              password: _passwordController.text.trim(),
                                              // panel: widget.panel,
                                            );
                                          }
                                        },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: moduleColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: controller.isLoading.value
                                      ? const SizedBox(
                                          width: 22,
                                          height: 22,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                      : const Text(
                                          'LOGIN TO MODULE',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  const Center(
                    child: Text(
                      '© Docklex.care v4.1 | HIPAA Compliant',
                      style: TextStyle(fontSize: 11),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
    required Color color,
    Widget? suffix,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, size: 20),
      suffixIcon: suffix,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: color, width: 1.5),
      ),
    );
  }
}
