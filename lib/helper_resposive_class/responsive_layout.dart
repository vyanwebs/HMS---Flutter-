import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget tablet;
  final Widget desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    required this.tablet,
    required this.desktop,
  });

  static const double mobileBreakpoint = 450;
  static const double tabletBreakpoint = 800;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;

        if (width < mobileBreakpoint) {
          return mobile;
        } else if (width < tabletBreakpoint) {
          return tablet;
        } else {
          return desktop;
        }
      },
    );
  }
}
