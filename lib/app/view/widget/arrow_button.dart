import 'package:flutter/material.dart';

class ArrowButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;

  const ArrowButton({
    super.key,
    required this.icon,
    required this.onTap,
  });

  @override
  State<ArrowButton> createState() => _ArrowButtonState();
}

// FIX 1: Converted to StatefulWidget to support hover state.
// FIX 2: Replaced Material+InkWell (causes z-index/clipping issues
// inside a Stack with clipBehavior: Clip.none) with GestureDetector
// + AnimatedContainer for a smooth, self-contained button.
// FIX 3: withOpacity deprecated → withValues(alpha:)
class _ArrowButtonState extends State<ArrowButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _hovered
                ? Colors.black.withValues(alpha: 0.65)
                : Colors.black.withValues(alpha: 0.35),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: _hovered ? 0.4 : 0.2),
                blurRadius: _hovered ? 14 : 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: AnimatedScale(
            scale: _hovered ? 1.1 : 1.0,
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            child: Icon(
              widget.icon,
              size: 16,
              color: Colors.white.withValues(alpha: _hovered ? 1.0 : 0.85),
            ),
          ),
        ),
      ),
    );
  }
}