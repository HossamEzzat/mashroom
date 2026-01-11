import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Reusable animated card wrapper with press animations and optional glassmorphism
class AnimatedCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final Gradient? gradient;
  final double borderRadius;
  final bool enableGlassmorphism;
  final bool enablePressAnimation;
  final bool elevated;

  const AnimatedCard({
    super.key,
    required this.child,
    this.onTap,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.color,
    this.gradient,
    this.borderRadius = AppTheme.radiusM,
    this.enableGlassmorphism = false,
    this.enablePressAnimation = true,
    this.elevated = true,
  });

  @override
  State<AnimatedCard> createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<AnimatedCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppTheme.animationFast,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _controller, curve: AppTheme.defaultCurve),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.enablePressAnimation && widget.onTap != null) {
      _controller.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.enablePressAnimation && widget.onTap != null) {
      _controller.reverse();
    }
  }

  void _handleTapCancel() {
    if (widget.enablePressAnimation && widget.onTap != null) {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: widget.width,
              height: widget.height,
              margin: widget.margin,
              padding: widget.padding,
              decoration: widget.enableGlassmorphism
                  ? AppTheme.glassmorphismDecoration(
                      radius: widget.borderRadius,
                    )
                  : AppTheme.enhancedCardDecoration(
                      color: widget.color,
                      radius: widget.borderRadius,
                      gradient: widget.gradient,
                      elevated: widget.elevated,
                    ),
              child: widget.child,
            ),
          );
        },
      ),
    );
  }
}
