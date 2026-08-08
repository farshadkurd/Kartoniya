// lib/presentation/pages/favorites_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/cartoon_model.dart';
import '../../data/providers/cartoons_provider.dart';
import '../widgets/cartoon_card.dart';
import '../widgets/shimmer_loader.dart';
import 'cartoon_detail_page.dart';

/// ❤️ صفحه علاقه‌مندی‌ها
class FavoritesPage extends ConsumerWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);
    final cartoonsAsync = ref.watch(cartoonsProvider);

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // هدر
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: AppColors.warmGradient,
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  ),
                  child: const Icon(
                    Icons.favorite_rounded,
                    color: AppColors.textOnPrimary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'علاقه‌مندی‌ها',
                  style: TextStyle(
                    fontFamily: GoogleFonts.vazirmatn().fontFamily,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                if (favorites.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.accent5.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(
                        AppTheme.radiusCircular,
                      ),
                    ),
                    child: Text(
                      '${favorites.length}',
                      style: TextStyle(
                        fontFamily: GoogleFonts.vazirmatn().fontFamily,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.accent5,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // محتوا
          Expanded(
            child: cartoonsAsync.when(
              data: (cartoons) {
                final favoriteCartoons = cartoons
                    .where((c) => favorites.contains(c.id))
                    .toList();

                if (favoriteCartoons.isEmpty) {
                  return _buildEmptyState();
                }

                return GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: favoriteCartoons.length,
                  itemBuilder: (context, index) {
                    return CartoonCard(
                      cartoon: favoriteCartoons[index],
                      index: index,
                      onTap: () => _navigateToDetail(
                        context,
                        favoriteCartoons[index],
                      ),
                    );
                  },
                );
              },
              loading: () => GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.75,
                ),
                itemCount: 6,
                itemBuilder: (context, index) => const ShimmerCard(),
              ),
              error: (e, s) => _buildEmptyState(),
            ),
          ),
        ],
      ),
    );
  }

  /// حالت خالی
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // انیمیشن قلب
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.8, end: 1.0),
            duration: const Duration(seconds: 2),
            curve: Curves.easeInOut,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: child,
              );
            },
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.accent5.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.favorite_border_rounded,
                size: 60,
                color: AppColors.accent5,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'هنوز علاقه‌مندی نداری!',
            style: TextStyle(
              fontFamily: GoogleFonts.vazirmatn().fontFamily,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'روی قلب ❤️ کارتون‌ها بزن\nتا اینجا ذخیره بشن',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: GoogleFonts.vazirmatn().fontFamily,
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToDetail(BuildContext context, CartoonModel cartoon) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            CartoonDetailPage(cartoon: cartoon),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            ),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }
}
