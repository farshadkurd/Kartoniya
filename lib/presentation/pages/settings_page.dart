import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../data/providers/cartoons_provider.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final autoplay = ref.watch(autoplayProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('تنظیمات والدین')),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 34),
              children: [
                _SectionLabel(label: 'ظاهر برنامه'),
                Card(
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      RadioListTile<ThemeMode>(
                        value: ThemeMode.system,
                        groupValue: themeMode,
                        onChanged: (value) {
                          if (value != null) {
                            ref.read(themeModeProvider.notifier).setMode(value);
                          }
                        },
                        title: const Text('هماهنگ با دستگاه'),
                        subtitle: const Text('روشن یا تاریک براساس تنظیم گوشی'),
                        secondary: const Icon(Icons.brightness_auto_rounded),
                      ),
                      const Divider(indent: 72, endIndent: 16),
                      RadioListTile<ThemeMode>(
                        value: ThemeMode.light,
                        groupValue: themeMode,
                        onChanged: (value) {
                          if (value != null) {
                            ref.read(themeModeProvider.notifier).setMode(value);
                          }
                        },
                        title: const Text('حالت روشن'),
                        secondary: const Icon(Icons.light_mode_outlined),
                      ),
                      const Divider(indent: 72, endIndent: 16),
                      RadioListTile<ThemeMode>(
                        value: ThemeMode.dark,
                        groupValue: themeMode,
                        onChanged: (value) {
                          if (value != null) {
                            ref.read(themeModeProvider.notifier).setMode(value);
                          }
                        },
                        title: const Text('حالت تاریک'),
                        secondary: const Icon(Icons.dark_mode_outlined),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                _SectionLabel(label: 'پخش ویدئو'),
                Card(
                  clipBehavior: Clip.antiAlias,
                  child: SwitchListTile.adaptive(
                    value: autoplay,
                    onChanged: (value) =>
                        ref.read(autoplayProvider.notifier).setEnabled(value),
                    title: const Text('پخش خودکار'),
                    subtitle: const Text('پس از باز شدن قسمت، پخش شروع شود'),
                    secondary: const Icon(Icons.play_circle_outline_rounded),
                  ),
                ),
                const SizedBox(height: 24),
                _SectionLabel(label: 'داده‌های این دستگاه'),
                Card(
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.history_toggle_off_rounded),
                        title: const Text('پاک کردن ادامهٔ تماشا'),
                        subtitle: const Text('موقعیت قسمت‌های نیمه‌تمام پاک می‌شود'),
                        trailing: const Icon(Icons.delete_outline_rounded),
                        onTap: () => _clearHistory(context, ref),
                      ),
                      const Divider(indent: 72, endIndent: 16),
                      ListTile(
                        leading: const Icon(Icons.favorite_border_rounded),
                        title: const Text('پاک کردن علاقه‌مندی‌ها'),
                        subtitle: const Text('فهرست ذخیره‌شده فقط از این دستگاه حذف می‌شود'),
                        trailing: const Icon(Icons.delete_outline_rounded),
                        onTap: () => _clearFavorites(context, ref),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withOpacity(.10),
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.info_outline_rounded, color: AppColors.secondary),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'تغییرات بلافاصله و فقط به‌صورت محلی ذخیره می‌شوند. این نسخه دادهٔ کودک را به سرور ارسال نمی‌کند.',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: context.secondaryTextColor,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _clearHistory(BuildContext context, WidgetRef ref) async {
    final confirmed = await _confirm(
      context,
      title: 'پاک کردن ادامهٔ تماشا؟',
      body: 'این کار موقعیت همهٔ قسمت‌های نیمه‌تمام را پاک می‌کند.',
    );
    if (confirmed != true) return;
    await ref.read(watchHistoryProvider.notifier).clear();
    if (context.mounted) _showDone(context, 'ادامهٔ تماشا پاک شد.');
  }

  Future<void> _clearFavorites(BuildContext context, WidgetRef ref) async {
    final confirmed = await _confirm(
      context,
      title: 'پاک کردن علاقه‌مندی‌ها؟',
      body: 'این کار فقط فهرست ذخیره‌شدهٔ این دستگاه را پاک می‌کند.',
    );
    if (confirmed != true) return;
    await ref.read(favoritesProvider.notifier).clear();
    if (context.mounted) _showDone(context, 'علاقه‌مندی‌ها پاک شد.');
  }

  Future<bool?> _confirm(
    BuildContext context, {
    required String title,
    required String body,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: const Icon(Icons.warning_amber_rounded, color: AppColors.warning),
        title: Text(title),
        content: Text(body),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('انصراف'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('پاک کردن'),
          ),
        ],
      ),
    );
  }

  void _showDone(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Text(label, style: Theme.of(context).textTheme.titleLarge),
    );
  }
}
