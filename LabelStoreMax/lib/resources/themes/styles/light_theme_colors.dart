import 'package:flutter/material.dart';
import '/bootstrap/app_helper.dart';
import '/resources/themes/styles/color_styles.dart';

/* Light Theme Colors
|-------------------------------------------------------------------------- */

class LightThemeColors implements ColorStyles {
  // general

  @override
  Color get background => Color(int.parse(
      AppHelper.instance.appConfig!.themeColors!['light']['background']));
  @override
  Color get backgroundContainer => Colors.white;
  @override
  Color get content => Color(int.parse(
      AppHelper.instance.appConfig!.themeColors!['light']['primary_text']));
  @override
  Color get primaryAccent => const Color(0xFF87c694);

  @override
  Color get surfaceBackground => Colors.white;
  @override
  Color get surfaceContent => Colors.black;

  // app bar
  @override
  Color get appBarBackground =>
      Color(int.parse(AppHelper.instance.appConfig!.themeColors!['light']
          ['app_bar_background']));
  @override
  Color get appBarPrimaryContent => Color(int.parse(
      AppHelper.instance.appConfig!.themeColors!['light']['app_bar_text']));

  @override
  Color get inputPrimaryContent => Colors.black;

  // buttons
  @override
  Color get buttonContent => Color(int.parse(
      AppHelper.instance.appConfig!.themeColors!['light']['button_text']));

  @override
  Color get buttonSecondaryBackground => Colors.black;

  @override
  Color get buttonSecondaryContent => Colors.white;

  @override
  Color get buttonBackground =>
      Color(int.parse(AppHelper.instance.appConfig!.themeColors!['light']
          ['button_background']));

  // bottom tab bar
  @override
  Color get bottomTabBarBackground => Colors.white;

  // bottom tab bar - icons
  @override
  Color get bottomTabBarIconSelected => Colors.blue;
  @override
  Color get bottomTabBarIconUnselected => Colors.black54;

  // bottom tab bar - label
  @override
  Color get bottomTabBarLabelUnselected => Colors.black45;
  @override
  Color get bottomTabBarLabelSelected => Colors.black;
}
