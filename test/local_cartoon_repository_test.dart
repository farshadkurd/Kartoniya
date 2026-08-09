import 'package:flutter_test/flutter_test.dart';
import 'package:kartoniya/data/repositories/local_cartoon_repository.dart';

void main() {
  group('LocalCartoonRepository', () {
    test('کاتالوگ دارای شناسه‌های یکتا و قسمت قابل پخش است', () async {
      final repository = LocalCartoonRepository();
      final cartoons = await repository.fetchCartoons();

      expect(cartoons, isNotEmpty);
      expect(cartoons.map((item) => item.id).toSet().length, cartoons.length);
      expect(
        cartoons.every(
          (cartoon) =>
              cartoon.episodes.isNotEmpty &&
              cartoon.episodes.every((episode) => episode.videoUrl.startsWith('https://')),
        ),
        isTrue,
      );
    });

    test('دستهٔ همه در ابتدای فهرست قرار دارد', () async {
      final categories = await LocalCartoonRepository().fetchCategories();
      expect(categories.first.id, 'all');
    });
  });
}
