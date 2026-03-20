import 'package:flutter/material.dart';
import '../../../utils/responsive.dart';
import 'desktop_navbar.dart';
import 'mobile_navbar.dart';
import 'mobile_drawer.dart';

class AppNavbar extends StatelessWidget {
  const AppNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    // Switch between desktop and mobile layout
    if (Responsive.isDesktop(context) || Responsive.isTablet(context)) {
      return const DesktopNavbar();
    }
    return const MobileNavbar();
  }
}