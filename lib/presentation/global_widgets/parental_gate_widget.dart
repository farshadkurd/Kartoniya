import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';

/// قفل والدین مبتنی بر پرسش تصادفی؛ هیچ PIN ثابت یا دادهٔ حساسی ذخیره نمی‌شود.
Future<bool> showParentalGate(BuildContext context) async {
  return (await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (_) => const _ParentalGateDialog(),
      )) ??
      false;
}

class _ParentalGateDialog extends StatefulWidget {
  const _ParentalGateDialog();

  @override
  State<_ParentalGateDialog> createState() => _ParentalGateDialogState();
}

class _ParentalGateDialogState extends State<_ParentalGateDialog>
    with SingleTickerProviderStateMixin {
  final _answerController = TextEditingController();
  final _random = Random();
  late final AnimationController _shakeController;
  late final Animation<double> _shakeAnimation;

  late int _first;
  late int _second;
  late int _answer;
  late String _operator;
  String? _error;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
    _shakeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: -9), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -9, end: 9), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 9, end: -6), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -6, end: 0), weight: 1),
    ]).animate(CurvedAnimation(parent: _shakeController, curve: Curves.easeOut));
    _newChallenge();
  }

  @override
  void dispose() {
    _answerController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  void _newChallenge() {
    switch (_random.nextInt(3)) {
      case 0:
        _first = _random.nextInt(14) + 6;
        _second = _random.nextInt(14) + 4;
        _answer = _first + _second;
        _operator = '+';
        break;
      case 1:
        _first = _random.nextInt(15) + 15;
        _second = _random.nextInt(_first - 3) + 2;
        _answer = _first - _second;
        _operator = '−';
        break;
      default:
        _first = _random.nextInt(7) + 3;
        _second = _random.nextInt(6) + 3;
        _answer = _first * _second;
        _operator = '×';
    }
  }

  void _submit() {
    final submitted = _normalizeDigits(_answerController.text.trim());
    final parsed = int.tryParse(submitted);
    if (parsed == _answer) {
      HapticFeedback.lightImpact();
      Navigator.of(context).pop(true);
      return;
    }

    HapticFeedback.heavyImpact();
    setState(() {
      _error = submitted.isEmpty ? 'لطفاً پاسخ را وارد کنید.' : 'پاسخ درست نیست؛ یک مسئلهٔ تازه امتحان کن.';
      _answerController.clear();
      _newChallenge();
    });
    _shakeController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shakeAnimation,
      builder: (context, child) => Transform.translate(
        offset: Offset(_shakeAnimation.value, 0),
        child: child,
      ),
      child: AlertDialog(
        icon: Container(
          width: 58,
          height: 58,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            gradient: AppColors.sunsetGradient,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.family_restroom_rounded, color: Colors.white),
        ),
        title: const Text('ورود والدین'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'برای باز کردن تنظیمات، مسئلهٔ زیر را حل کنید.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 18),
            Semantics(
              label: 'مسئله ریاضی: $_first $_operator $_second',
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                ),
                child: Text(
                  '$_first  $_operator  $_second  =  ؟',
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.ltr,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppColors.primaryDark,
                        fontWeight: FontWeight.w900,
                      ),
                ),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _answerController,
              autofocus: true,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9۰-۹]')),
              ],
              onSubmitted: (_) => _submit(),
              decoration: InputDecoration(
                hintText: 'پاسخ',
                errorText: _error,
                prefixIcon: const Icon(Icons.calculate_outlined),
              ),
            ),
          ],
        ),
        actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('انصراف'),
          ),
          FilledButton(
            onPressed: _submit,
            child: const Text('تأیید'),
          ),
        ],
      ),
    );
  }
}

String _normalizeDigits(String input) {
  const persian = '۰۱۲۳۴۵۶۷۸۹';
  const arabic = '٠١٢٣٤٥٦٧٨٩';
  final buffer = StringBuffer();
  for (final character in input.runes) {
    final value = String.fromCharCode(character);
    final persianIndex = persian.indexOf(value);
    final arabicIndex = arabic.indexOf(value);
    if (persianIndex >= 0) {
      buffer.write(persianIndex);
    } else if (arabicIndex >= 0) {
      buffer.write(arabicIndex);
    } else {
      buffer.write(value);
    }
  }
  return buffer.toString();
}
