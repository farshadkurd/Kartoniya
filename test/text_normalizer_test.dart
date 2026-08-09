import 'package:flutter_test/flutter_test.dart';
import 'package:kartoniya/core/utils/text_normalizer.dart';

void main() {
  group('normalizeForSearch', () {
    test('یکسان‌سازی حروف عربی و فارسی', () {
      expect(normalizeForSearch('  كارتونِ  يِاس  '), 'کارتون یاس');
    });

    test('فاصله‌های تکراری را حذف می‌کند', () {
      expect(normalizeForSearch('دنیای   ریاضی\nجادویی'), 'دنیای ریاضی جادویی');
    });
  });
}
