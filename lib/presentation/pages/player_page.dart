// lib/presentation/pages/player_page.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:wakelock_plus/wakelock_plus.dart'; // توصیه شده برای خاموش نشدن صفحه
import '../../core/theme/app_theme.dart';
import '../../data/models/cartoon_model.dart';

class PlayerPage extends StatefulWidget {
  final CartoonModel cartoon;
  const PlayerPage({super.key, required this.cartoon});

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  bool _showControls = false; // آیا کنترل‌ها نمایش داده شوند؟
  bool _isPlaying = false;
  Timer? _hideTimer;

  @override
  void initState() {
    super.initState();
    // فعال کردن حالت بیدار نگه داشتن صفحه
    try { WakelockPlus.enable(); } catch(e){} 
    
    // شروع خودکار پخش (شبیه‌سازی)
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() { _isPlaying = true; });
      _startHideTimer();
    });
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    try { WakelockPlus.disable(); } catch(e){}
    super.dispose();
  }

  void _toggleControls() {
    setState(() => _showControls = !_showControls);
    if (_showControls) _startHideTimer();
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(Duration(seconds: 3), () {
      if(mounted && _isPlaying) setState(() => _showControls = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(textDirection: TextDirection.rtl, child: Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: _toggleControls,
        child: Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: [
            // پس‌زمینه ویدیو (در اینجا تصویر ثابت به عنوان فریم اولیه)
            Image.network(widget.cartoon.thumbnailUrl, fit: BoxFit.cover, width: double.infinity, errorBuilder: (c, e, s) => Container(color: Colors.black)),

            // گرادیان کناره‌ها برای خوانایی کنترل‌ها
            Container(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.center, colors: [Colors.black54, Colors.transparent]))),
            
            // محتوای وسط (Play Button Big)
            if (!_isPlaying || (_isPlaying && _showControls))
             Center(child: AnimatedOpacity(
               opacity: _isPlaying ? 0.0 : 1.0, // وقتی پخش شود دکمه وسط محو می‌شود
               duration: Duration(milliseconds: 300),
               child: GestureDetector(
                 onTap: () => setState((){_isPlaying=true; _showControls=false;}),
                 child: CircleAvatar(radius: 35, backgroundColor: Colors.white24, child: Icon(_isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.white, size: 50))
               ),
             )),

            // نوار بالایی (App Bar کوچک)
            if (_showControls)
             Positioned(top: MediaQuery.of(context).padding.top + 10, left: 10, right: 10, child: Row(children: [
               IconButton(icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white), onPressed: () => Navigator.pop(context)),
               Spacer(),
               Text(widget.cartoon.title, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16))
             ])),

            // نوار پایینی (Progress + Controls)
            if (_showControls)
             Positioned(bottom: 0, left: 0, right: 0, child: Container(
               padding: EdgeInsets.only(left: 10, right: 10, bottom: 20, top: 10),
               color: Colors.black38.withAlpha(150),
               child: Column(mainAxisSize: MainAxisSize.min, children: [
                 Slider(value: 0.3, onChanged: (v){}, activeColor: AppTheme.primary, inactiveColor: Colors.grey),
                 Row(children: [
                   Icon(Icons.skip_previous_rounded, color: Colors.white),
                   SizedBox(width: 10),
                   Icon((_isPlaying)?Icons.pause_circle_filled:Icons.play_circle_filled, size: 35, color: Colors.white, onTap: ()=>setState(()=>_isPlaying=!_isPlaying)),
                   SizedBox(width: 10),
                   Icon(Icons.skip_next_rounded, color: Colors.white),
                   Spacer(),
                   Text("۰۲:۳۵ / ۱۰:۰۰", style: TextStyle(color: Colors.white70, fontSize: 12)),
                   SizedBox(width: 10),
                   Icon(Icons.fullscreen_rounded, color: Colors.white)
                 ])
               ]),
             ))
          ],
        ),
      ),
    ));
  }
}
