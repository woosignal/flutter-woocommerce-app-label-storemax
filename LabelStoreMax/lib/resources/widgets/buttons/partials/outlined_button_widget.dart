import 'package:flutter/material.dart';
import '/bootstrap/extensions.dart';
import '/resources/widgets/buttons/abstract/app_button.dart';

class OutlinedButton extends AppButton {
  final Color? borderColor;
  final Color? textColor;

  const OutlinedButton({
    super.key,
    required super.text,
    super.onPressed,
    this.borderColor,
    this.textColor,
    super.width,
    super.height,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: buildButtonChild(
        context,
        textColor: textColor ?? context.color.content,
        backgroundColor: Colors.transparent,
        border: Border.all(
            color: borderColor ?? context.color.buttonBackground, width: 2),
      ),
    );
  }
}
