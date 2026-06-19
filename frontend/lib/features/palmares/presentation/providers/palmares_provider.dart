import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_tables.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../militants/domain/entities/militant.dart';
import '../../../militants/domain/entities/unite_organisationnelle.dart';
import '../../../militants/presentation/providers/militants_provider.dart';
import '../../../finances/presentation/providers/finances_provider.dart';
import '../../domain/entities/classement_entry.dart';

final palmaresProvider =
    StateNotifierProvider<PalmaresNotifier, PalmaresState>((ref) {
  return PalmaresNotifier(ref);
});

class PalmaresState {
  final List<ClassementEntry> topMassificateurs;
  final List<ClassementEntry> topCotiseurs;
  final List<ClassementEntry> topDonateurs;
  final List<UniteOrganisationnelle> unites;
  final String? filtreUniteId;

  const PalmaresState({
    this.topMassificateurs = const [],
    this.topCotiseurs = const [],
    this.topDonateurs = const [],
    this.unites = const [],
    this.filtreUniteId,
  });

  PalmaresState copyWith({
    List<ClassementEntry>? topMassificateurs,
    List<ClassementEntry>? topCotiseurs,
    List<ClassementEntry>? topDonateurs,
    List<UniteOrganisationnelle>? unites,
    String? Function()? filtreUniteId,
  }) =>
      PalmaresState(
        topMassificateurs: topMassificateurs ?? this.topMassificateurs,
        topCotiseurs: topCotiseurs ?? this.topCotiseurs,
        topDonateurs: topDonateurs ?? this.topDonateurs,
        unites: unites ?? this.unites,
        filtreUniteId:
            filtreUniteId != null ? filtreUniteId() : this.filtreUniteId,
      );
}

class PalmaresNotifier extends StateNotifier<PalmaresState> {
  final Ref _ref;

  String? _filtreUniteId;

  PalmaresNotifier(this._ref) : super(const PalmaresState()) {
    _ref.listen(militantsProvider, (_, __) => _calculer());
    _ref.listen(financesProvider, (_, __) => _calculer());
    _ref.listen<AuthState>(authProvider, (_, next) {
      next.whenOrNull(connecte: (_) => _calculer());
    });
    _calculer();
  }

  void filtrerParUnite(String? uniteId) {
    _filtreUniteId = uniteId;
    _calculer();
  }

  Set<String> _uniteIdsAccessibles(
      String uniteId, List<UniteOrganisationnelle> unites) {
    final unite = unites.where((u) => u.id == uniteId).firstOrNull;
    if (unite == null) return {uniteId};
    if (unite.type == AppUniteTypes.sousSection) {
      return {
        uniteId,
        ...unites
            .where((u) =>
                u.type == AppUniteTypes.cellule && u.parentId == uniteId)
            .map((u) => u.id),
      };
    }
    return {uniteId};
  }

  void _calculer() {
    final milState = _ref.read(militantsProvider);
    final finState = _ref.read(financesProvider);

    milState.maybeWhen(
      charge: (militants, unites, _, __) {
        final unitesMap = {for (final u in unites) u.id: u.nom};

        final filtreId = _filtreUniteId;
        final idsAccessibles = filtreId != null
            ? _uniteIdsAccessibles(filtreId, unites)
            : null;

        final actifs = militants
            .where((m) => m.statut == AppEnums.militantActif)
            .where((m) =>
                idsAccessibles == null ||
                idsAccessibles.contains(m.uniteId))
            .toList();

        final allActifs = militants
            .where((m) => m.statut == AppEnums.militantActif)
            .toList();

        final topMass = _calcMassificateurs(actifs, allActifs, unitesMap);

        final annee = DateTime.now().year;
        final topCot = finState.maybeWhen(
          charge: (_, cotisations) =>
              _calcCotiseurs(cotisations, actifs, unitesMap, annee),
          orElse: () => <ClassementEntry>[],
        );

        final topDon = finState.maybeWhen(
          charge: (transactions, _) =>
              _calcDonateurs(transactions, actifs, unitesMap),
          orElse: () => <ClassementEntry>[],
        );

        state = PalmaresState(
          topMassificateurs: topMass,
          topCotiseurs: topCot,
          topDonateurs: topDon,
          unites: unites,
          filtreUniteId: _filtreUniteId,
        );
      },
      orElse: () {},
    );
  }

  List<ClassementEntry> _calcMassificateurs(
    List<Militant> actifsFiltres,
    List<Militant> tousActifs,
    Map<String, String> unitesMap,
  ) {
    final idsFiltre = actifsFiltres.map((m) => m.id).toSet();
    final compteur = <String, int>{};
    for (final m in tousActifs) {
      if (m.parrainId != null && idsFiltre.contains(m.parrainId)) {
        compteur[m.parrainId!] = (compteur[m.parrainId!] ?? 0) + 1;
      }
    }
    final sorted = compteur.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sorted.take(20).toList().asMap().entries.map((e) {
      final m = actifsFiltres.where((m) => m.id == e.value.key).firstOrNull;
      return ClassementEntry(
        rang: e.key + 1,
        militantId: e.value.key,
        nom: m?.nom ?? '—',
        prenom: m?.prenom ?? '',
        uniteNom: m != null ? unitesMap[m.uniteId] : null,
        score: e.value.value,
        detailLabel:
            '${e.value.value} filleul${e.value.value > 1 ? 's' : ''}',
      );
    }).toList();
  }

  List<ClassementEntry> _calcCotiseurs(
    List cotisations,
    List<Militant> actifs,
    Map<String, String> unitesMap,
    int annee,
  ) {
    final idsFiltre = actifs.map((m) => m.id).toSet();
    final compteurCot = <String, int>{};
    final montantCot = <String, double>{};
    for (final c in cotisations.where((c) =>
        c.annee == annee &&
        c.statut == AppEnums.cotisationPayee &&
        idsFiltre.contains(c.militantId))) {
      compteurCot[c.militantId] = (compteurCot[c.militantId] ?? 0) + 1;
      montantCot[c.militantId] =
          (montantCot[c.militantId] ?? 0) + c.montantPaye;
    }
    final sorted = compteurCot.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sorted.take(20).toList().asMap().entries.map((e) {
      final m = actifs.where((m) => m.id == e.value.key).firstOrNull;
      final montant = montantCot[e.value.key] ?? 0;
      return ClassementEntry(
        rang: e.key + 1,
        militantId: e.value.key,
        nom: m?.nom ?? '—',
        prenom: m?.prenom ?? '',
        uniteNom: m != null ? unitesMap[m.uniteId] : null,
        score: e.value.value,
        detailLabel: '${e.value.value} mois · ${montant.toStringAsFixed(0)} €',
      );
    }).toList();
  }

  List<ClassementEntry> _calcDonateurs(
    List transactions,
    List<Militant> actifs,
    Map<String, String> unitesMap,
  ) {
    final idsFiltre = actifs.map((m) => m.id).toSet();
    final montantDon = <String, double>{};
    final nbDons = <String, int>{};
    final estExterne = <String, bool>{};
    final nomDonateur = <String, String>{};

    for (final t in transactions.where((t) => t.categorie == AppCategories.don)) {
      String cle;
      if (t.militantId != null && idsFiltre.contains(t.militantId)) {
        cle = t.militantId!;
        estExterne[cle] = false;
      } else if (t.donateurId != null) {
        cle = t.donateurId!;
        estExterne[cle] = true;
        if (t.donateurNom != null) nomDonateur[cle] = t.donateurNom!;
      } else if (t.beneficiaire != null && t.beneficiaire!.trim().isNotEmpty) {
        cle = 'legacy:${t.beneficiaire!.trim().toLowerCase()}';
        estExterne[cle] = true;
        nomDonateur[cle] = t.beneficiaire!.trim();
      } else {
        continue;
      }
      montantDon[cle] = (montantDon[cle] ?? 0) + t.montant;
      nbDons[cle] = (nbDons[cle] ?? 0) + 1;
    }

    final sorted = montantDon.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sorted.take(20).toList().asMap().entries.map((e) {
      final cle = e.value.key;
      final nb = nbDons[cle] ?? 0;
      final externe = estExterne[cle] == true;

      if (externe) {
        final nom = nomDonateur[cle] ?? '—';
        return ClassementEntry(
          rang: e.key + 1,
          militantId: cle,
          nom: nom,
          prenom: '',
          score: e.value.value.round(),
          detailLabel: '${e.value.value.toStringAsFixed(0)} € · $nb don${nb > 1 ? 's' : ''}',
          estExterne: true,
        );
      }

      final m = actifs.where((m) => m.id == cle).firstOrNull;
      return ClassementEntry(
        rang: e.key + 1,
        militantId: cle,
        nom: m?.nom ?? '—',
        prenom: m?.prenom ?? '',
        uniteNom: m != null ? unitesMap[m.uniteId] : null,
        score: e.value.value.round(),
        detailLabel: '${e.value.value.toStringAsFixed(0)} € · $nb don${nb > 1 ? 's' : ''}',
      );
    }).toList();
  }
}
