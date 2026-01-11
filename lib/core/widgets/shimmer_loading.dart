import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Shimmer loading effect for skeleton screens
class ShimmerLoading extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;
  final ShimmerShape shape;

  const ShimmerLoading({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = AppTheme.radiusM,
    this.shape = ShimmerShape.rectangle,
  });

  /// Preset for card shimmer
  const ShimmerLoading.card({
    super.key,
    this.width = double.infinity,
    this.height = 120,
    this.borderRadius = AppTheme.radiusM,
  }) : shape = ShimmerShape.rectangle;

  /// Preset for circular shimmer (avatars, icons)
  const ShimmerLoading.circle({super.key, required double size})
    : width = size,
      height = size,
      borderRadius = 999,
      shape = ShimmerShape.circle;

  /// Preset for text line shimmer
  const ShimmerLoading.text({
    super.key,
    this.width = double.infinity,
    this.height = 16,
    this.borderRadius = 4,
  }) : shape = ShimmerShape.rectangle;

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: widget.shape == ShimmerShape.circle
                ? null
                : BorderRadius.circular(widget.borderRadius),
            shape: widget.shape == ShimmerShape.circle
                ? BoxShape.circle
                : BoxShape.rectangle,
            gradient: LinearGradient(
              colors: const [
                Color(0xFFE0E0E0),
                Color(0xFFF5F5F5),
                Color(0xFFE0E0E0),
              ],
              stops: const [0.0, 0.5, 1.0],
              begin: Alignment(-1.0 + _controller.value * 2, -0.3),
              end: Alignment(1.0 + _controller.value * 2, 0.3),
            ),
          ),
        );
      },
    );
  }
}

enum ShimmerShape { rectangle, circle }

/// Multiple shimmer items for list loading
class ShimmerList extends StatelessWidget {
  final int itemCount;
  final double itemHeight;
  final double spacing;

  const ShimmerList({
    super.key,
    this.itemCount = 3,
    this.itemHeight = 100,
    this.spacing = 16,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      separatorBuilder: (context, index) => SizedBox(height: spacing),
      itemBuilder: (context, index) {
        return ShimmerLoading(width: double.infinity, height: itemHeight);
      },
    );
  }
}
