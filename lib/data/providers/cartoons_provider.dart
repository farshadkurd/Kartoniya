import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/services/app_preferences.dart';
import '../../core/utils/text_normalizer.dart';
import '../../domain/repositories/cartoon_repository.dart';
import '../models/cartoon_model.dart';
import '../repositories/local_cartoon_repository.dart';

/// در [main] با نمونهٔ واقعی SharedPreferences override می‌شود.
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences باید هنگام شروع برنامه فراهم شود.');
});

final appPreferencesProvider = Provider<AppPreferences>((ref) {
  return AppPreferences(ref.watch(sharedPreferencesProvider));
});

final cartoonRepositoryProvider = Provider<CartoonRepository>((ref) {
  return LocalCartoonRepository();
});

final cartoonsProvider = FutureProvider<List<CartoonModel>>((ref) {
  return ref.watch(cartoonRepositoryProvider).fetchCartoons();
});

final categoriesProvider = FutureProvider<List<CategoryModel>>((ref) {
  return ref.watch(cartoonRepositoryProvider).fetchCategories();
});

final featuredCartoonsProvider = FutureProvider<List<CartoonModel>>((ref) async {
  final cartoons = await ref.watch(cartoonsProvider.future);
  return cartoons.where((cartoon) => cartoon.isFeatured).toList(growable: false);
});

final newCartoonsProvider = FutureProvider<List<CartoonModel>>((ref) async {
  final cartoons = await ref.watch(cartoonsProvider.future);
  return cartoons.where((cartoon) => cartoon.isNew).toList(growable: false);
});

final selectedCategoryProvider = StateProvider<String?>((ref) => null);

final filteredCartoonsProvider = FutureProvider<List<CartoonModel>>((ref) async {
  final selectedCategory = ref.watch(selectedCategoryProvider);
  final cartoons = await ref.watch(cartoonsProvider.future);
  if (selectedCategory == null) return cartoons;
  return cartoons
      .where((cartoon) => cartoon.category == selectedCategory)
      .toList(growable: false);
});

final searchQueryProvider = StateProvider<String>((ref) => '');

final searchResultsProvider = FutureProvider<List<CartoonModel>>((ref) async {
  final query = normalizeForSearch(ref.watch(searchQueryProvider));
  if (query.isEmpty) return const <CartoonModel>[];
  final cartoons = await ref.watch(cartoonsProvider.future);
  return cartoons.where((cartoon) {
    final searchableText = <String>[
      cartoon.title,
      cartoon.description,
      cartoon.category,
      ...cartoon.tags,
    ].join(' ');
    return normalizeForSearch(searchableText).contains(query);
  }).toList(growable: false);
});

final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, Set<String>>((ref) {
  return FavoritesNotifier(ref.watch(appPreferencesProvider));
});

class FavoritesNotifier extends StateNotifier<Set<String>> {
  FavoritesNotifier(this._preferences) : super(_preferences.favoriteIds);

  final AppPreferences _preferences;

  void toggle(String cartoonId) {
    final next = <String>{...state};
    if (!next.add(cartoonId)) next.remove(cartoonId);
    state = Set<String>.unmodifiable(next);
    unawaited(_preferences.saveFavoriteIds(state));
  }

  Future<void> clear() async {
    state = const <String>{};
    await _preferences.clearFavorites();
  }
}

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier(ref.watch(appPreferencesProvider));
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier(this._preferences) : super(_preferences.themeMode);

  final AppPreferences _preferences;

  Future<void> setMode(ThemeMode mode) async {
    state = mode;
    await _preferences.saveThemeMode(mode);
  }
}

final autoplayProvider = StateNotifierProvider<AutoplayNotifier, bool>((ref) {
  return AutoplayNotifier(ref.watch(appPreferencesProvider));
});

class AutoplayNotifier extends StateNotifier<bool> {
  AutoplayNotifier(this._preferences) : super(_preferences.autoplayEnabled);

  final AppPreferences _preferences;

  Future<void> setEnabled(bool value) async {
    state = value;
    await _preferences.saveAutoplayEnabled(value);
  }
}

final profileNameProvider = StateNotifierProvider<ProfileNameNotifier, String>((ref) {
  return ProfileNameNotifier(ref.watch(appPreferencesProvider));
});

class ProfileNameNotifier extends StateNotifier<String> {
  ProfileNameNotifier(this._preferences) : super(_preferences.parentName);

  final AppPreferences _preferences;

  Future<void> update(String value) async {
    final next = value.trim().isEmpty ? 'والد مهربان' : value.trim();
    state = next;
    await _preferences.saveParentName(next);
  }
}

final onboardingProvider = StateNotifierProvider<OnboardingNotifier, bool>((ref) {
  return OnboardingNotifier(ref.watch(appPreferencesProvider));
});

class OnboardingNotifier extends StateNotifier<bool> {
  OnboardingNotifier(this._preferences) : super(_preferences.onboardingCompleted);

  final AppPreferences _preferences;

  Future<void> complete() async {
    state = true;
    await _preferences.completeOnboarding();
  }
}

final watchHistoryProvider =
    StateNotifierProvider<WatchHistoryNotifier, Map<String, double>>((ref) {
  return WatchHistoryNotifier(ref.watch(appPreferencesProvider));
});

class WatchHistoryNotifier extends StateNotifier<Map<String, double>> {
  WatchHistoryNotifier(this._preferences)
      : super(Map<String, double>.unmodifiable(_preferences.watchProgress));

  final AppPreferences _preferences;

  void saveProgress(String episodeId, double value) {
    final normalized = value.clamp(0.0, 1.0).toDouble();
    final next = <String, double>{...state};
    if (normalized >= .995) {
      next.remove(episodeId);
    } else if (normalized > .01) {
      next[episodeId] = normalized;
    }
    state = Map<String, double>.unmodifiable(next);
    unawaited(_preferences.saveWatchProgress(state));
  }

  Future<void> clear() async {
    state = const <String, double>{};
    await _preferences.clearWatchProgress();
  }
}

final episodeProgressProvider = Provider.family<double, String>((ref, episodeId) {
  return ref.watch(watchHistoryProvider)[episodeId] ?? 0.0;
});
