class CartoonModel {
  final String id;
  final String title;
  final String thumbnailUrl; // لینک عکس
  final String category;     // دسته‌بندی
  final int duration;        // مدت زمان به دقیقه
  final bool isNew;          // آیا جدید است؟

  const CartoonModel({
    required this.id,
    required this.title,
    required this.thumbnailUrl,
    required this.category,
    required this.duration,
    this.isNew = false,
  });
}
