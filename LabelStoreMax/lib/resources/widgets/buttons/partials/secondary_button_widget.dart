import 'package:flutter/material.dart';
import '/bootstrap/extensions.dart';
import '/resources/widgets/buttons/abstract/app_button.dart';

class SecondaryButton extends AppButton {
  final Color? color;

  const SecondaryButton({
    super.key,
    required super.text,
    super.onPressed,
    this.color,
    super.width,
    super.height,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? context.color.buttonSecondaryBackground,
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: buildButtonChild(
        context,
        textColor: context.color.buttonSecondaryContent,
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
