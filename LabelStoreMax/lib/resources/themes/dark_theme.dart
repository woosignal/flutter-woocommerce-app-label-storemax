import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/bootstrap/app_helper.dart';
import '/config/font.dart';
import '/resources/themes/styles/color_styles.dart';
import '/resources/themes/text_theme/default_text_theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nylo_framework/nylo_framework.dart';

/* Dark Theme
|--------------------------------------------------------------------------
| Theme Config - config/theme.dart
|-------------------------------------------------------------------------- */

ThemeData darkTheme(ColorStyles darkColors) {
  try {
    appFont = GoogleFonts.getFont(
        AppHelper.instance.appConfig!.themeFont ?? "Poppins");
  } on Exception catch (e) {
    if (getEnv('APP_DEBUG') == true) {
      NyLogger.error(e.toString());
    }
  }

  TextTheme darkTheme =
      getAppTextTheme(appFont, defaultTextTheme.merge(_textTheme(darkColors)));
  return ThemeData(
    primaryColor: darkColors.content,
    primaryColorDark: darkColors.content,
    brightness: Brightness.dark,
    focusColor: darkColors.content,
    scaffoldBackgroundColor: darkColors.background,
    appBarTheme: AppBarTheme(
        surfaceTintColor: Colors.transparent,
        backgroundColor: darkColors.appBarBackground,
        titleTextStyle: darkTheme.titleLarge!
            .copyWith(color: darkColors.appBarPrimaryContent),
        iconTheme: IconThemeData(color: darkColors.appBarPrimaryContent),
        elevation: 1.0,
        systemOverlayStyle: SystemUiOverlayStyle.light),
    buttonTheme: ButtonThemeData(
      buttonColor: darkColors.primaryAccent,
      colorScheme: ColorScheme.light(primary: darkColors.buttonBackground),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: darkColors.content),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: TextButton.styleFrom(
          foregroundColor: darkColors.buttonContent,
          backgroundColor: darkColors.buttonBackground),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: darkColors.bottomTabBarBackground,
      unselectedIconTheme:
          IconThemeData(color: darkColors.bottomTabBarIconUnselected),
      selectedIconTheme:
          IconThemeData(color: darkColors.bottomTabBarIconSelected),
      unselectedLabelStyle:
          TextStyle(color: darkColors.bottomTabBarLabelUnselected),
      selectedLabelStyle:
          TextStyle(color: darkColors.bottomTabBarLabelSelected),
      selectedItemColor: darkColors.bottomTabBarLabelSelected,
    ),
    textTheme: darkTheme,
    colorScheme: ColorScheme.dark(
        surface: darkColors.background, primary: darkColors.content),
  );
}

/*
|--------------------------------------------------------------------------
| Dark Text Theme
|--------------------------------------------------------------------------
*/

TextTheme _textTheme(ColorStyles colors) {
  Color primaryContent = colors.content;
  TextTheme textTheme = TextTheme().apply(displayColor: primaryContent);
  return textTheme.copyWith(
      titleLarge: TextStyle(color: primaryContent.withOpacity(0.8)),
      labelLarge: TextStyle(color: primaryContent.withOpacity(0.8)),
      bodySmall: TextStyle(color: primaryContent.withOpacity(0.8)),
      bodyMedium: TextStyle(color: primaryContent.withOpacity(0.8)));
}
