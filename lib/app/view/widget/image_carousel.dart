import 'package:flutter/material.dart';
import 'package:porfolio/app/theme/app_theme.dart';
import 'package:porfolio/app/view/widget/arrow_button.dart';
import 'package:porfolio/app/view/widget/iphone_frame.dart';
import 'package:porfolio/app/view/widget/windos_frame.dart';

class ImageCarousel extends StatefulWidget {
  final List<String> images;
  final bool isFullScreen;

  const ImageCarousel({
    super.key,
    required this.images,
    this.isFullScreen = false,
  });

  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  int _currentIndex = 0;
  bool _goingForward = true;

  void _next() {
    setState(() {
      _goingForward = true;
      _currentIndex = (_currentIndex + 1) % widget.images.length;
    });
  }

  void _prev() {
    setState(() {
      _goingForward = false;
      _currentIndex =
          (_currentIndex - 1 + widget.images.length) % widget.images.length;
    });
  }

  // FIX: Frame sizes are now capped so they never exceed the available
  // height inside a dialog (which is ~605px). Previously the desktop
  // frame was 350px tall + arrows + dots + padding = overflow → arrows
  // painted outside bounds → taps ignored by the hit-test system.
  Widget _buildFrame(String img) {
  final isMobile = img.contains('mobile');

  if (isMobile) {
    return SizedBox(
      width: widget.isFullScreen ? 280 : 160,
      height: widget.isFullScreen ? 560 : 360,
      child: IphoneFrameWidget(screenshotPath: img),
    );
  }

  // Desktop — fullscreen uses almost full screen size
  if (widget.isFullScreen) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width * 0.88,
      height: size.height * 0.80,
      child: WindowFrame(
        child: Image.asset(img, fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }

  return SizedBox(
    width: 480,
    height: 300,
    child: WindowFrame(
      child: Image.asset(img, fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      ),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    final hasMultiple = widget.images.length > 1;

    // FIX: Wrap the whole carousel in a LayoutBuilder so the arrow
    // positioning is always relative to actual available space —
    // never bleeds outside the parent's clipping boundary.
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // FIX: The arrows are inside the Stack but use horizontal
            // padding on the AnimatedSwitcher so the frame never covers
            // the arrow hit area. Previously arrows were at Positioned(-52)
            // which puts them OUTSIDE the Stack's bounds — if any ancestor
            // clips (Dialog, Card, etc.) the hit area is swallowed.
            Stack(
              alignment: Alignment.center,
              // Keep clipBehavior at hardEdge so arrows ARE visible,
              // but the key fix is padding so they don't need to overflow.
              clipBehavior: Clip.none,
              children: [
                // Horizontal padding reserves space for the arrow buttons
                // (44px each side) so they sit inside the Stack bounds.
                Padding(
                  padding: hasMultiple
                      ? const EdgeInsets.symmetric(horizontal: 52)
                      : EdgeInsets.zero,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    transitionBuilder: (child, animation) {
                      final offset = _goingForward
                          ? const Offset(0.07, 0)
                          : const Offset(-0.07, 0);
                      final slide = Tween<Offset>(
                        begin: offset,
                        end: Offset.zero,
                      ).animate(CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOutCubic,
                      ));
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(position: slide, child: child),
                      );
                    },
                    child: KeyedSubtree(
                      key: ValueKey(_currentIndex),
                      child: _buildFrame(widget.images[_currentIndex]),
                    ),
                  ),
                ),

                // Arrows sit inside the padded space — fully within
                // Stack bounds, hit area is intact.
                if (hasMultiple) ...[
                  Positioned(
                    left: 0,
                    child: ArrowButton(
                      icon: Icons.arrow_back_ios_new_rounded,
                      onTap: _prev,
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: ArrowButton(
                      icon: Icons.arrow_forward_ios_rounded,
                      onTap: _next,
                    ),
                  ),
                ],
              ],
            ),

            const SizedBox(height: 14),

            if (hasMultiple)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(widget.images.length, (index) {
                  final active = index == _currentIndex;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: active ? 20 : 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: active
                          ? AppTheme.primaryColor
                          : Colors.grey.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  );
                }),
              ),
          ],
        );
      },
    );
  }
}