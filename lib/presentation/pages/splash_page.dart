import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import 'home_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});
  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  late AnimationController animCtrl;
  late Animation<double> scaleAnim;

  @override
  void initState() {
    super.initState();
    animCtrl = AnimationController(vsync: this, duration: Duration(milliseconds: 1200));
    scaleAnim = CurvedAnimation(parent: animCtrl, curve: Curves.elasticOut);
    animCtrl.forward();

    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomePage()));
    });
  }

  @override
  void dispose() { animCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Center(
        child: AnimatedBuilder(
          animation: scaleAnim,
          builder: (c, ch) => Transform.scale(scale: scaleAnim.value, child: ch),
          child: Container(
            padding: EdgeInsets.all(30),
            decoration: BoxDecoration(color: AppTheme.surface, borderRadius: BorderRadius.circular(30), boxShadow: [BoxShadow(color: AppTheme.primary.withOpacity(0.3), blurRadius: 30)]),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.play_circle_fill_rounded, size: 80, color: AppTheme.primaryDark),
              SizedBox(height: 10),
              Text("کارتونیا", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 28, color: AppTheme.textMain))
            ])
          ),
        )
      )
    );
  }
}
