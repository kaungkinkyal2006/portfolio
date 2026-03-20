import 'package:flutter/material.dart' hide HeroController;
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:porfolio/app/controllers/hero_controller.dart';
import 'package:porfolio/app/data/porfolio_data.dart';
import 'package:porfolio/app/theme/app_theme.dart';
import 'package:porfolio/app/utils/responsive.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<HeroController>();

    return FadeTransition(
      opacity: ctrl.fadeAnim,
      child: SlideTransition(
        position: ctrl.slideAnim,
        child: Container(
          width: double.infinity,
          // Min height fills the screen below the navbar
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height - 70,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: Responsive.value<double>(
              context, mobile: 24, tablet: 60, desktop: 120,
            ),
            vertical: 80,
          ),
          child: Responsive.isDesktop(context)
              ? _DesktopLayout(ctrl: ctrl)
              : _MobileLayout(ctrl: ctrl),
        ),
      ),
    );
  }
}

// ── Desktop: text left, avatar right ──────────────────────
class _DesktopLayout extends StatelessWidget {
  final HeroController ctrl;
  const _DesktopLayout({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(flex: 3, child: _TextContent(ctrl: ctrl)),
        const SizedBox(width: 60),
        Expanded(flex: 2, child: _AvatarCard()),
      ],
    );
  }
}

// ── Mobile: stacked ────────────────────────────────────────
class _MobileLayout extends StatelessWidget {
  final HeroController ctrl;
  const _MobileLayout({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const _AvatarCard(),
        const SizedBox(height: 40),
        _TextContent(ctrl: ctrl),
      ],
    );
  }
}

// ── Text content ───────────────────────────────────────────
class _TextContent extends StatelessWidget {
  final HeroController ctrl;
  const _TextContent({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    return Column(
      crossAxisAlignment: isDesktop
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Greeting chip
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppTheme.primaryColor.withOpacity(0.3),
            ),
          ),
          child: Text(
            '👋  Hello, world!',
            style: TextStyle(
              fontSize: 13,
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Name
        Text(
          PortfolioData.name,
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
            fontSize: isDesktop ? 56 : 36,
          ),
          textAlign: isDesktop ? TextAlign.left : TextAlign.center,
        ),

        const SizedBox(height: 12),

        // Typed role text
        Obx(() => Row(
          mainAxisAlignment: isDesktop
              ? MainAxisAlignment.start
              : MainAxisAlignment.center,
          children: [
            Text(
              'I am a ',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w400,
                fontSize: isDesktop ? 26 : 20,
              ),
            ),
            Text(
              ctrl.displayedText.value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppTheme.primaryColor,
                fontSize: isDesktop ? 26 : 20,
              ),
            ),
            // Blinking cursor
            _BlinkingCursor(),
          ],
        )),

        const SizedBox(height: 24),

        // Description
        SizedBox(
          width: isDesktop ? 480 : double.infinity,
          child: Text(
            PortfolioData.description,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: isDesktop ? TextAlign.left : TextAlign.center,
          ),
        ),

        const SizedBox(height: 40),

        // CTA buttons
        Wrap(
          spacing: 16,
          runSpacing: 12,
          alignment: isDesktop ? WrapAlignment.start : WrapAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () => _launch(PortfolioData.resumeUrl),
              icon: const Icon(Icons.download_rounded, size: 18),
              label: const Text('Download CV'),
            ),
            OutlinedButton.icon(
              onPressed: () => _launch(PortfolioData.github),
              icon: const Icon(Icons.code_rounded, size: 18),
              label: const Text('GitHub'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.primaryColor,
                side: BorderSide(color: AppTheme.primaryColor),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24, vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 40),

        // Social icons row
        Row(
          mainAxisAlignment: isDesktop
              ? MainAxisAlignment.start
              : MainAxisAlignment.center,
          children: [
            _SocialIcon(
              icon: Icons.email_outlined,
              onTap: () => _launch('mailto:${PortfolioData.email}'),
            ),
            const SizedBox(width: 12),
            _SocialIcon(
              icon: Icons.link_rounded,
              onTap: () => _launch(PortfolioData.linkedin),
            ),
            const SizedBox(width: 12),
            _SocialIcon(
              icon: Icons.code_rounded,
              onTap: () => _launch(PortfolioData.github),
            ),
          ],
        ),
      ],
    );
  }

  void _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) launchUrl(uri);
  }
}

// ── Avatar card ────────────────────────────────────────────
class _AvatarCard extends StatelessWidget {
  const _AvatarCard();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 280,
        height: 280,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.primaryColor.withOpacity(0.8),
              AppTheme.secondaryColor.withOpacity(0.8),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryColor.withOpacity(0.3),
              blurRadius: 40,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        // Replace with your actual photo:
        // child: ClipOval(child: Image.asset('assets/photo.jpg', fit: BoxFit.cover))
        child: const Icon(Icons.person_rounded, size: 120, color: Colors.white),
      ),
    );
  }
}

// ── Blinking cursor ────────────────────────────────────────
class _BlinkingCursor extends StatefulWidget {
  @override
  State<_BlinkingCursor> createState() => _BlinkingCursorState();
}

class _BlinkingCursorState extends State<_BlinkingCursor>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _ctrl,
      child: Text(
        '|',
        style: TextStyle(
          color: AppTheme.primaryColor,
          fontSize: 26,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }
}

// ── Social icon button ─────────────────────────────────────
class _SocialIcon extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _SocialIcon({required this.icon, required this.onTap});

  @override
  State<_SocialIcon> createState() => _SocialIconState();
}

class _SocialIconState extends State<_SocialIcon> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _hovered
                ? AppTheme.primaryColor
                : AppTheme.primaryColor.withOpacity(0.1),
            border: Border.all(
              color: AppTheme.primaryColor.withOpacity(0.3),
            ),
          ),
          child: Icon(
            widget.icon,
            size: 20,
            color: _hovered ? Colors.white : AppTheme.primaryColor,
          ),
        ),
      ),
    );
  }
}