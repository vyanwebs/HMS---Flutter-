import 'package:flutter/material.dart';
import 'package:hms/utils/constants.dart';

// Import all dashboard screens
import 'package:hms/screens/reception/reception_dashboard.dart';
import 'package:hms/screens/doctor/doctor_dashboard.dart';
import 'package:hms/screens/pharmacy/pharmacy_dashboard.dart';
import 'package:hms/screens/laboratory/lab_dashboard.dart';
import 'package:hms/screens/nurse/nurse_dashboard.dart';
import 'package:hms/screens/patient/patient_dashboard.dart';
import 'package:hms/screens/admin/admin_dashboard.dart';
import 'package:hms/screens/insurance/insurance_dashboard.dart';
import 'package:hms/screens/diagnostics/diagnostics_dashboard.dart';
import 'package:hms/screens/dialysis/dialysis_dashboard.dart';

class ModuleLoginScreen extends StatefulWidget {
  final String module;
  const ModuleLoginScreen({super.key, required this.module});

  @override
  State<ModuleLoginScreen> createState() => _ModuleLoginScreenState();
}

class _ModuleLoginScreenState extends State<ModuleLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  // Module information
  final Map<String, Map<String, dynamic>> _moduleInfo = {
    'External Doctor': {
      'color': AppColors.externalDoctor,
      'icon': Icons.people_alt_outlined,
      'description': 'External consultation and patient records access',
      'demoUser': 'externaldoctor',
      'demoPass': 'externaldoctor123',
    },
    'Reception': {
      'color': AppColors.reception,
      'icon': Icons.desktop_mac_outlined,
      'description': 'Patient registration, billing and appointments',
      'demoUser': 'reception',
      'demoPass': 'reception123',
    },
    'Doctor': {
      'color': AppColors.doctor,
      'icon': Icons.person_outline,
      'description': 'Patient management and medical records',
      'demoUser': 'doctor',
      'demoPass': 'doctor123',
    },
    'Nurses': {
      'color': AppColors.nurses,
      'icon': Icons.medical_services_outlined,
      'description': 'Patient care and monitoring station',
      'demoUser': 'nurses',
      'demoPass': 'nurses123',
    },
    'Pharmacy': {
      'color': AppColors.pharmacy,
      'icon': Icons.local_pharmacy_outlined,
      'description': 'Medicine dispensing and inventory management',
      'demoUser': 'pharmacy',
      'demoPass': 'pharmacy123',
    },
    'Laboratory': {
      'color': AppColors.laboratory,
      'icon': Icons.science_outlined,
      'description': 'Test management and reports system',
      'demoUser': 'laboratory',
      'demoPass': 'laboratory123',
    },
    'Insurance': {
      'color': AppColors.insurance,
      'icon': Icons.security_outlined,
      'description': 'Insurance processing and claims management',
      'demoUser': 'insurance',
      'demoPass': 'insurance123',
    },
    'Diagnostics': {
      'color': AppColors.diagnostics,
      'icon': Icons.monitor_heart_outlined,
      'description': 'Advanced diagnostics and imaging center',
      'demoUser': 'diagnostics',
      'demoPass': 'diagnostics123',
    },
    'Dialysis': {
      'color': AppColors.dialysis,
      'icon': Icons.water_drop_outlined,
      'description': 'Dialysis treatment management system',
      'demoUser': 'dialysis',
      'demoPass': 'dialysis123',
    },
    'Patient': {
      'color': AppColors.patient,
      'icon': Icons.accessible_outlined,
      'description': 'Personal health records and appointment booking',
      'demoUser': 'patient',
      'demoPass': 'patient123',
    },
    'Admin': {
      'color': AppColors.admin,
      'icon': Icons.admin_panel_settings_outlined,
      'description': 'System configuration and user management',
      'demoUser': 'admin',
      'demoPass': 'admin123',
    },
  };

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // Simulate authentication delay
      await Future.delayed(const Duration(seconds: 1));

      final moduleInfo = _moduleInfo[widget.module]!;
      final demoUser = moduleInfo['demoUser'] as String;
      final demoPass = moduleInfo['demoPass'] as String;

      // Check credentials (for demo, accept demo credentials or any non-empty)
      if ((_usernameController.text == demoUser &&
              _passwordController.text == demoPass) ||
          (_usernameController.text.isNotEmpty &&
              _passwordController.text.isNotEmpty)) {
        // Navigate to respective dashboard
        _navigateToDashboard();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid credentials'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      }

      setState(() => _isLoading = false);
    }
  }

  void _navigateToDashboard() {
    switch (widget.module) {
      case 'Reception':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ReceptionDashboard()),
        );
        break;
      case 'Doctor':
      case 'External Doctor':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DoctorDashboard()),
        );
        break;
      case 'Nurses':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const NurseDashboard()),
        );
        break;
      case 'Pharmacy':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const PharmacyDashboard()),
        );
        break;
      case 'Laboratory':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LabDashboard()),
        );
        break;
      case 'Insurance':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const InsuranceDashboard()),
        );
        break;
      case 'Diagnostics':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DiagnosticsDashboard()),
        );
        break;
      case 'Dialysis':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DialysisDashboard()),
        );
        break;
      case 'Patient':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const PatientDashboard()),
        );
        break;
      case 'Admin':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AdminDashboard()),
        );
        break;
      default:
        // Fallback to a generic dashboard
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Scaffold(
              appBar: AppBar(title: Text('${widget.module} Dashboard')),
              body: Center(
                child: Text('Welcome to ${widget.module} Module'),
              ),
            ),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final moduleInfo = _moduleInfo[widget.module] ??
        {
          'color': AppColors.primary,
          'icon': Icons.apps,
          'description': 'Module Portal',
          'demoUser': 'user',
          'demoPass': 'password123',
        };

    final moduleColor = moduleInfo['color'] as Color;
    final moduleIcon = moduleInfo['icon'] as IconData;

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
                  // Back button - SAME POSITION as reference screen
                  const SizedBox(height: 40),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, size: 28),
                    color: AppColors.textPrimary,
                  ),

                  const SizedBox(height: 20),

                  // Module Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: moduleColor.withOpacity(0.1),
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
                                '${widget.module} Portal',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                moduleInfo['description'] as String,
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

                  // Login Form - Larger Card
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            // Module Badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: moduleColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(22),
                              ),
                              child: Text(
                                widget.module.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: moduleColor,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),

                            const SizedBox(height: 28),

                            // Username Field
                            TextFormField(
                              controller: _usernameController,
                              decoration: InputDecoration(
                                labelText: 'Username',
                                hintText: 'Enter your username',
                                prefixIcon:
                                    const Icon(Icons.person_outline, size: 20),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      BorderSide(color: AppColors.border),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: moduleColor, width: 1.5),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16,
                                ),
                                labelStyle: const TextStyle(fontSize: 15),
                                hintStyle: TextStyle(
                                  fontSize: 14,
                                  color:
                                      AppColors.textSecondary.withOpacity(0.6),
                                ),
                              ),
                              style: const TextStyle(fontSize: 15),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter username';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 20),

                            // Password Field
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                hintText: 'Enter your password',
                                prefixIcon:
                                    const Icon(Icons.lock_outline, size: 20),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    size: 20,
                                  ),
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(
                                      minWidth: 36, minHeight: 36),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      BorderSide(color: AppColors.border),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: moduleColor, width: 1.5),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16,
                                ),
                                labelStyle: const TextStyle(fontSize: 15),
                                hintStyle: TextStyle(
                                  fontSize: 14,
                                  color:
                                      AppColors.textSecondary.withOpacity(0.6),
                                ),
                              ),
                              style: const TextStyle(fontSize: 15),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter password';
                                }
                                if (value.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 16),

                            // Remember me
                            Row(
                              children: [
                                Checkbox(
                                  value: false,
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  visualDensity: VisualDensity.compact,
                                  side: BorderSide(
                                      color: AppColors.border, width: 1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  onChanged: (value) {},
                                ),
                                const SizedBox(width: 6),
                                const Text(
                                  'Remember for 30 days',
                                  style: TextStyle(fontSize: 14),
                                ),
                                const Spacer(),
                                TextButton(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Contact administrator to reset password'),
                                        duration: Duration(seconds: 2),
                                      ),
                                    );
                                  },
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: Size.zero,
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: const Text(
                                    'Forgot Password?',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 24),

                            // Login Button
                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _login,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: moduleColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 2,
                                  padding: EdgeInsets.zero,
                                ),
                                child: _isLoading
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.white),
                                        ),
                                      )
                                    : const Text(
                                        'LOGIN TO MODULE',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Demo credentials
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.background,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: AppColors.border.withOpacity(0.5)),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    'Demo Credentials',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                      color: moduleColor,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Username: ${moduleInfo['demoUser']}\nPassword: ${moduleInfo['demoPass']}',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Footer
                  const Center(
                    child: Text(
                      '© Docklex.care v4.1 | HIPAA Compliant',
                      style: TextStyle(
                        color: AppColors.textTertiary,
                        fontSize: 11,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
