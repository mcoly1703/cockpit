import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/app_colors.dart';
import '../constants/app_constants.dart';
import '../constants/app_tables.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/militants/domain/entities/militant.dart';
import '../../features/militants/domain/entities/unite_organisationnelle.dart';
import '../../features/militants/presentation/providers/militants_provider.dart';

/// Nombre de membres composant l'AG (coordinateur + resp unités + délégués cellules).
/// Exclut bureau_executif et admin_technique qui n'en font pas partie.
final _countAGProvider = FutureProvider.autoDispose<int>((ref) async {
  final client = ref.watch(supabaseClientProvider);
  final rolesAG = [
    AppRoles.coordinateur,
    AppRoles.responsableSousSection,
    AppRoles.responsableMouvement,
    AppRoles.responsableSecretariat,
    AppRoles.coordinateurCellule,
  ];
  final data = await client
      .from(AppTables.profiles)
      .select(AppTables.colId)
      .inFilter(AppTables.colRole, rolesAG);
  return (data as List).length;
});

/// Map uniteId → photoUrl des responsables (depuis la table profiles).
final _photosResponsablesProvider = FutureProvider.autoDispose<Map<String, String>>((ref) async {
  final client = ref.watch(supabaseClientProvider);
  final data   = await client
      .from(AppTables.profiles)
      .select('${AppTables.colUniteId}, ${AppTables.colPhotoUrl}')
      .not(AppTables.colUniteId, 'is', null)
      .not(AppTables.colPhotoUrl, 'is', null);
  return {
    for (final row in data as List<dynamic>)
      row[AppTables.colUniteId] as String: row[AppTables.colPhotoUrl] as String,
  };
});

// ─── Page principale ──────────────────────────────────────────────────────────

class OrganigrammePage extends ConsumerStatefulWidget {
  const OrganigrammePage({super.key});

  @override
  ConsumerState<OrganigrammePage> createState() => _OrganigrammePageState();
}

class _OrganigrammePageState extends ConsumerState<OrganigrammePage> {
  int          _vue      = 0;          // 0 = liste, 1 = arbre
  final Set<String> _expandedListe = {};   // SS dépliées dans la vue liste
  final Set<String> _collapsedArbre = {};  // noeuds réduits dans la vue arbre

  @override
  Widget build(BuildContext context) {
    final authState  = ref.watch(authProvider);
    final utilisateur = authState.whenOrNull(connecte: (u) => u);
    final role       = utilisateur?.role ?? '';
    final monUniteId = utilisateur?.uniteOrganisationnelleId;
    final state      = ref.watch(militantsProvider);
    final photos     = ref.watch(_photosResponsablesProvider).valueOrNull ?? {};

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
        final data    = _construire(militants, unites, role, monUniteId);
        final countAG = ref.watch(_countAGProvider).valueOrNull ?? 0;
        final racine  = _buildArbre(data, countAG);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _EnTetePage(
              vue:      _vue,
              onToggle: (v) => setState(() => _vue = v),
            ),
            Expanded(
              child: _vue == 0
                  ? _VueListe(
                      data:     data,
                      photos:   photos,
                      expanded: _expandedListe,
                      onToggle: (id) => setState(() {
                        if (_expandedListe.contains(id)) {
                          _expandedListe.remove(id);
                        } else {
                          _expandedListe.add(id);
                        }
                      }),
                    )
                  : _VueArbre(
                      racine:    racine,
                      collapsed: _collapsedArbre,
                      onToggle:  (id) => setState(() {
                        if (_collapsedArbre.contains(id)) {
                          _collapsedArbre.remove(id);
                        } else {
                          _collapsedArbre.add(id);
                        }
                      }),
                    ),
            ),
          ],
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

    final cellulesParSS = <String, List<UniteOrganisationnelle>>{};
    for (final u in unites.where((u) => u.type == AppUniteTypes.cellule)) {
      final parentId = u.parentId;
      if (parentId == null) continue;
      cellulesParSS.putIfAbsent(parentId, () => []).add(u);
    }

    List<UniteOrganisationnelle> sousSections = unites
        .where((u) => u.type == AppUniteTypes.sousSection)
        .toList()
      ..sort((a, b) => a.nom.compareTo(b.nom));
    if (!estGlobal) {
      sousSections = role == AppRoles.responsableSousSection
          ? sousSections.where((ss) => ss.id == monUniteId).toList()
          : [];
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

    List<UniteOrganisationnelle> mouvements = unites
        .where((u) => u.type == AppUniteTypes.mouvement)
        .toList()
      ..sort((a, b) => a.nom.compareTo(b.nom));
    if (!estGlobal) {
      mouvements = role == AppRoles.responsableMouvement
          ? mouvements.where((m) => m.id == monUniteId).toList()
          : [];
    }

    List<UniteOrganisationnelle> secretariats = unites
        .where((u) => u.type == AppUniteTypes.secretariat)
        .toList()
      ..sort((a, b) => a.nom.compareTo(b.nom));
    if (!estGlobal) {
      secretariats = role == AppRoles.responsableSecretariat
          ? secretariats.where((s) => s.id == monUniteId).toList()
          : [];
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

// ─── En-tête avec toggle ──────────────────────────────────────────────────────

class _EnTetePage extends StatelessWidget {
  const _EnTetePage({required this.vue, required this.onToggle});
  final int vue;
  final void Function(int) onToggle;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Row(
          children: [
            const Expanded(
              child: Text('Organigramme',
                  style: TextStyle(
                    fontSize: 28, fontWeight: FontWeight.w900,
                    color: AppColors.text, height: 1.1,
                  )),
            ),
            Container(
              decoration: BoxDecoration(
                color:        AppColors.background,
                borderRadius: BorderRadius.circular(10),
                border:       Border.all(color: AppColors.border),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _BoutonVue(
                    label:  'Liste',
                    icone:  Icons.view_list_rounded,
                    actif:  vue == 0,
                    onTap:  () => onToggle(0),
                    isLeft: true,
                  ),
                  _BoutonVue(
                    label:   'Arbre',
                    icone:   Icons.account_tree_outlined,
                    actif:   vue == 1,
                    onTap:   () => onToggle(1),
                    isLeft:  false,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}

class _BoutonVue extends StatelessWidget {
  const _BoutonVue({
    required this.label,
    required this.icone,
    required this.actif,
    required this.onTap,
    required this.isLeft,
  });
  final String     label;
  final IconData   icone;
  final bool       actif;
  final VoidCallback onTap;
  final bool       isLeft;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color:        actif ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.horizontal(
              left:  isLeft  ? const Radius.circular(9) : Radius.zero,
              right: !isLeft ? const Radius.circular(9) : Radius.zero,
            ),
          ),
          child: Row(
            children: [
              Icon(icone, size: 14,
                  color: actif ? Colors.white : AppColors.text2),
              const SizedBox(width: 4),
              Text(label,
                  style: TextStyle(
                    fontSize: 11, fontWeight: FontWeight.w600,
                    color: actif ? Colors.white : AppColors.text2,
                  )),
            ],
          ),
        ),
      );
}

// ══════════════════════════════════════════════════════════════════════════════
// VUE LISTE
// ══════════════════════════════════════════════════════════════════════════════

class _VueListe extends StatelessWidget {
  const _VueListe({
    required this.data,
    required this.photos,
    required this.expanded,
    required this.onToggle,
  });
  final _OrganigrammeData     data;
  final Map<String, String>   photos;
  final Set<String>           expanded;
  final void Function(String) onToggle;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: _CarteBex(unite: data.bex, totalActifs: data.totalActifs),
        ),

        if (data.blocsSSections.isNotEmpty) ...[
          const SliverToBoxAdapter(child: _EnTeteSection('SOUS-SECTIONS')),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, i) => _CarteSS(
                bloc:      data.blocsSSections[i],
                photoUrl:  photos[data.blocsSSections[i].unite.id],
                expanded:  expanded.contains(data.blocsSSections[i].unite.id),
                onToggle:  () => onToggle(data.blocsSSections[i].unite.id),
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
                stat:     data.mouvements[i],
                photoUrl: photos[data.mouvements[i].unite.id],
                couleur:  AppColors.accent,
                icone:    Icons.group_outlined,
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
                stat:     data.secretariats[i],
                photoUrl: photos[data.secretariats[i].unite.id],
                couleur:  const Color(0xFF1A4A8A),
                icone:    Icons.folder_outlined,
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

class _EnTeteSection extends StatelessWidget {
  const _EnTeteSection(this.titre);
  final String titre;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 6),
        child: Text(titre,
            style: const TextStyle(
              fontSize: 10, fontWeight: FontWeight.w800,
              color: AppColors.text2, letterSpacing: 0.8,
            )),
      );
}

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
              color: Colors.white.withValues(alpha: 0.2), shape: BoxShape.circle),
            child: const Icon(Icons.account_balance_rounded,
                color: Colors.white, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(unite.nom,
                  style: const TextStyle(
                      color: Colors.white, fontSize: 15, fontWeight: FontWeight.w800),
                  overflow: TextOverflow.ellipsis),
              const SizedBox(height: 3),
              Text('$totalActifs militants actifs',
                  style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8), fontSize: 12)),
            ]),
          ),
          if (unite.code != null) _BadgeCode(unite.code!),
        ]),
      );
}

class _CarteSS extends StatelessWidget {
  const _CarteSS({
    required this.bloc,
    required this.expanded,
    required this.onToggle,
    this.photoUrl,
  });
  final _BlocSS      bloc;
  final String?      photoUrl;
  final bool         expanded;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final nbCellules = bloc.cellules.length;
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 4, 14, 0),
      decoration: BoxDecoration(
        color: AppColors.card, borderRadius: BorderRadius.circular(13),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(children: [
        InkWell(
          onTap: nbCellules > 0 ? onToggle : null,
          borderRadius: BorderRadius.circular(13),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 12, 14),
            child: Row(children: [
              CircleAvatar(
                radius: 21,
                backgroundImage:
                    photoUrl != null ? NetworkImage(photoUrl!) : null,
                backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                child: photoUrl == null
                    ? const Icon(Icons.location_on_outlined,
                        color: AppColors.primary, size: 20)
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(bloc.unite.nom,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w700,
                          color: AppColors.text),
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Text(
                    '${bloc.total} militants · '
                    '$nbCellules cellule${nbCellules > 1 ? 's' : ''}',
                    style: const TextStyle(fontSize: 11, color: AppColors.text2),
                  ),
                ]),
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
          const Divider(
              height: 1, indent: 14, endIndent: 14, color: AppColors.border),
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
      couleur = AppColors.secondary; label = '⚠ Pleine';
    } else if (count >= AppConstants.seuilActiveCellule) {
      couleur = AppColors.primary; label = 'Active';
    } else {
      couleur = AppColors.accent; label = 'En cours';
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
          child: Text(stat.unite.nom,
              style: const TextStyle(fontSize: 13, color: AppColors.text),
              overflow: TextOverflow.ellipsis),
        ),
        Text('$count',
            style: const TextStyle(
                fontSize: 13, fontWeight: FontWeight.w700,
                color: AppColors.text)),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: couleur.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(label,
              style: TextStyle(
                  fontSize: 9, fontWeight: FontWeight.w700, color: couleur)),
        ),
      ]),
    );
  }
}

class _CarteUniteSimple extends StatelessWidget {
  const _CarteUniteSimple({
    required this.stat,
    required this.couleur,
    required this.icone,
    this.photoUrl,
  });
  final _UniteStat stat;
  final String?    photoUrl;
  final Color      couleur;
  final IconData   icone;

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.fromLTRB(14, 4, 14, 0),
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        decoration: BoxDecoration(
          color: AppColors.card, borderRadius: BorderRadius.circular(13),
          boxShadow: AppColors.cardShadow,
        ),
        child: Row(children: [
          CircleAvatar(
            radius: 20,
            backgroundImage:
                photoUrl != null ? NetworkImage(photoUrl!) : null,
            backgroundColor: couleur.withValues(alpha: 0.12),
            child: photoUrl == null
                ? Icon(icone, color: couleur, size: 20)
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(stat.unite.nom,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w700,
                      color: AppColors.text),
                  overflow: TextOverflow.ellipsis),
              if (stat.unite.code != null)
                Text(stat.unite.code!,
                    style: const TextStyle(fontSize: 10, color: AppColors.text2)),
            ]),
          ),
          Text('${stat.count}',
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w900,
                  color: AppColors.text)),
          const SizedBox(width: 4),
          const Text('membres',
              style: TextStyle(fontSize: 10, color: AppColors.text2)),
        ]),
      );
}

class _BadgeCode extends StatelessWidget {
  const _BadgeCode(this.code);
  final String code;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(code,
            style: const TextStyle(
              fontSize: 9, fontWeight: FontWeight.w800,
              color: AppColors.primary, letterSpacing: 0.3,
            )),
      );
}

// ══════════════════════════════════════════════════════════════════════════════
// VUE ARBRE
// ══════════════════════════════════════════════════════════════════════════════

// ─── Modèle noeud d'arbre ────────────────────────────────────────────────────

class _NoeudArbre {
  final String id;
  final String label;
  final String? sousLabel;
  final IconData icone;
  final Color couleur;
  final int count;
  final List<_NoeudArbre> enfants;

  const _NoeudArbre({
    required this.id,
    required this.label,
    this.sousLabel,
    required this.icone,
    required this.couleur,
    required this.count,
    this.enfants = const [],
  });

  bool get estFeuille => enfants.isEmpty;
}

// ─── Construction de l'arbre depuis les données ───────────────────────────────

_NoeudArbre _buildArbre(_OrganigrammeData data, int countAG) {
  // Cellules
  _NoeudArbre noeudCellule(_UniteStat c) => _NoeudArbre(
    id: c.unite.id, label: c.unite.nom,
    icone: Icons.circle, couleur: AppColors.accent, count: c.count,
  );

  // SS → cellules
  final noeudsSS = data.blocsSSections.map((b) => _NoeudArbre(
    id: b.unite.id, label: b.unite.nom, sousLabel: b.unite.code,
    icone: Icons.location_on_outlined, couleur: AppColors.primary,
    count: b.total,
    enfants: b.cellules.map(noeudCellule).toList(),
  )).toList();

  // Mouvements
  final noeudsMvt = data.mouvements.map((s) => _NoeudArbre(
    id: s.unite.id, label: s.unite.nom,
    icone: Icons.group_outlined, couleur: AppColors.accent, count: s.count,
  )).toList();

  // Secrétariats
  final noeudsSec = data.secretariats.map((s) => _NoeudArbre(
    id: s.unite.id, label: s.unite.nom,
    icone: Icons.folder_outlined,
    couleur: const Color(0xFF1A4A8A), count: s.count,
  )).toList();

  // Groupes enfants de l'AG
  int sumCount(List<_NoeudArbre> l) => l.fold(0, (s, n) => s + n.count);

  final enfantsAG = <_NoeudArbre>[
    if (noeudsSS.isNotEmpty) _NoeudArbre(
      id: '__ss', label: 'Sous-sections',
      sousLabel: '${noeudsSS.length} entité${noeudsSS.length > 1 ? 's' : ''}',
      icone: Icons.location_on_outlined, couleur: AppColors.primary,
      count: sumCount(noeudsSS), enfants: noeudsSS,
    ),
    if (noeudsMvt.isNotEmpty) _NoeudArbre(
      id: '__mvt', label: 'Mouvements',
      sousLabel: '${noeudsMvt.length} entité${noeudsMvt.length > 1 ? 's' : ''}',
      icone: Icons.group_outlined, couleur: AppColors.accent,
      count: sumCount(noeudsMvt), enfants: noeudsMvt,
    ),
    if (noeudsSec.isNotEmpty) _NoeudArbre(
      id: '__sec', label: 'Secrétariats',
      sousLabel: '${noeudsSec.length} entité${noeudsSec.length > 1 ? 's' : ''}',
      icone: Icons.folder_outlined, couleur: const Color(0xFF1A4A8A),
      count: sumCount(noeudsSec), enfants: noeudsSec,
    ),
  ];

  final ag = _NoeudArbre(
    id: '__ag', label: 'Assemblée Générale', sousLabel: 'Coordinateurs · Resp. · Délégués',
    icone: Icons.groups_rounded, couleur: AppColors.secondary,
    count: countAG,
    enfants: enfantsAG,
  );

  final bexId = data.bex.id.isNotEmpty ? data.bex.id : '__bex';
  return _NoeudArbre(
    id: bexId, label: data.bex.nom,
    sousLabel: '${data.totalActifs} actifs',
    icone: Icons.account_balance_rounded, couleur: AppColors.primary,
    count: data.totalActifs, enfants: [ag],
  );
}

// ─── Vue arbre (scrollable) ───────────────────────────────────────────────────

class _VueArbre extends StatelessWidget {
  const _VueArbre({
    required this.racine,
    required this.collapsed,
    required this.onToggle,
  });
  final _NoeudArbre       racine;
  final Set<String>       collapsed;
  final void Function(String) onToggle;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(8, 4, 8, 24),
        child: _ArbreNoeud(
          noeud:         racine,
          profondeur:    0,
          ancestorLines: const [],
          estDernier:    true,
          collapsed:     collapsed,
          onToggle:      onToggle,
        ),
      );
}

// ─── Noeud récursif ───────────────────────────────────────────────────────────

class _ArbreNoeud extends StatelessWidget {
  const _ArbreNoeud({
    required this.noeud,
    required this.profondeur,
    required this.ancestorLines,
    required this.estDernier,
    required this.collapsed,
    required this.onToggle,
  });
  final _NoeudArbre       noeud;
  final int               profondeur;
  final List<bool>        ancestorLines; // true = montrer la ligne verticale à cet ancêtre
  final bool              estDernier;
  final Set<String>       collapsed;
  final void Function(String) onToggle;

  static const double _rowH  = 54.0;
  static const double _pipeW = 18.0;

  bool _isExpanded() => !collapsed.contains(noeud.id);

  @override
  Widget build(BuildContext context) {
    final expanded    = _isExpanded();
    final hasChildren = noeud.enfants.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Ligne du noeud ──
        SizedBox(
          height: _rowH,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Pipes des ancêtres
              ...List.generate(profondeur, (i) => SizedBox(
                width: _pipeW,
                child: CustomPaint(
                  painter: _PipePainter(
                    show: i < ancestorLines.length && ancestorLines[i],
                  ),
                ),
              )),
              // Connecteur ├── ou └──
              if (profondeur > 0)
                SizedBox(
                  width: _pipeW,
                  child: CustomPaint(
                    painter: _ConnectorPainter(isLast: estDernier),
                  ),
                ),
              // Carte du noeud
              Expanded(
                child: _CarteArbre(
                  noeud:       noeud,
                  isExpanded:  expanded,
                  estRacine:   profondeur == 0,
                  onToggle:    hasChildren ? () => onToggle(noeud.id) : null,
                ),
              ),
            ],
          ),
        ),

        // ── Enfants ──
        if (expanded && hasChildren)
          ...noeud.enfants.asMap().entries.map((e) {
            final isLast = e.key == noeud.enfants.length - 1;
            return _ArbreNoeud(
              noeud:         e.value,
              profondeur:    profondeur + 1,
              ancestorLines: [...ancestorLines, !estDernier],
              estDernier:    isLast,
              collapsed:     collapsed,
              onToggle:      onToggle,
            );
          }),
      ],
    );
  }
}

// ─── Carte d'un noeud dans l'arbre ───────────────────────────────────────────

class _CarteArbre extends StatelessWidget {
  const _CarteArbre({
    required this.noeud,
    required this.isExpanded,
    required this.estRacine,
    this.onToggle,
  });
  final _NoeudArbre   noeud;
  final bool          isExpanded;
  final bool          estRacine;
  final VoidCallback? onToggle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
        decoration: BoxDecoration(
          gradient:     estRacine ? AppColors.kpiVertGradient : null,
          color:        estRacine ? null : AppColors.card,
          borderRadius: BorderRadius.circular(10),
          boxShadow:    AppColors.cardShadow,
          border: estRacine
              ? null
              : Border.all(color: noeud.couleur.withValues(alpha: 0.18)),
        ),
        child: Row(children: [
          // Icône
          Container(
            width: 28, height: 28,
            decoration: BoxDecoration(
              color: estRacine
                  ? Colors.white.withValues(alpha: 0.2)
                  : noeud.couleur.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(noeud.icone,
                color: estRacine ? Colors.white : noeud.couleur, size: 14),
          ),
          const SizedBox(width: 8),
          // Texte
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment:  MainAxisAlignment.center,
              children: [
                Text(noeud.label,
                    style: TextStyle(
                      fontSize: 11, fontWeight: FontWeight.w700,
                      color: estRacine ? Colors.white : AppColors.text,
                    ),
                    overflow: TextOverflow.ellipsis, maxLines: 1),
                if (noeud.sousLabel != null)
                  Text(noeud.sousLabel!,
                      style: TextStyle(
                        fontSize: 9,
                        color: estRacine
                            ? Colors.white.withValues(alpha: 0.75)
                            : AppColors.text2,
                      ),
                      overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          // Badge count
          if (noeud.count > 0) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              decoration: BoxDecoration(
                color: estRacine
                    ? Colors.white.withValues(alpha: 0.2)
                    : noeud.couleur.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text('${noeud.count}',
                  style: TextStyle(
                    fontSize: 9, fontWeight: FontWeight.w700,
                    color: estRacine ? Colors.white : noeud.couleur,
                  )),
            ),
            const SizedBox(width: 4),
          ],
          // Flèche expand/collapse
          if (onToggle != null)
            Icon(
              isExpanded
                  ? Icons.keyboard_arrow_up_rounded
                  : Icons.keyboard_arrow_down_rounded,
              size: 14,
              color: estRacine
                  ? Colors.white.withValues(alpha: 0.7)
                  : AppColors.text2,
            ),
        ]),
      ),
    );
  }
}

// ─── CustomPainters pour les connecteurs ─────────────────────────────────────

/// Ligne verticale continue (│) pour les ancêtres qui ont encore des descendants.
class _PipePainter extends CustomPainter {
  const _PipePainter({required this.show});
  final bool show;

  @override
  void paint(Canvas canvas, Size size) {
    if (!show) return;
    canvas.drawLine(
      Offset(size.width / 2, 0),
      Offset(size.width / 2, size.height),
      Paint()
        ..color       = AppColors.border
        ..strokeWidth = 1.5,
    );
  }

  @override
  bool shouldRepaint(_PipePainter old) => old.show != show;
}

/// Connecteur ├── (non dernier) ou └── (dernier).
class _ConnectorPainter extends CustomPainter {
  const _ConnectorPainter({required this.isLast});
  final bool isLast;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color       = AppColors.border
      ..strokeWidth = 1.5;
    final cx = size.width / 2;
    final cy = size.height / 2;

    // Segment vertical haut (toujours)
    canvas.drawLine(Offset(cx, 0), Offset(cx, cy), paint);
    // Segment vertical bas (seulement si pas dernier)
    if (!isLast) canvas.drawLine(Offset(cx, cy), Offset(cx, size.height), paint);
    // Segment horizontal
    canvas.drawLine(Offset(cx, cy), Offset(size.width, cy), paint);
  }

  @override
  bool shouldRepaint(_ConnectorPainter old) => old.isLast != isLast;
}