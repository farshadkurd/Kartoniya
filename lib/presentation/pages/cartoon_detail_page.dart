// lib/presentation/pages/cartoon_detail_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/cartoon_model.dart';
import '../../data/providers/cartoons_provider.dart';
import '../global_widgets/parental_gate_widget.dart';
import 'player_page.dart';

/// 📺 صفحه جزئیات کارتون
class CartoonDetailPage extends ConsumerStatefulWidget {
  final CartoonModel cartoon;

  const CartoonDetailPage({super.key, required this.cartoon});

  @override
  ConsumerState<CartoonDetailPage> createState() => _CartoonDetailPageState();
}

class _CartoonDetailPageState extends ConsumerState<CartoonDetailPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _playButtonController;
  late Animation<double> _playButtonScale;

  @override
  void initState() {
    super.initState();
    _playButtonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _playButtonScale = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(
        parent: _playButtonController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _playButtonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final favorites = ref.watch(favoritesProvider);
    final isFav = favorites.contains(widget.cartoon.id);
    final categoryColor =
        AppColors.getCategoryColor(widget.cartoon.category);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // هدر تصویری بزرگ
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              stretch: true,
              backgroundColor: AppColors.background,
              leading: GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  Navigator.pop(context);
                },
                child: Container(
                  margin: const EdgeInsets.all(8),
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
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: AppColors.textPrimary,
                    size: 20,
                  ),
                ),
              ),
              actions: [
                GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    ref
                        .read(favoritesProvider.notifier)
                        .toggle(widget.cartoon.id);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isFav
                          ? AppColors.accent5.withOpacity(0.9)
                          : Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Icon(
                      isFav
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      color: isFav ? Colors.white : AppColors.textHint,
                      size: 22,
                    ),
                  ),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    // تصویر
                    CachedNetworkImage(
                      imageUrl: widget.cartoon.thumbnailUrl,
                      fit: BoxFit.cover,
                      placeholder: (c, u) => Container(
                        color: AppColors.primarySoft,
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      errorWidget: (c, u, e) => Container(
                        color: AppColors.primarySoft,
                        child: const Icon(
                          Icons.movie_rounded,
                          size: 60,
                          color: AppColors.primary,
                        ),
                      ),
                    ),

                    // گرادیان پایین
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      height: 120,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              AppColors.background,
                            ],
                          ),
                        ),
                      ),
                    ),

                    // بج جدید
                    if (widget.cartoon.isNew)
                      Positioned(
                        top: MediaQuery.of(context).padding.top + 60,
                        right: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            gradient: AppColors.warmGradient,
                            borderRadius: BorderRadius.circular(
                              AppTheme.radiusCircular,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.accent1.withOpacity(0.4),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: Text(
                            '✨ جدید',
                            style: TextStyle(
                              fontFamily: GoogleFonts.vazirmatn().fontFamily,
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // محتوای متنی و دکمه‌ها
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // عنوان
                    Text(
                      widget.cartoon.title,
                      style: TextStyle(
                        fontFamily: GoogleFonts.vazirmatn().fontFamily,
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // اطلاعات سریع
                    Row(
                      children: [
                        _buildInfoChip(
                          Icons.star_rounded,
                          AppColors.starYellow,
                          widget.cartoon.rating.toStringAsFixed(1),
                        ),
                        const SizedBox(width: 8),
                        _buildInfoChip(
                          Icons.access_time_rounded,
                          AppColors.textSecondary,
                          '${widget.cartoon.duration} دقیقه',
                        ),
                        const SizedBox(width: 8),
                        _buildInfoChip(
                          Icons.movie_rounded,
                          categoryColor,
                          '${widget.cartoon.episodeCount} قسمت',
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // دسته‌بندی و سن
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: categoryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(
                              AppTheme.radiusCircular,
                            ),
                            border: Border.all(
                              color: categoryColor.withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            widget.cartoon.category,
                            style: TextStyle(
                              fontFamily: GoogleFonts.vazirmatn().fontFamily,
                              color: categoryColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.secondarySoft,
                            borderRadius: BorderRadius.circular(
                              AppTheme.radiusCircular,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.child_care_rounded,
                                size: 14,
                                color: AppColors.secondary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'سن ${widget.cartoon.ageRange}',
                                style: TextStyle(
                                  fontFamily:
                                      GoogleFonts.vazirmatn().fontFamily,
                                  color: AppColors.secondaryDark,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // توضیحات
                    if (widget.cartoon.description.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(
                            AppTheme.radiusLarge,
                          ),
                          boxShadow: AppTheme.softShadow,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '📖 درباره این کارتون',
                              style: TextStyle(
                                fontFamily:
                                    GoogleFonts.vazirmatn().fontFamily,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.cartoon.description,
                              style: TextStyle(
                                fontFamily:
                                    GoogleFonts.vazirmatn().fontFamily,
                                fontSize: 14,
                                color: AppColors.textSecondary,
                                height: 1.7,
                              ),
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 24),

                    // دکمه پخش اصلی
                    AnimatedBuilder(
                      animation: _playButtonScale,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _playButtonScale.value,
                          child: child,
                        );
                      },
                      child: GestureDetector(
                        onTap: () {
                          HapticFeedback.mediumImpact();
                          _playCartoon();
                        },
                        child: Container(
                          width: double.infinity,
                          height: 60,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [categoryColor, categoryColor.withOpacity(0.8)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(
                              AppTheme.radiusLarge,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: categoryColor.withOpacity(0.4),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.play_circle_fill_rounded,
                                color: Colors.white,
                                size: 32,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'شروع تماشا',
                                style: TextStyle(
                                  fontFamily:
                                      GoogleFonts.vazirmatn().fontFamily,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // لیست قسمت‌ها
                    Text(
                      '🎬 قسمت‌ها',
                      style: TextStyle(
                        fontFamily: GoogleFonts.vazirmatn().fontFamily,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),

                    ...List.generate(
                      widget.cartoon.episodeCount,
                      (index) => _buildEpisodeTile(index, categoryColor),
                    ),

                    const SizedBox(height: 20),

                    // تگ‌ها
                    if (widget.cartoon.tags.isNotEmpty) ...[
                      Text(
                        '🏷️ برچسب‌ها',
                        style: TextStyle(
                          fontFamily: GoogleFonts.vazirmatn().fontFamily,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: widget.cartoon.tags
                            .map(
                              (tag) => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primarySoft,
                                  borderRadius: BorderRadius.circular(
                                    AppTheme.radiusCircular,
                                  ),
                                ),
                                child: Text(
                                  '#$tag',
                                  style: TextStyle(
                                    fontFamily:
                                        GoogleFonts.vazirmatn().fontFamily,
                                    fontSize: 12,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// چیپ اطلاعات
  Widget _buildInfoChip(IconData icon, Color color, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusCircular),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontFamily: GoogleFonts.vazirmatn().fontFamily,
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /// آیتم قسمت
  Widget _buildEpisodeTile(int index, Color color) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        _playCartoon();
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          boxShadow: AppTheme.softShadow,
        ),
        child: Row(
          children: [
            // شماره قسمت
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    fontFamily: GoogleFonts.vazirmatn().fontFamily,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // اطلاعات
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'قسمت ${index + 1}',
                    style: TextStyle(
                      fontFamily: GoogleFonts.vazirmatn().fontFamily,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${widget.cartoon.duration} دقیقه',
                    style: TextStyle(
                      fontFamily: GoogleFonts.vazirmatn().fontFamily,
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            // آیکون پخش
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.play_arrow_rounded,
                color: color,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// پخش کارتون
  void _playCartoon() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            PlayerPage(cartoon: widget.cartoon),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }
}
