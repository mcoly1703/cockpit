import 'package:flutter/material.dart';

class AppColors {
  // Couleurs officielles Pastef France
  static const Color primary    = Color(0xFF1B4D1B); // Vert foncé
  static const Color secondary  = Color(0xFF8B0000); // Rouge foncé
  static const Color accent     = Color(0xFFC8950A); // Or
  static const Color background = Color(0xFFF5F2F0); // Fond
  static const Color card       = Color(0xFFFFFFFF); // Cards
  static const Color border     = Color(0xFFDDD8D0); // Bordures
  static const Color text       = Color(0xFF1A1A1A); // Texte principal
  static const Color text2      = Color(0xFF5A5248); // Texte secondaire

  // Topbar : dégradé vert → rouge
  static const LinearGradient topbarGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  // MonCap Diaspora
  static const Color moncapPrimary   = Color(0xFF1A4A8A); // Bleu marine
  static const Color moncapSecondary = Color(0xFF5B2D8B); // Violet

  static const LinearGradient moncapGradient = LinearGradient(
    colors: [Color(0xFF0A1F4A), Color(0xFF1A4A8A), Color(0xFF5B2D8B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Gradients KPI
  static const LinearGradient kpiVertGradient = LinearGradient(
    colors: [Color(0xFF1B4D1B), Color(0xFF2E7D32)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient kpiRougeGradient = LinearGradient(
    colors: [Color(0xFF8B0000), Color(0xFFB71C1C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient kpiOrGradient = LinearGradient(
    colors: [Color(0xFFC8950A), Color(0xFFE6A817)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient kpiBleuGradient = LinearGradient(
    colors: [Color(0xFF1A4A8A), Color(0xFF2563EB)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient kpiVioletGradient = LinearGradient(
    colors: [Color(0xFF5B2D8B), Color(0xFF7C3AED)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient kpiDarkGradient = LinearGradient(
    colors: [Color(0xFF2D2D2D), Color(0xFF4A4A4A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Fond des alertes
  static const Color alerteRougeBg  = Color(0xFFF5E8E8);
  static const Color alerteOrangeBg = Color(0xFFFFF8E1);
  static const Color alerteVertBg   = Color(0xFFE8F0E8);

  // Ombre standard des cards
  static const List<BoxShadow> cardShadow = [
    BoxShadow(color: Color(0x1A1B4D1B), blurRadius: 12, offset: Offset(0, 2)),
  ];
}