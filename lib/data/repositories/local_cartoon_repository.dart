import '../../domain/repositories/cartoon_repository.dart';
import '../models/cartoon_model.dart';

/// منبع محلی کاتالوگ نسخهٔ اول.
///
/// URL آزمایشی فقط برای تست فنی player است و پیش از انتشار باید با CDN دارای
/// مجوز محتوای کودک جایگزین شود. UI از منبع داده مستقل است.
class LocalCartoonRepository implements CartoonRepository {
  static const _demoVideoUrl =
      'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4';

  @override
  Future<List<CartoonModel>> fetchCartoons() async =>
      List<CartoonModel>.unmodifiable(_cartoons);

  @override
  Future<List<CategoryModel>> fetchCategories() async =>
      List<CategoryModel>.unmodifiable(_categories);

  EpisodeModel _episode(String cartoonId, int number, int minutes) {
    return EpisodeModel(
      id: '$cartoonId-$number',
      title: 'قسمت $number',
      description: 'یک ماجرای تازه و رنگی برای تماشا و یادگیری.',
      durationSeconds: minutes * 60,
      videoUrl: _demoVideoUrl,
      isNew: number == 1,
    );
  }

  late final List<CartoonModel> _cartoons = [
    CartoonModel(
      id: 'felak',
      title: 'ماجراهای فِلَک',
      description:
          'فِلَک، ابر کوچولوی مهربان، با دوستانش در آسمان سفر می‌کند و در هر قسمت یک راه تازه برای کمک‌کردن یاد می‌گیرد.',
      category: 'ماجراجویی',
      duration: 14,
      rating: 4.8,
      ageRange: '۳ تا ۷',
      artworkEmoji: '☁️',
      artworkColorValue: 0xFFF06A70,
      isNew: true,
      isFeatured: true,
      tags: const ['دوستی', 'آسمان', 'ماجراجویی'],
      episodes: [_episode('felak', 1, 14), _episode('felak', 2, 13)],
    ),
    CartoonModel(
      id: 'alefba',
      title: 'الفبای شاد',
      description:
          'حروف فارسی را با آهنگ، بازی و مثال‌های ساده یاد بگیر؛ هر قسمت کوتاه است تا فرصت تمرین و شادی داشته باشی.',
      category: 'آموزشی',
      duration: 10,
      rating: 4.9,
      ageRange: '۴ تا ۶',
      artworkEmoji: 'آ',
      artworkColorValue: 0xFF4DB9EE,
      isFeatured: true,
      tags: const ['الفبا', 'فارسی', 'یادگیری'],
      episodes: [_episode('alefba', 1, 10), _episode('alefba', 2, 10)],
    ),
    CartoonModel(
      id: 'math',
      title: 'دنیای ریاضی جادویی',
      description:
          'اعداد جادویی منتظرند؛ همراه دوست‌های رنگی بشمار، مقایسه کن و معماهای کوچک را حل کن.',
      category: 'آموزشی',
      duration: 12,
      rating: 4.7,
      ageRange: '۵ تا ۸',
      artworkEmoji: '🔢',
      artworkColorValue: 0xFF53B86A,
      isNew: true,
      tags: const ['اعداد', 'حل مسئله', 'ریاضی'],
      episodes: [_episode('math', 1, 12), _episode('math', 2, 12)],
    ),
    CartoonModel(
      id: 'bedtime',
      title: 'قصه‌های شب‌بخیر',
      description:
          'قصه‌های آرام و کوتاه برای پایان یک روز شاد؛ با لحن ملایم و پیام‌های مهربانانه دربارهٔ خانواده و دوستی.',
      category: 'سرگرمی',
      duration: 18,
      rating: 4.9,
      ageRange: '۲ تا ۶',
      artworkEmoji: '🌙',
      artworkColorValue: 0xFF9B7CEB,
      isFeatured: true,
      tags: const ['قصه', 'خواب', 'آرامش'],
      episodes: [_episode('bedtime', 1, 18), _episode('bedtime', 2, 17)],
    ),
    CartoonModel(
      id: 'kitchen',
      title: 'کارگاه آشپزی کوچولو',
      description:
          'در یک آشپزخانهٔ امن و رنگی، مواد سالم را بشناس و همراه بزرگ‌ترها ایده‌های خوشمزه بساز.',
      category: 'هنری',
      duration: 16,
      rating: 4.6,
      ageRange: '۵ تا ۹',
      artworkEmoji: '🍓',
      artworkColorValue: 0xFFFF8A50,
      tags: const ['خلاقیت', 'غذا', 'مهارت زندگی'],
      episodes: [_episode('kitchen', 1, 16), _episode('kitchen', 2, 15)],
    ),
    CartoonModel(
      id: 'rainbow',
      title: 'باغ رنگین‌کمان',
      description:
          'گل‌ها، حشرات و حیوانات باغ رنگین‌کمان با هم بازی می‌کنند و دربارهٔ مراقبت از طبیعت حرف می‌زنند.',
      category: 'سرگرمی',
      duration: 15,
      rating: 4.8,
      ageRange: '۲ تا ۶',
      artworkEmoji: '🌈',
      artworkColorValue: 0xFFFFC83D,
      isFeatured: true,
      tags: const ['طبیعت', 'حیوانات', 'دوستی'],
      episodes: [_episode('rainbow', 1, 15), _episode('rainbow', 2, 15)],
    ),
    CartoonModel(
      id: 'lab',
      title: 'آزمایشگاه کوچولو',
      description:
          'با آزمایش‌های ساده و بی‌خطر، پرسش بپرس و جواب‌ها را کشف کن؛ کنجکاوی بهترین ابزار یک دانشمند است.',
      category: 'علمی',
      duration: 13,
      rating: 4.7,
      ageRange: '۶ تا ۱۰',
      artworkEmoji: '🔬',
      artworkColorValue: 0xFF53B86A,
      isNew: true,
      tags: const ['علم', 'آزمایش', 'کنجکاوی'],
      episodes: [_episode('lab', 1, 13), _episode('lab', 2, 13)],
    ),
    CartoonModel(
      id: 'melody',
      title: 'ملودی جنگل',
      description:
          'صدای سازها و حیوانات جنگل را بشناس، ریتم بساز و با حرکت‌های شاد همراه موسیقی بازی کن.',
      category: 'موسیقی',
      duration: 11,
      rating: 4.6,
      ageRange: '۲ تا ۵',
      artworkEmoji: '🎵',
      artworkColorValue: 0xFFFFC83D,
      tags: const ['موسیقی', 'ریتم', 'جنگل'],
      episodes: [_episode('melody', 1, 11), _episode('melody', 2, 11)],
    ),
  ];

  static const List<CategoryModel> _categories = [
    CategoryModel(id: 'all', name: 'همه', emoji: '✨', colorValue: 0xFFFF8A50),
    CategoryModel(
      id: 'adventure',
      name: 'ماجراجویی',
      emoji: '🚀',
      colorValue: 0xFFF06A70,
    ),
    CategoryModel(
      id: 'education',
      name: 'آموزشی',
      emoji: '📚',
      colorValue: 0xFF4DB9EE,
    ),
    CategoryModel(
      id: 'fun',
      name: 'سرگرمی',
      emoji: '🎪',
      colorValue: 0xFFFF6B9D,
    ),
    CategoryModel(id: 'art', name: 'هنری', emoji: '🎨', colorValue: 0xFF9B7CEB),
    CategoryModel(id: 'science', name: 'علمی', emoji: '🔬', colorValue: 0xFF53B86A),
    CategoryModel(id: 'music', name: 'موسیقی', emoji: '🎵', colorValue: 0xFFFFC83D),
  ];
}
