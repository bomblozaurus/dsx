import 'dart:ui';

import 'package:flutter/cupertino.dart';

class Colors {
  const Colors();

  static const Color logoBackgroundColor = const Color(0xFFaeea00);

  static const Color loginGradientStart = const Color(0xFF484848);
  static const Color loginGradientEnd = const Color(0xFF1b1b1b);

  static const primaryGradient = const LinearGradient(
    colors: const [loginGradientStart, loginGradientEnd],
    stops: const [0.0, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
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
