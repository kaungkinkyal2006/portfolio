import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:porfolio/app/view/widget/image_carousel.dart';
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
            context,
            mobile: 24,
            tablet: 60,
            desktop: 120,
          ),
          vertical: 80,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionHeading(),
            const SizedBox(height: 40),
            _TagFilter(ctrl: ctrl),
            const SizedBox(height: 48),
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
    // FIX: withOpacity deprecated → withValues(alpha:)
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
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.primaryColor
                      : AppTheme.primaryColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.primaryColor
                        : AppTheme.primaryColor.withValues(alpha: 0.2),
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
      context,
      mobile: 1,
      tablet: 2,
      desktop: 3,
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
            context,
            mobile: 1.4,
            tablet: 1.2,
            desktop: 1.1,
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
    final String? iconPath = widget.project['icon'] as String?;
    final title = widget.project['title'] as String;
    final tags = (widget.project['tags'] as List).cast<String>();
    final github = widget.project['github'] as String?;
    final live = widget.project['live'] as String?;

    // FIX: withOpacity deprecated → withValues(alpha:) throughout
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => _openDetailDialog(iconPath: iconPath),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.translationValues(0, _hovered ? -6 : 0, 0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _hovered
                  ? AppTheme.primaryColor.withValues(alpha: 0.4)
                  : Theme.of(context).dividerColor.withValues(alpha: 0.1),
            ),
            boxShadow: [
              BoxShadow(
                color: _hovered
                    ? AppTheme.primaryColor.withValues(alpha: 0.12)
                    : Colors.black.withValues(alpha: 0.05),
                blurRadius: _hovered ? 24 : 10,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: iconPath != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(iconPath, fit: BoxFit.cover),
                          )
                        : const Icon(
                            Icons.folder_rounded,
                            color: AppTheme.primaryColor,
                            size: 24,
                          ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Row(
                    children: [
                      if (github != null && github.isNotEmpty)
                        _IconLink(
                          icon: Icons.code_rounded,
                          url: github,
                          tooltip: 'GitHub',
                        ),
                      if (live != null && live.isNotEmpty) ...[
                        const SizedBox(width: 6),
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
              const SizedBox(height: 12),
              if (tags.isNotEmpty)
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: tags.map((tag) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        tag,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _openDetailDialog({String? iconPath}) {
    final title = widget.project['title'] as String;
    final description = widget.project['description'] as String;
    final tags = (widget.project['tags'] as List).cast<String>();
    final github = widget.project['github'] as String?;
    final live = widget.project['live'] as String?;
    final images = (widget.project['images'] as List<String>?) ?? [];

    showDialog(
      context: context,
      builder: (dialogContext) => _ProjectDetailDialog(
        title: title,
        description: description,
        tags: tags,
        github: github,
        live: live,
        images: images,
        iconPath: iconPath,
      ),
    );
  }
}

// ── Detail dialog — extracted to its own StatefulWidget ───
// FIX: The Scrollbar crash is caused by passing a fresh ScrollController()
// inline (which is never disposed) and the Scrollbar trying to paint before
// the controller has a position attached. Fix: own the controller in
// StatefulWidget so it is created once, properly attached, and disposed.
class _ProjectDetailDialog extends StatefulWidget {
  final String title;
  final String description;
  final List<String> tags;
  final String? github;
  final String? live;
  final List<String> images;
  final String? iconPath;

  const _ProjectDetailDialog({
    required this.title,
    required this.description,
    required this.tags,
    required this.github,
    required this.live,
    required this.images,
    this.iconPath,
  });

  @override
  State<_ProjectDetailDialog> createState() => _ProjectDetailDialogState();
}

class _ProjectDetailDialogState extends State<_ProjectDetailDialog> {
  // FIX: Controller lives here — created once, disposed properly.
  // This is the root cause of "Scrollbar's ScrollController has no
  // ScrollPosition attached." — an inline ScrollController() is constructed
  // fresh every build and never has time to attach before Scrollbar paints.
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      // FIX: Use constraints on the Dialog itself so it respects safe
      // areas and doesn't overflow on small screens / mobile web.
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: Responsive.value<double>(
            context,
            mobile: double.infinity,
            tablet: 600,
            desktop: 800,
          ),
          // FIX: maxHeight as fraction of screen so dialog never overflows
          // on short viewports (e.g. landscape mobile, small browser window).
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Header row ───────────────────────────────
              Row(
                children: [
                  if (widget.iconPath != null)
                    Container(
                      width: 40,
                      height: 40,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(widget.iconPath!, fit: BoxFit.cover),
                      ),
                    ),
                  Expanded(
                    child: Text(
                      widget.title,
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(fontSize: 22),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // ── Scrollable body ──────────────────────────
              // FIX: Pass the same _scrollController to BOTH Scrollbar
              // and SingleChildScrollView. This is what binds them together
              // and eliminates the "no ScrollPosition attached" crash.
              Flexible(
                child: Scrollbar(
                  controller: _scrollController,
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    padding: const EdgeInsets.only(right: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Description
                        Text(
                          widget.description,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 16),

                        // Tags
                        if (widget.tags.isNotEmpty)
                          Wrap(
                            spacing: 8,
                            runSpacing: 6,
                            children: widget.tags
                                .map(
                                  (tag) => Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: AppTheme.primaryColor
                                          .withValues(alpha: 0.08),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      tag,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppTheme.primaryColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),

                        // Screenshots section
                        // FIX: The original had broken if/else indentation —
                        // "Screenshots" text and ImageCarousel were ALWAYS
                        // shown even when images was empty. Wrapped correctly.
                        if (widget.images.isNotEmpty) ...[
                          const SizedBox(height: 24),
                          Text(
                            'Screenshots',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 12),
                          Center(
                            child: ImageCarousel(images: widget.images),
                          ),
                          const SizedBox(height: 12),
                          Center(
                            child: TextButton.icon(
                              onPressed: () => _openFullscreen(context),
                              icon: const Icon(Icons.fullscreen_rounded,
                                  size: 18),
                              label: const Text('View Fullscreen'),
                            ),
                          ),
                        ],

                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ── Action buttons ───────────────────────────
              Row(
                children: [
                  if (widget.github != null && widget.github!.isNotEmpty)
                    ElevatedButton.icon(
                      onPressed: () => _launch(widget.github!),
                      icon: const Icon(Icons.code),
                      label: const Text('GitHub'),
                    ),
                  if (widget.live != null && widget.live!.isNotEmpty) ...[
                    const SizedBox(width: 12),
                    OutlinedButton.icon(
                      onPressed: () => _launch(widget.live!),
                      icon: const Icon(Icons.open_in_new),
                      label: const Text('Live'),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openFullscreen(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.black,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          children: [
            Center(
              child: ImageCarousel(
                images: widget.images,
                isFullScreen: true,
              ),
            ),
            Positioned(
              top: 20,
              right: 20,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) launchUrl(uri);
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
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
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
                  ? AppTheme.primaryColor.withValues(alpha: 0.1)
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