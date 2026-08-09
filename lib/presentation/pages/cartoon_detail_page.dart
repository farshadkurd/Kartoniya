import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/cartoon_model.dart';
import '../../data/providers/cartoons_provider.dart';
import '../widgets/cartoon_artwork.dart';
import 'player_page.dart';

class CartoonDetailPage extends ConsumerWidget {
  const CartoonDetailPage({super.key, required this.cartoon});

  final CartoonModel cartoon;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavorite = ref.watch(favoritesProvider).contains(cartoon.id);
    final progress = ref.watch(watchHistoryProvider);
    final categoryColor = AppColors.categoryColor(cartoon.category);

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 286,
            pinned: true,
            backgroundColor: context.pageBackground,
            leading: IconButton.filledTonal(
              tooltip: 'بازگشت',
              onPressed: () => Navigator.of(context).maybePop(),
              icon: const Icon(Icons.arrow_forward_rounded),
            ),
            actions: [
              Padding(
                padding: const EdgeInsetsDirectional.only(end: 8),
                child: IconButton.filledTonal(
                  tooltip:
                      isFavorite ? 'حذف از علاقه‌مندی‌ها' : 'افزودن به علاقه‌مندی‌ها',
                  style: IconButton.styleFrom(
                    backgroundColor: isFavorite
                        ? AppColors.red.withOpacity(.94)
                        : context.surfaceColor.withOpacity(.90),
                    foregroundColor: isFavorite ? Colors.white : AppColors.red,
                  ),
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    ref.read(favoritesProvider.notifier).toggle(cartoon.id);
                  },
                  icon: Icon(
                    isFavorite
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  CartoonArtwork(
                    cartoon: cartoon,
                    borderRadius: 0,
                    showPlayAffordance: false,
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(.12),
                          Colors.transparent,
                          context.pageBackground,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 760),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 34),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(cartoon.title, style: Theme.of(context).textTheme.headlineMedium),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _InfoPill(
                            icon: Icons.star_rounded,
                            color: AppColors.yellow,
                            text: cartoon.rating.toStringAsFixed(1),
                          ),
                          _InfoPill(
                            icon: Icons.schedule_rounded,
                            color: context.secondaryTextColor,
                            text: cartoon.durationLabel,
                          ),
                          _InfoPill(
                            icon: Icons.child_care_rounded,
                            color: AppColors.secondary,
                            text: 'سن ${cartoon.ageRange}',
                          ),
                          _InfoPill(
                            icon: Icons.movie_outlined,
                            color: categoryColor,
                            text: '${cartoon.episodeCount} قسمت',
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: context.surfaceColor,
                          borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                          boxShadow: AppTheme.softShadow(context),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('دربارهٔ این کارتون', style: Theme.of(context).textTheme.titleMedium),
                            const SizedBox(height: 7),
                            Text(
                              cartoon.description,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: context.secondaryTextColor,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      FilledButton.icon(
                        style: FilledButton.styleFrom(
                          minimumSize: const Size(double.infinity, 58),
                          backgroundColor: categoryColor,
                        ),
                        onPressed: () => _play(context, cartoon.firstEpisode),
                        icon: const Icon(Icons.play_circle_fill_rounded, size: 27),
                        label: const Text('شروع تماشا'),
                      ),
                      const SizedBox(height: 28),
                      Text('قسمت‌ها', style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 10),
                      ...cartoon.episodes.map(
                        (episode) => _EpisodeTile(
                          episode: episode,
                          color: categoryColor,
                          progress: progress[episode.id] ?? 0.0,
                          onTap: () => _play(context, episode),
                        ),
                      ),
                      if (cartoon.tags.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Text('برچسب‌ها', style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: cartoon.tags
                              .map((tag) => Chip(label: Text('#$tag')))
                              .toList(growable: false),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _play(BuildContext context, EpisodeModel episode) {
    HapticFeedback.mediumImpact();
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => PlayerPage(cartoon: cartoon, episode: episode),
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  const _InfoPill({required this.icon, required this.color, required this.text});

  final IconData icon;
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: color.withOpacity(.12),
        borderRadius: BorderRadius.circular(AppTheme.radiusCircular),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 17),
          const SizedBox(width: 5),
          Text(
            text,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: color,
                  fontSize: 12,
                ),
          ),
        ],
      ),
    );
  }
}

class _EpisodeTile extends StatelessWidget {
  const _EpisodeTile({
    required this.episode,
    required this.color,
    required this.progress,
    required this.onTap,
  });

  final EpisodeModel episode;
  final Color color;
  final double progress;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final hasProgress = progress > .01;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(13),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: color.withOpacity(.14),
                    borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                  ),
                  child: Icon(
                    hasProgress ? Icons.play_arrow_rounded : Icons.movie_rounded,
                    color: color,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              episode.title,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          if (episode.isNew)
                            Text(
                              'جدید',
                              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                    color: color,
                                    fontSize: 11,
                                  ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        episode.durationLabel,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: context.secondaryTextColor,
                            ),
                      ),
                      if (hasProgress) ...[
                        const SizedBox(height: 7),
                        LinearProgressIndicator(
                          value: progress,
                          minHeight: 4,
                          color: color,
                          backgroundColor: color.withOpacity(.15),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.arrow_back_ios_new_rounded, color: context.secondaryTextColor, size: 17),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
