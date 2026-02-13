import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';

class GlassContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsets? padding;
  final EdgeInsets? margin;

  const GlassContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
  width: width ?? double.infinity,
  height: height ?? 200, 
  borderRadius: 20,
  blur: 20,
  alignment: Alignment.center,
  border: 2,
  linearGradient: LinearGradient(
    colors: [
      Colors.white.withOpacity(0.2),
      Colors.white.withOpacity(0.1),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),
  borderGradient: LinearGradient(
    colors: [
      Colors.white.withOpacity(0.5),
      Colors.white.withOpacity(0.2),
    ],
  ),
  margin: margin,
  child: Padding(
    padding: padding ?? const EdgeInsets.all(16),
    child: child,
  ),
);
  }
}