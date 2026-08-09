import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/cartoon_model.dart';
import '../../data/providers/cartoons_provider.dart';
import '../widgets/cartoon_card.dart';
import '../widgets/shimmer_loader.dart';
import 'cartoon_detail_page.dart';

class CategoriesPage extends ConsumerWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoriesProvider);
    final cartoons = ref.watch(cartoonsProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);

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
                    gradient: AppColors.coolGradient,
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  ),
                  child: const Icon(Icons.grid_view_rounded, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'دسته‌بندی‌ها',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 62,
            child: categories.when(
              data: (items) => ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                physics: const BouncingScrollPhysics(),
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(width: 9),
                itemBuilder: (context, index) {
                  final category = items[index];
                  final selected = (category.id == 'all' && selectedCategory == null) ||
                      category.name == selectedCategory;
                  return FilterChip(
                    selected: selected,
                    showCheckmark: false,
                    avatar: Text(category.emoji),
                    label: Text(category.name),
                    selectedColor: category.color.withOpacity(.2),
                    labelStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: selected ? category.color : context.secondaryTextColor,
                        ),
                    onSelected: (_) {
                      ref.read(selectedCategoryProvider.notifier).state =
                          category.id == 'all' ? null : category.name;
                    },
                  );
                },
              ),
              loading: () => const _CategoryChipsSkeleton(),
              error: (_, __) => Center(
                child: TextButton.icon(
                  onPressed: () => ref.invalidate(categoriesProvider),
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('بارگذاری دسته‌ها'),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 10),
            child: Text(
              selectedCategory == null ? 'همهٔ کارتون‌ها' : selectedCategory,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Expanded(
            child: cartoons.when(
              data: (items) {
                final visible = selectedCategory == null
                    ? items
                    : items
                        .where((item) => item.category == selectedCategory)
                        .toList(growable: false);
                if (visible.isEmpty) return const _NoCategoryContent();
                return GridView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 220,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: .74,
                  ),
                  itemCount: visible.length,
                  itemBuilder: (context, index) => CartoonCard(
                    cartoon: visible[index],
                    onTap: () => _openDetail(context, visible[index]),
                  ),
                );
              },
              loading: () => const _CategoryGridLoading(),
              error: (_, __) => _CategoryError(
                onRetry: () => ref.invalidate(cartoonsProvider),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openDetail(BuildContext context, CartoonModel cartoon) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => CartoonDetailPage(cartoon: cartoon)),
    );
  }
}

class _CategoryChipsSkeleton extends StatelessWidget {
  const _CategoryChipsSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
      itemCount: 4,
      separatorBuilder: (_, __) => const SizedBox(width: 9),
      itemBuilder: (_, __) => Container(
        width: 92,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(AppTheme.radiusCircular),
        ),
      ),
    );
  }
}

class _CategoryGridLoading extends StatelessWidget {
  const _CategoryGridLoading();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 220,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: .74,
      ),
      itemCount: 6,
      itemBuilder: (_, __) => const ShimmerCard(),
    );
  }
}

class _NoCategoryContent extends StatelessWidget {
  const _NoCategoryContent();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🧩', style: TextStyle(fontSize: 52)),
            const SizedBox(height: 14),
            Text('هنوز چیزی در این دسته نیست', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 6),
            Text(
              'یک دستهٔ دیگر را امتحان کن.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryError extends StatelessWidget {
  const _CategoryError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: OutlinedButton.icon(
        onPressed: onRetry,
        icon: const Icon(Icons.refresh_rounded),
        label: const Text('تلاش دوباره'),
      ),
    );
  }
}
