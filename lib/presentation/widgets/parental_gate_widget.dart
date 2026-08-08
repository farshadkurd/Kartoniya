import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_theme.dart';

// تابع فراخوانی ساده
Future<bool> showParentalGate(BuildContext context) async {
  return await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => _ParentalGateDialog(),
  ) ?? false;
}

class _ParentalGateDialog extends StatefulWidget {
  @override
  State<_ParentalGateDialog> createState() => __ParentalGateDialogState();
}

class __ParentalGateDialogState extends State<_ParentalGateDialog> {
  late int num1, num2, answer;
  final controller = TextEditingController();
  bool isShaking = false;

  @override
  void initState() {
    super.initState();
    generateProblem();
  }

  void generateProblem() {
    final r = Random();
    num1 = r.nextInt(10) + 1;
    num2 = r.nextInt(9) + 1;
    answer = num1 + num2;
  }

  void check() {
    if (controller.text == answer.toString()) {
      Navigator.of(context).pop(true);
    } else {
      HapticFeedback.heavyImpact(); // لرزش گوشی
      setState(() => isShaking = true);
      controller.clear();
      generateProblem();
      Future.delayed(Duration(milliseconds: 500), () {
        if(mounted) setState(() => isShaking = false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedScale(
        scale: isShaking ? 0.95 : 1.0,
        duration: Duration(milliseconds: 100),
        child: Container(
          margin: EdgeInsets.all(24),
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(color: AppTheme.surface, borderRadius: BorderRadius.circular(30)),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.lock_outline_rounded, size: 50, color: AppTheme.primaryDark),
            SizedBox(height: 16),
            Text("قفل والدین", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text("مسئله ریاضی حل کن تا ادامه بدی:", style: TextStyle(color: AppTheme.textSub)),
            SizedBox(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              Text("$num1", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              Text("+", style: TextStyle(fontSize: 25)),
              Text("$num2", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              Text("= ?", style: TextStyle(fontSize: 25))
            ]),
            TextField(controller: controller, keyboardType: TextInputType.number, textAlign: TextAlign.center, decoration: InputDecoration(hintText: 'پاسخ', filled: true, fillColor: Colors.grey[100], border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none))),
            SizedBox(height: 20),
            ElevatedButton(onPressed: check, child: Text("باز کردن"))
          ]),
        ),
      ),
    );
  }
}
