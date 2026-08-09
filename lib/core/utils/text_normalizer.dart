/// یکسان‌سازی حداقلی متن فارسی برای جست‌وجوی قابل پیش‌بینی.
String normalizeForSearch(String value) {
  return value
      .replaceAll('ي', 'ی')
      .replaceAll('ى', 'ی')
      .replaceAll('ك', 'ک')
      .replaceAll(RegExp(r'[\u064B-\u065F\u0670]'), '')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim()
      .toLowerCase();
}
