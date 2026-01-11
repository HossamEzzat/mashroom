import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

enum ButtonVariant { primary, secondary, gradient, outline, ghost }

class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final bool isLoading;
  final IconData? icon;
  final double? width;
  final double? height;
  final Gradient? gradient;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = ButtonVariant.primary,
    this.isLoading = false,
    this.icon,
    this.width,
    this.height,
    this.gradient,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.0,
      upperBound: 0.05, // Shrinks by 5%
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _isEnabled => widget.onPressed != null && !widget.isLoading;

  void _handleTapDown(TapDownDetails details) =>
      _isEnabled ? _controller.forward() : null;
  void _handleTapUp(TapUpDetails details) =>
      _isEnabled ? _controller.reverse() : null;
  void _handleTapCancel() => _isEnabled ? _controller.reverse() : null;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: _isEnabled ? 1.0 : 0.6,
          child: SizedBox(
            width: widget.width ?? double.infinity,
            height: widget.height ?? 56,
            child: _buildButtonBody(context),
          ),
        ),
      ),
    );
  }

  Widget _buildButtonBody(BuildContext context) {
    final bool isGradient = widget.variant == ButtonVariant.gradient;

    // We use DecoratedBox + Material for the "Gradient" look
    // but keep standard ElevatedButton for others to respect Theme.
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        gradient: isGradient
            ? (widget.gradient ?? AppColors.primaryGradient)
            : null,
        boxShadow: _getShadows(),
      ),
      child: ElevatedButton(
        onPressed: _isEnabled
            ? () {
                HapticFeedback.lightImpact();
                widget.onPressed?.call();
              }
            : null,
        style: _getButtonStyle(context),
        child: widget.isLoading ? _buildLoader() : _buildContent(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.icon != null) ...[
          Icon(widget.icon, size: 20),
          const SizedBox(width: 8),
        ],
        Text(
          widget.text,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildLoader() {
    return const SizedBox(
      height: 24,
      width: 24,
      child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
    );
  }

  List<BoxShadow>? _getShadows() {
    if (widget.variant == ButtonVariant.outline ||
        widget.variant == ButtonVariant.ghost ||
        !_isEnabled) {
      return null;
    }
    return [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ];
  }

  ButtonStyle _getButtonStyle(BuildContext context) {
    final theme = Theme.of(context);

    return ElevatedButton.styleFrom(
      backgroundColor: _getBgColor(),
      foregroundColor: _getFgColor(),
      elevation: 0, // Handled by DecoratedBox for more control
      shadowColor: Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
      ),
      side: widget.variant == ButtonVariant.outline
          ? const BorderSide(color: AppColors.primary, width: 1.5)
          : null,
    ).copyWith(
      // Prevents splash from going outside corners
      splashFactory: InkRipple.splashFactory,
    );
  }

  Color? _getBgColor() {
    switch (widget.variant) {
      case ButtonVariant.primary:
        return AppColors.primary;
      case ButtonVariant.secondary:
        return AppColors.secondary;
      case ButtonVariant.outline:
      case ButtonVariant.ghost:
      case ButtonVariant.gradient:
        return Colors.transparent;
    }
  }

  Color _getFgColor() {
    switch (widget.variant) {
      case ButtonVariant.outline:
      case ButtonVariant.ghost:
        return AppColors.primary;
      default:
        return Colors.white;
    }
  }
}
