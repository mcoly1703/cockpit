import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/rapports_service.dart';
import '../../data/repositories/rapports_repository_impl.dart';
import '../../domain/repositories/rapports_repository.dart';
import '../../domain/usecases/generer_rapport.dart';

part 'rapports_provider.freezed.dart';

// --- Types de rapports ---

enum TypeRapport { cra, financier, reunion, evenement, cotisations }

extension TypeRapportX on TypeRapport {
  String get label => switch (this) {
    TypeRapport.cra         => 'CRA',
    TypeRapport.financier   => 'Financier',
    TypeRapport.reunion     => 'Réunion',
    TypeRapport.evenement   => 'Événement',
    TypeRapport.cotisations => 'Cotisations',
  };
}

// --- État ---

@freezed
class RapportsState with _$RapportsState {
  const factory RapportsState.initial()    = _Initial;
  const factory RapportsState.generation() = _Generation;
  const factory RapportsState.pret({
    required Uint8List bytes,
    required String    nom,
  }) = _Pret;
  const factory RapportsState.erreur({required String message}) = _Erreur;
}

// --- Providers d'infrastructure ---

final rapportsServiceProvider = Provider(
  (ref) => RapportsService(ref.watch(supabaseClientProvider)),
);

final rapportsRepositoryProvider = Provider<RapportsRepository>(
  (ref) => RapportsRepositoryImpl(ref.watch(rapportsServiceProvider)),
);

// --- Notifier ---

final rapportsProvider = StateNotifierProvider<RapportsNotifier, RapportsState>(
  (ref) => RapportsNotifier(
    genererCra:         GenererRapportCra(ref.watch(rapportsRepositoryProvider)),
    genererFinancier:   GenererRapportFinancier(ref.watch(rapportsRepositoryProvider)),
    genererReunion:     GenererRapportReunion(ref.watch(rapportsRepositoryProvider)),
    genererEvenement:   GenererRapportEvenement(ref.watch(rapportsRepositoryProvider)),
    genererCotisations: GenererRapportCotisations(ref.watch(rapportsRepositoryProvider)),
    ref:                ref,
  ),
);

class RapportsNotifier extends StateNotifier<RapportsState> {
  final GenererRapportCra         _genererCra;
  final GenererRapportFinancier   _genererFinancier;
  final GenererRapportReunion     _genererReunion;
  final GenererRapportEvenement   _genererEvenement;
  final GenererRapportCotisations _genererCotisations;
  final Ref                       _ref;

  RapportsNotifier({
    required GenererRapportCra         genererCra,
    required GenererRapportFinancier   genererFinancier,
    required GenererRapportReunion     genererReunion,
    required GenererRapportEvenement   genererEvenement,
    required GenererRapportCotisations genererCotisations,
    required Ref                       ref,
  })  : _genererCra         = genererCra,
        _genererFinancier   = genererFinancier,
        _genererReunion     = genererReunion,
        _genererEvenement   = genererEvenement,
        _genererCotisations = genererCotisations,
        _ref                = ref,
        super(const RapportsState.initial());

  void reinitialiser() => state = const RapportsState.initial();

  Future<void> genererCra({required DateTime debut, required DateTime fin}) async {
    final uniteId = _uniteId();
    if (uniteId == null) return;
    state = const RapportsState.generation();
    final result = await _genererCra(
      ParamsRapportCra(uniteId: uniteId, debut: debut, fin: fin),
    );
    result.fold(
      (f) => state = RapportsState.erreur(message: f.maybeWhen(serveur: (m) => m, orElse: () => 'Erreur')),
      (r) => state = RapportsState.pret(bytes: r.bytes, nom: r.nom),
    );
  }

  Future<void> genererFinancier({required DateTime debut, required DateTime fin}) async {
    final uniteId = _uniteId();
    if (uniteId == null) return;
    state = const RapportsState.generation();
    final result = await _genererFinancier(
      ParamsRapportFinancier(uniteId: uniteId, debut: debut, fin: fin),
    );
    result.fold(
      (f) => state = RapportsState.erreur(message: f.maybeWhen(serveur: (m) => m, orElse: () => 'Erreur')),
      (r) => state = RapportsState.pret(bytes: r.bytes, nom: r.nom),
    );
  }

  Future<void> genererReunion({required String reunionId, required String titre}) async {
    state = const RapportsState.generation();
    final result = await _genererReunion(
      ParamsRapportReunion(reunionId: reunionId, titre: titre),
    );
    result.fold(
      (f) => state = RapportsState.erreur(message: f.maybeWhen(serveur: (m) => m, orElse: () => 'Erreur')),
      (r) => state = RapportsState.pret(bytes: r.bytes, nom: r.nom),
    );
  }

  Future<void> genererEvenement({required String evenementId, required String titre}) async {
    state = const RapportsState.generation();
    final result = await _genererEvenement(
      ParamsRapportEvenement(evenementId: evenementId, titre: titre),
    );
    result.fold(
      (f) => state = RapportsState.erreur(message: f.maybeWhen(serveur: (m) => m, orElse: () => 'Erreur')),
      (r) => state = RapportsState.pret(bytes: r.bytes, nom: r.nom),
    );
  }

  Future<void> genererCotisations({required int annee, required int mois}) async {
    final uniteId = _uniteId();
    if (uniteId == null) return;
    state = const RapportsState.generation();
    final result = await _genererCotisations(
      ParamsRapportCotisations(uniteId: uniteId, annee: annee, mois: mois),
    );
    result.fold(
      (f) => state = RapportsState.erreur(message: f.maybeWhen(serveur: (m) => m, orElse: () => 'Erreur')),
      (r) => state = RapportsState.pret(bytes: r.bytes, nom: r.nom),
    );
  }

  String? _uniteId() =>
      _ref.read(authProvider).whenOrNull(connecte: (u) => u)?.uniteOrganisationnelleId;
}

// ─── Rapport d'activité (dashboard) ─────────────────────────────────────────

final rapportActiviteProvider =
    StateNotifierProvider<RapportActiviteNotifier, RapportsState>(
  (ref) => RapportActiviteNotifier(
    generer: GenererRapportActivite(ref.watch(rapportsRepositoryProvider)),
  ),
);

class RapportActiviteNotifier extends StateNotifier<RapportsState> {
  final GenererRapportActivite _generer;

  RapportActiviteNotifier({required GenererRapportActivite generer})
      : _generer = generer,
        super(const RapportsState.initial());

  void reinitialiser() => state = const RapportsState.initial();

  Future<void> generer({
    String?  uniteId,
    required DateTime debut,
    required DateTime fin,
    bool inclureMilitants  = true,
    bool inclureProspects  = true,
    bool inclureFinances   = true,
    bool inclureEvenements = true,
    bool inclureReunions   = true,
    bool inclureBureau     = true,
  }) async {
    state = const RapportsState.generation();
    final result = await _generer(ParamsRapportActivite(
      uniteId:          uniteId,
      debut:            debut,
      fin:              fin,
      inclureMilitants:  inclureMilitants,
      inclureProspects:  inclureProspects,
      inclureFinances:   inclureFinances,
      inclureEvenements: inclureEvenements,
      inclureReunions:   inclureReunions,
      inclureBureau:     inclureBureau,
    ));
    result.fold(
      (f) => state = RapportsState.erreur(message: f.maybeWhen(serveur: (m) => m, orElse: () => 'Erreur')),
      (r) => state = RapportsState.pret(bytes: r.bytes, nom: r.nom),
    );
  }
}