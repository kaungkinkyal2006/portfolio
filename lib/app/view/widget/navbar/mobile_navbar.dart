import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/navigation_controller.dart';
import '../../../controllers/theme_controller.dart';
import '../../../theme/app_theme.dart';

class MobileNavbar extends StatelessWidget {
  const MobileNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    final nav   = Get.find<NavigationController>();
    final theme = Get.find<ThemeController>();

    return Obx(() => AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      height: 60,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: nav.isScrolled.value
            ? [BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 20,
                offset: const Offset(0, 2),
              )]
            : [],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo
          Text(
            'Kaung Kin Kyal',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppTheme.primaryColor,
            ),
          ),

          Row(
            children: [
              // Theme toggle
              Obx(() => IconButton(
                onPressed: theme.toggleTheme,
                icon: Icon(
                  theme.isDark
                      ? Icons.light_mode_outlined
                      : Icons.dark_mode_outlined,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              )),

              // Hamburger button — animated to X when open
              Obx(() => IconButton(
                onPressed: nav.toggleMenu,
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    nav.isMenuOpen.value ? Icons.close : Icons.menu,
                    key: ValueKey(nav.isMenuOpen.value),
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                ),
              )),
            ],
          ),
        ],
      ),
    ));
  }
}