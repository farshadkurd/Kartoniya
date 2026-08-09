import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/cartoon_model.dart';
import '../../data/providers/cartoons_provider.dart';
import 'cartoon_artwork.dart';

/// کارت یکپارچهٔ کاتالوگ با وضعیت علاقه‌مندی پایدار و بازخورد لمسی.
class CartoonCard extends ConsumerWidget {
  const CartoonCard({
    super.key,
    required this.cartoon,
    required this.onTap,
    this.compact = false,
  });

  final CartoonModel cartoon;
  final VoidCallback onTap;
  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavorite = ref.watch(favoritesProvider).contains(cartoon.id);
    final categoryColor = AppColors.categoryColor(cartoon.category);

    return Semantics(
      button: true,
      label: '${cartoon.title}، ${cartoon.category}، امتیاز ${cartoon.rating}',
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            HapticFeedback.selectionClick();
            onTap();
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  AspectRatio(
                    aspectRatio: compact ? 1.55 : 1.42,
                    child: CartoonArtwork(cartoon: cartoon),
                  ),
                  PositionedDirectional(
                    top: 8,
                    start: 8,
                    child: Tooltip(
                      message:
                          isFavorite ? 'حذف از علاقه‌مندی‌ها' : 'افزودن به علاقه‌مندی‌ها',
                      child: Material(
                        color: Colors.transparent,
                        child: IconButton.filledTonal(
                          visualDensity: VisualDensity.compact,
                          style: IconButton.styleFrom(
                            backgroundColor: isFavorite
                                ? AppColors.red
                                : Colors.white.withOpacity(.88),
                            foregroundColor:
                                isFavorite ? Colors.white : AppColors.red,
                          ),
                          onPressed: () {
                            HapticFeedback.lightImpact();
                            ref.read(favoritesProvider.notifier).toggle(cartoon.id);
                          },
                          icon: Icon(
                            isFavorite
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            size: 19,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        cartoon.title,
                        maxLines: compact ? 1 : 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontSize: compact ? 14 : 15,
                            ),
                      ),
                      Row(
                        children: [
                          Flexible(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 7,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: categoryColor.withOpacity(.12),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                cartoon.category,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge
                                    ?.copyWith(
                                      color: categoryColor,
                                      fontSize: 10,
                                    ),
                              ),
                            ),
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.star_rounded,
                            color: AppColors.yellow,
                            size: 16,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            cartoon.rating.toStringAsFixed(1),
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(fontSize: 11),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
