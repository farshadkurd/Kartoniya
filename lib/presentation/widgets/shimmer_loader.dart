// lib/presentation/widgets/shimmer_loader.dart
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';

/// ✨ اسکلتون لودینگ با انیمیشن شیمر
class ShimmerCard extends StatelessWidget {
  const ShimmerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.primarySoft,
      highlightColor: AppColors.surface,
      period: const Duration(milliseconds: 1500),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // بخش تصویر
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(AppTheme.radiusLarge),
                    topRight: Radius.circular(AppTheme.radiusLarge),
                  ),
                ),
              ),
            ),
            // بخش متن
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // عنوان
                    Container(
                      width: double.infinity,
                      height: 12,
                      decoration: BoxDecoration(
                        color: AppColors.primarySoft,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // زیرعنوان
                    Row(
                      children: [
                        Container(
                          width: 50,
                          height: 10,
                          decoration: BoxDecoration(
                            color: AppColors.primarySoft,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          width: 30,
                          height: 10,
                          decoration: BoxDecoration(
                            color: AppColors.primarySoft,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ],
                    ),
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

/// ✨ لودینگ برای بخش بنر
class ShimmerBanner extends StatelessWidget {
  const ShimmerBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.primarySoft,
      highlightColor: AppColors.surface,
      period: const Duration(milliseconds: 1500),
      child: Container(
        width: double.infinity,
        height: 180,
        decoration: BoxDecoration(
          color: AppColors.primarySoft,
          borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        ),
      ),
    );
  }
}

/// ✨ لودینگ برای چیپ‌های دسته‌بندی
class ShimmerChip extends StatelessWidget {
  const ShimmerChip({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.primarySoft,
      highlightColor: AppColors.surface,
      child: Container(
        width: 70,
        height: 36,
        decoration: BoxDecoration(
          color: AppColors.primarySoft,
          borderRadius: BorderRadius.circular(AppTheme.radiusCircular),
        ),
      ),
    );
  }
}
