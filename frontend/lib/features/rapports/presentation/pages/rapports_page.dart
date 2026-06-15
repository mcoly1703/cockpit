import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../evenements/presentation/providers/evenements_provider.dart';
import '../../../reunions/presentation/providers/reunions_provider.dart';
import '../providers/rapports_provider.dart';

class RapportsPage extends ConsumerStatefulWidget {
  const RapportsPage({super.key});

  @override
  ConsumerState<RapportsPage> createState() => _RapportsPageState();
}

class _RapportsPageState extends ConsumerState<RapportsPage> {
  TypeRapport _type  = TypeRapport.cra;

  int _debutJour   = 1;
  int _debutMois   = DateTime.now().month;
  int _debutAnnee  = DateTime.now().year;
  int _finJour     = DateTime.now().day;
  int _finMois     = DateTime.now().month;
  int _finAnnee    = DateTime.now().year;

  String? _reunionId;
  String? _evenementId;
  String? _reunionTitre;
  String? _evenementTitre;

  static const _moisLabels = [
    '', 'Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin',
    'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre',
  ];

  static int _nbJours(int mois, int annee) =>
      DateTime(annee, mois + 1, 0).day;

  void _setDebutMois(int v) => setState(() {
    _debutMois = v;
    _debutJour = _debutJour.clamp(1, _nbJours(v, _debutAnnee));
  });
  void _setDebutAnnee(int v) => setState(() {
    _debutAnnee = v;
    _debutJour  = _debutJour.clamp(1, _nbJours(_debutMois, v));
  });
  void _setFinMois(int v) => setState(() {
    _finMois = v;
    _finJour = _finJour.clamp(1, _nbJours(v, _finAnnee));
  });
  void _setFinAnnee(int v) => setState(() {
    _finAnnee = v;
    _finJour  = _finJour.clamp(1, _nbJours(_finMois, v));
  });

  @override
  void initState() {
    super.initState();
    // Écouter l'état pour partager le PDF dès qu'il est prêt
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.listenManual(rapportsProvider, (_, next) {
        next.whenOrNull(
          pret: (bytes, nom) async {
            await Printing.sharePdf(bytes: bytes, filename: nom);
            if (mounted) ref.read(rapportsProvider.notifier).reinitialiser();
          },
          erreur: (msg) {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Erreur : $msg'),
              backgroundColor: AppColors.secondary,
            ));
            ref.read(rapportsProvider.notifier).reinitialiser();
          },
        );
      });
    });
  }

  bool get _avecPeriode => _type == TypeRapport.cra ||
      _type == TypeRapport.financier ||
      _type == TypeRapport.cotisations;

  bool get _avecReunion    => _type == TypeRapport.reunion;
  bool get _avecEvenement  => _type == TypeRapport.evenement;

  Future<void> _generer() async {
    final notifier = ref.read(rapportsProvider.notifier);
    final debut = DateTime(_debutAnnee, _debutMois, _debutJour);
    final fin   = DateTime(_finAnnee, _finMois, _finJour, 23, 59, 59);

    switch (_type) {
      case TypeRapport.cra:
        await notifier.genererCra(debut: debut, fin: fin);
      case TypeRapport.financier:
        await notifier.genererFinancier(debut: debut, fin: fin);
      case TypeRapport.cotisations:
        await notifier.genererCotisations(annee: _debutAnnee, mois: _debutMois);
      case TypeRapport.reunion:
        if (_reunionId == null) return _snackErreur('Sélectionnez une réunion');
        await notifier.genererReunion(reunionId: _reunionId!, titre: _reunionTitre ?? '');
      case TypeRapport.evenement:
        if (_evenementId == null) return _snackErreur('Sélectionnez un événement');
        await notifier.genererEvenement(evenementId: _evenementId!, titre: _evenementTitre ?? '');
    }
  }

  void _snackErreur(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: AppColors.secondary,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final etat = ref.watch(rapportsProvider);
    final enCours = etat.maybeWhen(generation: () => true, orElse: () => false);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Titre ─────────────────────────────────────────────────
          const Text('Rapports',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900,
                  color: AppColors.text)),
          const Text('Génération PDF des données de votre unité',
              style: TextStyle(fontSize: 13, color: AppColors.text2)),
          const SizedBox(height: 20),

          // ── Sélection du type ──────────────────────────────────────
          _Carte(
            titre: 'TYPE DE RAPPORT',
            child: Column(children: [
              _TypeBouton(
                icone: Icons.assignment_outlined,
                label: 'CRA',
                sousTitre: 'Compte Rendu d\'Activité mensuel',
                selectionne: _type == TypeRapport.cra,
                onTap: () => setState(() { _type = TypeRapport.cra; }),
              ),
              _TypeBouton(
                icone: Icons.account_balance_wallet_outlined,
                label: 'Financier',
                sousTitre: 'Entrées, dépenses, solde du mois',
                selectionne: _type == TypeRapport.financier,
                onTap: () => setState(() { _type = TypeRapport.financier; }),
              ),
              _TypeBouton(
                icone: Icons.payments_outlined,
                label: 'Cotisations',
                sousTitre: 'Statut des cotisations par militant',
                selectionne: _type == TypeRapport.cotisations,
                onTap: () => setState(() { _type = TypeRapport.cotisations; }),
              ),
              _TypeBouton(
                icone: Icons.groups_outlined,
                label: 'Réunion',
                sousTitre: 'CR d\'une réunion + décisions',
                selectionne: _type == TypeRapport.reunion,
                onTap: () => setState(() { _type = TypeRapport.reunion; }),
              ),
              _TypeBouton(
                icone: Icons.event_outlined,
                label: 'Événement',
                sousTitre: 'Feuille de présences d\'un événement',
                selectionne: _type == TypeRapport.evenement,
                onTap: () => setState(() { _type = TypeRapport.evenement; }),
                derniere: true,
              ),
            ]),
          ),
          const SizedBox(height: 12),

          // ── Paramètres selon le type ───────────────────────────────
          if (_avecPeriode) ...[
            _Carte(
              titre: 'PÉRIODE',
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Du', style: TextStyle(fontSize: 11,
                    color: AppColors.text2, fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                Row(children: [
                  Expanded(
                    flex: 1,
                    child: _DropdownJour(
                      valeur: _debutJour,
                      mois: _debutMois,
                      annee: _debutAnnee,
                      onChanged: (v) => setState(() => _debutJour = v!),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 2,
                    child: _DropdownSimple<int>(
                      label: 'Mois',
                      valeur: _debutMois,
                      items: List.generate(12, (i) => i + 1),
                      labelBuilder: (m) => _moisLabels[m],
                      onChanged: (v) => _setDebutMois(v!),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 2,
                    child: _DropdownSimple<int>(
                      label: 'Année',
                      valeur: _debutAnnee,
                      items: List.generate(5, (i) => DateTime.now().year - i),
                      labelBuilder: (a) => '$a',
                      onChanged: (v) => _setDebutAnnee(v!),
                    ),
                  ),
                ]),
                const SizedBox(height: 12),
                const Text('Au', style: TextStyle(fontSize: 11,
                    color: AppColors.text2, fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                Row(children: [
                  Expanded(
                    flex: 1,
                    child: _DropdownJour(
                      valeur: _finJour,
                      mois: _finMois,
                      annee: _finAnnee,
                      onChanged: (v) => setState(() => _finJour = v!),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 2,
                    child: _DropdownSimple<int>(
                      label: 'Mois',
                      valeur: _finMois,
                      items: List.generate(12, (i) => i + 1),
                      labelBuilder: (m) => _moisLabels[m],
                      onChanged: (v) => _setFinMois(v!),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 2,
                    child: _DropdownSimple<int>(
                      label: 'Année',
                      valeur: _finAnnee,
                      items: List.generate(5, (i) => DateTime.now().year - i),
                      labelBuilder: (a) => '$a',
                      onChanged: (v) => _setFinAnnee(v!),
                    ),
                  ),
                ]),
              ]),
            ),
            const SizedBox(height: 12),
          ],

          if (_avecReunion) ...[
            _Carte(
              titre: 'RÉUNION',
              child: _SelecteurReunion(
                valeur: _reunionId,
                onChanged: (id, titre) => setState(() {
                  _reunionId    = id;
                  _reunionTitre = titre;
                }),
              ),
            ),
            const SizedBox(height: 12),
          ],

          if (_avecEvenement) ...[
            _Carte(
              titre: 'ÉVÉNEMENT',
              child: _SelecteurEvenement(
                valeur: _evenementId,
                onChanged: (id, titre) => setState(() {
                  _evenementId    = id;
                  _evenementTitre = titre;
                }),
              ),
            ),
            const SizedBox(height: 12),
          ],

          // ── Bouton générer ─────────────────────────────────────────
          const SizedBox(height: 8),
          SizedBox(
            height: 52,
            child: ElevatedButton.icon(
              onPressed: enCours ? null : _generer,
              icon: enCours
                  ? const SizedBox(width: 18, height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2,
                          color: Colors.white))
                  : const Icon(Icons.picture_as_pdf_outlined),
              label: Text(enCours ? 'Génération en cours…' : 'Générer le PDF',
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.6),
                disabledForegroundColor: Colors.white70,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Center(child: Text(
            'Le PDF sera ouvert dans le partage système',
            style: TextStyle(fontSize: 11, color: AppColors.text2),
          )),
        ],
      ),
    );
  }
}

// ─── Sélecteur de réunion ────────────────────────────────────────────────────

class _SelecteurReunion extends ConsumerWidget {
  const _SelecteurReunion({required this.valeur, required this.onChanged});
  final String?                       valeur;
  final void Function(String, String) onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(reunionsProvider);

    return state.maybeWhen(
      charge: (_) {
        final reunions = state.toutes;
        if (reunions.isEmpty) {
          return const Text('Aucune réunion disponible',
              style: TextStyle(fontSize: 13, color: AppColors.text2));
        }
        return DropdownButtonFormField<String>(
          // ignore: deprecated_member_use
          value: valeur,
          hint: const Text('Choisir une réunion'),
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            filled: true, fillColor: AppColors.card,
          ),
          items: reunions.map((r) => DropdownMenuItem(
            value: r.id,
            child: Text('${DateFormat('dd/MM/yy', 'fr').format(r.date)} — ${r.titre}',
                overflow: TextOverflow.ellipsis),
          )).toList(),
          onChanged: (id) {
            if (id == null) return;
            final r = reunions.firstWhere((r) => r.id == id);
            onChanged(id, r.titre);
          },
        );
      },
      orElse: () => const Center(child: CircularProgressIndicator()),
    );
  }
}

// ─── Sélecteur d'événement ────────────────────────────────────────────────────

class _SelecteurEvenement extends ConsumerWidget {
  const _SelecteurEvenement({required this.valeur, required this.onChanged});
  final String?                       valeur;
  final void Function(String, String) onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(evenementsProvider);

    return state.maybeWhen(
      charge: (_) {
        final evs = state.tous;
        if (evs.isEmpty) {
          return const Text('Aucun événement disponible',
              style: TextStyle(fontSize: 13, color: AppColors.text2));
        }
        return DropdownButtonFormField<String>(
          // ignore: deprecated_member_use
          value: valeur,
          hint: const Text('Choisir un événement'),
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            filled: true, fillColor: AppColors.card,
          ),
          items: evs.map((e) => DropdownMenuItem<String>(
            value: e.id,
            child: Text('${DateFormat('dd/MM/yy', 'fr').format(e.dateDebut)} — ${e.titre}',
                overflow: TextOverflow.ellipsis),
          )).toList(),
          onChanged: (id) {
            if (id == null) return;
            final e = evs.firstWhere((e) => e.id == id);
            onChanged(id, e.titre);
          },
        );
      },
      orElse: () => const Center(child: CircularProgressIndicator()),
    );
  }
}

// ─── Widgets utilitaires ──────────────────────────────────────────────────────

class _Carte extends StatelessWidget {
  const _Carte({required this.titre, required this.child});
  final String titre;
  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(13),
          boxShadow: AppColors.cardShadow,
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(titre,
              style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700,
                  color: AppColors.text2, letterSpacing: 0.8)),
          const SizedBox(height: 12),
          child,
        ]),
      );
}

class _TypeBouton extends StatelessWidget {
  const _TypeBouton({
    required this.icone,
    required this.label,
    required this.sousTitre,
    required this.selectionne,
    required this.onTap,
    this.derniere = false,
  });
  final IconData icone;
  final String   label;
  final String   sousTitre;
  final bool     selectionne;
  final VoidCallback onTap;
  final bool     derniere;

  @override
  Widget build(BuildContext context) => Column(children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: selectionne ? AppColors.primary.withValues(alpha: 0.08) : null,
              borderRadius: BorderRadius.circular(8),
              border: selectionne
                  ? Border.all(color: AppColors.primary.withValues(alpha: 0.3))
                  : null,
            ),
            child: Row(children: [
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  color: selectionne
                      ? AppColors.primary.withValues(alpha: 0.12)
                      : AppColors.border.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icone,
                    size: 18,
                    color: selectionne ? AppColors.primary : AppColors.text2),
              ),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(label,
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700,
                        color: selectionne ? AppColors.primary : AppColors.text)),
                Text(sousTitre,
                    style: const TextStyle(fontSize: 11, color: AppColors.text2)),
              ])),
              if (selectionne)
                const Icon(Icons.check_circle_rounded,
                    color: AppColors.primary, size: 18),
            ]),
          ),
        ),
        if (!derniere)
          const Divider(height: 1, indent: 60),
      ]);
}

class _DropdownSimple<T> extends StatelessWidget {
  const _DropdownSimple({
    required this.label,
    required this.valeur,
    required this.items,
    required this.labelBuilder,
    required this.onChanged,
  });
  final String   label;
  final T        valeur;
  final List<T>  items;
  final String Function(T) labelBuilder;
  final void Function(T?) onChanged;

  @override
  Widget build(BuildContext context) => DropdownButtonFormField<T>(
        // ignore: deprecated_member_use
        value: valeur,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled: true, fillColor: AppColors.card,
        ),
        items: items
            .map((v) => DropdownMenuItem(value: v, child: Text(labelBuilder(v))))
            .toList(),
        onChanged: onChanged,
      );
}

class _DropdownJour extends StatelessWidget {
  const _DropdownJour({
    required this.valeur,
    required this.mois,
    required this.annee,
    required this.onChanged,
  });
  final int  valeur;
  final int  mois;
  final int  annee;
  final void Function(int?) onChanged;

  @override
  Widget build(BuildContext context) {
    final nbJours = DateTime(annee, mois + 1, 0).day;
    final jours   = List.generate(nbJours, (i) => i + 1);
    return DropdownButtonFormField<int>(
      // ignore: deprecated_member_use
      value: valeur.clamp(1, nbJours),
      decoration: InputDecoration(
        labelText: 'Jour',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true, fillColor: AppColors.card,
      ),
      items: jours.map((j) => DropdownMenuItem(value: j, child: Text('$j'))).toList(),
      onChanged: onChanged,
    );
  }
}