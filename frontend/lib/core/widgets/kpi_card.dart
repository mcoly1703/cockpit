import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class KpiCard extends StatelessWidget {
  final String titre;
  final String valeur;
  final IconData icone;
  final String? sousTitre;
  final String? evolution; // ex: "+12 %" ou "-3 %"
  final LinearGradient? gradient;

  const KpiCard({
    super.key,
    required this.titre,
    required this.valeur,
    required this.icone,
    this.sousTitre,
    this.evolution,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient ?? AppColors.kpiVertGradient,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(titre, style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500)),
              Icon(icone, color: Colors.white70, size: 20),
            ],
          ),
          const SizedBox(height: 8),
          Text(valeur, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
          if (sousTitre != null || evolution != null) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                if (sousTitre != null)
                  Expanded(
                    child: Text(sousTitre!, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                  ),
                if (evolution != null)
                  Text(
                    evolution!,
                    style: TextStyle(
                      color: evolution!.startsWith('+') ? Colors.greenAccent : Colors.redAccent,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}