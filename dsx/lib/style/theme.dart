import 'dart:ui';

import 'package:flutter/material.dart' as Material;
import 'package:flutter/painting.dart';

class TextStyles {
  static var baseTextStyle = const Material.TextStyle(fontFamily: 'Poppins');
  static var regularTextStyle = baseTextStyle.copyWith(
      color: const Color(0xffb6b2df),
      fontSize: 12.0,
      fontWeight: FontWeight.w400);
  static var subHeaderTextStyle = regularTextStyle.copyWith(fontSize: 14.0);
  static var headerTextStyle = baseTextStyle.copyWith(
      color: Material.Colors.white,
      fontSize: 22.0,
      fontWeight: FontWeight.w600);
  static var headerTextStyleDark =
      headerTextStyle.copyWith(color: Colors.loginGradientEnd);

  static var subHeaderTextStyleDark =
      subHeaderTextStyle.copyWith(color: Colors.loginGradientEnd);
  static var descriptionTextStyleDark = regularTextStyle.copyWith(
      color: Colors.loginGradientEnd,
      fontSize: 18.0,
      fontWeight: Material.FontWeight.bold);

  static var descriptionTextStyle = descriptionTextStyleDark.copyWith(
    color: Material.Colors.white,
  );
}

class Colors {
  const Colors();

  static const Color logoBackgroundColor = const Color(0xFFaeea00);
  static const Color loginGradientStart = const Color(0xFF484848);
  static const Color loginGradientEnd = const Color(0xFF1b1b1b);

  static const primaryGradient = const LinearGradient(
    colors: const [loginGradientStart, loginGradientEnd],
    stops: const [0.0, 1.0],
    begin: Material.Alignment.topCenter,
    end: Material.Alignment.bottomCenter,
  );
}

class Fonts {
  const Fonts();

  static const loginFontMedium = "WorkSansMedium";
  static const loginFontSemiBold = "WorkSansSemiBold";
  static const loginFontBold = "WorkSansBold";
  static const loginFontSize = 16.0;

  static const logoFont = "AdventProSemiBold";
  static const logoFontSize = 50.0;
}
