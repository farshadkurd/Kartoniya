import '../../data/models/cartoon_model.dart';

/// قرارداد لایهٔ دامنه برای دریافت کاتالوگ.
///
/// صفحه‌ها فقط این قرارداد را می‌شناسند؛ بنابراین جایگزینی منبع محلی با API یا
/// CMS بدون تغییر UI انجام می‌شود.
abstract interface class CartoonRepository {
  Future<List<CartoonModel>> fetchCartoons();
  Future<List<CategoryModel>> fetchCategories();
}
