import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_colors.dart';
import '../constants/app_routes.dart';

class ModulesPage extends StatelessWidget {
  const ModulesPage({super.key});

  static const _modules = [
    _Module(
      titre:     'Événements',
      sousTitre: 'Planning & présences',
      icone:     Icons.event_rounded,
      gradient:  AppColors.kpiVertGradient,
      route:     AppRoutes.evenements,
    ),
    _Module(
      titre:     'Réunions',
      sousTitre: 'Décisions & suivi',
      icone:     Icons.groups_rounded,
      gradient:  AppColors.kpiDarkGradient,
      route:     AppRoutes.reunions,
    ),
    _Module(
      titre:     'Bureau',
      sousTitre: 'Organigramme postes',
      icone:     Icons.account_tree_rounded,
      gradient:  AppColors.kpiRougeGradient,
      route:     AppRoutes.bureau,
    ),
    _Module(
      titre:     'Rapports',
      sousTitre: '5 types de PDF',
      icone:     Icons.picture_as_pdf_rounded,
      gradient:  AppColors.kpiOrGradient,
      route:     AppRoutes.rapports,
    ),
    _Module(
      titre:     'Scan',
      sousTitre: 'Carte & présences',
      icone:     Icons.qr_code_scanner_rounded,
      gradient:  AppColors.kpiBleuGradient,
      route:     AppRoutes.scan,
    ),
    _Module(
      titre:     'Élections',
      sousTitre: 'Scrutins & résultats',
      icone:     Icons.how_to_vote_rounded,
      gradient:  AppColors.kpiVioletGradient,
      route:     AppRoutes.elections,
    ),
    _Module(
      titre:     'CRA',
      sousTitre: 'Comptes rendus terrain',
      icone:     Icons.assignment_rounded,
      gradient:  AppColors.kpiVertGradient,
      route:     AppRoutes.cra,
    ),
    _Module(
      titre:     'Organigramme',
      sousTitre: 'Structure & cellules',
      icone:     Icons.account_tree_outlined,
      gradient:  AppColors.kpiBleuGradient,
      route:     AppRoutes.organigramme,
    ),
    _Module(
      titre:     'Palmarès',
      sousTitre: 'Top militants & cotiseurs',
      icone:     Icons.emoji_events_rounded,
      gradient:  AppColors.kpiOrGradient,
      route:     AppRoutes.palmares,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount:   2,
        crossAxisSpacing: 12,
        mainAxisSpacing:  12,
        childAspectRatio: 0.95,
      ),
      itemCount: _modules.length,
      itemBuilder: (ctx, i) => _ModuleTile(module: _modules[i]),
    );
  }
}

// ─── Tuile module ─────────────────────────────────────────────────────────────

class _Module {
  const _Module({
    required this.titre,
    required this.sousTitre,
    required this.icone,
    required this.gradient,
    required this.route,
  });
  final String          titre;
  final String          sousTitre;
  final IconData        icone;
  final LinearGradient  gradient;
  final String          route;
}

class _ModuleTile extends StatelessWidget {
  const _ModuleTile({required this.module});
  final _Module module;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => context.go(module.route),
        child: Ink(
          decoration: BoxDecoration(
            gradient:     module.gradient,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color:  Color(0x28000000),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icône dans un cercle semi-transparent
                Container(
                  width:  48,
                  height: 48,
                  decoration: BoxDecoration(
                    color:  Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(module.icone, color: Colors.white, size: 26),
                ),
                const Spacer(),
                Text(
                  module.titre,
                  style: const TextStyle(
                    color:      Colors.white,
                    fontSize:   16,
                    fontWeight: FontWeight.w800,
                    height:     1.1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  module.sousTitre,
                  style: TextStyle(
                    color:    Colors.white.withValues(alpha: 0.75),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}