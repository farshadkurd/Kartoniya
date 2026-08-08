// lib/data/providers/cartoons_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cartoon_model.dart';

// ═══════════════════════════════════════
// Provider اصلی لیست کارتون‌ها
// ═══════════════════════════════════════
final cartoonsProvider = FutureProvider<List<CartoonModel>>((ref) async {
  // تأخیر مصنوعی برای نمایش انیمیشن لودینگ
  await Future.delayed(const Duration(seconds: 2));
  return _sampleCartoons;
});

// ═══════════════════════════════════════
// Provider فیلتر شده بر اساس دسته‌بندی
// ═══════════════════════════════════════
final selectedCategoryProvider = StateProvider<String?>((ref) => null);

final filteredCartoonsProvider = FutureProvider<List<CartoonModel>>((ref) async {
  final category = ref.watch(selectedCategoryProvider);
  final allCartoons = await ref.watch(cartoonsProvider.future);
  
  if (category == null) return allCartoons;
  return allCartoons.where((c) => c.category == category).toList();
});

// ═══════════════════════════════════════
// Provider علاقه‌مندی‌ها
// ═══════════════════════════════════════
final favoritesProvider = StateNotifierProvider<FavoritesNotifier, Set<String>>((ref) {
  return FavoritesNotifier();
});

class FavoritesNotifier extends StateNotifier<Set<String>> {
  FavoritesNotifier() : super({});

  void toggle(String cartoonId) {
    if (state.contains(cartoonId)) {
      state = {...state}..remove(cartoonId);
    } else {
      state = {...state, cartoonId};
    }
  }

  bool isFavorite(String cartoonId) => state.contains(cartoonId);
}

// ═══════════════════════════════════════
// Provider جستجو
// ═══════════════════════════════════════
final searchQueryProvider = StateProvider<String>((ref) => '');

final searchResultsProvider = FutureProvider<List<CartoonModel>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  if (query.isEmpty) return [];
  
  final allCartoons = await ref.watch(cartoonsProvider.future);
  return allCartoons.where((c) => 
    c.title.contains(query) || 
    c.category.contains(query) ||
    c.tags.any((tag) => tag.contains(query))
  ).toList();
});

// ═══════════════════════════════════════
// Provider ویژه (Featured)
// ═══════════════════════════════════════
final featuredCartoonsProvider = FutureProvider<List<CartoonModel>>((ref) async {
  final allCartoons = await ref.watch(cartoonsProvider.future);
  return allCartoons.where((c) => c.isFeatured).toList();
});

// ═══════════════════════════════════════
// Provider جدیدها
// ═══════════════════════════════════════
final newCartoonsProvider = FutureProvider<List<CartoonModel>>((ref) async {
  final allCartoons = await ref.watch(cartoonsProvider.future);
  return allCartoons.where((c) => c.isNew).toList();
});

// ═══════════════════════════════════════
// Provider دسته‌بندی‌ها
// ═══════════════════════════════════════
final categoriesProvider = Provider<List<CategoryModel>>((ref) {
  return _sampleCategories;
});

// ═══════════════════════════════════════
// داده‌های نمونه
// ═══════════════════════════════════════
const _sampleCategories = [
  CategoryModel(id: 'all', name: 'همه', emoji: '🌟'),
  CategoryModel(id: 'adventure', name: 'ماجراجویی', emoji: '🚀', color: '#FF6B6B'),
  CategoryModel(id: 'education', name: 'آموزشی', emoji: '📚', color: '#5AC8FA'),
  CategoryModel(id: 'fun', name: 'سرگرمی', emoji: '🎪', color: '#FF6B9D'),
  CategoryModel(id: 'art', name: 'هنری', emoji: '🎨', color: '#C9A0FF'),
  CategoryModel(id: 'science', name: 'علمی', emoji: '🔬', color: '#7DD956'),
  CategoryModel(id: 'music', name: 'موسیقی', emoji: '🎵', color: '#FFD93D'),
];

final _sampleCartoons = [
  CartoonModel(
    id: '1',
    title: 'ماجراهای فِلَک',
    description: 'فلک، ابر کوچولوی مهربون، با دوستاش توی آسمون ماجراجویی می‌کنه!',
    thumbnailUrl: 'https://picsum.photos/seed/cartoon1/400/300',
    category: 'ماجراجویی',
    duration: 15,
    rating: 4.8,
    isNew: true,
    isFeatured: true,
    episodeCount: 12,
    ageRange: '۳-۷',
    tags: ['ابر', 'آسمان', 'ماجراجویی'],
  ),
  CartoonModel(
    id: '2',
    title: 'الفبای شاد',
    description: 'با آهنگ و بازی، حروف فارسی رو یاد بگیر!',
    thumbnailUrl: 'https://picsum.photos/seed/cartoon2/400/300',
    category: 'آموزشی',
    duration: 10,
    rating: 4.9,
    isFeatured: true,
    episodeCount: 32,
    ageRange: '۴-۶',
    tags: ['الفبا', 'یادگیری', 'فارسی'],
  ),
  CartoonModel(
    id: '3',
    title: 'دنیای ریاضی جادویی',
    description: 'اعداد جادویی منتظرتن! با دوستات بشمار و حل کن.',
    thumbnailUrl: 'https://picsum.photos/seed/cartoon3/400/300',
    category: 'آموزشی',
    duration: 12,
    rating: 4.7,
    isNew: true,
    episodeCount: 20,
    ageRange: '۵-۸',
    tags: ['ریاضی', 'اعداد', 'آموزش'],
  ),
  CartoonModel(
    id: '4',
    title: 'قصه‌های شب‌بخیر',
    description: 'قصه‌های آرام و قشنگ برای خواب خوش کوچولوها.',
    thumbnailUrl: 'https://picsum.photos/seed/cartoon4/400/300',
    category: 'سرگرمی',
    duration: 20,
    rating: 4.9,
    isFeatured: true,
    episodeCount: 25,
    ageRange: '۲-۵',
    tags: ['قصه', 'خواب', 'آرام'],
  ),
  CartoonModel(
    id: '5',
    title: 'کارگاه آشپزی کوچولو',
    description: 'با بچه‌های آشپز، غذاهای خوشمزه و سالم درست کن!',
    thumbnailUrl: 'https://picsum.photos/seed/cartoon5/400/300',
    category: 'هنری',
    duration: 18,
    rating: 4.6,
    episodeCount: 15,
    ageRange: '۵-۹',
    tags: ['آشپزی', 'هنر', 'خلاقیت'],
  ),
  CartoonModel(
    id: '6',
    title: 'مسابقه ماشین‌ها',
    description: 'ماشین‌های رنگی مسابقه می‌دن! کی برنده می‌شه؟',
    thumbnailUrl: 'https://picsum.photos/seed/cartoon6/400/300',
    category: 'ماجراجویی',
    duration: 14,
    rating: 4.5,
    isNew: true,
    episodeCount: 18,
    ageRange: '۳-۷',
    tags: ['ماشین', 'مسابقه', 'هیجان'],
  ),
  CartoonModel(
    id: '7',
    title: 'باغ رنگین‌کمان',
    description: 'گل‌ها و حیوانات باغ رنگین‌کمان منتظرت هستن!',
    thumbnailUrl: 'https://picsum.photos/seed/cartoon7/400/300',
    category: 'سرگرمی',
    duration: 16,
    rating: 4.8,
    isFeatured: true,
    episodeCount: 22,
    ageRange: '۲-۶',
    tags: ['گل', 'حیوانات', 'طبیعت'],
  ),
  CartoonModel(
    id: '8',
    title: 'آزمایشگاه کوچولو',
    description: 'آزمایش‌های علمی ساده و جالب برای بچه‌های کنجکاو!',
    thumbnailUrl: 'https://picsum.photos/seed/cartoon8/400/300',
    category: 'علمی',
    duration: 15,
    rating: 4.7,
    isNew: true,
    episodeCount: 10,
    ageRange: '۶-۱۰',
    tags: ['علم', 'آزمایش', 'کنجکاوی'],
  ),
  CartoonModel(
    id: '9',
    title: 'ملودی جنگل',
    description: 'حیوانات جنگل با هم آهنگ می‌خونن! برقص و بخون!',
    thumbnailUrl: 'https://picsum.photos/seed/cartoon9/400/300',
    category: 'موسیقی',
    duration: 12,
    rating: 4.6,
    episodeCount: 14,
    ageRange: '۲-۵',
    tags: ['موسیقی', 'جنگل', 'رقص'],
  ),
  CartoonModel(
    id: '10',
    title: 'نقاشی با انگشت',
    description: 'یاد بگیر با انگشتات نقاشی‌های قشنگ بکشی!',
    thumbnailUrl: 'https://picsum.photos/seed/cartoon10/400/300',
    category: 'هنری',
    duration: 20,
    rating: 4.8,
    isFeatured: true,
    isNew: true,
    episodeCount: 16,
    ageRange: '۳-۸',
    tags: ['نقاشی', 'هنر', 'خلاقیت'],
  ),
  CartoonModel(
    id: '11',
    title: 'ستاره‌های کوچولو',
    description: 'با ستاره‌ها به فضا سفر کن و سیاره‌ها رو بشناس!',
    thumbnailUrl: 'https://picsum.photos/seed/cartoon11/400/300',
    category: 'علمی',
    duration: 18,
    rating: 4.9,
    isFeatured: true,
    episodeCount: 8,
    ageRange: '۵-۹',
    tags: ['فضا', 'ستاره', 'سیاره'],
  ),
  CartoonModel(
    id: '12',
    title: 'دوستی پروانه‌ها',
    description: 'داستان دوستی قشنگ بین پروانه‌های رنگی.',
    thumbnailUrl: 'https://picsum.photos/seed/cartoon12/400/300',
    category: 'سرگرمی',
    duration: 10,
    rating: 4.7,
    isNew: true,
    episodeCount: 20,
    ageRange: '۲-۵',
    tags: ['پروانه', 'دوستی', 'طبیعت'],
  ),
];
