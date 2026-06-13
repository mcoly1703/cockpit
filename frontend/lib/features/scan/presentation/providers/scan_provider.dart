import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/datasources/scan_datasource.dart';
import '../../data/repositories/scan_repository_impl.dart';
import '../../domain/entities/resultat_scan.dart';
import '../../domain/repositories/scan_repository.dart';
import '../../domain/usecases/enregistrer_presence_scan.dart';
import '../../domain/usecases/scanner_carte.dart';

part 'scan_provider.freezed.dart';

// --- État ---

@freezed
class ScanState with _$ScanState {
  const factory ScanState.attente()                                     = _Attente;
  const factory ScanState.chargement()                                  = _Chargement;
  const factory ScanState.resultat({required ResultatScan resultat})    = _Resultat;
  const factory ScanState.erreur({required String message})             = _Erreur;
}

// --- Providers d'infrastructure ---

final scanDatasourceProvider = Provider(
  (ref) => ScanDatasource(ref.watch(supabaseClientProvider)),
);

final scanRepositoryProvider = Provider<ScanRepository>(
  (ref) => ScanRepositoryImpl(ref.watch(scanDatasourceProvider)),
);

// --- Mode événement ---

class ScanModeEvenement {
  final String evenementId;
  final String evenementTitre;
  int          compteur;
  ScanModeEvenement({
    required this.evenementId,
    required this.evenementTitre,
    this.compteur = 0,
  });
}

// --- Notifier ---

final scanProvider = StateNotifierProvider<ScanNotifier, ScanState>(
  (ref) => ScanNotifier(
    scannerCarte:        ScannerCarte(ref.watch(scanRepositoryProvider)),
    enregistrerPresence: EnregistrerPresenceScan(ref.watch(scanRepositoryProvider)),
  ),
);

class ScanNotifier extends StateNotifier<ScanState> {
  final ScannerCarte          _scannerCarte;
  final EnregistrerPresenceScan _enregistrerPresence;

  bool               _enTraitement = false;
  ScanModeEvenement? modeEvenement;

  ScanNotifier({
    required ScannerCarte          scannerCarte,
    required EnregistrerPresenceScan enregistrerPresence,
  })  : _scannerCarte        = scannerCarte,
        _enregistrerPresence  = enregistrerPresence,
        super(const ScanState.attente());

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

    final result = await _scannerCarte(militantId);
    result.fold(
      (failure) {
        final msg = failure.maybeWhen(
          serveur: (m) => m,
          orElse:  ()  => 'Erreur réseau',
        );
        state = ScanState.erreur(message: msg);
      },
      (resultat) async {
        if (modeEvenement != null) {
          final ok = resultat.maybeWhen(
            valide: (nom, prenom, carte, statut)  => (nom: nom, prenom: prenom),
            retard: (nom, prenom, carte, periode) => (nom: nom, prenom: prenom),
            orElse: ()                            => null,
          );
          if (ok != null) {
            await _enregistrerPresence(ParamsEnregistrerPresenceScan(
              evenementId: modeEvenement!.evenementId,
              militantId:  militantId,
              nom:         ok.nom,
              prenom:      ok.prenom,
            ));
            modeEvenement!.compteur++;
          }
        }
        state = ScanState.resultat(resultat: resultat);
      },
    );

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