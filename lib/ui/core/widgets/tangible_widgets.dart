import 'package:flutter/material.dart';
import '../../../services/haptic_service.dart';
import '../theme/app_theme.dart';



class TangibleButton extends StatefulWidget {
  const TangibleButton({
    super.key,
    required this.child,
    this.onPressed,
    this.color,
    this.bevelColor,
    this.height = 56,
    this.width,
    this.elevation = 5,
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
    this.padding = const EdgeInsets.symmetric(horizontal: 24),
  });

  final Widget child;
  final VoidCallback? onPressed;
  final Color? color;
  final Color? bevelColor;
  final double height;
  final double? width;
  final double elevation;
  final BorderRadius borderRadius;
  final EdgeInsetsGeometry padding;

  @override
  State<TangibleButton> createState() => _TangibleButtonState();
}

class _TangibleButtonState extends State<TangibleButton> {
  bool _isPressed = false;

  void _onTapDown(TapDownDetails _) {
    if (widget.onPressed == null) return;
    HapticService.light();
    setState(() => _isPressed = true);
  }

  void _onTapUp(TapUpDetails _) {
    if (widget.onPressed == null) return;
    setState(() => _isPressed = false);
    widget.onPressed!();
  }

  void _onTapCancel() {
    if (widget.onPressed == null) return;
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final bool isEnabled = widget.onPressed != null;
    final Color currentColor = isEnabled ? (widget.color ?? colors.mint) : colors.locked;
    final Color currentBevel = isEnabled ? (widget.bevelColor ?? colors.mintBevel) : colors.lockedBevel;
    final double currentElevation = isEnabled ? (_isPressed ? 1.0 : widget.elevation) : 2.0;

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              top: widget.elevation,
              child: Container(
                decoration: BoxDecoration(
                  color: currentBevel,
                  borderRadius: widget.borderRadius,
                ),
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 60),
              curve: Curves.easeOut,
              left: 0,
              right: 0,
              top: widget.elevation - currentElevation,
              bottom: currentElevation,
              child: Container(
                padding: widget.padding,
                decoration: BoxDecoration(
                  color: currentColor,
                  borderRadius: widget.borderRadius,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.35),
                    width: 1.5,
                  ),
                ),
                alignment: Alignment.center,
                child: widget.child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TangibleIconButton extends StatefulWidget {
  const TangibleIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.color,
    this.bevelColor,
    this.iconColor,
    this.size = 46,
    this.elevation = 4,
    this.borderRadius = const BorderRadius.all(Radius.circular(15)),
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final Color? color;
  final Color? bevelColor;
  final Color? iconColor;
  final double size;
  final double elevation;
  final BorderRadius borderRadius;

  @override
  State<TangibleIconButton> createState() => _TangibleIconButtonState();
}

class _TangibleIconButtonState extends State<TangibleIconButton> {
  bool _isPressed = false;

  void _onTapDown(TapDownDetails _) {
    if (widget.onPressed == null) return;
    HapticService.light();
    setState(() => _isPressed = true);
  }

  void _onTapUp(TapUpDetails _) {
    if (widget.onPressed == null) return;
    setState(() => _isPressed = false);
    widget.onPressed!();
  }

  void _onTapCancel() {
    if (widget.onPressed == null) return;
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final bool isEnabled = widget.onPressed != null;
    final Color currentColor = isEnabled ? (widget.color ?? colors.card) : colors.locked;
    final Color currentBevel = isEnabled ? (widget.bevelColor ?? colors.bevel) : colors.lockedBevel;
    final Color currentIconColor = isEnabled ? (widget.iconColor ?? colors.text) : colors.lockedText;
    final double currentElevation = isEnabled ? (_isPressed ? 1.0 : widget.elevation) : 2.0;

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              top: widget.elevation,
              child: Container(
                decoration: BoxDecoration(
                  color: currentBevel,
                  borderRadius: widget.borderRadius,
                ),
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 60),
              curve: Curves.easeOut,
              left: 0,
              right: 0,
              top: widget.elevation - currentElevation,
              bottom: currentElevation,
              child: Container(
                decoration: BoxDecoration(
                  color: currentColor,
                  borderRadius: widget.borderRadius,
                  border: Border.all(
                    color: colors.border,
                    width: 1.5,
                  ),
                ),
                alignment: Alignment.center,
                child: Icon(
                  widget.icon,
                  color: currentIconColor,
                  size: widget.size * 0.52,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TangibleBadge extends StatelessWidget {
  const TangibleBadge({
    super.key,
    required this.child,
    this.color,
    this.bevelColor,
    this.elevation = 3,
    this.padding = const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
  });

  final Widget child;
  final Color? color;
  final Color? bevelColor;
  final double elevation;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final badgeColor = color ?? colors.card;
    final badgeBevel = bevelColor ?? colors.bevel;

    return Container(
      decoration: BoxDecoration(
        color: badgeBevel,
        borderRadius: borderRadius,
      ),
      child: Container(
        margin: EdgeInsets.only(bottom: elevation),
        padding: padding,
        decoration: BoxDecoration(
          color: badgeColor,
          borderRadius: borderRadius,
          border: Border.all(
            color: colors.border,
            width: 1.5,
          ),
        ),
        child: child,
      ),
    );
  }
}

class TangibleCard extends StatelessWidget {
  const TangibleCard({
    super.key,
    required this.child,
    this.color,
    this.bevelColor,
    this.elevation = 4,
    this.borderRadius = const BorderRadius.all(Radius.circular(24)),
    this.padding = const EdgeInsets.all(20),
    this.borderWidth = 1.5,
  });

  final Widget child;
  final Color? color;
  final Color? bevelColor;
  final double elevation;
  final BorderRadius borderRadius;
  final EdgeInsetsGeometry padding;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final cardColor = color ?? colors.card;
    final cardBevel = bevelColor ?? colors.bevel;

    return Container(
      decoration: BoxDecoration(
        color: cardBevel,
        borderRadius: borderRadius,
      ),
      child: Container(
        margin: EdgeInsets.only(bottom: elevation),
        padding: padding,
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: borderRadius,
          border: Border.all(
            color: colors.border,
            width: borderWidth,
          ),
        ),
        child: child,
      ),
    );
  }
}
