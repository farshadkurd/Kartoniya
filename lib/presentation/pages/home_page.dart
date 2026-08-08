// lib/presentation/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/theme/app_theme.dart';
import '../../data/providers/cartoons_provider.dart';
import '../widgets/shimmer_loader.dart'; // ما این ویجت را پایین‌تر می‌سازیم
import '../pages/about_us_page.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartoonsAsync = ref.watch(cartoonsProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppTheme.background,
        
        // هدر بالا
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("🌟 ", style: TextStyle(fontSize: 24)),
              Text("کارتون‌های جدید", style: Theme.of(context).textTheme.headlineMedium)
            ],
          ),
          actions: [
            IconButton(icon: Icon(Icons.info_outline_rounded), onPressed: () {
               Navigator.push(context, MaterialPageRoute(builder: (_) => AboutUsPage()));
            })
          ],
        ),
        
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- نوار جستجو (فیک) ---
              Container(
                margin: EdgeInsets.only(bottom: 20),
                child: TextField(
                  readOnly: true,
                  onTap: () { /* TODO: */ },
                  decoration: InputDecoration(
                    hintText: 'جستجوی کارتون...',
                    prefixIcon: Icon(Icons.search_rounded, color: AppTheme.primary),
                    filled: true,
                    fillColor: AppTheme.surface,
                  ),
                ),
              ),

              Expanded(
                child: cartoonsAsync.when(
                  data: (cartoons) => GridView.builder(
                    clipBehavior: Clip.none,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // دو ستون
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 24,
                      childAspectRatio: 0.85, // نسبت طول به عرض کارت (اندکی عمودی)
                    ),
                    itemCount: cartoons.length,
                    itemBuilder: (context, index) => _buildCartoonCard(context, cartoons[index]),
                  ),
                  loading: () => GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 24, childAspectRatio: 0.85),
                    itemCount: 6,
                    itemBuilder: (ctx, i) => ShimmerCard(), // لودینگ اسکلتونی
                  ),
                  error: (error, stack) => Center(child: Text("خطا دربارگذاری")),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCartoonCard(BuildContext context, cartoon) {
    return GestureDetector(
      onTap: () {
        // Micro-interaction: Haptic Feedback
        HapticFeedback.lightImpact();
        
        // TODO: رفتن به صفحه پلیر
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('پخش: ${cartoon.title}')));
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          gradient: LinearGradient(colors: [AppTheme.surface, AppTheme.surface], begin: Alignment.topLeft, end: Alignment.bottomRight),
          boxShadow: [
            BoxShadow(color: AppTheme.primary.withOpacity(0.15), blurRadius: 15, offset: Offset(5, 8)),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Stack(
                  fit: StackFit.expand,
                  children: (
                    CachedNetworkImage(
                      imageUrl: cartoon.thumbnailUrl,
                      fit: BoxFit.cover,
                      placeholder: (c, u) => Center(child: CircularProgressIndicator(color: AppTheme.primary)),
                      errorWidget: (c, u, e) => Container(color: Colors.grey[200], child: Icon(Icons.broken_image)),
                    ),
                    if (cartoon.isNew) Positioned(top: 10, left: 10, child: _NewBadge())
                  ).toList(), // ترکیب تصویر و بدج
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(cartoon.title, maxLines: 1, overflow: TextOverflow.overflow, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.textMain)),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.access_time_rounded, size: 12, color: AppTheme.textSub),
                          SizedBox(width: 4),
                          Text('${cartoon.duration} دقیقه', style: TextStyle(fontSize: 11, color: AppTheme.textSub)),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _NewBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.redAccent.withOpacity(0.4), blurRadius: 6)]),
      child: Text("جدید", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800)),
    );
  }
}
