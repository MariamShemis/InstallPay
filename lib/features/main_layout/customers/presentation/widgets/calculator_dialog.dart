import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_installment_management/core/costants/color_manager.dart';

class CalculatorDialog extends StatefulWidget {
  const CalculatorDialog({super.key});

  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const CalculatorDialog(),
    );
  }

  @override
  State<CalculatorDialog> createState() => _CalculatorDialogState();
}

class _CalculatorDialogState extends State<CalculatorDialog> {
  String _input = '';
  String _result = '0';
  String _operator = '';
  double? _firstNum;
  bool _isNewInput = false;

  void _onDigitPressed(String digit) {
    setState(() {
      if (_isNewInput) {
        _input = digit == '.' ? '0.' : digit;
        _isNewInput = false;
      } else {
        if (digit == '.' && _input.contains('.')) return;
        if (_input == '0' && digit != '.') {
          _input = digit;
        } else {
          _input += digit;
        }
      }
      _result = _input;
    });
  }

  void _onOperatorPressed(String op) {
    if (_input.isNotEmpty) {
      _firstNum = double.tryParse(_input);
      setState(() {
        _operator = op;
        _isNewInput = true;
      });
    }
  }

  void _onCalculate() {
    if (_firstNum != null && _input.isNotEmpty && _operator.isNotEmpty) {
      double secondNum = double.tryParse(_input) ?? 0;
      double calcResult = 0;

      switch (_operator) {
        case '+':
          calcResult = _firstNum! + secondNum;
          break;
        case '-':
          calcResult = _firstNum! - secondNum;
          break;
        case '×':
          calcResult = _firstNum! * secondNum;
          break;
        case '÷':
          calcResult = secondNum != 0 ? _firstNum! / secondNum : 0;
          break;
      }

      setState(() {
        _result = calcResult % 1 == 0
            ? calcResult.toInt().toString()
            : calcResult.toStringAsFixed(2);
        _input = _result;
        _firstNum = null;
        _operator = '';
        _isNewInput = true;
      });
    }
  }

  void _toggleSign() {
    if (_input.isNotEmpty && _input != '0') {
      setState(() {
        if (_input.startsWith('-')) {
          _input = _input.substring(1);
        } else {
          _input = '-$_input';
        }
        _result = _input;
      });
    }
  }

  void _clear() {
    setState(() {
      _input = '';
      _result = '0';
      _operator = '';
      _firstNum = null;
      _isNewInput = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? ColorManager.darkSurface : ColorManager.white;
    final numBtnColor = isDark ? ColorManager.darkSurfaceVariant : ColorManager.greyLight;
    final opBtnColor = isDark ? ColorManager.green : ColorManager.primaryColor;
    final equalsBtnColor = isDark ? ColorManager.darkAccentGreen : ColorManager.darkAccentGreen;
    final textColor = isDark ? ColorManager.white : ColorManager.black;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.r),
      ),
      backgroundColor: bgColor,
      insetPadding: REdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Padding(
        padding: REdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Display Area
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      _result,
                      style: TextStyle(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (_input.isNotEmpty) {
                      setState(() {
                        _input = _input.substring(0, _input.length - 1);
                        _result = _input.isEmpty ? '0' : _input;
                      });
                    }
                  },
                  icon: Icon(Icons.backspace_outlined, size: 22.r, color: textColor),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            // Keypad
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Numbers Grid
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      _buildRow(['7', '8', '9'], numBtnColor, textColor),
                      SizedBox(height: 8.h),
                      _buildRow(['4', '5', '6'], numBtnColor, textColor),
                      SizedBox(height: 8.h),
                      _buildRow(['1', '2', '3'], numBtnColor, textColor),
                      SizedBox(height: 8.h),
                      _buildRow(['.', '0', '±'], numBtnColor, textColor),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                // Operators Column (÷, ×, -, +)
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      _buildOpBtn('÷', opBtnColor),
                      SizedBox(height: 8.h),
                      _buildOpBtn('×', opBtnColor),
                      SizedBox(height: 8.h),
                      _buildOpBtn('-', opBtnColor),
                      SizedBox(height: 8.h),
                      _buildOpBtn('+', opBtnColor),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            // Full Width Equals (=) Button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Material(
                color: equalsBtnColor,
                borderRadius: BorderRadius.circular(16.r),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16.r),
                  onTap: _onCalculate,
                  child: Container(
                    height: 52.h,
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Text(
                      '=',
                      style: TextStyle(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.bold,
                        color: ColorManager.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            // Footer Actions in English
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: _clear,
                  child: const Text(
                    'Clear',
                    style: TextStyle(color: ColorManager.red, fontWeight: FontWeight.w600),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: _result));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Copied to clipboard')),
                    );
                  },
                  child: const Text(
                    'Copy to clipboard',
                    style: TextStyle(color: ColorManager.darkAccentGreen, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(List<String> values, Color btnColor, Color textColor) {
    return Row(
      children: values.map((val) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Material(
              color: btnColor,
              borderRadius: BorderRadius.circular(16.r),
              child: InkWell(
                borderRadius: BorderRadius.circular(16.r),
                onTap: () {
                  if (val == '±') {
                    _toggleSign();
                  } else {
                    _onDigitPressed(val);
                  }
                },
                child: Container(
                  height: 56.h,
                  alignment: Alignment.center,
                  child: Text(
                    val,
                    style: TextStyle(
                      fontSize: 26.sp,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildOpBtn(String op, Color btnColor) {
    final isSelected = _operator == op;

    return Material(
      color: isSelected ? ColorManager.warningYellow : btnColor,
      borderRadius: BorderRadius.circular(16.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(16.r),
        onTap: () => _onOperatorPressed(op),
        child: Container(
          height: 56.h,
          alignment: Alignment.center,
          decoration: isSelected
              ? BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: ColorManager.white, width: 2.w),
          )
              : null,
          child: Text(
            op,
            style: TextStyle(
              fontSize: 26.sp,
              fontWeight: FontWeight.bold,
              color: isSelected ? ColorManager.black : ColorManager.white,
            ),
          ),
        ),
      ),
    );
  }
}