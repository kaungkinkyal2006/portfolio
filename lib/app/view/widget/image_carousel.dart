import 'package:flutter/material.dart';
import 'package:porfolio/app/theme/app_theme.dart';
import 'package:porfolio/app/utils/responsive.dart';
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

  Widget _buildFrame(String img) {
    final isMobile = img.contains('mobile');
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;

    if (isMobile) {
      return SizedBox(
        width: widget.isFullScreen ? 280 : (isSmallScreen ? 140 : 160),
        height: widget.isFullScreen ? 560 : (isSmallScreen ? 300 : 360),
        child: IphoneFrameWidget(screenshotPath: img),
      );
    }

    // Desktop frame
    if (widget.isFullScreen) {
      return SizedBox(
        width: screenSize.width * 0.88,
        height: screenSize.height * 0.80,
        child: WindowFrame(
          child: Image.asset(img,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity),
        ),
      );
    }

    // Desktop frame in dialog — shrink on mobile screens
    final frameWidth = isSmallScreen ? screenSize.width - 80 : 480.0;
    final frameHeight = isSmallScreen ? frameWidth * 0.62 : 300.0;

    return SizedBox(
      width: frameWidth,
      height: frameHeight,
      child: WindowFrame(
        child: Image.asset(img,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasMultiple = widget.images.length > 1;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                Padding(
                  padding: hasMultiple
                      ? const EdgeInsets.symmetric(horizontal: 44)
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
                        child:
                            SlideTransition(position: slide, child: child),
                      );
                    },
                    child: KeyedSubtree(
                      key: ValueKey(_currentIndex),
                      child: _buildFrame(widget.images[_currentIndex]),
                    ),
                  ),
                ),
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
            const SizedBox(height: 12),
            if (hasMultiple)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(widget.images.length, (index) {
                  final active = index == _currentIndex;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: active ? 18 : 6,
                    height: 6,
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