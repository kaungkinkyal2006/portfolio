import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:porfolio/app/view/section/contact_section.dart';
import 'package:porfolio/app/view/section/hero_section.dart';
import 'package:porfolio/app/view/section/projects_section.dart';
import 'package:porfolio/app/view/section/skills_section.dart';
import 'package:porfolio/app/view/widget/navbar/app_navbar.dart';
import 'package:porfolio/app/view/widget/navbar/mobile_drawer.dart';
import '../../controllers/navigation_controller.dart';
import '../../utils/responsive.dart';

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

  // Widget _buildSection({
  //   required GlobalKey key,
  //   required String label,
  //   required BuildContext context,
  //   required Color color,
  // }) {
  //   final hPadding = Responsive.value<double>(
  //     context,
  //     mobile: 24,
  //     tablet: 60,
  //     desktop: 120,
  //   );

  //   return Container(
  //     key: key,
  //     width: double.infinity,
  //     height: 500,
  //     color: color,
  //     padding: EdgeInsets.symmetric(horizontal: hPadding),
  //     child: Center(
  //       child: Text(label, style: Theme.of(context).textTheme.displayMedium),
  //     ),
  //   );
  // }
}
