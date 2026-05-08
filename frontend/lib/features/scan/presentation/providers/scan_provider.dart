import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/datasources/scan_datasource.dart';
import '../../domain/entities/resultat_scan.dart';

part 'scan_provider.freezed.dart';

// --- État ---

@freezed
class ScanState with _$ScanState {
  const factory ScanState.attente()                                     = _Attente;
  const factory ScanState.chargement()                                  = _Chargement;
  const factory ScanState.resultat({required ResultatScan resultat})    = _Resultat;
  const factory ScanState.erreur({required String message})             = _Erreur;
}

// --- Provider d'infrastructure ---

final scanDatasourceProvider = Provider(
  (ref) => ScanDatasource(ref.watch(supabaseClientProvider)),
);

// --- Mode événement ---

class ScanModeEvenement {
  final String  evenementId;
  final String  evenementTitre;
  int           compteur;
  ScanModeEvenement({
    required this.evenementId,
    required this.evenementTitre,
    this.compteur = 0,
  });
}

// --- Notifier ---

final scanProvider = StateNotifierProvider<ScanNotifier, ScanState>(
  (ref) => ScanNotifier(ref.watch(scanDatasourceProvider)),
);

class ScanNotifier extends StateNotifier<ScanState> {
  final ScanDatasource _datasource;

  bool                  _enTraitement = false;
  ScanModeEvenement?    modeEvenement;

  ScanNotifier(this._datasource) : super(const ScanState.attente());

  void activerModeEvenement(String evenementId, String titre) {
    modeEvenement = ScanModeEvenement(evenementId: evenementId, evenementTitre: titre);
  }

  void desactiverModeEvenement() {
    modeEvenement = null;
  }

  Future<void> scanner(String valeurQr) async {
    if (_enTraitement) return;
    _enTraitement = true;

    final militantId = _extraireUuid(valeurQr);
    if (militantId == null) {
      state = const ScanState.resultat(resultat: ResultatScan.inconnu());
      _planifierReset();
      return;
    }

    state = const ScanState.chargement();
    try {
      final resultat = await _datasource.scannerCarte(militantId);

      // En mode événement : enregistre la présence si militant valide ou en retard
      if (modeEvenement != null) {
        final ok = resultat.maybeWhen(
          valide:  (nom, prenom, carte, statut)  => (nom: nom, prenom: prenom),
          retard:  (nom, prenom, carte, periode) => (nom: nom, prenom: prenom),
          orElse:  ()                            => null,
        );
        if (ok != null) {
          await _datasource.enregistrerPresence(
            evenementId: modeEvenement!.evenementId,
            militantId:  militantId,
            nom:         ok.nom,
            prenom:      ok.prenom,
          );
          modeEvenement!.compteur++;
        }
      }

      state = ScanState.resultat(resultat: resultat);
    } on ServerException catch (e) {
      state = ScanState.erreur(message: e.message);
    } catch (_) {
      state = const ScanState.erreur(message: 'Erreur réseau');
    }
    _planifierReset();
  }

  void reinitialiser() {
    _enTraitement = false;
    state = const ScanState.attente();
  }

  void _planifierReset() {
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) reinitialiser();
    });
  }

  static final _uuidRegex = RegExp(
    r'[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}',
    caseSensitive: false,
  );

  static String? _extraireUuid(String valeur) =>
      _uuidRegex.firstMatch(valeur)?.group(0);
}