import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors
  static const Color primary =  Color(0xFF8A1538);
  static const Color primaryDark = Color(0xFF6E102D);
  static const Color primaryLight = Color(0xFFF8E9EE);

  // Accent
  static const Color secondary = Color(0xFFD9B27C);

  // Backgrounds
  static const Color background = Color(0xFFFDFDFD);
  static const Color scaffold = Color(0xFFFFFFFF);
  static const Color card = Color(0xFFFFFFFF);

  // Text
  static const Color textPrimary = Color(0xFF222222);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textHint = Color(0xFF9CA3AF);

  // Borders
  static const Color border = Color(0xFFE5E7EB);
  static const Color divider = Color(0xFFF3F4F6);

  // Input
  static const Color inputBorder = Color(0xFFE5E7EB);
  static const Color focusedBorder = primary;

  // Status
  static const Color success = Color(0xFF16A34A);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFDC2626);
  static const Color info = Color(0xFF2563EB);

  // Common
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color transparent = Colors.transparent;

  // Auth Screens
  static const Color authInfoBackground = Color(0xFFF9F2F4);
  static const Color authIconBackground = Color(0xFFF7E8EE);

  // Property Tags
  static const Color featured = primary;
  static const Color newProperty = Color(0xFF16A34A);
  static const Color sold = Color(0xFFDC2626);

  // Shadow
  static const Color shadow = Color(0x14000000);

  // Button Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFF980A43), Color(0xFF8A1538), Color(0xFF730D30)],
  );

  // Decorative Background
  static const Color backgroundPattern = Color(0xFFF8EEF2);

  // OTP Box
  static const Color otpBorder = Color(0xFFE5E7EB);
  static const Color otpFocused = primary;

  // Disabled
  static const Color disabled = Color(0xFFD1D5DB);
  static const pinkChipBg = Color(0xFFFDF0F3);
  static const fieldBorder = Color(0xFFE3E1E6);
  static const fieldBg = Color(0xFFFFFFFF);
  static const greenBg = Color(0xFFE8F8EE);
  static const greenText = Color(0xFF1E9E4B);
  static const hintGrey = Color(0xFF9C9AA3);
  static const labelGrey = Color(0xFF4A4750);
  static const pinkBg = Color(0xFFFBE7EC);
  static const mapBg = Color(0xFFDCE9E4);
  static const cardBg = Color(0xFFFFFFFF);

  static const Color primarySoft = Color(0xFFF3E3E9);
   static const Color surface = Color(0xFFFFFFFF);
    static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF7B1F3D), Color(0xFFA13A5C)],
  );

   static const LinearGradient buttonGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFF7B1F3D), Color(0xFF9A3054)],
  );
}
