// lib/presentation/pages/search_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/cartoon_model.dart';
import '../../data/providers/cartoons_provider.dart';
import '../widgets/cartoon_card.dart';
import 'cartoon_detail_page.dart';

/// 🔍 صفحه جستجو
class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<CartoonModel> _results = [];
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String query) async {
    if (query.isEmpty) {
      setState(() {
        _results = [];
        _isSearching = false;
      });
      return;
    }

    setState(() => _isSearching = true);

    final allCartoons = await ref.read(cartoonsProvider.future);
    final filtered = allCartoons.where((c) =>
        c.title.contains(query) ||
        c.category.contains(query) ||
        c.tags.any((tag) => tag.contains(query)) ||
        c.description.contains(query)
    ).toList();

    if (mounted) {
      setState(() {
        _results = filtered;
        _isSearching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // هدر و جستجو
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: AppColors.secondaryGradient,
                        borderRadius: BorderRadius.circular(
                          AppTheme.radiusMedium,
                        ),
                      ),
                      child: const Icon(
                        Icons.search_rounded,
                        color: AppColors.textOnPrimary,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'جستجو',
                      style: TextStyle(
                        fontFamily: GoogleFonts.vazirmatn().fontFamily,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // فیلد جستجو
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                    boxShadow: AppTheme.softShadow,
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: _onSearch,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontFamily: GoogleFonts.vazirmatn().fontFamily,
                      fontSize: 16,
                    ),
                    decoration: InputDecoration(
                      hintText: '🔍 اسم کارتون رو بنویس...',
                      hintStyle: TextStyle(
                        fontFamily: GoogleFonts.vazirmatn().fontFamily,
                        color: AppColors.textHint,
                        fontSize: 15,
                      ),
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        color: AppColors.primary,
                        size: 24,
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? GestureDetector(
                              onTap: () {
                                _searchController.clear();
                                _onSearch('');
                              },
                              child: const Icon(
                                Icons.close_rounded,
                                color: AppColors.textHint,
                                size: 20,
                              ),
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // نتایج یا پیشنهادات
          Expanded(
            child: _searchController.text.isEmpty
                ? _buildSuggestions()
                : _isSearching
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      )
                    : _results.isEmpty
                        ? _buildNoResults()
                        : _buildResults(),
          ),
        ],
      ),
    );
  }

  /// پیشنهادات
  Widget _buildSuggestions() {
    final suggestions = [
      {'emoji': '🚀', 'text': 'ماجراجویی'},
      {'emoji': '📚', 'text': 'آموزشی'},
      {'emoji': '🎪', 'text': 'سرگرمی'},
      {'emoji': '🎨', 'text': 'هنری'},
      {'emoji': '🔬', 'text': 'علمی'},
      {'emoji': '🎵', 'text': 'موسیقی'},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'پیشنهادات جستجو',
            style: TextStyle(
              fontFamily: GoogleFonts.vazirmatn().fontFamily,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: suggestions.map((s) {
              return GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  _searchController.text = s['text']!;
                  _onSearch(s['text']!);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(
                      AppTheme.radiusCircular,
                    ),
                    border: Border.all(
                      color: AppColors.textHint.withOpacity(0.2),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(s['emoji']!, style: const TextStyle(fontSize: 18)),
                      const SizedBox(width: 8),
                      Text(
                        s['text']!,
                        style: TextStyle(
                          fontFamily: GoogleFonts.vazirmatn().fontFamily,
                          fontSize: 14,
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  /// نتایج جستجو
  Widget _buildResults() {
    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.75,
      ),
      itemCount: _results.length,
      itemBuilder: (context, index) {
        return CartoonCard(
          cartoon: _results[index],
          index: index,
          onTap: () => _navigateToDetail(_results[index]),
        );
      },
    );
  }

  /// نتیجه‌ای پیدا نشد
  Widget _buildNoResults() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🔍', style: TextStyle(fontSize: 50)),
          const SizedBox(height: 16),
          Text(
            'نتیجه‌ای پیدا نشد',
            style: TextStyle(
              fontFamily: GoogleFonts.vazirmatn().fontFamily,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'یه چیز دیگه جستجو کن!',
            style: TextStyle(
              fontFamily: GoogleFonts.vazirmatn().fontFamily,
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

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
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }
}
