import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cartoon_model.dart';

final cartoonsProvider = FutureProvider<List<CartoonModel>>((ref) async {
  // ایجاد تاخیر مصنوعی برای نمایش انیمیشن لودینگ
  await Future.delayed(const Duration(seconds: 2));
  
  // داده‌های نمونه (شما بعداً این را به API واقعی وصل کنید)
  return [
    CartoonModel(id: '1', title: 'ماجراهای فلگ', thumbnailUrl: 'https://picsum.photos/id/10/300/200', category: 'ماجراجویی', duration: 15, isNew: true),
    CartoonModel(id: '2', title: 'آموزش الفبا', thumbnailUrl: 'https://picsum.photos/id/20/300/200', category: 'آموزشی', duration: 10),
    CartoonModel(id: '3', title: 'دنیای ریاضی', thumbnailUrl: 'https://picsum.photos/id/30/300/200', category: 'آموزشی', duration: 12),
    CartoonModel(id: '4', title: 'قصه قبل خواب', thumbnailUrl: 'https://picsum.photos/id/40/300/200', category: 'سرگرمی', duration: 20, isNew: true),
    CartoonModel(id: '5', title: 'کارگاه آشپزی', thumbnailUrl: 'https://picsum.photos/id/50/300/200', category: 'هنری', duration: 18),
    CartoonModel(id: '6', title: 'ماشین مسابقه', thumbnailUrl: 'https://picsum.photos/id/60/300/200', category: 'ماجراجویی', duration: 14),
  ];
});
