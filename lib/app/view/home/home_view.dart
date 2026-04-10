import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:porfolio/app/view/section/contact_section.dart';
import 'package:porfolio/app/view/section/hero_section.dart';
import 'package:porfolio/app/view/section/projects_section.dart';
import 'package:porfolio/app/view/section/skills_section.dart';
import 'package:porfolio/app/view/widget/navbar/app_navbar.dart';
import 'package:porfolio/app/view/widget/navbar/mobile_drawer.dart';
import '../../controllers/navigation_controller.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final nav = Get.find<NavigationController>();

    return Scaffold(
      body: Column(
        children: [
          // ── Sticky navbar ────────────────────────────
          AppNavbar(),

          // ── Mobile drawer dropdown ───────────────────
          Obx(() => AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, animation) => SizeTransition(
              sizeFactor: animation,
              axisAlignment: -1,
              child: child,
            ),
            child: nav.isMenuOpen.value
                ? KeyedSubtree(
                    key: const ValueKey('drawer'),
                    child: const MobileDrawer(),
                  )
                : const SizedBox.shrink(),
          )),

          // ── Scrollable content ───────────────────────
          Expanded(
            child: SingleChildScrollView(
              controller: nav.scrollController,
              child: Column(
                children: [
                  HeroSection(key: nav.sectionKeys[0]),
                  SkillsSection(key: nav.sectionKeys[1]),
                  ProjectsSection(key: nav.sectionKeys[2]),
                  ContactSection(key: nav.sectionKeys[3]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}