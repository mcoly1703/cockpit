import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';

class FinancesResumeCard extends StatelessWidget {
  const FinancesResumeCard({
    super.key,
    required this.titre,
    required this.solde,
    required this.nbMembres,
    required this.couleur,
    required this.icone,
  });

  final String titre;
  final double solde;
  final int nbMembres;
  final Color couleur;
  final IconData icone;

  @override
  Widget build(BuildContext context) {
    final fmt =
        NumberFormat.currency(locale: 'fr', symbol: '€', decimalDigits: 0);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: couleur,
        borderRadius: BorderRadius.circular(13),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(icone, color: Colors.white70, size: 16),
            const SizedBox(width: 6),
            Text(titre,
                style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Colors.white70,
                    letterSpacing: 0.5)),
          ]),
          const SizedBox(height: 8),
          Text(fmt.format(solde),
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Colors.white)),
          const SizedBox(height: 4),
          Text('$nbMembres membre${nbMembres > 1 ? 's' : ''} actif${nbMembres > 1 ? 's' : ''}',
              style: TextStyle(
                  fontSize: 11,
                  color: Colors.white.withValues(alpha: 0.8))),
        ],
      ),
    );
  }
}
