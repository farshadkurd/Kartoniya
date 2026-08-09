import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/cartoon_model.dart';
import '../../data/providers/cartoons_provider.dart';
import '../widgets/cartoon_card.dart';
import 'cartoon_detail_page.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final _controller = TextEditingController();
  Timer? _debounce;
  String _query = '';
  bool _waitingForQuery = false;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    setState(() {
      _query = value;
      _waitingForQuery = value.trim().isNotEmpty;
    });
    _debounce?.cancel();
    if (value.trim().isEmpty) {
      ref.read(searchQueryProvider.notifier).state = '';
      setState(() => _waitingForQuery = false);
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 280), () {
      if (!mounted) return;
      ref.read(searchQueryProvider.notifier).state = value;
      setState(() => _waitingForQuery = false);
    });
  }

  void _submitImmediately(String value) {
    _debounce?.cancel();
    ref.read(searchQueryProvider.notifier).state = value;
    setState(() => _waitingForQuery = false);
  }

  void _selectSuggestion(String value) {
    _controller.value = TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
    );
    _onChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    final result = ref.watch(searchResultsProvider);
    final showSuggestions = _query.trim().isEmpty;

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    gradient: AppColors.coolGradient,
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  ),
                  child: const Icon(Icons.search_rounded, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Text('جست‌وجو', style: Theme.of(context).textTheme.headlineSmall),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: _controller,
              autofocus: false,
              textInputAction: TextInputAction.search,
              onChanged: _onChanged,
              onSubmitted: _submitImmediately,
              decoration: InputDecoration(
                hintText: 'نام، موضوع یا دسته را بنویس…',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _query.isEmpty
                    ? null
                    : IconButton(
                        tooltip: 'پاک کردن جست‌وجو',
                        onPressed: () {
                          _controller.clear();
                          _onChanged('');
                        },
                        icon: const Icon(Icons.close_rounded),
                      ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Expanded(
            child: showSuggestions
                ? _SearchSuggestions(onSelected: _selectSuggestion)
                : _waitingForQuery
                    ? const Center(child: CircularProgressIndicator())
                    : result.when(
                        data: (items) => items.isEmpty
                            ? const _NoSearchResult()
                            : _SearchResultGrid(
                                cartoons: items,
                                onTap: (cartoon) => _openDetail(context, cartoon),
                              ),
                        loading: () => const Center(child: CircularProgressIndicator()),
                        error: (_, __) => Center(
                          child: OutlinedButton.icon(
                            onPressed: () => ref.invalidate(searchResultsProvider),
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

  void _openDetail(BuildContext context, CartoonModel cartoon) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => CartoonDetailPage(cartoon: cartoon)),
    );
  }
}

class _SearchSuggestions extends StatelessWidget {
  const _SearchSuggestions({required this.onSelected});

  final ValueChanged<String> onSelected;

  static const _suggestions = [
    ('🚀', 'ماجراجویی'),
    ('📚', 'آموزشی'),
    ('🎪', 'سرگرمی'),
    ('🔬', 'علمی'),
    ('🎨', 'هنری'),
    ('🎵', 'موسیقی'),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('پیشنهاد برای جست‌وجو', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          Text(
            'یک دسته را انتخاب کن یا نام کارتونی که دوست داری را بنویس.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: context.secondaryTextColor,
                ),
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _suggestions
                .map(
                  (suggestion) => ActionChip(
                    avatar: Text(suggestion.$1),
                    label: Text(suggestion.$2),
                    onPressed: () => onSelected(suggestion.$2),
                  ),
                )
                .toList(growable: false),
          ),
        ],
      ),
    );
  }
}

class _SearchResultGrid extends StatelessWidget {
  const _SearchResultGrid({required this.cartoons, required this.onTap});

  final List<CartoonModel> cartoons;
  final ValueChanged<CartoonModel> onTap;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 220,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: .74,
      ),
      itemCount: cartoons.length,
      itemBuilder: (context, index) => CartoonCard(
        cartoon: cartoons[index],
        onTap: () => onTap(cartoons[index]),
      ),
    );
  }
}

class _NoSearchResult extends StatelessWidget {
  const _NoSearchResult();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🔎', style: TextStyle(fontSize: 54)),
            const SizedBox(height: 14),
            Text('چیزی پیدا نشد', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 7),
            Text(
              'املای کلمه را بررسی کن یا یک دستهٔ دیگر را امتحان کن.',
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
