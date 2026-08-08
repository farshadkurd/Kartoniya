// lib/presentation/pages/cartoon_detail_page.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/cartoon_model.dart';
import '../global_widgets/parental_gate_widget.dart'; // ایمپورت قفل
import 'player_page.dart'; // ایمپورت صفحه پلیر بعدی

class CartoonDetailPage extends StatelessWidget {
  final CartoonModel cartoon;

  const CartoonDetailPage({super.key, required this.cartoon});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppTheme.background,
        body: CustomScrollView(
          slivers: [
            // هدر تصویری بزرگ (Hero Image Area)
            SliverAppBar(
              expandedHeight: 280,
              pinned: true,
              stretch: true,
              backgroundColor: AppTheme.background,
              leading: IconButton(icon: Icon(Icons.arrow_back_rounded), onPressed: () => Navigator.pop(context)),
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(imageUrl: cartoon.thumbnailUrl, fit: BoxFit.cover),
                    // گرادیان پایین تصویر برای خوانایی متن
                    DecoratedBox(
                      position: DecorationPosition.foreground,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, AppTheme.background],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),

            // محتوای متنی و دکمه ها
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(cartoon.title, style: Theme.of(context).textTheme.displayLarge!.copyWith(fontSize: 28)),
                    SizedBox(height: 8),
                    
                    Row(children: [
                      Icon(Icons.star_half_rounded, color: AppTheme.goldGlow, size: 20),
                      SizedBox(width: 5),
                      Text("۴.۸ (رتبه برتر)", style: TextStyle(color: AppTheme.textSub)),
                      Spacer(),
                      Icon(Icons.access_time, color: AppTheme.textSub, size: 18),
                      SizedBox(width: 4),
                      Text("${cartoon.duration} دقیقه")
                    ]),

                    SizedBox(height: 12),
                    Text("دسته‌بندی: ${cartoon.category}", style: TextStyle(color: AppTheme.primaryDark, fontWeight: FontWeight.w600)),
                    
                    SizedBox(height: 25),

                    // --- دکمه پخش اصلی (Call to Action) ---
                    SafeArea(
                      child: InkWell(
                        onTap: () {
                          HapticFeedback.mediumImpact();
                          Navigator.push(context, MaterialPageRoute(builder: (c) => PlayerPage(cartoon: cartoon)));
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: double.infinity,
                          height: 65,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [AppTheme.primary, AppTheme.primaryDark]),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [BoxShadow(color: AppTheme.primary.withOpacity(0.4), blurRadius: 15, offset: Offset(0, 8))]
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.play_circle_fill_rounded, color: Colors.white, size: 32),
                              SizedBox(width: 10),
                              Text("شروع تماشا", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white))
                            ],
                          ),
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 40),
                    
                    // لیست قسمت‌ها (Mock List)
                    Text("قسمت‌های دیگر", style: Theme.of(context).textTheme.headlineMedium),
                    ...List.generate(5, (index) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Container(width: 60, height: 40, color: Colors.grey[200], child: Icon(Icons.play_arrow)), // Placeholder thumbnail
                      title: Text("قسمت ${index + 1}: ماجراجویی جدید"),
                      trailing: Icon(Icons.download_outlined, color: AppTheme.textSub),
                    ))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
