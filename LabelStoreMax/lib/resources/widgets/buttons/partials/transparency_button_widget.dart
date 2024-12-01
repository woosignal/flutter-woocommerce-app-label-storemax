import 'package:flutter/material.dart';
import '/bootstrap/extensions.dart';
import '/resources/widgets/buttons/abstract/app_button.dart';

class TransparencyButton extends AppButton {
  final Color? color;

  const TransparencyButton({
    super.key,
    required super.text,
    super.onPressed,
    this.color,
    super.width,
    super.height,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      padding: EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      color: Colors.white.withOpacity(0.3),
      elevation: 0,
      onPressed: onPressed,
      child: buildButtonChild(
        context,
        textColor: color ?? context.color.buttonContent,
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
