import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:porfolio/app/data/porfolio_data.dart';
import 'package:porfolio/app/view/widget/scroll_reveal.dart';
import 'package:visibility_detector/visibility_detector.dart'; 
import '../../controllers/skills_controller.dart';
import '../../theme/app_theme.dart';
import '../../utils/responsive.dart';

class SkillsSection extends StatelessWidget {
  const SkillsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<SkillsController>();

    return ScrollReveal(
      delay: const Duration(milliseconds: 100),
      child: VisibilityDetector(
        key: const Key('skills-section'),
        onVisibilityChanged: (info) {
          if (info.visibleFraction > 0.2) ctrl.onSectionVisible();
        },
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: Responsive.value<double>(
              context, mobile: 24, tablet: 60, desktop: 120,
            ),
            vertical: 80,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Section heading ──────────────────────────
              _SectionHeading(),
              const SizedBox(height: 40),
      
              // ── Category filter chips ────────────────────
              _CategoryFilter(ctrl: ctrl),
              const SizedBox(height: 48),
      
              // ── Skills grid ──────────────────────────────
              _SkillsGrid(ctrl: ctrl),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Section heading ────────────────────────────────────────
class _SectionHeading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Skills',
          style: Theme.of(context).textTheme.displayMedium,
        ),
        const SizedBox(height: 10),
        Container(
          width: 50,
          height: 4,
          decoration: BoxDecoration(
            color: AppTheme.primaryColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Technologies and tools I work with',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}

// ── Category filter chips ──────────────────────────────────
class _CategoryFilter extends StatelessWidget {
  final SkillsController ctrl;
  const _CategoryFilter({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Wrap(
      spacing: 10,
      runSpacing: 10,
      children: ctrl.categories.map((cat) {
        final isSelected = ctrl.selectedCategory.value == cat;
        return GestureDetector(
          onTap: () => ctrl.selectCategory(cat),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(
              horizontal: 20, vertical: 10,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppTheme.primaryColor
                  : AppTheme.primaryColor.withOpacity(0.08),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: isSelected
                    ? AppTheme.primaryColor
                    : AppTheme.primaryColor.withOpacity(0.2),
              ),
            ),
            child: Text(
              cat,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isSelected
                    ? Colors.white
                    : AppTheme.primaryColor,
              ),
            ),
          ),
        );
      }).toList(),
    ));
  }
}

// ── Skills grid ────────────────────────────────────────────
class _SkillsGrid extends StatelessWidget {
  final SkillsController ctrl;
  const _SkillsGrid({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);
    final crossCount = Responsive.value<int>(
      context, mobile: 1, tablet: 2, desktop: 2,
    );

    return Obx(() {
  final filtered = ctrl.filteredSkills;

  return Wrap(
    spacing: 12,
    runSpacing: 12,
    children: filtered.map((skill) {
      return _SkillCard(skill: skill);
    }).toList(),
  );
});
 }
}

// ── Single skill card ──────────────────────────────────────
class _SkillCard extends StatelessWidget {
  final Map<String, dynamic> skill;

  const _SkillCard({required this.skill});

  @override
  Widget build(BuildContext context) {
    final name = skill['name'] as String;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: AppTheme.primaryColor.withOpacity(0.2),
        ),
      ),
      child: Text(
        name,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppTheme.primaryColor,
        ),
      ),
    );
  }
}