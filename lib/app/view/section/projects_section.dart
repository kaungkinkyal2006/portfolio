import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:porfolio/app/view/widget/scroll_reveal.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../controllers/projects_controller.dart';
import '../../theme/app_theme.dart';
import '../../utils/responsive.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<ProjectsController>();

    return ScrollReveal(
      delay: const Duration(milliseconds: 100),
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
      
            // ── Tag filter chips ─────────────────────────
            _TagFilter(ctrl: ctrl),
            const SizedBox(height: 48),
      
            // ── Projects grid ────────────────────────────
            _ProjectsGrid(ctrl: ctrl),
          ],
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
          'Projects',
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
          'Things I have built',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}

// ── Tag filter chips ───────────────────────────────────────
class _TagFilter extends StatelessWidget {
  final ProjectsController ctrl;
  const _TagFilter({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Wrap(
      spacing: 10,
      runSpacing: 10,
      children: ctrl.tags.map((tag) {
        final isSelected = ctrl.selectedTag.value == tag;
        return GestureDetector(
          onTap: () => ctrl.selectTag(tag),
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
              tag,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : AppTheme.primaryColor,
              ),
            ),
          ),
        );
      }).toList(),
    ));
  }
}

// ── Projects grid ──────────────────────────────────────────
class _ProjectsGrid extends StatelessWidget {
  final ProjectsController ctrl;
  const _ProjectsGrid({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    final crossCount = Responsive.value<int>(
      context, mobile: 1, tablet: 2, desktop: 3,
    );

    return Obx(() {
      final filtered = ctrl.filteredProjects;

      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossCount,
          crossAxisSpacing: 24,
          mainAxisSpacing: 24,
          childAspectRatio: Responsive.value<double>(
            context, mobile: 1.4, tablet: 1.2, desktop: 1.1,
          ),
        ),
        itemCount: filtered.length,
        itemBuilder: (_, index) => _ProjectCard(
          project: filtered[index],
        ),
      );
    });
  }
}

// ── Single project card ────────────────────────────────────
class _ProjectCard extends StatefulWidget {
  final Map<String, dynamic> project;
  const _ProjectCard({required this.project});

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final title       = widget.project['title']       as String;
    final description = widget.project['description'] as String;
    final tags        = (widget.project['tags'] as List).cast<String>();
    final github      = widget.project['github']      as String;
    final live        = widget.project['live']        as String;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.translationValues(0, _hovered ? -6 : 0, 0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _hovered
                ? AppTheme.primaryColor.withOpacity(0.4)
                : Theme.of(context).dividerColor.withOpacity(0.1),
          ),
          boxShadow: [
            BoxShadow(
              color: _hovered
                  ? AppTheme.primaryColor.withOpacity(0.12)
                  : Colors.black.withOpacity(0.05),
              blurRadius: _hovered ? 24 : 10,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Top row: folder icon + links ──────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.folder_rounded,
                      color: AppTheme.primaryColor,
                      size: 24,
                    ),
                  ),
                  Row(
                    children: [
                      if (github.isNotEmpty)
                        _IconLink(
                          icon: Icons.code_rounded,
                          url: github,
                          tooltip: 'GitHub',
                        ),
                      if (live.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        _IconLink(
                          icon: Icons.open_in_new_rounded,
                          url: live,
                          tooltip: 'Live demo',
                        ),
                      ],
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // ── Title ─────────────────────────────────
              Text(
                title,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontSize: 20,
                ),
              ),

              const SizedBox(height: 10),

              // ── Description ───────────────────────────
              Expanded(
                child: Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              const SizedBox(height: 16),

              // ── Tag chips ─────────────────────────────
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: tags.map((tag) => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    tag,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Icon link button ───────────────────────────────────────
class _IconLink extends StatefulWidget {
  final IconData icon;
  final String url;
  final String tooltip;

  const _IconLink({
    required this.icon,
    required this.url,
    required this.tooltip,
  });

  @override
  State<_IconLink> createState() => _IconLinkState();
}

class _IconLinkState extends State<_IconLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit:  (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: () async {
            final uri = Uri.parse(widget.url);
            if (await canLaunchUrl(uri)) launchUrl(uri);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: _hovered
                  ? AppTheme.primaryColor.withOpacity(0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              widget.icon,
              size: 20,
              color: _hovered
                  ? AppTheme.primaryColor
                  : Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
        ),
      ),
    );
  }
}