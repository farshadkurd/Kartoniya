import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../data/providers/cartoons_provider.dart';
import '../global_widgets/parental_gate_widget.dart';
import 'about_us_page.dart';
import 'settings_page.dart';

/// فضای ویژهٔ والدین؛ ورودی تنظیمات مهم با قفل والدین محافظت می‌شود.
class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final parentName = ref.watch(profileNameProvider);
    final favorites = ref.watch(favoritesProvider);
    final history = ref.watch(watchHistoryProvider);
    final themeMode = ref.watch(themeModeProvider);

    return SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
                  child: Row(
                    children: [
                      Container(
                        width: 58,
                        height: 58,
                        decoration: const BoxDecoration(
                          gradient: AppColors.sunsetGradient,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.family_restroom_rounded, color: Colors.white, size: 30),
                      ),
                      const SizedBox(width: 13),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(parentName, style: Theme.of(context).textTheme.headlineSmall),
                            const SizedBox(height: 2),
                            Text(
                              'فضای امن والدین',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: context.secondaryTextColor,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        tooltip: 'ویرایش نام',
                        onPressed: () => _editName(context, ref, parentName),
                        icon: const Icon(Icons.edit_outlined),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _StatCard(
                        icon: Icons.favorite_rounded,
                        color: AppColors.red,
                        value: favorites.length.toString(),
                        label: 'علاقه‌مندی',
                      ),
                      _StatCard(
                        icon: Icons.play_circle_fill_rounded,
                        color: AppColors.secondary,
                        value: history.length.toString(),
                        label: 'ادامهٔ تماشا',
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 25, 20, 0),
                  child: Text('کنترل و تنظیمات', style: Theme.of(context).textTheme.titleLarge),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: [
                        _ProfileActionTile(
                          icon: Icons.lock_outline_rounded,
                          color: AppColors.primary,
                          title: 'تنظیمات والدین',
                          subtitle: 'ظاهر، پخش خودکار و داده‌های محلی',
                          onTap: () => _openSettings(context),
                        ),
                        const Divider(indent: 72, endIndent: 16),
                        SwitchListTile.adaptive(
                          value: themeMode == ThemeMode.dark,
                          onChanged: (value) {
                            ref
                                .read(themeModeProvider.notifier)
                                .setMode(value ? ThemeMode.dark : ThemeMode.light);
                          },
                          secondary: const Icon(Icons.dark_mode_outlined),
                          title: const Text('حالت تاریک'),
                          subtitle: const Text('برای تماشای راحت‌تر در شب'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 25, 20, 0),
                  child: Text('درباره و پشتیبانی', style: Theme.of(context).textTheme.titleLarge),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    child: _ProfileActionTile(
                      icon: Icons.auto_awesome_rounded,
                      color: AppColors.goldDark,
                      title: 'Parsa Apps',
                      subtitle: 'دربارهٔ سازنده و پشتیبانی تلگرام',
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(builder: (_) => const AboutUsPage()),
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 25, 20, 34),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withOpacity(.10),
                      borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.privacy_tip_outlined, color: AppColors.secondary),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'کارتونیا در این نسخه حساب کاربری نمی‌سازد و فقط نام نمایشی، علاقه‌مندی‌ها و ادامهٔ تماشا را روی همین دستگاه نگه می‌دارد.',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: context.secondaryTextColor,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openSettings(BuildContext context) async {
    final allowed = await showParentalGate(context);
    if (!allowed || !context.mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const SettingsPage()),
    );
  }

  Future<void> _editName(
    BuildContext context,
    WidgetRef ref,
    String currentName,
  ) async {
    final controller = TextEditingController(text: currentName);
    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('نام نمایشی والد'),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLength: 28,
          textInputAction: TextInputAction.done,
          onSubmitted: (value) => Navigator.of(dialogContext).pop(value),
          decoration: const InputDecoration(
            hintText: 'مثلاً مامان یا بابا',
            counterText: '',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('انصراف'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(controller.text),
            child: const Text('ذخیره'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (result != null && context.mounted) {
      await ref.read(profileNameProvider.notifier).update(result);
    }
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.color,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final Color color;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: context.surfaceColor,
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          boxShadow: AppTheme.softShadow(context),
        ),
        child: Row(
          children: [
            Container(
              width: 39,
              height: 39,
              decoration: BoxDecoration(color: color.withOpacity(.14), shape: BoxShape.circle),
              child: Icon(icon, color: color, size: 21),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: Theme.of(context).textTheme.titleLarge),
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: context.secondaryTextColor,
                        fontSize: 11,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileActionTile extends StatelessWidget {
  const _ProfileActionTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      leading: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(color: color.withOpacity(.13), shape: BoxShape.circle),
        child: Icon(icon, color: color),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_back_ios_new_rounded, size: 16),
    );
  }
}
