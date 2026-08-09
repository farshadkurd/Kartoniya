import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/cartoon_model.dart';
import '../../data/providers/cartoons_provider.dart';
import '../widgets/cartoon_card.dart';
import '../widgets/shimmer_loader.dart';
import 'cartoon_detail_page.dart';

class FavoritesPage extends ConsumerWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);
    final cartoons = ref.watch(cartoonsProvider);

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    gradient: AppColors.warmGradient,
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  ),
                  child: const Icon(Icons.favorite_rounded, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('علاقه‌مندی‌ها', style: Theme.of(context).textTheme.headlineSmall),
                      Text(
                        '${favorites.length} کارتون ذخیره شده',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: context.secondaryTextColor,
                            ),
                      ),
                    ],
                  ),
                ),
                if (favorites.isNotEmpty)
                  IconButton(
                    tooltip: 'پاک کردن علاقه‌مندی‌ها',
                    onPressed: () => _confirmClear(context, ref),
                    icon: const Icon(Icons.delete_outline_rounded),
                  ),
              ],
            ),
          ),
          Expanded(
            child: cartoons.when(
              data: (items) {
                final selected = items
                    .where((cartoon) => favorites.contains(cartoon.id))
                    .toList(growable: false);
                if (selected.isEmpty) return const _FavoritesEmptyState();
                return GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 220,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: .74,
                  ),
                  itemCount: selected.length,
                  itemBuilder: (context, index) => CartoonCard(
                    cartoon: selected[index],
                    onTap: () => _openDetail(context, selected[index]),
                  ),
                );
              },
              loading: () => const _FavoritesLoading(),
              error: (_, __) => Center(
                child: OutlinedButton.icon(
                  onPressed: () => ref.invalidate(cartoonsProvider),
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('تلاش دوباره'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmClear(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: const Icon(Icons.delete_outline_rounded),
        title: const Text('پاک کردن علاقه‌مندی‌ها؟'),
        content: const Text('این فهرست فقط از همین دستگاه پاک می‌شود.'),
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
    if (confirmed == true) {
      await ref.read(favoritesProvider.notifier).clear();
    }
  }

  void _openDetail(BuildContext context, CartoonModel cartoon) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => CartoonDetailPage(cartoon: cartoon)),
    );
  }
}

class _FavoritesEmptyState extends StatelessWidget {
  const _FavoritesEmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 106,
              height: 106,
              decoration: BoxDecoration(
                color: AppColors.red.withOpacity(.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.favorite_border_rounded,
                size: 54,
                color: AppColors.red,
              ),
            ),
            const SizedBox(height: 20),
            Text('هنوز چیزی اینجا نیست', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              'روی قلب هر کارتون بزن تا بعداً سریع‌تر پیدایش کنی.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: context.secondaryTextColor,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FavoritesLoading extends StatelessWidget {
  const _FavoritesLoading();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 220,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: .74,
      ),
      itemCount: 4,
      itemBuilder: (_, __) => const ShimmerCard(),
    );
  }
}
