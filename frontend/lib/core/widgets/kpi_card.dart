import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class KpiCard extends StatelessWidget {
  const KpiCard({
    super.key,
    required this.titre,
    required this.valeur,
    required this.icone,
    this.sousTitre,
    this.evolution,
    this.emoji,
    this.gradient,
    this.onTap,
  });

  final String   titre;
  final String   valeur;
  final IconData icone;
  final String?  sousTitre;
  final String?  evolution;
  final String?  emoji;
  final LinearGradient? gradient;
  final VoidCallback?   onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient ?? AppColors.kpiVertGradient,
          borderRadius: BorderRadius.circular(13),
        ),
        padding: const EdgeInsets.all(13),
        child: Stack(
          children: [
            // Emoji watermark en bas à droite
            if (emoji != null)
              Positioned(
                right: -6,
                bottom: -6,
                child: Text(
                  emoji!,
                  style: const TextStyle(fontSize: 44),
                ),
              ),

            // Contenu
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Valeur principale
                Text(
                  valeur,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 3),

                // Titre (uppercase, petit)
                Text(
                  titre.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 9,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                ),

                // Sous-titre / évolution
                if (sousTitre != null || evolution != null) ...[
                  const SizedBox(height: 5),
                  Text(
                    evolution ?? sousTitre ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}