import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../core/theme/app_theme.dart';

class ShimmerCard extends StatelessWidget {
  const ShimmerCard({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Shimmer.fromColors(
      baseColor: scheme.surfaceVariant,
      highlightColor: scheme.surface,
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: compact ? 1.55 : 1.42,
              child: const _Block(),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    _Block(width: double.infinity, height: 14),
                    _Block(width: 76, height: 11),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShimmerBanner extends StatelessWidget {
  const ShimmerBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Shimmer.fromColors(
      baseColor: scheme.surfaceVariant,
      highlightColor: scheme.surface,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        child: const _Block(),
      ),
    );
  }
}

class _Block extends StatelessWidget {
  const _Block({this.width, this.height});

  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
