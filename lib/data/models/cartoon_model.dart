// lib/data/models/cartoon_model.dart

/// 📺 مدل داده کارتون/انیمیشن
class CartoonModel {
  final String id;
  final String title;
  final String description;
  final String thumbnailUrl;
  final String videoUrl;
  final String category;
  final int duration;       // مدت زمان به دقیقه
  final double rating;      // امتیاز از ۵
  final bool isNew;
  final bool isFeatured;
  final int episodeCount;
  final String ageRange;    // محدوده سنی مناسب
  final List<String> tags;

  const CartoonModel({
    required this.id,
    required this.title,
    required this.thumbnailUrl,
    required this.category,
    required this.duration,
    this.description = '',
    this.videoUrl = '',
    this.rating = 4.5,
    this.isNew = false,
    this.isFeatured = false,
    this.episodeCount = 1,
    this.ageRange = '۳-۷',
    this.tags = const [],
  });

  /// ایجاد کپی با تغییرات
  CartoonModel copyWith({
    String? id,
    String? title,
    String? description,
    String? thumbnailUrl,
    String? videoUrl,
    String? category,
    int? duration,
    double? rating,
    bool? isNew,
    bool? isFeatured,
    int? episodeCount,
    String? ageRange,
    List<String>? tags,
  }) {
    return CartoonModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      videoUrl: videoUrl ?? this.videoUrl,
      category: category ?? this.category,
      duration: duration ?? this.duration,
      rating: rating ?? this.rating,
      isNew: isNew ?? this.isNew,
      isFeatured: isFeatured ?? this.isFeatured,
      episodeCount: episodeCount ?? this.episodeCount,
      ageRange: ageRange ?? this.ageRange,
      tags: tags ?? this.tags,
    );
  }
}

/// 🏷️ مدل دسته‌بندی
class CategoryModel {
  final String id;
  final String name;
  final String emoji;
  final String color; // کد رنگ هگزا

  const CategoryModel({
    required this.id,
    required this.name,
    required this.emoji,
    this.color = '#FF8A50',
  });
}
