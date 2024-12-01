import 'package:flutter/material.dart';
import '/bootstrap/extensions.dart';
import '/resources/widgets/buttons/abstract/app_button.dart';

class GradientButton extends AppButton {
  final List<Color> gradientColors;

  const GradientButton({
    super.key,
    required super.text,
    super.onPressed,
    this.gradientColors = const [Colors.blue, Colors.purple],
    super.width,
    super.height,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: context.color.buttonContent,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
