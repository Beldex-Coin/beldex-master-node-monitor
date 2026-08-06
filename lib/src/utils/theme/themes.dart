import 'package:flutter/material.dart';

import 'palette.dart';

class Themes {
  static final ThemeData lightTheme = ThemeData(
      fontFamily: 'Lato',
      brightness: Brightness.light,
      dialogTheme: DialogThemeData(backgroundColor: Palette.lightThemeBackground),
      scaffoldBackgroundColor: Palette.lightThemeBackground,
      hintColor: Palette.hintColor,
      focusColor: Palette.lightGrey,
      cardColor: Palette.cardColor,
      primaryTextTheme: TextTheme(
          titleLarge: TextStyle(color: BeldexPalette.black),
          bodySmall: TextStyle(
            color: BeldexPalette.black,
            backgroundColor: Colors.black
          ),
          labelLarge: TextStyle(
              color: BeldexPalette.white,
              backgroundColor: BeldexPalette.tealWithOpacity,
              decorationColor: BeldexPalette.teal),
          titleMedium: TextStyle(color: BeldexPalette.black),
      ),
      toggleButtonsTheme: ToggleButtonsThemeData(
          selectedColor: BeldexPalette.teal,
          disabledColor: Palette.wildDarkBlue,
          color: Palette.switchBackground,
          borderColor: Palette.switchBorder),
      dividerColor: Palette.lightGrey,
      dividerTheme: DividerThemeData(color: Palette.lightGrey),
      textTheme: TextTheme(
          titleLarge: TextStyle(
              color: Colors.grey,
              backgroundColor: Colors.transparent),
          bodySmall: TextStyle(
              color: Palette.wildDarkBlue,
              backgroundColor:Colors.transparent,
              decorationColor: Palette.cloudySky),
          labelLarge: TextStyle(
              backgroundColor: Colors.transparent,//Palette.indigo,
              decorationColor: Palette.deepIndigo),
          titleMedium: TextStyle(
            color: Palette.lightGrey2,
            backgroundColor: Colors.transparent,//Colors.white,
            decorationColor: Palette.darkGrey,
          ),
          titleSmall: TextStyle(
              color: Palette.lightBlue,
              backgroundColor: Colors.transparent//Palette.lightGrey2
          ),
      ),
      buttonTheme: ButtonThemeData(buttonColor: Palette.darkGrey),
      primaryIconTheme: IconThemeData(color: Colors.white),
      //accentIconTheme: IconThemeData(color: Colors.white)
  );

  static final ThemeData darkTheme = ThemeData(
      fontFamily: 'Lato',
      brightness: Brightness.dark,
      dialogTheme: DialogThemeData(backgroundColor: PaletteDark.darkThemeBackgroundDark),
      scaffoldBackgroundColor: PaletteDark.darkThemeBlack,
      hintColor: PaletteDark.hintColor,
      focusColor: PaletteDark.darkThemeGreyWithOpacity,
      cardColor: PaletteDark.cardColor,
      primaryTextTheme: TextTheme(
          titleLarge: TextStyle(color: PaletteDark.darkThemeTitle),
          bodySmall: TextStyle(color: Colors.white,backgroundColor: BeldexPalette.progressCenterText),
          labelLarge: TextStyle(
              color: BeldexPalette.white,
              backgroundColor: BeldexPalette.tealWithOpacity,
              decorationColor: BeldexPalette.teal),
          titleMedium: TextStyle(color: BeldexPalette.white),
      ),
      toggleButtonsTheme: ToggleButtonsThemeData(
          selectedColor: BeldexPalette.teal,
          disabledColor: Palette.wildDarkBlue,
          color: PaletteDark.switchBackground,
          borderColor: PaletteDark.darkThemeMidGrey),
      dividerColor: PaletteDark.darkThemeDarkGrey,
      dividerTheme:
          DividerThemeData(color: PaletteDark.darkThemeGreyWithOpacity),
      textTheme: TextTheme(
          titleLarge: TextStyle(
              color: PaletteDark.darkThemeTitle,
              backgroundColor: Colors.transparent),
          bodySmall: TextStyle(
              color: PaletteDark.darkThemeTitleViolet,
              backgroundColor: Colors.transparent,
              decorationColor: PaletteDark.darkThemeBlueButtonBorder),
          labelLarge: TextStyle(
              backgroundColor: Colors.transparent,//PaletteDark.darkThemeIndigoButton,
              decorationColor: PaletteDark.darkThemeIndigoButtonBorder),
          titleMedium: TextStyle(
            color: PaletteDark.darkThemeBlack,
            backgroundColor: Colors.transparent,//PaletteDark.darkThemeMidGrey,
            decorationColor: PaletteDark.darkThemeDarkGrey,
          ),
          titleSmall: TextStyle(
              color: Palette.wildDarkBlue,
              backgroundColor: Colors.transparent//PaletteDark.darkThemeMidGrey
          ),
      ),
      buttonTheme: ButtonThemeData(buttonColor: PaletteDark.darkThemePinButton),
      primaryIconTheme: IconThemeData(color: PaletteDark.darkThemeViolet),
      //accentIconTheme: IconThemeData(color: PaletteDark.darkThemeIndigoButtonBorder)
  );
}
