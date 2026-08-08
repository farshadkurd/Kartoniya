// lib/presentation/widgets/cartoon_card.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/cartoon_model.dart';
import '../../data/providers/cartoons_provider.dart';

/// 🎴 کارت کارتون با انیمیشن و تعامل
class CartoonCard extends ConsumerStatefulWidget {
  final CartoonModel cartoon;
  final VoidCallback onTap;
  final int index;

  const CartoonCard({
    super.key,
    required this.cartoon,
    required this.onTap,
    this.index = 0,
  });

  @override
  ConsumerState<CartoonCard> createState() => _CartoonCardState();
}

class _CartoonCardState extends ConsumerState<CartoonCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _controller.reverse();
    HapticFeedback.lightImpact();
    widget.onTap();
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final favorites = ref.watch(favoritesProvider);
    final isFav = favorites.contains(widget.cartoon.id);
    final categoryColor = AppColors.getCategoryColor(widget.cartoon.category);

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        );
      },
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
            boxShadow: _isPressed
                ? [
                    BoxShadow(
                      color: categoryColor.withOpacity(0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : AppTheme.softShadow,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // تصویر کارتون
                Expanded(
                  flex: 3,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // تصویر
                      CachedNetworkImage(
                        imageUrl: widget.cartoon.thumbnailUrl,
                        fit: BoxFit.cover,
                        placeholder: (c, u) => Container(
                          color: AppColors.primarySoft,
                          child: Center(
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: AppColors.primary,
                                strokeWidth: 2,
                              ),
                            ),
                          ),
                        ),
                        errorWidget: (c, u, e) => Container(
                          color: AppColors.primarySoft,
                          child: const Icon(
                            Icons.movie_rounded,
                            size: 40,
                            color: AppColors.primary,
                          ),
                        ),
                      ),

                      // گرادیان پایین تصویر
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        height: 60,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.3),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // بج "جدید"
                      if (widget.cartoon.isNew)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              gradient: AppColors.warmGradient,
                              borderRadius: BorderRadius.circular(
                                AppTheme.radiusCircular,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.accent1.withOpacity(0.4),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            child: Text(
                              '✨ جدید',
                              style: TextStyle(
                                fontFamily: GoogleFonts.vazirmatn().fontFamily,
                                color: AppColors.textOnPrimary,
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),

                      // آیکون پخش وسط
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.play_arrow_rounded,
                            color: categoryColor,
                            size: 28,
                          ),
                        ),
                      ),

                      // دکمه علاقه‌مندی
                      Positioned(
                        top: 8,
                        left: 8,
                        child: GestureDetector(
                          onTap: () {
                            HapticFeedback.lightImpact();
                            ref
                                .read(favoritesProvider.notifier)
                                .toggle(widget.cartoon.id);
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: isFav
                                  ? AppColors.accent5.withOpacity(0.9)
                                  : Colors.white.withOpacity(0.9),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isFav
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              color:
                                  isFav ? Colors.white : AppColors.textHint,
                              size: 18,
                            ),
                          ),
                        ),
                      ),

                      // مدت زمان
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.access_time_rounded,
                                color: Colors.white,
                                size: 12,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${widget.cartoon.duration} دقیقه',
                                style: TextStyle(
                                  fontFamily:
                                      GoogleFonts.vazirmatn().fontFamily,
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // اطلاعات متنی
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.cartoon.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: GoogleFonts.vazirmatn().fontFamily,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: categoryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                widget.cartoon.category,
                                style: TextStyle(
                                  fontFamily:
                                      GoogleFonts.vazirmatn().fontFamily,
                                  fontSize: 10,
                                  color: categoryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Icon(
                              Icons.star_rounded,
                              color: AppColors.starYellow,
                              size: 14,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              widget.cartoon.rating.toStringAsFixed(1),
                              style: TextStyle(
                                fontFamily:
                                    GoogleFonts.vazirmatn().fontFamily,
                                fontSize: 11,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w600,
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
        ),
      ),
    );
  }
}
