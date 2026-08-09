import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../data/providers/cartoons_provider.dart';
import 'home_page.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final _pageController = PageController();
  var _currentPage = 0;
  var _isCompleting = false;

  static const _pages = [
    _OnboardingData(
      icon: Icons.auto_awesome_rounded,
      emoji: '🎬',
      title: 'هر روز یک ماجرای تازه',
      description:
          'کارتون‌های کوتاه و رنگی را براساس علاقه و سن کودک پیدا کنید.',
      color: AppColors.primary,
    ),
    _OnboardingData(
      icon: Icons.favorite_rounded,
      emoji: '🌈',
      title: 'فضایی آرام برای کودک',
      description:
          'علاقه‌مندی‌ها و ادامهٔ تماشا فقط روی همین دستگاه ذخیره می‌شوند.',
      color: AppColors.pink,
    ),
    _OnboardingData(
      icon: Icons.family_restroom_rounded,
      emoji: '🛡️',
      title: 'کنترل در دست والدین',
      description:
          'تنظیمات والدین با یک پرسش تصادفی محافظت می‌شود تا کودک با خیال راحت تماشا کند.',
      color: AppColors.secondary,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    if (_isCompleting) return;
    setState(() => _isCompleting = true);
    await ref.read(onboardingProvider.notifier).complete();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => const HomePage()),
      (route) => false,
    );
  }

  void _next() {
    if (_currentPage == _pages.length - 1) {
      _finish();
      return;
    }
    _pageController.nextPage(
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final page = _pages[_currentPage];
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: TextButton(
                onPressed: _isCompleting ? null : _finish,
                child: const Text('رد کردن'),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (value) => setState(() => _currentPage = value),
                itemBuilder: (context, index) {
                  final item = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 178,
                          height: 178,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.lerp(item.color, Colors.white, .42)!,
                                item.color,
                              ],
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: item.color.withOpacity(.30),
                                blurRadius: 34,
                                offset: const Offset(0, 14),
                              ),
                            ],
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Text(item.emoji, style: const TextStyle(fontSize: 66)),
                              Positioned(
                                bottom: 20,
                                right: 28,
                                child: Icon(item.icon, color: Colors.white, size: 30),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 42),
                        Text(
                          item.title,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 14),
                        Text(
                          item.description,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: context.secondaryTextColor,
                              ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
              child: Row(
                children: [
                  Row(
                    children: List.generate(_pages.length, (index) {
                      final selected = index == _currentPage;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        margin: const EdgeInsetsDirectional.only(end: 6),
                        width: selected ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: selected ? page.color : context.softBorderColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      );
                    }),
                  ),
                  const Spacer(),
                  FilledButton.icon(
                    onPressed: _isCompleting ? null : _next,
                    icon: _isCompleting
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Icon(
                            _currentPage == _pages.length - 1
                                ? Icons.check_rounded
                                : Icons.arrow_back_rounded,
                          ),
                    label: Text(
                      _currentPage == _pages.length - 1 ? 'شروع کارتونیا' : 'بعدی',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingData {
  const _OnboardingData({
    required this.icon,
    required this.emoji,
    required this.title,
    required this.description,
    required this.color,
  });

  final IconData icon;
  final String emoji;
  final String title;
  final String description;
  final Color color;
}
