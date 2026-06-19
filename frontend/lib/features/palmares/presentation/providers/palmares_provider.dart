import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_tables.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
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

  const PalmaresState({
    this.topMassificateurs = const [],
    this.topCotiseurs = const [],
  });
}

class PalmaresNotifier extends StateNotifier<PalmaresState> {
  final Ref _ref;

  PalmaresNotifier(this._ref) : super(const PalmaresState()) {
    _ref.listen(militantsProvider, (_, __) => _calculer());
    _ref.listen(financesProvider, (_, __) => _calculer());
    _ref.listen<AuthState>(authProvider, (_, next) {
      next.whenOrNull(connecte: (_) => _calculer());
    });
    _calculer();
  }

  void _calculer() {
    final milState = _ref.read(militantsProvider);
    final finState = _ref.read(financesProvider);

    milState.maybeWhen(
      charge: (militants, unites, _, __) {
        final unitesMap = {for (final u in unites) u.id: u.nom};
        final actifs = militants
            .where((m) => m.statut == AppEnums.militantActif)
            .toList();

        // ── Top Massificateurs ──
        final compteur = <String, int>{};
        for (final m in actifs) {
          if (m.parrainId != null) {
            compteur[m.parrainId!] = (compteur[m.parrainId!] ?? 0) + 1;
          }
        }
        final sorted = compteur.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));
        final topMass = sorted.take(20).toList().asMap().entries.map((e) {
          final militant =
              actifs.where((m) => m.id == e.value.key).firstOrNull;
          return ClassementEntry(
            rang: e.key + 1,
            militantId: e.value.key,
            nom: militant?.nom ?? '—',
            prenom: militant?.prenom ?? '',
            uniteNom: militant != null ? unitesMap[militant.uniteId] : null,
            score: e.value.value,
            detailLabel:
                '${e.value.value} filleul${e.value.value > 1 ? 's' : ''}',
          );
        }).toList();

        // ── Top Cotiseurs ──
        final annee = DateTime.now().year;
        final topCot = finState.maybeWhen(
          charge: (_, cotisations) {
            final compteurCot = <String, int>{};
            final montantCot = <String, double>{};
            for (final c in cotisations.where(
                (c) => c.annee == annee && c.statut == AppEnums.cotisationPayee)) {
              compteurCot[c.militantId] =
                  (compteurCot[c.militantId] ?? 0) + 1;
              montantCot[c.militantId] =
                  (montantCot[c.militantId] ?? 0) + c.montantPaye;
            }
            final sortedCot = compteurCot.entries.toList()
              ..sort((a, b) => b.value.compareTo(a.value));
            return sortedCot.take(20).toList().asMap().entries.map((e) {
              final militant =
                  actifs.where((m) => m.id == e.value.key).firstOrNull;
              final montant = montantCot[e.value.key] ?? 0;
              return ClassementEntry(
                rang: e.key + 1,
                militantId: e.value.key,
                nom: militant?.nom ?? '—',
                prenom: militant?.prenom ?? '',
                uniteNom:
                    militant != null ? unitesMap[militant.uniteId] : null,
                score: e.value.value,
                detailLabel:
                    '${e.value.value} mois · ${montant.toStringAsFixed(0)} €',
              );
            }).toList();
          },
          orElse: () => <ClassementEntry>[],
        );

        state = PalmaresState(
          topMassificateurs: topMass,
          topCotiseurs: topCot,
        );
      },
      orElse: () {},
    );
  }
}
