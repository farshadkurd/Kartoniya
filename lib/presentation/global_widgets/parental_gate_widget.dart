// lib/presentation/global_widgets/parental_gate_widget.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';

/// 🔒 نمایش قفل والدین
/// استفاده: final result = await showParentalGate(context);
Future<bool> showParentalGate(BuildContext context) async {
  return await showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black54,
    builder: (ctx) => const _ParentalGateDialog(),
  ) ??
      false;
}

class _ParentalGateDialog extends StatefulWidget {
  const _ParentalGateDialog();

  @override
  State<_ParentalGateDialog> createState() => _ParentalGateDialogState();
}

class _ParentalGateDialogState extends State<_ParentalGateDialog>
    with SingleTickerProviderStateMixin {
  late int num1;
  late int num2;
  late int correctAnswer;
  late String operator;
  final TextEditingController _controller = TextEditingController();
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;
  bool _isWrong = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _shakeAnimation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticOut),
    );
    _generateProblem();
  }

  @override
  void dispose() {
    _controller.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  void _generateProblem() {
    final random = Random();
    final op = random.nextInt(3); // 0: +, 1: -, 2: ×

    switch (op) {
      case 0:
        num1 = random.nextInt(15) + 1;
        num2 = random.nextInt(15) + 1;
        correctAnswer = num1 + num2;
        operator = '+';
        break;
      case 1:
        num1 = random.nextInt(20) + 5;
        num2 = random.nextInt(num1);
        correctAnswer = num1 - num2;
        operator = '-';
        break;
      case 2:
        num1 = random.nextInt(9) + 2;
        num2 = random.nextInt(9) + 2;
        correctAnswer = num1 * num2;
        operator = '×';
        break;
    }
  }

  void _checkAnswer() {
    final input = _controller.text.trim();
    if (input.isEmpty) {
      setState(() {
        _isWrong = true;
        _errorMessage = 'لطفاً پاسخ را وارد کنید';
      });
      _shakeController.forward().then((_) => _shakeController.reset());
      return;
    }

    final answer = int.tryParse(input);
    if (answer == null) {
      setState(() {
        _isWrong = true;
        _errorMessage = 'لطفاً عدد وارد کنید';
      });
      _shakeController.forward().then((_) => _shakeController.reset());
      return;
    }

    if (answer == correctAnswer) {
      HapticFeedback.lightImpact();
      Navigator.of(context).pop(true);
    } else {
      HapticFeedback.heavyImpact();
      setState(() {
        _isWrong = true;
        _errorMessage = 'پاسخ اشتباه است! دوباره تلاش کنید';
      });
      _shakeController.forward().then((_) {
        _shakeController.reset();
        if (mounted) {
          setState(() {
            _controller.clear();
            _generateProblem();
            _isWrong = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _shakeAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(
              _shakeAnimation.value *
                  (0.5 - (Random().nextDouble())), // لرزش تصادفی
              0,
            ),
            child: child,
          );
        },
        child: Container(
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppTheme.radiusXLarge),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // آیکون قفل
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: AppColors.sunsetGradient,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.lock_outline_rounded,
                  size: 36,
                  color: AppColors.textOnPrimary,
                ),
              ),

              const SizedBox(height: 20),

              Text(
                '🔒 قفل والدین',
                style: TextStyle(
                  fontFamily: GoogleFonts.vazirmatn().fontFamily,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'این بخش فقط برای بزرگسالان است.\nلطفاً مسئله ریاضی زیر را حل کنید:',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: GoogleFonts.vazirmatn().fontFamily,
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
              ),

              const SizedBox(height: 24),

              // مسئله ریاضی
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      '$num1',
                      style: TextStyle(
                        fontFamily: GoogleFonts.vazirmatn().fontFamily,
                        fontSize: 36,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      operator,
                      style: TextStyle(
                        fontFamily: GoogleFonts.vazirmatn().fontFamily,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      '$num2',
                      style: TextStyle(
                        fontFamily: GoogleFonts.vazirmatn().fontFamily,
                        fontSize: 36,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      '=',
                      style: TextStyle(
                        fontFamily: GoogleFonts.vazirmatn().fontFamily,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      '?',
                      style: TextStyle(
                        fontFamily: GoogleFonts.vazirmatn().fontFamily,
                        fontSize: 36,
                        fontWeight: FontWeight.w900,
                        color: AppColors.accent5,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ورودی پاسخ
              Container(
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  border: Border.all(
                    color: _isWrong
                        ? AppColors.error
                        : AppColors.textHint.withOpacity(0.3),
                  ),
                ),
                child: TextField(
                  controller: _controller,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  style: TextStyle(
                    fontFamily: GoogleFonts.vazirmatn().fontFamily,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  decoration: InputDecoration(
                    hintText: '؟',
                    hintStyle: TextStyle(
                      fontFamily: GoogleFonts.vazirmatn().fontFamily,
                      color: AppColors.textHint,
                      fontSize: 28,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                  ),
                  onSubmitted: (_) => _checkAnswer(),
                ),
              ),

              // پیام خطا
              if (_isWrong && _errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    _errorMessage,
                    style: TextStyle(
                      fontFamily: GoogleFonts.vazirmatn().fontFamily,
                      fontSize: 12,
                      color: AppColors.error,
                    ),
                  ),
                ),

              const SizedBox(height: 20),

              // دکمه تایید
              GestureDetector(
                onTap: _checkAnswer,
                child: Container(
                  width: double.infinity,
                  height: 52,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(
                      AppTheme.radiusMedium,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'باز کردن قفل',
                      style: TextStyle(
                        fontFamily: GoogleFonts.vazirmatn().fontFamily,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textOnPrimary,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // دکمه انصراف
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  Navigator.of(context).pop(false);
                },
                child: Text(
                  'انصراف',
                  style: TextStyle(
                    fontFamily: GoogleFonts.vazirmatn().fontFamily,
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
