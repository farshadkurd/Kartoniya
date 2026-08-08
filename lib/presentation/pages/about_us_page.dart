// lib/presentation/pages/about_us_page.dart
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../core/theme/app_theme.dart';
import 'package:url_launcher/url_launcher.dart'; // یادتان نود برای لینک تلگرام

class AboutUsPage extends StatefulWidget {
  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> with TickerProviderStateMixin {
  
  late AnimationController _glowController; // کنترلر پالس نور
  late AnimationController _rotateController; // کنترلر چرخش

  @override
  void initState() {
    super.initState();
    
    // تکرار بی نهایت و معکوس شدن برای افکت نفس کشیدن (Breathing Effect)
    _glowController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: true);

    // چرخش بسیار آرام
    _rotateController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _glowController.dispose();
    _rotateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppTheme.background,
        body: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.all(24),
            child: Column(
              children: [
                SizedBox(height: 30),

                // ======== قاب اصلی با انیمیشن‌های تلفیقی ========
                AnimatedBuilder(
                  animation: Listenable.merge([_glowController, _rotateController]),
                  builder: (context, child) {
                    
                    // محاسبه شدت تابش
                    double currentGlowOpacity = 0.4 + (_glowController.value * 0.6);

                    return Transform.rotate(
                      angle: _rotateController.value * 2 * math.pi,
                      child: Container(
                        width: 180,
                        height: 180,
                        
                        // سایه و هاله (Halo / Shadow Layers)
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            // هاله طلایی بزرگ و نرم
                            BoxShadow(
                              color: AppTheme.goldGlow.withOpacity(currentGlowOpacity * 0.4),
                              blurRadius: 40 + (20 * _glowController.value),
                              spreadRadius: 10,
                            ),
                            // هاله کوچک‌تر و متمرکزتر
                            BoxShadow(
                              color: AppTheme.amberAccent.withOpacity(currentGlowOpacity * 0.6),
                              blurRadius: 20,
                            )
                          ],
                        ),

                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // خط دور درخشان (Rotating Shimmer Border)
                            CustomPaint(
                              size: Size(160, 160),
                              painter: GoldenRingPainter(rotationValue: _rotateController.value),
                            ),

                            // محتوای مرکزی (لوگو و متن)
                            Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                color: AppTheme.background,
                                shape: BoxShape.circle,
                                // حاشیه داخلی سفید برای تفکیک از دورنمای طلایی
                                border: Border.all(color: AppTheme.background, width: 4),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.verified_user_rounded, size: 50, color: AppTheme.primaryDark),
                                  SizedBox(height: 8),
                                  Text("Parsa", style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900, color: AppTheme.textMain)),
                                  Text("Apps", style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppTheme.primaryDark))
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                SizedBox(height: 40),

                // نام سازنده با گرادیان متن
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [Colors.orange[800]!, AppTheme.goldGlow, Colors.orange[800]],
                  ).createShader(bounds),
                  child: Text(
                    "فرشاد پارسا",
                    style: TextStyle(
                      fontSize: 28, 
                      fontWeight: FontWeight.w900, 
                      color: Colors.white, // مهم: برای شیدرمسک باید رنگ سفید باشد
                      letterSpacing: 1,
                    ),
                  ),
                ),
                
                Text("توسعه‌دهنده نسل آینده", style: Theme.of(context).textTheme.bodyLarge),

                SizedBox(height: 50),

                // کارت تلگرام
                _buildContactTile(
                  context,
                  icon: Icons.send_rounded,
                  iconBgColor: Color(0xFF0088cc),
                  title: "پشتیبانی تلگرام",
                  subtitle: "@Parsaappsadmin",
                  onTap: () async {
                    final uri = Uri.parse("https://t.me/Parsaappsadmin");
                    if (await canLaunchUrl(uri)) await launchUrl(uri);
                  },
                ),
                
                 SizedBox(height: 15),

                // کارت ایمیل یا وبسایت
                _buildContactTile(
                  context,
                  icon: Icons.language_rounded,
                  iconBgColor: Colors.deepPurple,
                  title: "وب‌سایت",
                  subtitle: "www.parsa-apps.com",
                  onTap: () {},
                ),

                Spacer(),

                Text("نسخه ۱.۰.۰", style: TextStyle(color: Colors.grey.withOpacity(0.5)))
                
              ].expand((widget) => [widget, if(widget != SizedBox(height: 30)) SizedBox(height: 20)]).toList() // افزودنSpacing بین عناصر
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContactTile(BuildContext context, {required IconData icon, required Color iconBgColor, required String title, required String subtitle, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)]
        ),
        child: Row(
          children: [
            Container(padding: EdgeInsets.all(10), decoration: BoxDecoration(color: iconBgColor, shape: BoxShape.circle), child: Icon(icon, color: Colors.white, size: 22)),
            SizedBox(width: 16),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              Text(subtitle, style: TextStyle(color: AppTheme.textSub, fontSize: 13))
            ]),
            Spacer(),
            Icon(Icons.arrow_back_ios_new_rounded, size: 14, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

// ------ نقاشي خط درخشان چرخان ------
class GoldenRingPainter extends CustomPainter {
  final double rotationValue;

  GoldenRingPainter({required this.rotationValue});

  @Override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    
    // ایجاد گرادیان چرخان (Sweep Gradient)
    final paint = Paint()
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..shader = SweepGradient(
        startAngle: -math.pi / 2 + (rotationValue * 2 * math.pi),
        endAngle: 3 * math.pi / 2 + (rotationValue * 2 * math.pi),
        colors: [
          Colors.transparent, 
          AppTheme.goldGlow.withOpacity(0.8), 
          Colors.transparent,
          AppTheme.amberAccent.withOpacity(0.5),
          Colors.transparent
        ],
        stops: [0.0, 0.25, 0.5, 0.75, 1.0],
        tileMode: TileMode.repeated,
      ).createShader(rect);

    canvas.drawCircle(size.center(Offset.zero), size.width / 2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
