import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/espace_cotisation_mois.dart';

class CotisationMoisGrid extends StatelessWidget {
  const CotisationMoisGrid({super.key, required this.cotisations});
  final List<EspaceCotisationMois> cotisations;

  static const _statutCouleur = {
    'payee': AppColors.primary,
    'partiel': AppColors.accent,
    'en_retard': AppColors.secondary,
    'en_attente': AppColors.border,
  };

  static const _statutLabel = {
    'payee': 'Payé',
    'partiel': 'Partiel',
    'en_retard': 'Retard',
    'en_attente': 'En attente',
  };

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final cotMap = {for (final c in cotisations) c.mois: c};

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1.3,
      ),
      itemCount: 12,
      itemBuilder: (_, i) {
        final mois = i + 1;
        final cot = cotMap[mois];
        final estFutur = mois > now.month;
        final statut = cot?.statut ?? (estFutur ? 'en_attente' : 'en_retard');
        final couleur = _statutCouleur[statut] ?? AppColors.border;
        final label = DateFormat('MMM', 'fr')
            .format(DateTime(now.year, mois))
            .toUpperCase();

        return Container(
          decoration: BoxDecoration(
            color: couleur.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color: couleur.withValues(alpha: 0.4), width: 1.5),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(label,
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: couleur)),
              const SizedBox(height: 2),
              if (cot != null && cot.montantPaye > 0)
                Text('${cot.montantPaye.toStringAsFixed(0)} €',
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: couleur)),
              Text(_statutLabel[statut] ?? statut,
                  style: TextStyle(fontSize: 8, color: couleur)),
            ],
          ),
        );
      },
    );
  }
}
