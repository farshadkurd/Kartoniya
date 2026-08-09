import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/cartoon_model.dart';
import '../../data/providers/cartoons_provider.dart';
import '../widgets/cartoon_artwork.dart';
import '../widgets/cartoon_card.dart';
import '../widgets/shimmer_loader.dart';
import 'cartoon_detail_page.dart';
import 'categories_page.dart';
import 'favorites_page.dart';
import 'profile_page.dart';
import 'search_page.dart';

/// پوستهٔ اصلی برنامه. IndexedStack وضعیت هر برگه (به‌ویژه جست‌وجو) را هنگام
/// جابه‌جایی در نوار پایین حفظ می‌کند.
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  var _selectedIndex = 0;

  void _selectTab(int index) => setState(() => _selectedIndex = index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _DiscoverTab(
            onOpenCategories: () => _selectTab(1),
            onOpenProfile: () => _selectTab(4),
          ),
          const CategoriesPage(),
          const FavoritesPage(),
          const SearchPage(),
          const ProfilePage(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _selectTab,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'خانه',
          ),
          NavigationDestination(
            icon: Icon(Icons.grid_view_outlined),
            selectedIcon: Icon(Icons.grid_view_rounded),
            label: 'دسته‌ها',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border_rounded),
            selectedIcon: Icon(Icons.favorite_rounded),
            label: 'دلخواه',
          ),
          NavigationDestination(
            icon: Icon(Icons.search_rounded),
            selectedIcon: Icon(Icons.search_rounded),
            label: 'جست‌وجو',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'والدین',
          ),
        ],
      ),
    );
  }
}

class _DiscoverTab extends ConsumerWidget {
  const _DiscoverTab({
    required this.onOpenCategories,
    required this.onOpenProfile,
  });

  final VoidCallback onOpenCategories;
  final VoidCallback onOpenProfile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartoons = ref.watch(cartoonsProvider);
    final categories = ref.watch(categoriesProvider);
    final favorites = ref.watch(favoritesProvider);
    final history = ref.watch(watchHistoryProvider);
    final parentName = ref.watch(profileNameProvider);

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(cartoonsProvider);
          ref.invalidate(categoriesProvider);
          await ref.read(cartoonsProvider.future);
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 4),
                child: _HomeHeader(
                  parentName: parentName,
                  onProfileTap: onOpenProfile,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: _WelcomeBanner(onTap: onOpenCategories),
              ),
            ),
            SliverToBoxAdapter(
              child: _SectionTitle(
                title: 'برای امروز انتخاب کن',
                action: 'دسته‌بندی‌ها',
                onAction: onOpenCategories,
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 48,
                child: categories.when(
                  data: (items) => ListView.separated(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final category = items[index];
                      return ActionChip(
                        avatar: Text(category.emoji),
                        label: Text(category.name),
                        onPressed: () {
                          ref.read(selectedCategoryProvider.notifier).state =
                              category.id == 'all' ? null : category.name;
                          onOpenCategories();
                        },
                      );
                    },
                  ),
                  loading: () => const _ChipsLoading(),
                  error: (_, __) => const SizedBox.shrink(),
                ),
              ),
            ),
            if (history.isNotEmpty)
              SliverToBoxAdapter(
                child: _SectionTitle(title: 'ادامهٔ تماشا'),
              ),
            if (history.isNotEmpty)
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 202,
                  child: cartoons.when(
                    data: (items) => _ContinueWatchingList(
                      cartoons: items,
                      progress: history,
                      onTap: (cartoon) => _openDetail(context, cartoon),
                    ),
                    loading: () => const _HorizontalLoading(),
                    error: (_, __) => const SizedBox.shrink(),
                  ),
                ),
              ),
            SliverToBoxAdapter(
              child: _SectionTitle(
                title: 'پیشنهاد ویژه',
                action: 'همه',
                onAction: onOpenCategories,
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 218,
                child: cartoons.when(
                  data: (items) => _HorizontalCartoonList(
                    cartoons: items.where((item) => item.isFeatured).toList(),
                    onTap: (cartoon) => _openDetail(context, cartoon),
                  ),
                  loading: () => const _HorizontalLoading(),
                  error: (_, __) => _InlineError(
                    onRetry: () => ref.invalidate(cartoonsProvider),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: _SectionTitle(title: 'همهٔ کارتون‌ها'),
            ),
            cartoons.when(
              data: (items) => _CartoonGridSliver(
                cartoons: items,
                onTap: (cartoon) => _openDetail(context, cartoon),
              ),
              loading: () => const _CartoonGridLoadingSliver(),
              error: (_, __) => SliverToBoxAdapter(
                child: _PageError(
                  title: 'کاتالوگ باز نشد',
                  description: 'اتصال را بررسی کنید و دوباره تلاش کنید.',
                  onRetry: () => ref.invalidate(cartoonsProvider),
                ),
              ),
            ),
            if (favorites.isNotEmpty)
              const SliverToBoxAdapter(child: SizedBox(height: 20)),
            const SliverToBoxAdapter(child: SizedBox(height: 30)),
          ],
        ),
      ),
    );
  }

  void _openDetail(BuildContext context, CartoonModel cartoon) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => CartoonDetailPage(cartoon: cartoon)),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({required this.parentName, required this.onProfileTap});

  final String parentName;
  final VoidCallback onProfileTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: const BoxDecoration(
            gradient: AppColors.sunsetGradient,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 28),
        ),
        const SizedBox(width: 11),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('کارتونیا', style: Theme.of(context).textTheme.titleLarge),
              Text(
                'سلام $parentName 👋',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: context.secondaryTextColor,
                    ),
              ),
            ],
          ),
        ),
        IconButton.filledTonal(
          tooltip: 'پروفایل والدین',
          onPressed: onProfileTap,
          icon: const Icon(Icons.tune_rounded),
        ),
      ],
    );
  }
}

class _WelcomeBanner extends StatelessWidget {
  const _WelcomeBanner({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'باز کردن دسته‌بندی‌ها',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
        child: Ink(
          height: 148,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(.25),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'وقت یک ماجرای تازه است!',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                          ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'کوتاه، شاد و مناسب کوچولوها',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withOpacity(.88),
                          ),
                    ),
                    const SizedBox(height: 10),
                    const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('دیدن دسته‌ها', style: TextStyle(color: Colors.white)),
                        SizedBox(width: 4),
                        Icon(Icons.arrow_back_rounded, color: Colors.white, size: 18),
                      ],
                    ),
                  ],
                ),
              ),
              const Text('🎬', style: TextStyle(fontSize: 62)),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({this.title = '', this.action, this.onAction});

  final String title;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 26, 20, 12),
      child: Row(
        children: [
          Expanded(child: Text(title, style: Theme.of(context).textTheme.titleLarge)),
          if (action != null)
            TextButton(onPressed: onAction, child: Text(action!)),
        ],
      ),
    );
  }
}

class _HorizontalCartoonList extends StatelessWidget {
  const _HorizontalCartoonList({required this.cartoons, required this.onTap});

  final List<CartoonModel> cartoons;
  final ValueChanged<CartoonModel> onTap;

  @override
  Widget build(BuildContext context) {
    if (cartoons.isEmpty) return const SizedBox.shrink();
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: cartoons.length,
      separatorBuilder: (_, __) => const SizedBox(width: 12),
      itemBuilder: (context, index) => SizedBox(
        width: 208,
        child: CartoonCard(
          cartoon: cartoons[index],
          compact: true,
          onTap: () => onTap(cartoons[index]),
        ),
      ),
    );
  }
}

class _ContinueWatchingList extends StatelessWidget {
  const _ContinueWatchingList({
    required this.cartoons,
    required this.progress,
    required this.onTap,
  });

  final List<CartoonModel> cartoons;
  final Map<String, double> progress;
  final ValueChanged<CartoonModel> onTap;

  @override
  Widget build(BuildContext context) {
    final entries = <_WatchingEntry>[];
    for (final cartoon in cartoons) {
      for (final episode in cartoon.episodes) {
        final amount = progress[episode.id];
        if (amount != null && amount > 0) {
          entries.add(_WatchingEntry(cartoon, episode.title, amount));
        }
      }
    }
    if (entries.isEmpty) return const SizedBox.shrink();
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: entries.length,
      separatorBuilder: (_, __) => const SizedBox(width: 12),
      itemBuilder: (context, index) {
        final entry = entries[index];
        final color = entry.cartoon.artworkColor;
        return SizedBox(
          width: 224,
          child: Semantics(
            button: true,
            label: 'ادامه ${entry.cartoon.title}، ${entry.episodeTitle}',
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () => onTap(entry.cartoon),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: CartoonArtwork(
                        cartoon: entry.cartoon,
                        showTitle: true,
                        showPlayAffordance: false,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            entry.episodeTitle,
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              value: entry.progress,
                              minHeight: 6,
                              color: color,
                              backgroundColor: color.withOpacity(.14),
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
      },
    );
  }
}

class _WatchingEntry {
  const _WatchingEntry(this.cartoon, this.episodeTitle, this.progress);

  final CartoonModel cartoon;
  final String episodeTitle;
  final double progress;
}

class _CartoonGridSliver extends StatelessWidget {
  const _CartoonGridSliver({required this.cartoons, required this.onTap});

  final List<CartoonModel> cartoons;
  final ValueChanged<CartoonModel> onTap;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 210,
          mainAxisSpacing: 14,
          crossAxisSpacing: 14,
          childAspectRatio: .74,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) => CartoonCard(
            cartoon: cartoons[index],
            onTap: () => onTap(cartoons[index]),
          ),
          childCount: cartoons.length,
        ),
      ),
    );
  }
}

class _CartoonGridLoadingSliver extends StatelessWidget {
  const _CartoonGridLoadingSliver();

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 210,
          mainAxisSpacing: 14,
          crossAxisSpacing: 14,
          childAspectRatio: .74,
        ),
        delegate: SliverChildBuilderDelegate(
          (_, __) => const ShimmerCard(),
          childCount: 6,
        ),
      ),
    );
  }
}

class _HorizontalLoading extends StatelessWidget {
  const _HorizontalLoading();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: 2,
      separatorBuilder: (_, __) => const SizedBox(width: 12),
      itemBuilder: (_, __) => const SizedBox(width: 208, child: ShimmerCard(compact: true)),
    );
  }
}

class _ChipsLoading extends StatelessWidget {
  const _ChipsLoading();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: 4,
      separatorBuilder: (_, __) => const SizedBox(width: 8),
      itemBuilder: (_, __) => Container(
        width: 88,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(AppTheme.radiusCircular),
        ),
      ),
    );
  }
}

class _InlineError extends StatelessWidget {
  const _InlineError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton.icon(
        onPressed: onRetry,
        icon: const Icon(Icons.refresh_rounded),
        label: const Text('تلاش دوباره'),
      ),
    );
  }
}

class _PageError extends StatelessWidget {
  const _PageError({
    required this.title,
    required this.description,
    required this.onRetry,
  });

  final String title;
  final String description;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(28),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.cloud_off_rounded, size: 52, color: context.secondaryTextColor),
            const SizedBox(height: 12),
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 5),
            Text(description, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('تلاش دوباره'),
            ),
          ],
        ),
      ),
    );
  }
}
