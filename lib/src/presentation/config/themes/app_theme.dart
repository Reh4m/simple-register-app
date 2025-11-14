import 'package:flutter/material.dart';
import 'package:simple_register_app/src/presentation/config/themes/color_palette.dart';
import 'package:simple_register_app/src/presentation/config/themes/light_theme.dart';
import 'package:simple_register_app/src/presentation/config/themes/text_theme.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
    brightness: Brightness.light,
    primaryColor: LightTheme.primaryColor,
    primaryColorDark: LightTheme.primaryColorDark,
    primaryColorLight: LightTheme.primaryColorLight,
    scaffoldBackgroundColor: LightTheme.backgroundColor,
    cardColor: LightTheme.backgroundColor,
    disabledColor: ColorPalette.greyLighten3,
    colorScheme: const ColorScheme.light(
      primary: LightTheme.primaryColor,
      onPrimary: LightTheme.onPrimaryColor,
      primaryContainer: LightTheme.primaryColorLight,
      onPrimaryContainer: LightTheme.primaryColor,
      primaryFixed: LightTheme.primaryColorFixed,
      onPrimaryFixed: LightTheme.onPrimaryColor,
      primaryFixedDim: LightTheme.primaryColorDim,
      onPrimaryFixedVariant: LightTheme.onPrimaryColor,
      inversePrimary: LightTheme.inversePrimaryColor,
      secondary: LightTheme.secondaryColor,
      onSecondary: LightTheme.onSecondaryColor,
      secondaryContainer: LightTheme.secondaryColorLight,
      onSecondaryContainer: LightTheme.secondaryColor,
      secondaryFixed: LightTheme.secondaryColorFixed,
      onSecondaryFixed: LightTheme.onSecondaryColor,
      secondaryFixedDim: LightTheme.secondaryColorDim,
      onSecondaryFixedVariant: LightTheme.onSecondaryColor,
      tertiary: LightTheme.tertiaryColor,
      onTertiary: LightTheme.onTertiaryColor,
      tertiaryContainer: LightTheme.tertiaryColorLight,
      onTertiaryContainer: LightTheme.tertiaryColor,
      tertiaryFixed: LightTheme.tertiaryColorFixed,
      onTertiaryFixed: LightTheme.onTertiaryColor,
      tertiaryFixedDim: LightTheme.tertiaryColorDim,
      onTertiaryFixedVariant: LightTheme.onTertiaryColor,
      surface: LightTheme.backgroundColor,
      onSurface: ColorPalette.greyDarken3,
      outline: ColorPalette.greyLighten2,
      outlineVariant: ColorPalette.greyLighten2,
      shadow: ColorPalette.greyDarken4,
      error: ColorPalette.error,
      onError: LightTheme.onPrimaryColor,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: LightTheme.backgroundColor,
      foregroundColor: ColorPalette.greyDarken3,
      centerTitle: true,
    ),
    tabBarTheme: const TabBarTheme(
      labelColor: LightTheme.primaryColor,
      indicatorColor: LightTheme.primaryColor,
      unselectedLabelColor: LightTheme.secondaryTextColor,
      indicatorSize: TabBarIndicatorSize.label,
      dividerHeight: 0.5,
      dividerColor: ColorPalette.greyLighten1,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: ColorPalette.greyLighten4,
      border: UnderlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(10.0),
      ),
    ),
    textTheme: AppTextTheme.light,
  );
}
