// lib/presentation/pages/home_page.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/full_screen_utils.dart';
import '../../data/models/cartoon_model.dart';
import '../../data/providers/cartoons_provider.dart';
import '../widgets/cartoon_card.dart';
import '../widgets/shimmer_loader.dart';
import 'cartoon_detail_page.dart';
import 'about_us_page.dart';
import 'favorites_page.dart';
import 'search_page.dart';
import 'categories_page.dart';

/// 🏠 صفحه اصلی کارتونیا
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with TickerProviderStateMixin {
  int _currentNavIndex = 0;
  late AnimationController _headerController;
  late Animation<double> _headerSlide;
  late Animation<double> _headerOpacity;

  @override
  void initState() {
    super.initState();
    FullScreenUtils.setLightStatusBar();

    _headerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _headerSlide = Tween<double>(begin: -30.0, end: 0.0).animate(
      CurvedAnimation(parent: _headerController, curve: Curves.easeOutCubic),
    );

    _headerOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _headerController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _headerController.forward();
  }

  @override
  void dispose() {
    _headerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: _buildBody(),
        bottomNavigationBar: _buildBottomNav(),
      ),
    );
  }

  Widget _buildBody() {
    switch (_currentNavIndex) {
      case 0:
        return _buildHomeContent();
      case 1:
        return const CategoriesPage();
      case 2:
        return const FavoritesPage();
      case 3:
        return const SearchPage();
      default:
        return _buildHomeContent();
    }
  }

  Widget _buildHomeContent() {
    final cartoonsAsync = ref.watch(cartoonsProvider);
    final featuredAsync = ref.watch(featuredCartoonsProvider);
    final newCartoonsAsync = ref.watch(newCartoonsProvider);

    return SafeArea(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // هدر
          SliverToBoxAdapter(
            child: AnimatedBuilder(
              animation: _headerController,
              builder: (context, child) {
                return Opacity(
                  opacity: _headerOpacity.value,
                  child: Transform.translate(
                    offset: Offset(0, _headerSlide.value),
                    child: child,
                  ),
                );
              },
              child: _buildHeader(),
            ),
          ),

          // بنر خوش‌آمدگویی
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: _buildWelcomeBanner(),
            ),
          ),

          // بخش ویژه (Featured)
          SliverToBoxAdapter(
            child: _buildSectionHeader('⭐ ویژه‌ها', 'مشاهده همه'),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 200,
              child: featuredAsync.when(
                data: (cartoons) => _buildFeaturedList(cartoons),
                loading: () => _buildFeaturedShimmer(),
                error: (e, s) => _buildErrorWidget(),
              ),
            ),
          ),

          // دسته‌بندی‌ها
          SliverToBoxAdapter(
            child: _buildSectionHeader('🏷️ دسته‌بندی‌ها', ''),
          ),
          SliverToBoxAdapter(
            child: _buildCategoryChips(),
          ),

          // جدیدها
          SliverToBoxAdapter(
            child: _buildSectionHeader('🆕 تازه‌ها', 'مشاهده همه'),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 200,
              child: newCartoonsAsync.when(
                data: (cartoons) => _buildNewCartoonsList(cartoons),
                loading: () => _buildFeaturedShimmer(),
                error: (e, s) => _buildErrorWidget(),
              ),
            ),
          ),

          // همه کارتون‌ها
          SliverToBoxAdapter(
            child: _buildSectionHeader('🎬 همه کارتون‌ها', ''),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            sliver: cartoonsAsync.when(
              data: (cartoons) => _buildCartoonsGrid(cartoons),
              loading: () => _buildCartoonsGridShimmer(),
              error: (e, s) => SliverToBoxAdapter(
                child: _buildErrorWidget(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// هدر بالای صفحه
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          // لوگو و نام
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: AppColors.sunsetGradient,
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.play_circle_fill_rounded,
              color: AppColors.textOnPrimary,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'کارتونیا',
                style: TextStyle(
                  fontFamily: GoogleFonts.vazirmatn().fontFamily,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  foreground: Paint()
                    ..shader = const LinearGradient(
                      colors: [AppColors.primary, AppColors.primaryDark],
                    ).createShader(const Rect.fromLTWH(0, 0, 120, 30)),
                ),
              ),
              Text(
                '🌟 دنیای شاد کودکان',
                style: TextStyle(
                  fontFamily: GoogleFonts.vazirmatn().fontFamily,
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const Spacer(),
          // دکمه درباره ما
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      const AboutUsPage(),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(-1.0, 0.0),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOutCubic,
                      )),
                      child: child,
                    );
                  },
                  transitionDuration: const Duration(milliseconds: 400),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                boxShadow: AppTheme.softShadow,
              ),
              child: const Icon(
                Icons.info_outline_rounded,
                color: AppColors.primary,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// بنر خوش‌آمدگویی
  Widget _buildWelcomeBanner() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'سلام کوچولو! 👋',
                  style: TextStyle(
                    fontFamily: GoogleFonts.vazirmatn().fontFamily,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textOnPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'کارتون مورد علاقت رو پیدا کن و تماشا کن!',
                  style: TextStyle(
                    fontFamily: GoogleFonts.vazirmatn().fontFamily,
                    fontSize: 13,
                    color: AppColors.textOnPrimary.withOpacity(0.85),
                  ),
                ),
              ],
            ),
          ),
          // ایموجی بزرگ
          const Text(
            '🎬',
            style: TextStyle(fontSize: 50),
          ),
        ],
      ),
    );
  }

  /// هدر بخش
  Widget _buildSectionHeader(String title, String action) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: GoogleFonts.vazirmatn().fontFamily,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const Spacer(),
          if (action.isNotEmpty)
            GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                // TODO: مشاهده همه
              },
              child: Text(
                action,
                style: TextStyle(
                  fontFamily: GoogleFonts.vazirmatn().fontFamily,
                  fontSize: 13,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// لیست ویژه (افقی)
  Widget _buildFeaturedList(List<CartoonModel> cartoons) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: cartoons.length,
      itemBuilder: (context, index) {
        final cartoon = cartoons[index];
        return GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            _navigateToDetail(cartoon);
          },
          child: Container(
            width: 280,
            margin: EdgeInsets.only(
              left: index == cartoons.length - 1 ? 0 : 16,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
              boxShadow: AppTheme.mediumShadow,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // تصویر
                  Image.network(
                    cartoon.thumbnailUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) => Container(
                      color: AppColors.primarySoft,
                      child: const Icon(
                        Icons.movie_rounded,
                        size: 50,
                        color: AppColors.primary,
                      ),
                    ),
                  ),

                  // گرادیان
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),

                  // محتوا
                  Positioned(
                    bottom: 16,
                    right: 16,
                    left: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (cartoon.isNew)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.accent1,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '✨ جدید',
                              style: TextStyle(
                                fontFamily:
                                    GoogleFonts.vazirmatn().fontFamily,
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        if (cartoon.isNew) const SizedBox(height: 8),
                        Text(
                          cartoon.title,
                          style: TextStyle(
                            fontFamily: GoogleFonts.vazirmatn().fontFamily,
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.star_rounded,
                              color: AppColors.starYellow,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              cartoon.rating.toStringAsFixed(1),
                              style: TextStyle(
                                fontFamily:
                                    GoogleFonts.vazirmatn().fontFamily,
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Icon(
                              Icons.access_time_rounded,
                              color: Colors.white70,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${cartoon.duration} دقیقه',
                              style: TextStyle(
                                fontFamily:
                                    GoogleFonts.vazirmatn().fontFamily,
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // آیکون پخش
                  Positioned(
                    top: 16,
                    left: 16,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// لیست جدیدها (افقی)
  Widget _buildNewCartoonsList(List<CartoonModel> cartoons) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: cartoons.length,
      itemBuilder: (context, index) {
        final cartoon = cartoons[index];
        return Container(
          width: 160,
          margin: EdgeInsets.only(
            left: index == cartoons.length - 1 ? 0 : 12,
          ),
          child: CartoonCard(
            cartoon: cartoon,
            index: index,
            onTap: () => _navigateToDetail(cartoon),
          ),
        );
      },
    );
  }

  /// چیپ‌های دسته‌بندی
  Widget _buildCategoryChips() {
    final categories = ref.watch(categoriesProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);

    return SizedBox(
      height: 44,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          final isSelected = (cat.id == 'all' && selectedCategory == null) ||
              cat.name == selectedCategory;

          return GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              ref.read(selectedCategoryProvider.notifier).state =
                  cat.id == 'all' ? null : cat.name;
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              margin: EdgeInsets.only(
                left: index == categories.length - 1 ? 0 : 8,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.surface,
                borderRadius: BorderRadius.circular(AppTheme.radiusCircular),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.textHint.withOpacity(0.2),
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    cat.emoji,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    cat.name,
                    style: TextStyle(
                      fontFamily: GoogleFonts.vazirmatn().fontFamily,
                      fontSize: 13,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.w500,
                      color: isSelected
                          ? AppColors.textOnPrimary
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// گرید کارتون‌ها
  Widget _buildCartoonsGrid(List<CartoonModel> cartoons) {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.75,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: Duration(milliseconds: 600 + (index * 100)),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 20 * (1 - value)),
                  child: child,
                ),
              );
            },
            child: CartoonCard(
              cartoon: cartoons[index],
              index: index,
              onTap: () => _navigateToDetail(cartoons[index]),
            ),
          );
        },
        childCount: cartoons.length,
      ),
    );
  }

  /// شیمر گرید
  Widget _buildCartoonsGridShimmer() {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.75,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) => const ShimmerCard(),
        childCount: 6,
      ),
    );
  }

  /// شیمر ویژه
  Widget _buildFeaturedShimmer() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: 3,
      itemBuilder: (context, index) => Container(
        width: 280,
        height: 200,
        margin: const EdgeInsets.only(left: 16),
        child: const ShimmerBanner(),
      ),
    );
  }

  /// ویجت خطا
  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.cloud_off_rounded,
            size: 48,
            color: AppColors.textHint,
          ),
          const SizedBox(height: 12),
          Text(
            'خطا در بارگذاری',
            style: TextStyle(
              fontFamily: GoogleFonts.vazirmatn().fontFamily,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  /// نوار پیمایش پایین
  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.home_rounded, 'خانه'),
              _buildNavItem(1, Icons.grid_view_rounded, 'دسته‌بندی'),
              _buildNavItem(2, Icons.favorite_rounded, 'علاقه‌مندی'),
              _buildNavItem(3, Icons.search_rounded, 'جستجو'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _currentNavIndex == index;
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        setState(() => _currentNavIndex = index);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primary : AppColors.textHint,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontFamily: GoogleFonts.vazirmatn().fontFamily,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? AppColors.primary : AppColors.textHint,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// رفتن به صفحه جزئیات
  void _navigateToDetail(CartoonModel cartoon) {
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
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, 0.1),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              )),
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }
}
