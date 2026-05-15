import 'package:flutter/material.dart';

class LALColors {
  LALColors._();

  static const c50 = Color(0xFFECEFF1);
  static const c100 = Color(0xFFCFD8DC);
  static const c200 = Color(0xFFB0BEC5);
  static const c300 = Color(0xFF90A4AE);
  static const c400 = Color(0xFF78909C);
  static const c500 = Color(0xFF607D8B);
  static const c600 = Color(0xFF546E7A);
  static const c700 = Color(0xFF455A64);
  static const c800 = Color(0xFF37474F);
  static const c900 = Color(0xFF263238);

  static const bg = Color(0xFFF6F7F8);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceAlt = Color(0xFFECEFF1);

  static const accent = Color(0xFFC97B5C);
  static const accentSoft = Color(0xFFF4E3D8);
  static const accentDark = Color(0xFFA85F45);

  static const error = Color(0xFFD32F2F);
  static const errorSoft = Color(0xFFFBE7E0);
  static const errorDark = Color(0xFFA04020);
  static const success = Color(0xFF388E3C);
  static const successSoft = Color(0xFFE3F1E5);
  static const warning = Color(0xFFFFA726);
  static const warningSoft = Color(0xFFFFF1DB);

  static const border = Color(0xFFE6E9EC);
}

class LALSpacing {
  LALSpacing._();

  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 20.0;
  static const xxl = 24.0;
  static const xxxl = 32.0;
  static const screenH = 20.0;
}

class LALRadii {
  LALRadii._();

  static const sm = Radius.circular(8.0);
  static const md = Radius.circular(12.0);
  static const lg = Radius.circular(16.0);
  static const xl = Radius.circular(22.0);
  static const pill = Radius.circular(999.0);

  static const smBorder = BorderRadius.all(sm);
  static const mdBorder = BorderRadius.all(md);
  static const lgBorder = BorderRadius.all(lg);
  static const xlBorder = BorderRadius.all(xl);
  static const pillBorder = BorderRadius.all(pill);
}
