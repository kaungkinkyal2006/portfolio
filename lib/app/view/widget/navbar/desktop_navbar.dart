import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/navigation_controller.dart';
import '../../../controllers/theme_controller.dart';
import '../../../theme/app_theme.dart';

class DesktopNavbar extends StatelessWidget {
  const DesktopNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    final nav   = Get.find<NavigationController>();
    final theme = Get.find<ThemeController>();

    return Obx(() => AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 60),
      height: 70,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withOpacity(
          nav.isScrolled.value ? 0.95 : 1.0,
        ),
        boxShadow: nav.isScrolled.value
            ? [BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 20,
                offset: const Offset(0, 2),
              )]
            : [],
      ),
      child: Row(
        children: [
          // ── Logo ──────────────────────────────────────
          Text(
            'Kaung Kin Kyal',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppTheme.primaryColor,
              letterSpacing: -0.5,
            ),
          ),

          const Spacer(),

          // ── Nav links ─────────────────────────────────
          ...nav.sections.asMap().entries.map((entry) {
            return _NavLink(index: entry.key, label: entry.value);
          }),

          const SizedBox(width: 24),

          // ── Theme toggle ──────────────────────────────
          Obx(() => IconButton(
            onPressed: theme.toggleTheme,
            icon: Icon(
              theme.isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          )),
        ],
      ),
    ));
  }
}

// ── Single nav link widget ─────────────────────────────────
class _NavLink extends StatefulWidget {
  final int index;
  final String label;

  const _NavLink({required this.index, required this.label});

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final nav      = Get.find<NavigationController>();
    final isActive = nav.currentIndex.value == widget.index;

    return Obx(() {
      final active = nav.currentIndex.value == widget.index;

      return MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit:  (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: () => nav.scrollToSection(widget.index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: active
                  ? AppTheme.primaryColor.withOpacity(0.1)
                  : _isHovered
                      ? Theme.of(context).colorScheme.surface
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              widget.label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                color: active
                    ? AppTheme.primaryColor
                    : _isHovered
                        ? AppTheme.primaryColor
                        : Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
          ),
        ),
      );
    });
  }
}