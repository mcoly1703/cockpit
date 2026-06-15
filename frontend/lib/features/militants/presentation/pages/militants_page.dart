import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/download_csv.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_tables.dart';
import '../../../../core/utils/csv_helper.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/entities/militant.dart';
import '../../domain/entities/unite_organisationnelle.dart';
import '../../domain/usecases/creer_cellule.dart';
import '../providers/militants_provider.dart';
import 'militant_form_page.dart';

class MilitantsPage extends ConsumerWidget {
  const MilitantsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(militantsProvider);

    return state.when(
      initial:    () => const SizedBox.shrink(),
      chargement: () => const Center(child: CircularProgressIndicator()),
      erreur: (f) => _ErreurVue(
        message: f.when(
          serveur:     (m) => m,
          reseau:      () => 'Pas de connexion réseau',
          nonAutorise: () => 'Accès non autorisé',
          nonTrouve:   () => 'Données introuvables',
          validation:  (m) => m,
        ),
        onRetry: () => ref.read(militantsProvider.notifier).charger(),
      ),
      charge: (militants, unites, recherche, filtreStatut) => _PageContenu(
        state:        state,
        militants:    militants,
        unites:       unites,
        recherche:    recherche,
        filtreStatut: filtreStatut,
      ),
    );
  }
}

// ─── Contenu principal ────────────────────────────────────────────────────────

class _PageContenu extends ConsumerStatefulWidget {
  const _PageContenu({
    required this.state,
    required this.militants,
    required this.unites,
    required this.recherche,
    required this.filtreStatut,
  });

  final MilitantsState state;
  final List<Militant> militants;
  final List<UniteOrganisationnelle> unites;
  final String recherche;
  final String? filtreStatut;

  @override
  ConsumerState<_PageContenu> createState() => _PageContenuState();
}

class _PageContenuState extends ConsumerState<_PageContenu> {
  String? _filtreUniteType = AppUniteTypes.sousSection;
  String? _filtreSSId;       // unité niveau 2 sélectionnée
  String? _filtreCelluleId;  // cellule niveau 3 (seulement sous une SS)

  bool get _afficherListe =>
      widget.recherche.trim().length >= 2 ||
      widget.filtreStatut != null ||
      _filtreSSId != null;

  List<Militant> _appliquerFiltreUnite(List<Militant> liste) {
    if (_filtreSSId == null) return liste;
    if (_filtreCelluleId != null) {
      return liste.where((m) => m.uniteId == _filtreCelluleId).toList();
    }
    if (_filtreUniteType == AppUniteTypes.sousSection) {
      final ids = {
        _filtreSSId!,
        ...widget.unites
            .where((u) => u.type == AppUniteTypes.cellule && u.parentId == _filtreSSId)
            .map((u) => u.id),
      };
      return liste.where((m) => ids.contains(m.uniteId)).toList();
    }
    return liste.where((m) => m.uniteId == _filtreSSId).toList();
  }

  void _snack(BuildContext ctx, String msg, {bool isError = false}) {
    ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: isError ? AppColors.secondary : AppColors.primary,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final state    = widget.state;
    final notifier = ref.read(militantsProvider.notifier);
    final filtres  = state.militantsFiltres;

    final filtresAvecUnite = _appliquerFiltreUnite(filtres);
    final affichage = filtresAvecUnite.take(100).toList();

    final statsFiltered = switch (_filtreUniteType) {
      AppUniteTypes.sousSection => state.statsParSousSection,
      AppUniteTypes.mouvement   => state.statsParMouvement,
      AppUniteTypes.cellule     => state.statsParCellule,
      AppUniteTypes.secretariat => state.statsParSecretariat,
      _                         => <(String, int, int, int, String?)>[],
    };

    final totalFiltre = state.countActifsForFilter(_filtreUniteType);

    final labelJauge = switch (_filtreUniteType) {
      AppUniteTypes.mouvement   => 'OBJECTIF — MOUVEMENTS',
      AppUniteTypes.cellule     => 'OBJECTIF — CELLULES',
      AppUniteTypes.sousSection => 'OBJECTIF — SOUS-SECTIONS',
      AppUniteTypes.secretariat => 'OBJECTIF — SECRÉTARIATS',
      _                         => 'OBJECTIF NATIONAL',
    };

    final titreStats = switch (_filtreUniteType) {
      AppUniteTypes.sousSection => 'PAR SOUS-SECTION',
      AppUniteTypes.mouvement   => 'PAR MOUVEMENT',
      AppUniteTypes.cellule     => 'PAR CELLULE',
      AppUniteTypes.secretariat => 'PAR SECRÉTARIAT',
      _                         => '',
    };

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Titre de page
          SliverToBoxAdapter(
            child: _TitrePage(
              total:      state.totalActifs,
              nbCellules: state.nbCellulesActives,
            ),
          ),

          // Jauge objectif (filtrée)
          SliverToBoxAdapter(
            child: _JaugeObjectif(
              total:    totalFiltre,
              objectif: AppConstants.objectifMilitants,
              label:    labelJauge,
            ),
          ),

          // KPIs
          SliverToBoxAdapter(
            child: _KpiSection(
              total:              state.totalActifs,
              variationTrimestre: state.variationCeTrimestre,
              pctHommes:          state.pourcentageHommes,
              pctFemmes:          state.pourcentageFemmes,
            ),
          ),

          // Tendance 6 mois
          SliverToBoxAdapter(
            child: _TendanceChart(evolution: state.evolutionNouveaux),
          ),

          // Actions
          SliverToBoxAdapter(
            child: _BarreActions(militants: widget.militants, unites: widget.unites),
          ),

          // Sélecteur unité 3 niveaux
          SliverToBoxAdapter(
            child: _FiltreUniteSelector(
              filtreType:      _filtreUniteType,
              filtreSSId:      _filtreSSId,
              filtreCelluleId: _filtreCelluleId,
              unites:          widget.unites,
              onTypeChanged: (t) => setState(() {
                _filtreUniteType = t;
                _filtreSSId      = null;
                _filtreCelluleId = null;
              }),
              onSSChanged: (id) => setState(() {
                _filtreSSId      = id;
                _filtreCelluleId = null;
              }),
              onCelluleChanged: (id) => setState(() => _filtreCelluleId = id),
            ),
          ),

          // Stats (filtrées) — visible quand un type est sélectionné
          if (_filtreUniteType != null)
            SliverToBoxAdapter(
              child: _StatsSousSections(
                stats:           statsFiltered,
                titre:           titreStats,
                showStatutBadge: _filtreUniteType == AppUniteTypes.cellule,
              ),
            ),

          // Titre liste
          SliverToBoxAdapter(
            child: _TitreSection(
              titre:  'LISTE DES MILITANTS',
              suffix: _afficherListe
                  ? '${affichage.length}'
                    '${filtresAvecUnite.length > 100 ? "/${filtresAvecUnite.length}" : ""}'
                    ' résultat${affichage.length > 1 ? "s" : ""}'
                  : null,
            ),
          ),

          // Barre de recherche
          SliverToBoxAdapter(
            child: _SearchBar(
              valeur:    widget.recherche,
              onChanged: notifier.modifierRecherche,
            ),
          ),

          // Chips filtre statut
          SliverToBoxAdapter(
            child: _FiltreChips(
              filtreActif: widget.filtreStatut,
              onChanged:   notifier.modifierFiltreStatut,
            ),
          ),

          // Liste conditionnelle
          if (!_afficherListe)
            const SliverToBoxAdapter(child: _PrompteRecherche())
          else if (affichage.isEmpty)
            SliverFillRemaining(
              child: _EtatVide(
                recherche:    widget.recherche,
                filtreStatut: widget.filtreStatut,
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(14, 4, 14, 4),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, i) => _MilitantCard(
                    militant: affichage[i],
                    unites:   widget.unites,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => MilitantFormPage(
                          militant: affichage[i],
                          unites:   widget.unites,
                        ),
                      ),
                    ),
                    onToggleStatut: (s) async {
                      final res = await notifier.toggleStatut(affichage[i].id, s);
                      if (!context.mounted) return;
                      res.fold(
                        (f) => _snack(context, 'Erreur', isError: true),
                        (_) => _snack(context, 'Statut mis à jour'),
                      );
                    },
                  ),
                  childCount: affichage.length,
                ),
              ),
            ),

          // Note si tronqué à 100
          if (_afficherListe && filtresAvecUnite.length > 100)
            SliverToBoxAdapter(
              child: _NoteTronquee(total: filtresAvecUnite.length),
            ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
      floatingActionButton: null,
    );
  }
}

// ─── Barre d'actions ─────────────────────────────────────────────────────────

class _BarreActions extends ConsumerWidget {
  const _BarreActions({required this.militants, required this.unites});
  final List<Militant> militants;
  final List<UniteOrganisationnelle> unites;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final utilisateur = ref.watch(authProvider).whenOrNull(connecte: (u) => u);
    final role        = utilisateur?.role;

    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 4),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  icon:  const Icon(Icons.person_add, size: 18),
                  label: const Text('Ajouter un militant'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    textStyle: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w700),
                  ),
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                          MilitantFormPage(militant: null, unites: unites),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  icon:  const Icon(Icons.upload_file, size: 18),
                  label: const Text('Import'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    textStyle: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w700),
                  ),
                  onPressed: () => _importer(context, ref),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  icon:  const Icon(Icons.download, size: 18),
                  label: const Text('Télécharger'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    textStyle: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w700),
                  ),
                  onPressed: () => _exporter(context),
                ),
              ),
            ],
          ),
          if (_peutCreerCellule(role)) ...[
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.add_location_alt_outlined, size: 16),
                label: const Text('Nouvelle cellule'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  padding: const EdgeInsets.symmetric(vertical: 11),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  textStyle: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w700),
                ),
                onPressed: () => _dialogCreerCellule(
                  context,
                  ref,
                  role!,
                  utilisateur?.uniteOrganisationnelleId,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _exporter(BuildContext context) async {
    final csv      = formaterCsvMilitants(militants, unites);
    final filename = 'militants_${DateFormat('yyyyMMdd').format(DateTime.now())}.csv';
    await telechargerCsv(csv, filename);
  }

  bool _peutCreerCellule(String? role) =>
      role == AppRoles.bureauExecutif ||
      role == AppRoles.coordinateur ||
      role == AppRoles.responsableSousSection;

  Future<void> _dialogCreerCellule(
    BuildContext context,
    WidgetRef ref,
    String role,
    String? uniteUtilisateurId,
  ) async {
    final nomCtrl    = TextEditingController();
    String? parentId = role == AppRoles.responsableSousSection
        ? uniteUtilisateurId
        : null;
    final sousSections = unites
        .where((u) => u.type == AppUniteTypes.sousSection)
        .toList()
      ..sort((a, b) => a.nom.compareTo(b.nom));

    final confirme = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) {
          final peutValider = nomCtrl.text.trim().isNotEmpty && parentId != null;
          return AlertDialog(
            title: const Text('Créer une cellule'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: nomCtrl,
                  onChanged: (_) => setS(() {}),
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: 'Nom de la cellule',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                if (role != AppRoles.responsableSousSection) ...[
                  const SizedBox(height: 14),
                  DropdownButtonFormField<String>(
                    value: parentId,
                    hint: const Text('Sous-section parente'),
                    isExpanded: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 8),
                    ),
                    items: sousSections
                        .map((ss) => DropdownMenuItem(
                              value: ss.id,
                              child: Text(ss.nom,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 13)),
                            ))
                        .toList(),
                    onChanged: (v) => setS(() => parentId = v),
                  ),
                ] else ...[
                  const SizedBox(height: 10),
                  Text(
                    'Sous-section : ${unites.where((u) => u.id == uniteUtilisateurId).firstOrNull?.nom ?? '—'}',
                    style: const TextStyle(fontSize: 12, color: AppColors.text2),
                  ),
                ],
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Annuler'),
              ),
              ElevatedButton(
                onPressed: peutValider ? () => Navigator.pop(ctx, true) : null,
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white),
                child: const Text('Créer'),
              ),
            ],
          );
        },
      ),
    );

    if (confirme != true || !context.mounted) return;

    final res = await ref.read(militantsProvider.notifier).creerCellule(
          ParamsCreerCellule(nom: nomCtrl.text.trim(), parentId: parentId!),
        );

    if (!context.mounted) return;
    res.fold(
      (_) => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Erreur : création impossible'),
        backgroundColor: AppColors.secondary,
      )),
      (_) => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Cellule créée avec succès'),
        backgroundColor: AppColors.primary,
      )),
    );
  }

  Future<void> _importer(BuildContext context, WidgetRef ref) async {
    final result = await FilePicker.platform.pickFiles(
      type:          FileType.custom,
      allowedExtensions: ['csv', 'txt'],
      withData:      true,
    );
    if (result == null || result.files.isEmpty) return;

    final bytes = result.files.first.bytes;
    if (bytes == null) return;

    final contenu = utf8.decode(bytes, allowMalformed: true);
    final lignes  = parseCsv(contenu);
    if (lignes.isEmpty) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Fichier vide ou format non reconnu'),
        backgroundColor: AppColors.secondary,
      ));
      return;
    }

    if (!context.mounted) return;
    await _dialogConfirmImport(context, ref, lignes);
  }

  Future<void> _dialogConfirmImport(
    BuildContext context,
    WidgetRef ref,
    List<Map<String, String>> lignes,
  ) async {
    String? uniteSelectee = unites.isNotEmpty ? unites.first.id : null;

    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => AlertDialog(
          title: const Text('Confirmer l\'import'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${lignes.length} lignes détectées dans le fichier.'),
              const SizedBox(height: 12),
              const Text('Unité cible :', style: TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                initialValue: uniteSelectee,
                isExpanded: true,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                items: unites.map((u) => DropdownMenuItem(
                  value: u.id,
                  child: Text(u.nom, overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 13)),
                )).toList(),
                onChanged: (v) => setS(() => uniteSelectee = v),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              onPressed: uniteSelectee == null
                  ? null
                  : () async {
                      Navigator.pop(ctx);
                      final rows = lignes
                          .map((r) => csvRowVersSupabase(r, uniteSelectee!))
                          .whereType<Map<String, dynamic>>()
                          .toList();
                      final res = await ref
                          .read(militantsProvider.notifier)
                          .importerMilitants(rows);
                      if (!context.mounted) return;
                      res.fold(
                        (f) => ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Erreur import'), backgroundColor: AppColors.secondary)),
                        (n) => ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('$n militants importés'), backgroundColor: AppColors.primary)),
                      );
                    },
              child: const Text('Importer', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

}

// ─── Titre de page ────────────────────────────────────────────────────────────

class _TitrePage extends StatelessWidget {
  const _TitrePage({required this.total, required this.nbCellules});
  final int total;
  final int nbCellules;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Militants',
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: AppColors.text,
                  height: 1.1)),
          const SizedBox(height: 2),
          Text(
            '${NumberFormat.compact(locale: 'fr').format(total)} membres'
            '${nbCellules > 0 ? ' · $nbCellules cellule${nbCellules > 1 ? 's' : ''}' : ''}',
            style: const TextStyle(fontSize: 13, color: AppColors.text2),
          ),
        ],
      ),
    );
  }
}

// ─── Jauge objectif ───────────────────────────────────────────────────────────

class _JaugeObjectif extends StatelessWidget {
  const _JaugeObjectif({
    required this.total,
    required this.objectif,
    this.label = 'OBJECTIF',
  });
  final int    total;
  final int    objectif;
  final String label;

  @override
  Widget build(BuildContext context) {
    final pct        = (total / objectif).clamp(0.0, 1.0);
    final pctAffiche = (pct * 100).toStringAsFixed(0);
    final fmtTotal   = NumberFormat.compact(locale: 'fr').format(total);
    final fmtObj     = NumberFormat.compact(locale: 'fr').format(objectif);

    return Container(
      margin: const EdgeInsets.fromLTRB(14, 4, 14, 4),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(13),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Icon(Icons.track_changes_rounded,
                size: 16, color: AppColors.secondary),
            const SizedBox(width: 6),
            Text(label,
                style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.text,
                    letterSpacing: 0.5)),
            const Spacer(),
            Text('$pctAffiche%',
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: AppColors.text)),
          ]),
          const SizedBox(height: 4),
          Text('$fmtTotal / $fmtObj',
              style: const TextStyle(fontSize: 12, color: AppColors.text2)),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Stack(children: [
              Container(height: 10, color: AppColors.border),
              FractionallySizedBox(
                widthFactor: pct,
                child: Container(height: 10, color: AppColors.secondary),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

// ─── KPI cards ────────────────────────────────────────────────────────────────

class _KpiSection extends StatelessWidget {
  const _KpiSection({
    required this.total,
    required this.variationTrimestre,
    required this.pctHommes,
    required this.pctFemmes,
  });
  final int    total;
  final String variationTrimestre;
  final double pctHommes;
  final double pctFemmes;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 4, 14, 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _KpiCard(
              valeur:    NumberFormat.compact(locale: 'fr').format(total),
              label:     'TOTAL',
              sousTitre: variationTrimestre,
              couleur:   AppColors.primary,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _KpiCard(
              valeur:    '${pctHommes.toStringAsFixed(0)}%',
              label:     'HOMMES',
              sousTitre: '${pctFemmes.toStringAsFixed(0)}% Femmes',
              couleur:   AppColors.secondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _KpiCard extends StatelessWidget {
  const _KpiCard({
    required this.valeur,
    required this.label,
    required this.sousTitre,
    required this.couleur,
  });
  final String valeur;
  final String label;
  final String sousTitre;
  final Color  couleur;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:        couleur,
        borderRadius: BorderRadius.circular(13),
        boxShadow:    AppColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(valeur,
              style: const TextStyle(
                  fontSize:   36,
                  fontWeight: FontWeight.w900,
                  color:      Colors.white,
                  height:     1.0)),
          const SizedBox(height: 2),
          Text(label,
              style: const TextStyle(
                  fontSize:    10,
                  fontWeight:  FontWeight.w700,
                  color:       Colors.white70,
                  letterSpacing: 0.8)),
          const SizedBox(height: 8),
          Text(sousTitre,
              style: const TextStyle(fontSize: 12, color: Colors.white70)),
        ],
      ),
    );
  }
}

// ─── Tendance 6 mois ──────────────────────────────────────────────────────────

class _TendanceChart extends StatelessWidget {
  const _TendanceChart({required this.evolution});
  final List<(DateTime, int)> evolution;

  static double _interval(double max) {
    if (max <= 0)    return 1;
    if (max <= 10)   return 2;
    if (max <= 50)   return 10;
    if (max <= 200)  return 50;
    if (max <= 1000) return 200;
    if (max <= 5000) return 500;
    return 1000;
  }

  @override
  Widget build(BuildContext context) {
    if (evolution.isEmpty) return const SizedBox.shrink();

    final maxY    = evolution.map((e) => e.$2).fold(0, (a, b) => a > b ? a : b);
    final allZero = maxY == 0;
    final labels  = evolution.map((e) => DateFormat('MMM', 'fr').format(e.$1)).toList();

    return Container(
      margin: const EdgeInsets.fromLTRB(14, 4, 14, 4),
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 8),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(13),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('NOUVEAUX MILITANTS — 12 MOIS',
              style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: AppColors.text2,
                  letterSpacing: 0.8)),
          const SizedBox(height: 12),
          if (allZero)
            SizedBox(
              height: 60,
              child: Center(
                child: Text(
                  'Aucun nouveau militant sur cette période',
                  style: TextStyle(fontSize: 12, color: AppColors.text2),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          else
            SizedBox(
              height: 160,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show:             true,
                    drawVerticalLine: false,
                    horizontalInterval: _interval(maxY * 1.2),
                    getDrawingHorizontalLine: (_) => FlLine(
                      color:       AppColors.border.withValues(alpha: 0.6),
                      strokeWidth: 1,
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles:   AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles:   true,
                        reservedSize: 38,
                        interval:     _interval(maxY * 1.2),
                        getTitlesWidget: (v, _) => Text(
                          NumberFormat.compact(locale: 'fr').format(v),
                          style: TextStyle(fontSize: 9, color: AppColors.text2),
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval:   1,
                        getTitlesWidget: (value, meta) {
                          final idx = value.toInt();
                          if (value != idx.toDouble()) return const SizedBox.shrink();
                          if (idx < 0 || idx >= labels.length) return const SizedBox.shrink();
                          return Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(labels[idx],
                                style: TextStyle(fontSize: 9, color: AppColors.text2)),
                          );
                        },
                      ),
                    ),
                  ),
                  minY: 0,
                  maxY: maxY * 1.2,
                  lineBarsData: [
                    LineChartBarData(
                      spots: evolution
                          .asMap()
                          .entries
                          .map((e) => FlSpot(e.key.toDouble(), e.value.$2.toDouble()))
                          .toList(),
                      isCurved:  true,
                      color:     AppColors.primary,
                      barWidth:  2.5,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (_, __, ___, ____) => FlDotCirclePainter(
                          radius:      3.5,
                          color:       AppColors.primary,
                          strokeWidth: 1.5,
                          strokeColor: Colors.white,
                        ),
                      ),
                      belowBarData: BarAreaData(
                        show:  true,
                        color: AppColors.primary.withValues(alpha: 0.08),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Stats par sous-section ───────────────────────────────────────────────────

class _StatsSousSections extends StatelessWidget {
  const _StatsSousSections({
    required this.stats,
    this.titre = 'PAR SOUS-SECTION',
    this.showStatutBadge = false,
  });
  // (nom, count, objectif, nouveauxCeMois, code)
  final List<(String, int, int, int, String?)> stats;
  final String titre;
  final bool   showStatutBadge;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 4, 14, 4),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(13),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titre,
              style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: AppColors.text2,
                  letterSpacing: 0.8)),
          const SizedBox(height: 12),
          if (stats.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: Text(
                  'Aucune donnée pour ce filtre',
                  style: TextStyle(fontSize: 13, color: AppColors.text2),
                ),
              ),
            )
          else
            ...stats.take(AppConstants.maxLignesStats).toList().asMap().entries.map((e) => _LigneSS(
                  nom:              e.value.$1,
                  count:            e.value.$2,
                  objectif:         e.value.$3,
                  nouveaux:         e.value.$4,
                  code:             e.value.$5,
                  index:            e.key,
                  showStatutBadge:  showStatutBadge,
                )),
        ],
      ),
    );
  }
}

class _LigneSS extends StatelessWidget {
  const _LigneSS({
    required this.nom,
    required this.count,
    required this.objectif,
    required this.nouveaux,
    required this.code,
    required this.index,
    this.showStatutBadge = false,
  });
  final String  nom;
  final int     count;
  final int     objectif;
  final int     nouveaux;
  final String? code;
  final int     index;
  final bool    showStatutBadge;

  static const _palette = [
    AppColors.secondary,
    AppColors.accent,
    Color(0xFF1A4A8A),
    AppColors.primary,
    Color(0xFF5B2D8B),
    Color(0xFF0D7377),
  ];

  @override
  Widget build(BuildContext context) {
    final couleur  = _palette[index % _palette.length];
    final pctObj   = objectif > 0 ? (count / objectif).clamp(0.0, 1.0) : 0.0;
    final pctAff   = (pctObj * 100).round();
    final badge    = code != null ? _badgeFromCode(code!) : _abrev(nom);
    final fmtCount = NumberFormat.compact(locale: 'fr').format(count);
    final fmtObj   = NumberFormat.compact(locale: 'fr').format(objectif);
    final pctNew   = count > 0 && nouveaux > 0
        ? '+${(nouveaux * 100 / count).round()}%'
        : null;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Badge cercle plein
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: couleur,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                badge,
                style: TextStyle(
                    color:      Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize:   badge.length > 3 ? 9 : 13),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Nom + sous-titre + barre
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(nom,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.text),
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Text(
                  '$fmtCount / $fmtObj · $pctAff%',
                  style: TextStyle(fontSize: 10, color: AppColors.text2),
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: Stack(children: [
                    Container(height: 6, color: AppColors.border),
                    FractionallySizedBox(
                      widthFactor: pctObj,
                      child: Container(height: 6, color: couleur),
                    ),
                  ]),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Count + variation % + badge statut cellule
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$count',
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: AppColors.text),
              ),
              if (pctNew != null)
                Text(
                  pctNew,
                  style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary),
                ),
              if (showStatutBadge) ...[
                const SizedBox(height: 4),
                _BadgeStatutCellule(count),
              ],
            ],
          ),
        ],
      ),
    );
  }

  // 'SS-093' → '93', 'MVT-JPS' → 'JPS', null → initiales du nom
  static String _badgeFromCode(String code) {
    final suffix = code.split('-').last;
    final n = int.tryParse(suffix);
    if (n != null) return n.toString();
    return suffix.length > 3 ? suffix.substring(0, 3) : suffix;
  }

  static String _abrev(String s) {
    final words = s.trim().split(RegExp(r'\s+'));
    if (words.length == 1) return s.substring(0, s.length.clamp(0, 4)).toUpperCase();
    return words.take(3).map((w) => w[0].toUpperCase()).join();
  }
}

// ─── Badge statut cellule ─────────────────────────────────────────────────────

class _BadgeStatutCellule extends StatelessWidget {
  const _BadgeStatutCellule(this.count);
  final int count;

  @override
  Widget build(BuildContext context) {
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

    return Container(
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
    );
  }
}

// ─── Titre de section ─────────────────────────────────────────────────────────

class _TitreSection extends StatelessWidget {
  const _TitreSection({required this.titre, this.suffix});
  final String titre;
  final String? suffix;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 2),
      child: Row(
        children: [
          Text(titre,
              style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: AppColors.text2,
                  letterSpacing: 0.8)),
          if (suffix != null) ...[
            const Spacer(),
            Text(suffix!,
                style: TextStyle(fontSize: 11, color: AppColors.text2)),
          ],
        ],
      ),
    );
  }
}

// ─── Search bar ───────────────────────────────────────────────────────────────

class _SearchBar extends StatefulWidget {
  const _SearchBar({required this.valeur, required this.onChanged});
  final String valeur;
  final void Function(String) onChanged;

  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  late final TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.valeur);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 6, 14, 4),
      child: TextField(
        controller: _ctrl,
        onChanged:  widget.onChanged,
        decoration: InputDecoration(
          hintText: 'Rechercher par nom, ville, téléphone…',
          hintStyle: TextStyle(color: AppColors.text2, fontSize: 13),
          prefixIcon: const Icon(Icons.search, color: AppColors.text2, size: 20),
          suffixIcon: _ctrl.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, size: 18),
                  onPressed: () {
                    _ctrl.clear();
                    widget.onChanged('');
                  },
                )
              : null,
          filled: true,
          fillColor: AppColors.card,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: AppColors.border),
          ),
        ),
      ),
    );
  }
}

// ─── Sélecteur unité 3 niveaux ───────────────────────────────────────────────

class _FiltreUniteSelector extends StatelessWidget {
  const _FiltreUniteSelector({
    required this.filtreType,
    required this.filtreSSId,
    required this.filtreCelluleId,
    required this.unites,
    required this.onTypeChanged,
    required this.onSSChanged,
    required this.onCelluleChanged,
  });
  final String?                      filtreType;
  final String?                      filtreSSId;
  final String?                      filtreCelluleId;
  final List<UniteOrganisationnelle> unites;
  final void Function(String?)       onTypeChanged;
  final void Function(String?)       onSSChanged;
  final void Function(String?)       onCelluleChanged;

  static const _types = [
    (null,                      'Tous',          Icons.public),
    (AppUniteTypes.sousSection, 'Sous-sections', Icons.account_tree_outlined),
    (AppUniteTypes.mouvement,   'Mouvements',    Icons.groups_outlined),
    (AppUniteTypes.secretariat, 'Secrétariats',  Icons.corporate_fare_outlined),
    (AppUniteTypes.cellule,     'Cellules',      Icons.location_city_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    final unitesNiveau2 = filtreType == null
        ? <UniteOrganisationnelle>[]
        : (unites.where((u) => u.type == filtreType).toList()
          ..sort((a, b) => a.nom.compareTo(b.nom)));

    // Cellules appartenant à la SS sélectionnée (niveau 3)
    final cellulesDeSS = filtreType == AppUniteTypes.sousSection && filtreSSId != null
        ? (unites
            .where((u) => u.type == AppUniteTypes.cellule && u.parentId == filtreSSId)
            .toList()
          ..sort((a, b) => a.nom.compareTo(b.nom)))
        : <UniteOrganisationnelle>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 4),
          child: Text(
            'FILTRER PAR UNITÉ',
            style: const TextStyle(
                fontSize: 9, fontWeight: FontWeight.w700,
                color: AppColors.text2, letterSpacing: 0.8),
          ),
        ),

        // Niveau 1 — type (Wrap pour s'adapter à la largeur)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Wrap(
            spacing: 8,
            runSpacing: 6,
            children: _types.map((t) {
              final (valeur, label, icone) = t;
              final actif = filtreType == valeur;
              return ChoiceChip(
                avatar: Icon(icone, size: 13,
                    color: actif ? Colors.white : AppColors.text2),
                label: Text(label, style: TextStyle(
                    fontSize: 11,
                    color: actif ? Colors.white : AppColors.text2)),
                selected:        actif,
                onSelected:      (_) => onTypeChanged(valeur),
                selectedColor:   AppColors.accent,
                backgroundColor: AppColors.card,
                side: BorderSide(
                    color: actif ? AppColors.accent : AppColors.border),
                padding: const EdgeInsets.symmetric(horizontal: 4),
              );
            }).toList(),
          ),
        ),

        // Niveau 2 — unités du type sélectionné (Wrap responsive)
        if (filtreType != null && unitesNiveau2.isNotEmpty) ...[
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                // Chip "Toutes"
                ChoiceChip(
                  label: Text('Toutes', style: TextStyle(
                      fontSize: 11,
                      color: filtreSSId == null ? Colors.white : AppColors.text2)),
                  selected:        filtreSSId == null,
                  onSelected:      (_) => onSSChanged(null),
                  selectedColor:   AppColors.primary,
                  backgroundColor: AppColors.card,
                  side: BorderSide(
                      color: filtreSSId == null ? AppColors.primary : AppColors.border),
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                ),
                ...unitesNiveau2.map((u) {
                  final actif = filtreSSId == u.id;
                  return ChoiceChip(
                    label: Text(_labelCourt(u), style: TextStyle(
                        fontSize: 11,
                        color: actif ? Colors.white : AppColors.text)),
                    selected:        actif,
                    onSelected:      (_) => onSSChanged(actif ? null : u.id),
                    selectedColor:   AppColors.primary,
                    backgroundColor: AppColors.card,
                    side: BorderSide(
                        color: actif ? AppColors.primary : AppColors.border),
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                  );
                }),
              ],
            ),
          ),
        ],

        // Niveau 3 — cellules de la SS sélectionnée (Wrap responsive)
        if (cellulesDeSS.isNotEmpty) ...[
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 0),
            child: Text(
              'CELLULES',
              style: const TextStyle(
                  fontSize: 9, fontWeight: FontWeight.w700,
                  color: AppColors.text2, letterSpacing: 0.8),
            ),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                ChoiceChip(
                  label: Text('Toutes', style: TextStyle(
                      fontSize: 11,
                      color: filtreCelluleId == null ? Colors.white : AppColors.text2)),
                  selected:        filtreCelluleId == null,
                  onSelected:      (_) => onCelluleChanged(null),
                  selectedColor:   AppColors.primary.withValues(alpha: 0.7),
                  backgroundColor: AppColors.card,
                  side: BorderSide(
                      color: filtreCelluleId == null
                          ? AppColors.primary
                          : AppColors.border),
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                ),
                ...cellulesDeSS.map((c) {
                  final actif = filtreCelluleId == c.id;
                  return ChoiceChip(
                    label: Text(_labelCourt(c), style: TextStyle(
                        fontSize: 11,
                        color: actif ? Colors.white : AppColors.text)),
                    selected:        actif,
                    onSelected:      (_) => onCelluleChanged(actif ? null : c.id),
                    selectedColor:   AppColors.primary,
                    backgroundColor: AppColors.card,
                    side: BorderSide(
                        color: actif ? AppColors.primary : AppColors.border),
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                  );
                }),
              ],
            ),
          ),
        ],

        const SizedBox(height: 8),
      ],
    );
  }

  static String _labelCourt(UniteOrganisationnelle u) {
    if (u.code != null) {
      final suffix = u.code!.split('-').last;
      return suffix;
    }
    final mots = u.nom.trim().split(RegExp(r'\s+'));
    final label = mots.take(2).join(' ');
    return label.length > 14 ? '${label.substring(0, 13)}…' : label;
  }
}

// ─── Prompt recherche (liste masquée par défaut) ──────────────────────────────

class _PrompteRecherche extends StatelessWidget {
  const _PrompteRecherche();

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(14, 16, 14, 8),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(13),
            boxShadow: AppColors.cardShadow,
          ),
          child: Row(children: [
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.manage_search_rounded,
                  color: AppColors.primary, size: 22),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Trouver un militant',
                      style: TextStyle(fontSize: 14,
                          fontWeight: FontWeight.w700, color: AppColors.text)),
                  SizedBox(height: 3),
                  Text(
                    'Recherchez par nom, ville ou téléphone, '
                    'ou sélectionnez une unité ci-dessus',
                    style: TextStyle(fontSize: 12, color: AppColors.text2),
                  ),
                ],
              ),
            ),
          ]),
        ),
      );
}

// ─── Note résultats tronqués ──────────────────────────────────────────────────

class _NoteTronquee extends StatelessWidget {
  const _NoteTronquee({required this.total});
  final int total;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(14, 0, 14, 8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.accent.withValues(alpha: 0.07),
            borderRadius: BorderRadius.circular(8),
            border: const Border(
                left: BorderSide(color: AppColors.accent, width: 3)),
          ),
          child: Row(children: [
            const Icon(Icons.info_outline_rounded,
                size: 14, color: AppColors.accent),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '100 premiers résultats sur $total — affinez la recherche ou le filtre',
                style: const TextStyle(fontSize: 11, color: AppColors.accent),
              ),
            ),
          ]),
        ),
      );
}

// ─── Chips de filtre statut ───────────────────────────────────────────────────

class _FiltreChips extends StatelessWidget {
  const _FiltreChips({required this.filtreActif, required this.onChanged});
  final String? filtreActif;
  final void Function(String?) onChanged;

  static const _filtres = [
    (null, 'Tous'),
    (AppEnums.militantActif, 'Actif'),
    (AppEnums.militantInactif, 'Inactif'),
    (AppEnums.militantSuspendu, 'Suspendu'),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        itemCount: _filtres.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final (valeur, label) = _filtres[i];
          final actif = filtreActif == valeur;
          return ChoiceChip(
            label: Text(label,
                style: TextStyle(
                    fontSize: 12,
                    color: actif ? Colors.white : AppColors.text2)),
            selected:         actif,
            onSelected:       (_) => onChanged(valeur),
            selectedColor:    AppColors.primary,
            backgroundColor:  AppColors.card,
            side: BorderSide(
                color: actif ? AppColors.primary : AppColors.border),
            padding: const EdgeInsets.symmetric(horizontal: 8),
          );
        },
      ),
    );
  }
}

// ─── Carte militant ───────────────────────────────────────────────────────────

class _MilitantCard extends StatelessWidget {
  const _MilitantCard({
    required this.militant,
    required this.unites,
    required this.onTap,
    required this.onToggleStatut,
  });

  final Militant militant;
  final List<UniteOrganisationnelle> unites;
  final VoidCallback onTap;
  final void Function(String) onToggleStatut;

  Color get _couleurStatut {
    switch (militant.statut) {
      case AppEnums.militantActif:    return AppColors.primary;
      case AppEnums.militantSuspendu: return AppColors.secondary;
      default:                         return AppColors.text2;
    }
  }

  String get _labelStatut {
    switch (militant.statut) {
      case AppEnums.militantActif:    return 'Actif';
      case AppEnums.militantInactif:  return 'Inactif';
      case AppEnums.militantSuspendu: return 'Suspendu';
      default:                         return militant.statut;
    }
  }

  String get _nomUnite {
    try { return unites.firstWhere((u) => u.id == militant.uniteId).nom; }
    catch (_) { return '—'; }
  }

  String get _initiales =>
      '${militant.nom.isNotEmpty ? militant.nom[0] : '?'}'
      '${militant.prenom.isNotEmpty ? militant.prenom[0] : ''}';

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        boxShadow: AppColors.cardShadow,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor:
                    _couleurStatut.withValues(alpha: 0.15),
                child: Text(
                  _initiales,
                  style: TextStyle(
                      color: _couleurStatut,
                      fontWeight: FontWeight.w800,
                      fontSize: 13),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${militant.nom} ${militant.prenom}',
                            style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: AppColors.text),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: _couleurStatut.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _labelStatut,
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: _couleurStatut),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(_nomUnite,
                        style: TextStyle(
                            fontSize: 12,
                            color: AppColors.text2,
                            fontWeight: FontWeight.w500),
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 2),
                    Text(
                      [
                        if (militant.ville != null) militant.ville!,
                        'depuis ${DateFormat('MMM yyyy', 'fr').format(militant.dateAdhesion)}',
                      ].join(' · '),
                      style: TextStyle(fontSize: 11, color: AppColors.text2),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert,
                    size: 18, color: AppColors.text2),
                onSelected: onToggleStatut,
                itemBuilder: (_) => [
                  if (militant.statut != AppEnums.militantActif)
                    PopupMenuItem(
                      value: AppEnums.militantActif,
                      child: Row(children: [
                        Icon(Icons.check_circle,
                            size: 16, color: AppColors.primary),
                        const SizedBox(width: 8),
                        const Text('Activer'),
                      ]),
                    ),
                  if (militant.statut != AppEnums.militantInactif)
                    PopupMenuItem(
                      value: AppEnums.militantInactif,
                      child: Row(children: [
                        Icon(Icons.pause_circle,
                            size: 16, color: AppColors.text2),
                        const SizedBox(width: 8),
                        const Text('Désactiver'),
                      ]),
                    ),
                  if (militant.statut != AppEnums.militantSuspendu)
                    PopupMenuItem(
                      value: AppEnums.militantSuspendu,
                      child: Row(children: [
                        Icon(Icons.block,
                            size: 16, color: AppColors.secondary),
                        const SizedBox(width: 8),
                        Text('Suspendre',
                            style:
                                TextStyle(color: AppColors.secondary)),
                      ]),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── États vide / erreur ──────────────────────────────────────────────────────

class _EtatVide extends StatelessWidget {
  const _EtatVide({required this.recherche, required this.filtreStatut});
  final String recherche;
  final String? filtreStatut;

  @override
  Widget build(BuildContext context) {
    final msg = recherche.isNotEmpty
        ? 'Aucun militant trouvé pour "$recherche"'
        : filtreStatut != null
            ? 'Aucun militant avec ce statut'
            : 'Aucun militant enregistré';
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.people_outline, size: 48, color: AppColors.border),
          const SizedBox(height: 12),
          Text(msg,
              style: TextStyle(color: AppColors.text2, fontSize: 13),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _ErreurVue extends StatelessWidget {
  const _ErreurVue({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, size: 48, color: AppColors.secondary),
          const SizedBox(height: 12),
          Text(message,
              style: TextStyle(color: AppColors.text2, fontSize: 13),
              textAlign: TextAlign.center),
          const SizedBox(height: 16),
          TextButton(onPressed: onRetry, child: const Text('Réessayer')),
        ],
      ),
    );
  }
}