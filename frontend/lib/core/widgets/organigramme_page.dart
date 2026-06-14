import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/app_colors.dart';
import '../constants/app_constants.dart';
import '../constants/app_tables.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/militants/domain/entities/militant.dart';
import '../../features/militants/domain/entities/unite_organisationnelle.dart';
import '../../features/militants/presentation/providers/militants_provider.dart';

class OrganigrammePage extends ConsumerStatefulWidget {
  const OrganigrammePage({super.key});

  @override
  ConsumerState<OrganigrammePage> createState() => _OrganigrammePageState();
}

class _OrganigrammePageState extends ConsumerState<OrganigrammePage> {
  final Set<String> _expanded = {};

  @override
  Widget build(BuildContext context) {
    final authState   = ref.watch(authProvider);
    final utilisateur = authState.whenOrNull(connecte: (u) => u);
    final role        = utilisateur?.role ?? '';
    final monUniteId  = utilisateur?.uniteOrganisationnelleId;
    final state       = ref.watch(militantsProvider);

    return state.when(
      initial:    () => const SizedBox.shrink(),
      chargement: () => const Center(child: CircularProgressIndicator()),
      erreur: (failure) => Center(
        child: Text(
          failure.when(
            serveur:     (m) => m,
            reseau:      () => 'Pas de connexion',
            nonAutorise: () => 'Accès non autorisé',
            nonTrouve:   () => 'Données introuvables',
            validation:  (m) => m,
          ),
          style: const TextStyle(color: AppColors.text2),
        ),
      ),
      charge: (militants, unites, _, _) {
        final data = _construire(militants, unites, role, monUniteId);
        return _VueOrganigramme(
          data:     data,
          expanded: _expanded,
          onToggle: (id) => setState(() {
            if (_expanded.contains(id)) {
              _expanded.remove(id);
            } else {
              _expanded.add(id);
            }
          }),
        );
      },
    );
  }

  _OrganigrammeData _construire(
    List<Militant> militants,
    List<UniteOrganisationnelle> unites,
    String role,
    String? monUniteId,
  ) {
    final countParUnite = <String, int>{};
    for (final m in militants.where((m) => m.statut == AppEnums.militantActif)) {
      countParUnite[m.uniteId] = (countParUnite[m.uniteId] ?? 0) + 1;
    }

    final bex = unites.firstWhere(
      (u) => u.type == AppUniteTypes.bureauExecutif,
      orElse: () => const UniteOrganisationnelle(
        id: '', type: 'bureau_executif', nom: 'Bureau Exécutif', isActive: true,
      ),
    );

    final estGlobal = role == AppRoles.bureauExecutif ||
        role == AppRoles.coordinateur ||
        role == AppRoles.adminTechnique;

    // Cellules groupées par SS parente
    final cellulesParSS = <String, List<UniteOrganisationnelle>>{};
    for (final u in unites.where((u) => u.type == AppUniteTypes.cellule)) {
      final parentId = u.parentId;
      if (parentId == null) continue;
      cellulesParSS.putIfAbsent(parentId, () => []).add(u);
    }

    // Sous-sections
    List<UniteOrganisationnelle> sousSections = unites
        .where((u) => u.type == AppUniteTypes.sousSection)
        .toList()
      ..sort((a, b) => a.nom.compareTo(b.nom));

    if (!estGlobal) {
      if (role == AppRoles.responsableSousSection) {
        sousSections = sousSections.where((ss) => ss.id == monUniteId).toList();
      } else {
        sousSections = [];
      }
    }

    final blocsSS = sousSections.map((ss) {
      final cellules = (cellulesParSS[ss.id] ?? [])
        ..sort((a, b) => a.nom.compareTo(b.nom));
      final countDirect   = countParUnite[ss.id] ?? 0;
      final countCellules = cellules.fold(0, (s, c) => s + (countParUnite[c.id] ?? 0));
      return _BlocSS(
        unite:    ss,
        total:    countDirect + countCellules,
        cellules: cellules
            .map((c) => _UniteStat(unite: c, count: countParUnite[c.id] ?? 0))
            .toList(),
      );
    }).toList();

    // Mouvements
    List<UniteOrganisationnelle> mouvements = unites
        .where((u) => u.type == AppUniteTypes.mouvement)
        .toList()
      ..sort((a, b) => a.nom.compareTo(b.nom));

    if (!estGlobal) {
      if (role == AppRoles.responsableMouvement) {
        mouvements = mouvements.where((m) => m.id == monUniteId).toList();
      } else {
        mouvements = [];
      }
    }

    // Secrétariats
    List<UniteOrganisationnelle> secretariats = unites
        .where((u) => u.type == AppUniteTypes.secretariat)
        .toList()
      ..sort((a, b) => a.nom.compareTo(b.nom));

    if (!estGlobal) {
      if (role == AppRoles.responsableSecretariat) {
        secretariats = secretariats.where((s) => s.id == monUniteId).toList();
      } else {
        secretariats = [];
      }
    }

    final totalActifs =
        militants.where((m) => m.statut == AppEnums.militantActif).length;

    return _OrganigrammeData(
      bex:            bex,
      totalActifs:    totalActifs,
      blocsSSections: blocsSS,
      mouvements: mouvements
          .map((m) => _UniteStat(unite: m, count: countParUnite[m.id] ?? 0))
          .toList(),
      secretariats: secretariats
          .map((s) => _UniteStat(unite: s, count: countParUnite[s.id] ?? 0))
          .toList(),
    );
  }
}

// ─── Modèles locaux ───────────────────────────────────────────────────────────

class _UniteStat {
  final UniteOrganisationnelle unite;
  final int count;
  const _UniteStat({required this.unite, required this.count});
}

class _BlocSS {
  final UniteOrganisationnelle unite;
  final int total;
  final List<_UniteStat> cellules;
  const _BlocSS({required this.unite, required this.total, required this.cellules});
}

class _OrganigrammeData {
  final UniteOrganisationnelle bex;
  final int totalActifs;
  final List<_BlocSS> blocsSSections;
  final List<_UniteStat> mouvements;
  final List<_UniteStat> secretariats;
  const _OrganigrammeData({
    required this.bex,
    required this.totalActifs,
    required this.blocsSSections,
    required this.mouvements,
    required this.secretariats,
  });
}

// ─── Vue principale ───────────────────────────────────────────────────────────

class _VueOrganigramme extends StatelessWidget {
  const _VueOrganigramme({
    required this.data,
    required this.expanded,
    required this.onToggle,
  });
  final _OrganigrammeData     data;
  final Set<String>           expanded;
  final void Function(String) onToggle;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(child: _TitrePage()),

        SliverToBoxAdapter(
          child: _CarteBex(unite: data.bex, totalActifs: data.totalActifs),
        ),

        if (data.blocsSSections.isNotEmpty) ...[
          const SliverToBoxAdapter(child: _EnTeteSection('SOUS-SECTIONS')),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, i) => _CarteSS(
                bloc:     data.blocsSSections[i],
                expanded: expanded.contains(data.blocsSSections[i].unite.id),
                onToggle: () => onToggle(data.blocsSSections[i].unite.id),
              ),
              childCount: data.blocsSSections.length,
            ),
          ),
        ],

        if (data.mouvements.isNotEmpty) ...[
          const SliverToBoxAdapter(child: _EnTeteSection('MOUVEMENTS')),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, i) => _CarteUniteSimple(
                stat:    data.mouvements[i],
                couleur: AppColors.accent,
                icone:   Icons.group_outlined,
              ),
              childCount: data.mouvements.length,
            ),
          ),
        ],

        if (data.secretariats.isNotEmpty) ...[
          const SliverToBoxAdapter(child: _EnTeteSection('SECRÉTARIATS')),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, i) => _CarteUniteSimple(
                stat:    data.secretariats[i],
                couleur: const Color(0xFF1A4A8A),
                icone:   Icons.folder_outlined,
              ),
              childCount: data.secretariats.length,
            ),
          ),
        ],

        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }
}

// ─── Titre ────────────────────────────────────────────────────────────────────

class _TitrePage extends StatelessWidget {
  const _TitrePage();

  @override
  Widget build(BuildContext context) => const Padding(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Text(
          'Organigramme',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: AppColors.text,
            height: 1.1,
          ),
        ),
      );
}

class _EnTeteSection extends StatelessWidget {
  const _EnTeteSection(this.titre);
  final String titre;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 6),
        child: Text(
          titre,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            color: AppColors.text2,
            letterSpacing: 0.8,
          ),
        ),
      );
}

// ─── Carte BEX ────────────────────────────────────────────────────────────────

class _CarteBex extends StatelessWidget {
  const _CarteBex({required this.unite, required this.totalActifs});
  final UniteOrganisationnelle unite;
  final int totalActifs;

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.fromLTRB(14, 4, 14, 4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient:     AppColors.kpiVertGradient,
          borderRadius: BorderRadius.circular(14),
          boxShadow:    AppColors.cardShadow,
        ),
        child: Row(children: [
          Container(
            width: 52, height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.account_balance_rounded,
                color: Colors.white, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  unite.nom,
                  style: const TextStyle(
                      color: Colors.white, fontSize: 15,
                      fontWeight: FontWeight.w800),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  '$totalActifs militants actifs',
                  style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 12),
                ),
              ],
            ),
          ),
          if (unite.code != null) _BadgeCode(unite.code!),
        ]),
      );
}

// ─── Carte sous-section (dépliable) ──────────────────────────────────────────

class _CarteSS extends StatelessWidget {
  const _CarteSS({
    required this.bloc,
    required this.expanded,
    required this.onToggle,
  });
  final _BlocSS      bloc;
  final bool         expanded;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final nbCellules = bloc.cellules.length;

    return Container(
      margin: const EdgeInsets.fromLTRB(14, 4, 14, 0),
      decoration: BoxDecoration(
        color:        AppColors.card,
        borderRadius: BorderRadius.circular(13),
        boxShadow:    AppColors.cardShadow,
      ),
      child: Column(children: [
        InkWell(
          onTap:        nbCellules > 0 ? onToggle : null,
          borderRadius: BorderRadius.circular(13),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 12, 14),
            child: Row(children: [
              Container(
                width: 42, height: 42,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.location_on_outlined,
                    color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bloc.unite.nom,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w700,
                          color: AppColors.text),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${bloc.total} militants · '
                      '$nbCellules cellule${nbCellules > 1 ? 's' : ''}',
                      style: const TextStyle(
                          fontSize: 11, color: AppColors.text2),
                    ),
                  ],
                ),
              ),
              if (bloc.unite.code != null) _BadgeCode(bloc.unite.code!),
              if (nbCellules > 0) ...[
                const SizedBox(width: 6),
                Icon(
                  expanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: AppColors.text2,
                ),
              ],
            ]),
          ),
        ),
        if (expanded && nbCellules > 0) ...[
          const Divider(height: 1, indent: 14, endIndent: 14,
              color: AppColors.border),
          ...bloc.cellules.map((stat) => _LigneCellule(stat: stat)),
          const SizedBox(height: 6),
        ],
      ]),
    );
  }
}

class _LigneCellule extends StatelessWidget {
  const _LigneCellule({required this.stat});
  final _UniteStat stat;

  @override
  Widget build(BuildContext context) {
    final count = stat.count;
    final Color couleur;
    final String label;

    if (count >= AppConstants.seuilPleineCellule) {
      couleur = AppColors.secondary;
      label   = '⚠ Pleine';
    } else if (count >= AppConstants.seuilActiveCellule) {
      couleur = AppColors.primary;
      label   = 'Active';
    } else {
      couleur = AppColors.accent;
      label   = 'En cours';
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 14, 0),
      child: Row(children: [
        const Icon(Icons.subdirectory_arrow_right_rounded,
            size: 16, color: AppColors.border),
        const SizedBox(width: 8),
        Container(
          width: 8, height: 8,
          decoration: const BoxDecoration(
              color: AppColors.accent, shape: BoxShape.circle),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            stat.unite.nom,
            style: const TextStyle(fontSize: 13, color: AppColors.text),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(
          '$count',
          style: const TextStyle(
              fontSize: 13, fontWeight: FontWeight.w700,
              color: AppColors.text),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color:        couleur.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            label,
            style: TextStyle(
                fontSize: 9, fontWeight: FontWeight.w700, color: couleur),
          ),
        ),
      ]),
    );
  }
}

// ─── Carte unité simple (mouvements / secrétariats) ──────────────────────────

class _CarteUniteSimple extends StatelessWidget {
  const _CarteUniteSimple({
    required this.stat,
    required this.couleur,
    required this.icone,
  });
  final _UniteStat stat;
  final Color      couleur;
  final IconData   icone;

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.fromLTRB(14, 4, 14, 0),
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        decoration: BoxDecoration(
          color:        AppColors.card,
          borderRadius: BorderRadius.circular(13),
          boxShadow:    AppColors.cardShadow,
        ),
        child: Row(children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: couleur.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icone, color: couleur, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stat.unite.nom,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w700,
                      color: AppColors.text),
                  overflow: TextOverflow.ellipsis,
                ),
                if (stat.unite.code != null)
                  Text(stat.unite.code!,
                      style: const TextStyle(
                          fontSize: 10, color: AppColors.text2)),
              ],
            ),
          ),
          Text(
            '${stat.count}',
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.w900,
                color: AppColors.text),
          ),
          const SizedBox(width: 4),
          const Text(
            'membres',
            style: TextStyle(fontSize: 10, color: AppColors.text2),
          ),
        ]),
      );
}

// ─── Badge code ───────────────────────────────────────────────────────────────

class _BadgeCode extends StatelessWidget {
  const _BadgeCode(this.code);
  final String code;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
        decoration: BoxDecoration(
          color:        AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          code,
          style: const TextStyle(
            fontSize: 9, fontWeight: FontWeight.w800,
            color: AppColors.primary, letterSpacing: 0.3,
          ),
        ),
      );
}