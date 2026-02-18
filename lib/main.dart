import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/Doctor/patient_search_controllers.dart';
import 'controllers/panel_navigation_controller.dart';
import 'screens/splash_screen.dart';
import 'utils/constants.dart';

// void main() => runApp(
//   DevicePreview(
//     enabled: !kReleaseMode,
//     builder: (context) => const MyApp(),
//   ),
// );

void main() {
  Get.put(PanelNavigationController(), permanent: true);
  Get.put(PatientSearchController(), permanent: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      // useInheritedMediaQuery: true,
      // locale: DevicePreview.locale(context),
      // builder: DevicePreview.appBuilder,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.info),
        primaryColor: AppColors.primary,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primary,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        cardTheme: ThemeData.light().cardTheme.copyWith(
              color: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.cardRadius),
              ),
            ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.secondary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
            borderSide: const BorderSide(color: AppColors.secondary),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.all(16),
        ),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
