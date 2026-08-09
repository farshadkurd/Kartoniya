import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import '../../data/models/cartoon_model.dart';

/// تصویرسازی برداری سبک برای کاتالوگ. این راهکار از دریافت تصویر تصادفی و
/// نامناسب برای کودک جلوگیری می‌کند و با هر اندازهٔ نمایش سازگار است.
class CartoonArtwork extends StatelessWidget {
  const CartoonArtwork({
    super.key,
    required this.cartoon,
    this.borderRadius = AppTheme.radiusLarge,
    this.showPlayAffordance = true,
    this.showTitle = false,
  });

  final CartoonModel cartoon;
  final double borderRadius;
  final bool showPlayAffordance;
  final bool showTitle;

  @override
  Widget build(BuildContext context) {
    final baseColor = cartoon.artworkColor;
    final lightColor = Color.lerp(baseColor, Colors.white, .38)!;
    final darkColor = Color.lerp(baseColor, const Color(0xFF171426), .18)!;

    return Semantics(
      image: true,
      label: 'تصویرسازی ${cartoon.title}',
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [lightColor, baseColor, darkColor],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned(
                top: -28,
                right: -20,
                child: _Bubble(color: Colors.white.withOpacity(.20), size: 118),
              ),
              Positioned(
                bottom: -44,
                left: -12,
                child: _Bubble(color: Colors.white.withOpacity(.12), size: 144),
              ),
              Positioned(
                top: 20,
                left: 20,
                child: Transform.rotate(
                  angle: -.28,
                  child: Icon(
                    Icons.auto_awesome_rounded,
                    color: Colors.white.withOpacity(.70),
                    size: 22,
                  ),
                ),
              ),
              Center(
                child: Transform.rotate(
                  angle: cartoon.id.hashCode.isEven ? -.05 : .05,
                  child: Container(
                    width: 96,
                    height: 96,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.22),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white.withOpacity(.35)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.12),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Text(
                      cartoon.artworkEmoji,
                      style: const TextStyle(fontSize: 52, height: 1),
                    ),
                  ),
                ),
              ),
              if (cartoon.isNew)
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.92),
                      borderRadius:
                          BorderRadius.circular(AppTheme.radiusCircular),
                    ),
                    child: Text(
                      'جدید',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: baseColor,
                            fontSize: 11,
                          ),
                    ),
                  ),
                ),
              if (showPlayAffordance)
                Positioned(
                  bottom: 12,
                  left: 12,
                  child: Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.92),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.play_arrow_rounded,
                      color: baseColor,
                      size: 23,
                    ),
                  ),
                ),
              if (showTitle)
                Positioned(
                  right: 14,
                  left: 14,
                  bottom: 14,
                  child: Text(
                    cartoon.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          shadows: const [
                            Shadow(color: Colors.black38, blurRadius: 5),
                          ],
                        ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: math.pi / 7,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }
}
