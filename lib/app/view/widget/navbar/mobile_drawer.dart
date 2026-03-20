import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/navigation_controller.dart';
import '../../../theme/app_theme.dart';

class MobileDrawer extends StatelessWidget {
  const MobileDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final nav = Get.find<NavigationController>();

   return Obx(() => Container(
    width: double.infinity,
    color: Theme.of(context).colorScheme.surface,
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: nav.sections.asMap().entries.map((entry) {
        final index    = entry.key;
        final label    = entry.value;
        final isActive = nav.currentIndex.value == index;

        return InkWell(
          onTap: () => nav.scrollToSection(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 24, vertical: 16,
            ),
            decoration: BoxDecoration(
              border: isActive
                  ? Border(
                      left: BorderSide(
                        color: AppTheme.primaryColor,
                        width: 3,
                      ),
                    )
                  : null,
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color: isActive
                    ? AppTheme.primaryColor
                    : Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
          ),
        );
      }).toList(),
    ),
  ));
   }
}