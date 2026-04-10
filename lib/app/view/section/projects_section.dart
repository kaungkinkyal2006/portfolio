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
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: Responsive.value<double>(
            context,
            mobile: 2.4,
            tablet: 0.88,
            desktop: 0.92,
          ),
        ),
        itemCount: filtered.length,
        itemBuilder: (_, index) => _ProjectCard(project: filtered[index]),
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
                    ? AppTheme.primaryColor.withValues(alpha: 0.10)
                    : Colors.black.withValues(alpha: 0.04),
                blurRadius: _hovered ? 24 : 8,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Icon zone ────────────────────────────────
              Expanded(
                flex: 3,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(
                        color: AppTheme.primaryColor.withValues(alpha: 0.06),
                      ),
                      Center(
                        child: iconPath != null
                            ? Container(
                                width: 90,
                                height: 90,
                                decoration: BoxDecoration(
                                  color:Colors.white,
                                  borderRadius: BorderRadius.circular(22),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Colors.black.withValues(alpha: 0.12),
                                      blurRadius: 16,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(22),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.asset(
                                      iconPath,
                                      width: 90,
                                      height: 90,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              )
                            : Container(
                                width: 90,
                                height: 90,
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryColor
                                      .withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(22),
                                ),
                                child: Icon(
                                  Icons.folder_rounded,
                                  size: 48,
                                  color: AppTheme.primaryColor
                                      .withValues(alpha: 0.45),
                                ),
                              ),
                      ),
                      // Link buttons
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Row(
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
                      ),
                    ],
                  ),
                ),
              ),

              Container(
                height: 0.5,
                color: Theme.of(context).dividerColor.withValues(alpha: 0.12),
              ),

              // ── Info zone ────────────────────────────────
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  height: 1.35,
                                ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      if (tags.isNotEmpty)
                        Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          children: tags.map((tag) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 7,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor
                                    .withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                tag,
                                style: const TextStyle(
                                  fontSize: 10,
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
    final frameType = widget.project['frameType'] as String? ?? 'mobile';

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
        frameType: frameType
      ),
    );
  }
}

// ── Detail dialog ──────────────────────────────────────────
class _ProjectDetailDialog extends StatefulWidget {
  final String title;
  final String description;
  final List<String> tags;
  final String? github;
  final String? live;
  final List<String> images;
  final String? iconPath;
  final String frameType;

  const _ProjectDetailDialog({
    required this.title,
    required this.description,
    required this.tags,
    required this.github,
    required this.live,
    required this.images,
    this.iconPath,
    this.frameType = 'mobile',
  });

  @override
  State<_ProjectDetailDialog> createState() => _ProjectDetailDialogState();
}

class _ProjectDetailDialogState extends State<_ProjectDetailDialog> {
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

  // Opens a full-black overlay showing the icon large and centred.
  void _openIconFullscreen(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.92),
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          children: [
            // Tapping the background closes the dialog
            GestureDetector(
              onTap: () => Navigator.pop(context),
              behavior: HitTestBehavior.opaque,
              child: const SizedBox.expand(),
            ),
            // Centred icon — InteractiveViewer lets user pinch-zoom
            Center(
              child: InteractiveViewer(
                minScale: 0.5,
                maxScale: 4.0,
                child: Hero(
                  tag: 'project-icon-${widget.title}',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: Image.asset(
                      widget.iconPath!,
                      width: 260,
                      height: 260,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
            // Close button
            Positioned(
              top: 20,
              right: 20,
              child: Material(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () => Navigator.pop(context),
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(Icons.close, color: Colors.white, size: 20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: Responsive.value<double>(
            context,
            mobile: double.infinity,
            tablet: 600,
            desktop: 800,
          ),
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
              // ── Header ───────────────────────────────────
              Row(
                children: [
                  if (widget.iconPath != null)
                    // Tappable icon — opens fullscreen viewer
                    Tooltip(
                      message: 'View full size',
                      child: GestureDetector(
                        onTap: () => _openIconFullscreen(context),
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: Hero(
                            tag: 'project-icon-${widget.title}',
                            child: Container(
                              width: 44,
                              height: 44,
                              margin: const EdgeInsets.only(right: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.10),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  widget.iconPath!,
                                  width: 44,
                                  height: 44,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
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
                        Text(
                          widget.description,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 16),
                        if (widget.tags.isNotEmpty)
                          Wrap(
                            spacing: 8,
                            runSpacing: 6,
                            children: widget.tags
                                .map(
                                  (tag) => Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
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
                              icon: const Icon(
                                Icons.fullscreen_rounded,
                                size: 18,
                              ),
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

// ── Icon link button (overlaid on card icon zone) ──────────
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
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: _hovered
                  ? Theme.of(context).colorScheme.surface
                  : Theme.of(context)
                      .colorScheme
                      .surface
                      .withValues(alpha: 0.80),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color:
                    Theme.of(context).dividerColor.withValues(alpha: 0.15),
                width: 0.5,
              ),
            ),
            child: Icon(
              widget.icon,
              size: 15,
              color: _hovered
                  ? AppTheme.primaryColor
                  : Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.color
                      ?.withValues(alpha: 0.6),
            ),
          ),
        ),
      ),
    );
  }
}