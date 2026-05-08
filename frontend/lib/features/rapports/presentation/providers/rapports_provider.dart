import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/rapports_service.dart';

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
  String get nomFichier => switch (this) {
    TypeRapport.cra         => 'cra',
    TypeRapport.financier   => 'financier',
    TypeRapport.reunion     => 'reunion',
    TypeRapport.evenement   => 'evenement',
    TypeRapport.cotisations => 'cotisations',
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

// --- Provider d'infrastructure ---

final rapportsServiceProvider = Provider(
  (ref) => RapportsService(ref.watch(supabaseClientProvider)),
);

// --- Notifier ---

final rapportsProvider = StateNotifierProvider<RapportsNotifier, RapportsState>(
  (ref) => RapportsNotifier(
    service: ref.watch(rapportsServiceProvider),
    ref: ref,
  ),
);

class RapportsNotifier extends StateNotifier<RapportsState> {
  final RapportsService _service;
  final Ref             _ref;

  RapportsNotifier({required RapportsService service, required Ref ref})
      : _service = service,
        _ref = ref,
        super(const RapportsState.initial());

  void reinitialiser() => state = const RapportsState.initial();

  Future<void> genererCra({required DateTime debut, required DateTime fin}) async {
    final uniteId = _uniteId();
    if (uniteId == null) return;

    state = const RapportsState.generation();
    try {
      final bytes = await _service.genererCra(uniteId: uniteId, debut: debut, fin: fin);
      final nom = 'CRA_${DateFormat('yyyy_MM').format(debut)}.pdf';
      state = RapportsState.pret(bytes: bytes, nom: nom);
    } catch (e) {
      state = RapportsState.erreur(message: e.toString());
    }
  }

  Future<void> genererFinancier({required DateTime debut, required DateTime fin}) async {
    final uniteId = _uniteId();
    if (uniteId == null) return;

    state = const RapportsState.generation();
    try {
      final bytes = await _service.genererFinancier(uniteId: uniteId, debut: debut, fin: fin);
      final nom = 'Financier_${DateFormat('yyyy_MM').format(debut)}.pdf';
      state = RapportsState.pret(bytes: bytes, nom: nom);
    } catch (e) {
      state = RapportsState.erreur(message: e.toString());
    }
  }

  Future<void> genererReunion({required String reunionId, required String titre}) async {
    state = const RapportsState.generation();
    try {
      final bytes = await _service.genererReunion(reunionId: reunionId);
      final nom = 'Reunion_${titre.replaceAll(' ', '_').substring(0, titre.length.clamp(0, 20))}.pdf';
      state = RapportsState.pret(bytes: bytes, nom: nom);
    } catch (e) {
      state = RapportsState.erreur(message: e.toString());
    }
  }

  Future<void> genererEvenement({required String evenementId, required String titre}) async {
    state = const RapportsState.generation();
    try {
      final bytes = await _service.genererEvenement(evenementId: evenementId);
      final nom = 'Evenement_${titre.replaceAll(' ', '_').substring(0, titre.length.clamp(0, 20))}.pdf';
      state = RapportsState.pret(bytes: bytes, nom: nom);
    } catch (e) {
      state = RapportsState.erreur(message: e.toString());
    }
  }

  Future<void> genererCotisations({required int annee, required int mois}) async {
    final uniteId = _uniteId();
    if (uniteId == null) return;

    state = const RapportsState.generation();
    try {
      final bytes = await _service.genererCotisations(uniteId: uniteId, annee: annee, mois: mois);
      final nom = 'Cotisations_${annee}_${mois.toString().padLeft(2, '0')}.pdf';
      state = RapportsState.pret(bytes: bytes, nom: nom);
    } catch (e) {
      state = RapportsState.erreur(message: e.toString());
    }
  }

  String? _uniteId() =>
      _ref.read(authProvider).whenOrNull(connecte: (u) => u)?.uniteOrganisationnelleId;
}