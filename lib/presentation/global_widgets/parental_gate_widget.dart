// lib/presentation/global_widgets/parental_gate_widget.dart
import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

// استفاده: await showParentalGate(context);
Future<bool> showParentalGate(BuildContext context) async {
  return await showDialog(
    context: context,
    barrierDismissible: false, // کاربر نمی‌تواند با زدن بیرون ببندد
    builder: (ctx) => _ParentalGateDialog(),
  ) ?? false;
}

class _ParentalGateDialog extends StatefulWidget {
  @override
  __ParentalGateDialogState createState() => __ParentalGateDialogState();
}

class __ParentalGateDialogState extends State<_ParentalGateDialog> {
  late int num1;
  late int num2;
  late int correctAnswer;
  final TextEditingController _controller = TextEditingController();
  
  // حالت‌های انیمیشن برای اشتباه زدن
  bool isShaking = false;

  @override
  void initState() {
    super.initState();
    _generateMathProblem();
  }

  void _generateMathProblem() {
    final random = Random();
    num1 = random.nextInt(10) + 1; // 1 تا 10
    num2 = random.nextInt(9) + 1; // 1 تا 9
    correctAnswer = num1 + num2;
  }

  void _checkAnswer() {
    if (_controller.text == correctAnswer.toString()) {
      Navigator.of(context).pop(true); // پاسخ صحیح، اجازه عبور
    } else {
      // پاسخ غلط: انیمیشن لرزش (Shake) + vibrates
      HapticFeedback.heavyImpact(); // لرزش گوشی
      
      setState(() => isShaking = true);
      Future.delayed(Duration(milliseconds: 500), () {
        if(mounted) setState(() => isShaking = false);
      });
      
      _controller.clear();
      _generateMathProblem(); // سوال جدید
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedScale(
        scale: isShaking ? 0.95 : 1.0,
        duration: Duration(milliseconds: 100),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20)]
          ),
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // آیکون قفل
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(color: AppTheme.primary.withOpacity(0.1), shape: BoxShape.circle),
                child: Icon(Icons.lock_outline_rounded, size: 40, color: AppTheme.primaryDark),
              ),
              SizedBox(height: 16),
              
              Text("قفل والدین", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text("این بخش فقط برای بزرگسالان است.\nمسئلت ریاضی زیر را حل کنید:", 
                   textAlign: TextAlign.center, style: TextStyle(color: AppTheme.textSub)),

              SizedBox(height: 24),

              // نمایش مسئله ریاضی
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("$num1", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppTheme.textMain)),
                  Text("+", style: TextStyle(fontSize: 28, color: AppTheme.textSub)),
                  Text("$num2", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppTheme.textMain)),
                  Text("= ?", style: TextStyle(fontSize: 28, color: AppTheme.textSub)),
                ],
              ),

              SizedBox(height: 20),

              // ورودی پاسخ
              TextField(
                controller: _controller,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24),
                decoration: InputDecoration(
                  hintText: 'پاسخ',
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                ),
                onSubmitted: (_) => _checkAnswer(),
              ),

              SizedBox(height: 20),

              // دکمه تایید
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _checkAnswer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.secondary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
                  ),
                  child: Text("باز کردن قفل", style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
