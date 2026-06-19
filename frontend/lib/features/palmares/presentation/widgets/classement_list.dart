import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/classement_entry.dart';

class ClassementList extends StatelessWidget {
  const ClassementList({super.key, required this.entries, required this.icone});
  final List<ClassementEntry> entries;
  final IconData icone;

  static const _medailles = [
    Color(0xFFFFD700), // or
    Color(0xFFC0C0C0), // argent
    Color(0xFFCD7F32), // bronze
  ];

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(icone, size: 48, color: AppColors.border),
            const SizedBox(height: 12),
            const Text('Aucune donnée pour ce classement',
                style: TextStyle(fontSize: 14, color: AppColors.text2)),
          ]),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 24),
      itemCount: entries.length,
      itemBuilder: (_, i) => _LigneClassement(entry: entries[i]),
    );
  }
}

class _LigneClassement extends StatelessWidget {
  const _LigneClassement({required this.entry});
  final ClassementEntry entry;

  @override
  Widget build(BuildContext context) {
    final estPodium = entry.rang <= 3;
    final couleurMedaille = estPodium
        ? ClassementList._medailles[entry.rang - 1]
        : AppColors.text2;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        boxShadow: AppColors.cardShadow,
        border: estPodium
            ? Border.all(color: couleurMedaille.withValues(alpha: 0.4), width: 1.5)
            : null,
      ),
      child: Row(
        children: [
          // Rang
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: estPodium
                  ? couleurMedaille
                  : AppColors.text2.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: estPodium
                  ? Icon(Icons.emoji_events_rounded,
                      color: Colors.white, size: 18)
                  : Text('${entry.rang}',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: AppColors.text2)),
            ),
          ),
          const SizedBox(width: 12),
          // Nom + unité
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Flexible(
                    child: Text(
                        entry.prenom.isNotEmpty
                            ? '${entry.prenom} ${entry.nom}'
                            : entry.nom,
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.text),
                        overflow: TextOverflow.ellipsis),
                  ),
                  if (entry.estExterne) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 1),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text('Externe',
                          style: TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.w700,
                              color: AppColors.accent)),
                    ),
                  ],
                ]),
                if (entry.uniteNom != null)
                  Text(entry.uniteNom!,
                      style:
                          const TextStyle(fontSize: 11, color: AppColors.text2),
                      overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Score
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('${entry.score}',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: estPodium ? couleurMedaille : AppColors.text)),
              if (entry.detailLabel != null)
                Text(entry.detailLabel!,
                    style:
                        const TextStyle(fontSize: 10, color: AppColors.text2)),
            ],
          ),
        ],
      ),
    );
  }
}
