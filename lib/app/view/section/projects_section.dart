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
            mobile: 16,
            tablet: 60,
            desktop: 120,
          ),
          vertical: 60,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionHeading(),
            const SizedBox(height: 32),
            _TagFilter(ctrl: ctrl),
            const SizedBox(height: 32),
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
          spacing: 8,
          runSpacing: 8,
          children: ctrl.tags.map((tag) {
            final isSelected = ctrl.selectedTag.value == tag;
            return GestureDetector(
              onTap: () => ctrl.selectTag(tag),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
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
                    fontSize: 12,
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
    final isMobile = Responsive.isMobile(context);
    final crossCount = Responsive.value<int>(
      context,
      mobile: 1,
      tablet: 2,
      desktop: 3,
    );

    return Obx(() {
      final filtered = ctrl.filteredProjects;

      // On mobile use ListView instead of GridView — no aspect ratio issues
      if (isMobile) {
        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: filtered.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (_, index) => _ProjectCard(project: filtered[index]),
        );
      }

      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossCount,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: Responsive.value<double>(
            context,
            mobile: 1.0,
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
    final isMobile = Responsive.isMobile(context);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => _openDetailDialog(iconPath: iconPath),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.translationValues(0, _hovered ? -4 : 0, 0),
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
          // ── Mobile: row layout, Desktop: column layout ──
          child: isMobile
              ? _buildMobileCard(context, iconPath, title, tags, github, live)
              : _buildDesktopCard(context, iconPath, title, tags, github, live),
        ),
      ),
    );
  }

  // Mobile: horizontal layout — icon on left, info on right
  Widget _buildMobileCard(BuildContext context, String? iconPath, String title,
      List<String> tags, String? github, String? live) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          // Icon
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: iconPath != null
                  ? Colors.white
                  : AppTheme.primaryColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(16),
              boxShadow: iconPath != null
                  ? [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.10),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      )
                    ]
                  : [],
            ),
            child: iconPath != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: Image.asset(iconPath, fit: BoxFit.contain),
                    ),
                  )
                : Icon(Icons.folder_rounded,
                    size: 32,
                    color: AppTheme.primaryColor.withValues(alpha: 0.45)),
          ),
          const SizedBox(width: 14),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // Link buttons
                    if (github != null && github.isNotEmpty)
                      _IconLink(
                          icon: Icons.code_rounded,
                          url: github,
                          tooltip: 'GitHub'),
                    if (live != null && live.isNotEmpty) ...[
                      const SizedBox(width: 4),
                      _IconLink(
                          icon: Icons.open_in_new_rounded,
                          url: live,
                          tooltip: 'Live demo'),
                    ],
                  ],
                ),
                const SizedBox(height: 8),
                if (tags.isNotEmpty)
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: tags.map((tag) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withValues(alpha: 0.08),
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
        ],
      ),
    );
  }

  // Desktop: original column layout
  Widget _buildDesktopCard(BuildContext context, String? iconPath, String title,
      List<String> tags, String? github, String? live) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
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
                    color: AppTheme.primaryColor.withValues(alpha: 0.06)),
                Center(
                  child: iconPath != null
                      ? Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(22),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.12),
                                blurRadius: 16,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(22),
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Image.asset(iconPath,
                                  width: 90,
                                  height: 90,
                                  fit: BoxFit.contain),
                            ),
                          ),
                        )
                      : Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            color:
                                AppTheme.primaryColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: Icon(Icons.folder_rounded,
                              size: 48,
                              color: AppTheme.primaryColor
                                  .withValues(alpha: 0.45)),
                        ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Row(
                    children: [
                      if (github != null && github.isNotEmpty)
                        _IconLink(
                            icon: Icons.code_rounded,
                            url: github,
                            tooltip: 'GitHub'),
                      if (live != null && live.isNotEmpty) ...[
                        const SizedBox(width: 6),
                        _IconLink(
                            icon: Icons.open_in_new_rounded,
                            url: live,
                            tooltip: 'Live demo'),
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
            color: Theme.of(context).dividerColor.withValues(alpha: 0.12)),
        Expanded(
          flex: 2,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
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
                            horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withValues(alpha: 0.08),
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
        frameType: frameType,
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

  void _openIconFullscreen(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.92),
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              behavior: HitTestBehavior.opaque,
              child: const SizedBox.expand(),
            ),
            Center(
              child: InteractiveViewer(
                minScale: 0.5,
                maxScale: 4.0,
                child: Hero(
                  tag: 'project-icon-${widget.title}',
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.85,
                      maxHeight: MediaQuery.of(context).size.height * 0.85,
                    ),
                    child: Image.asset(
                      widget.iconPath!,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
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
    final isMobile = Responsive.isMobile(context);
    final screenHeight = MediaQuery.of(context).size.height;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: isMobile ? 12 : 40,
        vertical: isMobile ? 24 : 40,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: Responsive.value<double>(
            context,
            mobile: double.infinity,
            tablet: 600,
            desktop: 800,
          ),
          maxHeight: screenHeight * (isMobile ? 0.92 : 0.85),
        ),
        child: Container(
          padding: EdgeInsets.all(isMobile ? 16 : 24),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(isMobile ? 16 : 20),
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
              // ── Header ──────────────────────────────────
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.iconPath != null)
                    Tooltip(
                      message: 'View full size',
                      child: GestureDetector(
                        onTap: () => _openIconFullscreen(context),
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: Hero(
                            tag: 'project-icon-${widget.title}',
                            child: Container(
                              width: 40,
                              height: 40,
                              margin: const EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        Colors.black.withValues(alpha: 0.10),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(
                                  widget.iconPath!,
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.contain,
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
                          .titleLarge
                          ?.copyWith(
                            fontSize: isMobile ? 15 : 20,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ),
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // ── Scrollable body ──────────────────────────
              Flexible(
                child: Scrollbar(
                  controller: _scrollController,
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    padding: const EdgeInsets.only(right: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.description,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontSize: isMobile ? 13 : 14),
                        ),
                        const SizedBox(height: 12),
                        if (widget.tags.isNotEmpty)
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: widget.tags
                                .map((tag) => Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: AppTheme.primaryColor
                                            .withValues(alpha: 0.08),
                                        borderRadius:
                                            BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        tag,
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: AppTheme.primaryColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ),
                        if (widget.images.isNotEmpty) ...[
                          const SizedBox(height: 20),
                          Text('Screenshots',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontSize: isMobile ? 13 : 15)),
                          const SizedBox(height: 10),
                          Center(
                            child: ImageCarousel(images: widget.images),
                          ),
                          const SizedBox(height: 8),
                          Center(
                            child: TextButton.icon(
                              onPressed: () => _openFullscreen(context),
                              icon: const Icon(Icons.fullscreen_rounded,
                                  size: 16),
                              label: const Text('View Fullscreen',
                                  style: TextStyle(fontSize: 12)),
                            ),
                          ),
                        ],
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // ── Action buttons ───────────────────────────
              Row(
                children: [
                  if (widget.github != null && widget.github!.isNotEmpty)
                    ElevatedButton.icon(
                      onPressed: () => _launch(widget.github!),
                      icon: const Icon(Icons.code, size: 16),
                      label: const Text('GitHub'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        textStyle: const TextStyle(fontSize: 13),
                      ),
                    ),
                  if (widget.live != null && widget.live!.isNotEmpty) ...[
                    const SizedBox(width: 10),
                    OutlinedButton.icon(
                      onPressed: () => _launch(widget.live!),
                      icon: const Icon(Icons.open_in_new, size: 16),
                      label: const Text('Live'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        textStyle: const TextStyle(fontSize: 13),
                      ),
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