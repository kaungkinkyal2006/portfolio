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
        const SizedBox(height: 8),
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

      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossCount,
          crossAxisSpacing: 24,
          mainAxisSpacing: 24,
          childAspectRatio: isDesktop ? 3.5 : 3.0,
        ),
        itemCount: filtered.length,
        itemBuilder: (context, index) {
          // Find original index to get the right animation
          final skill = filtered[index];
          final originalIndex = PortfolioData.skills.indexOf(skill);

          return _SkillCard(
            skill: skill,
            animation: ctrl.barAnimations[originalIndex],
          );
        },
      );
    });
  }
}

// ── Single skill card ──────────────────────────────────────
class _SkillCard extends StatelessWidget {
  final Map<String, dynamic> skill;
  final Animation<double> animation;

  const _SkillCard({required this.skill, required this.animation});

  @override
  Widget build(BuildContext context) {
    final name  = skill['name']  as String;
    final level = skill['level'] as double;
    final percent = (level * 100).toInt();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).dividerColor.withOpacity(0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Name + percentage row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: Theme.of(context).textTheme.labelLarge,
              ),
              AnimatedBuilder(
                animation: animation,
                builder: (_, __) => Text(
                  '${(animation.value * 100).toInt()}%',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Stack(
              children: [
                // Background track
                Container(
                  height: 8,
                  width: double.infinity,
                  color: AppTheme.primaryColor.withOpacity(0.1),
                ),
                // Animated fill
                AnimatedBuilder(
                  animation: animation,
                  builder: (context, _) {
                    return FractionallySizedBox(
                      widthFactor: animation.value,
                      child: Container(
                        height: 8,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppTheme.primaryColor,
                              AppTheme.secondaryColor,
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}