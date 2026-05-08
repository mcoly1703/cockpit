import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_tables.dart';
import '../../../../core/errors/failures.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/datasources/finances_datasource_impl.dart';
import '../../data/repositories/finances_repository_impl.dart';
import '../../domain/entities/cotisation.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/repositories/finances_repository.dart';
import '../../domain/usecases/ajouter_transaction.dart';
import '../../domain/usecases/enregistrer_cotisation.dart';
import '../../domain/usecases/get_cotisations.dart';
import '../../domain/usecases/get_transactions.dart';

part 'finances_provider.freezed.dart';

// --- État ---

@freezed
class FinancesState with _$FinancesState {
  const FinancesState._();

  const factory FinancesState.initial()                              = _Initial;
  const factory FinancesState.chargement()                          = _Chargement;
  const factory FinancesState.charge({
    required List<Transaction> transactions,
    required List<Cotisation>  cotisations,
  }) = _Charge;
  const factory FinancesState.erreur({required Failure failure})    = _Erreur;

  // ── Agrégats financiers ──────────────────────────────────────────

  double get totalEntrees => maybeWhen(
    charge: (txs, _) => txs
        .where((t) => t.type == AppEnums.transactionEntree)
        .fold(0.0, (s, t) => s + t.montant),
    orElse: () => 0.0,
  );

  double get totalDepenses => maybeWhen(
    charge: (txs, _) => txs
        .where((t) => t.type == AppEnums.transactionDepense)
        .fold(0.0, (s, t) => s + t.montant),
    orElse: () => 0.0,
  );

  double get solde => totalEntrees - totalDepenses;

  // ── Stats cotisations (année courante) ──────────────────────────

  int get cotisationsAJour => maybeWhen(
    charge: (_, cotisations) =>
        cotisations.where((c) => c.statut == AppEnums.cotisationPayee).length,
    orElse: () => 0,
  );

  int get cotisationsEnRetard => maybeWhen(
    charge: (_, cotisations) =>
        cotisations.where((c) => c.statut == AppEnums.cotisationEnRetard).length,
    orElse: () => 0,
  );

  int get cotisationsEnAttente => maybeWhen(
    charge: (_, cotisations) =>
        cotisations.where((c) => c.statut == AppEnums.cotisationEnAttente).length,
    orElse: () => 0,
  );

  int get totalCotisations => maybeWhen(
    charge: (_, cotisations) => cotisations.length,
    orElse: () => 0,
  );

  // ── Taux de recouvrement cotisations (année courante) ────────────

  double get tauxRecouvrement => maybeWhen(
    charge: (_, cotisations) {
      final annee = DateTime.now().year;
      final annuelles = cotisations.where((c) => c.annee == annee).toList();
      if (annuelles.isEmpty) return 0.0;
      final payees = annuelles.where((c) => c.statut == AppEnums.cotisationPayee).length;
      return payees / annuelles.length * 100;
    },
    orElse: () => 0.0,
  );

  // ── Évolution 6 mois (entrées, dépenses) ────────────────────────

  List<(DateTime, double, double)> get evolutionMensuelle => maybeWhen(
    charge: (txs, _) => List.generate(AppConstants.nombreMoisGraphiqueAnnuel, (i) {
      final now  = DateTime.now();
      final mois = DateTime(now.year, now.month - (AppConstants.nombreMoisGraphiqueAnnuel - 1 - i), 1);
      final fin  = DateTime(mois.year, mois.month + 1, 0);
      final duMois = txs.where((t) =>
          !t.dateTransaction.isBefore(mois) && !t.dateTransaction.isAfter(fin));
      final entrees  = duMois.where((t) => t.type == AppEnums.transactionEntree)
          .fold(0.0, (s, t) => s + t.montant);
      final depenses = duMois.where((t) => t.type == AppEnums.transactionDepense)
          .fold(0.0, (s, t) => s + t.montant);
      return (mois, entrees, depenses);
    }),
    orElse: () => [],
  );

  // ── Stats par catégorie ──────────────────────────────────────────

  // (categorie, montant)
  List<(String, double)> get statsParCategorie => maybeWhen(
    charge: (txs, _) {
      final map = <String, double>{};
      for (final t in txs) {
        map[t.categorie] = (map[t.categorie] ?? 0) + t.montant;
      }
      return map.entries
          .map((e) => (e.key, e.value))
          .toList()
        ..sort((a, b) => b.$2.compareTo(a.$2));
    },
    orElse: () => [],
  );

  List<(String, double)> get statsEntrees => maybeWhen(
    charge: (txs, _) {
      final map = <String, double>{};
      for (final t in txs.where((t) => t.type == AppEnums.transactionEntree)) {
        map[t.categorie] = (map[t.categorie] ?? 0) + t.montant;
      }
      return map.entries.map((e) => (e.key, e.value)).toList()
        ..sort((a, b) => b.$2.compareTo(a.$2));
    },
    orElse: () => [],
  );

  List<(String, double)> get statsDepenses => maybeWhen(
    charge: (txs, _) {
      final map = <String, double>{};
      for (final t in txs.where((t) => t.type == AppEnums.transactionDepense)) {
        map[t.categorie] = (map[t.categorie] ?? 0) + t.montant;
      }
      return map.entries.map((e) => (e.key, e.value)).toList()
        ..sort((a, b) => b.$2.compareTo(a.$2));
    },
    orElse: () => [],
  );
}

// --- Providers d'infrastructure ---

final financesDatasourceProvider = Provider(
  (ref) => FinancesDatasourceImpl(ref.watch(supabaseClientProvider)),
);

final financesRepositoryProvider = Provider(
  (ref) => FinancesRepositoryImpl(ref.watch(financesDatasourceProvider)),
);

// --- Notifier ---

final financesProvider =
    StateNotifierProvider<FinancesNotifier, FinancesState>(
  (ref) => FinancesNotifier(
    getTransactions:     GetTransactions(ref.watch(financesRepositoryProvider)),
    getCotisations:      GetCotisations(ref.watch(financesRepositoryProvider)),
    ajouterTransaction:  AjouterTransaction(ref.watch(financesRepositoryProvider)),
    enregistrerCotisation: EnregistrerCotisation(ref.watch(financesRepositoryProvider)),
    ref: ref,
  ),
);

class FinancesNotifier extends StateNotifier<FinancesState> {
  final GetTransactions       _getTransactions;
  final GetCotisations        _getCotisations;
  final AjouterTransaction    _ajouterTransaction;
  final EnregistrerCotisation _enregistrerCotisation;
  final Ref                   _ref;

  FinancesNotifier({
    required GetTransactions       getTransactions,
    required GetCotisations        getCotisations,
    required AjouterTransaction    ajouterTransaction,
    required EnregistrerCotisation enregistrerCotisation,
    required Ref                   ref,
  })  : _getTransactions      = getTransactions,
        _getCotisations       = getCotisations,
        _ajouterTransaction   = ajouterTransaction,
        _enregistrerCotisation = enregistrerCotisation,
        _ref                  = ref,
        super(const FinancesState.initial()) {
    charger();
  }

  bool _estAccesGlobal(String role) =>
      role == AppRoles.bureauExecutif ||
      role == AppRoles.coordinateur ||
      role == AppRoles.adminTechnique;

  Future<void> charger() async {
    state = const FinancesState.chargement();

    final utilisateur = _ref.read(authProvider).whenOrNull(connecte: (u) => u);
    if (utilisateur == null) {
      state = const FinancesState.erreur(failure: Failure.nonAutorise());
      return;
    }

    final filtrer  = !_estAccesGlobal(utilisateur.role);
    final uniteId  = filtrer ? utilisateur.uniteOrganisationnelleId : null;
    final annee    = DateTime.now().year;

    final results = await Future.wait([
      _getTransactions(ParamsGetTransactions(uniteId: uniteId)),
      _getCotisations(ParamsGetCotisations(uniteId: uniteId, annee: annee)),
    ]);

    final txs   = results[0] as Either<Failure, List<Transaction>>;
    final cotis = results[1] as Either<Failure, List<Cotisation>>;

    if (txs.isLeft()) {
      state = FinancesState.erreur(
          failure: txs.fold((f) => f, (_) => const Failure.reseau()));
      return;
    }

    state = FinancesState.charge(
      transactions: txs.getOrElse(() => []),
      cotisations:  cotis.getOrElse(() => []),
    );
  }

  Future<Either<Failure, void>> ajouterTransaction(
      ParamsAjouterTransaction params) async {
    final utilisateur = _ref.read(authProvider).whenOrNull(connecte: (u) => u);
    final uniteId = utilisateur?.uniteOrganisationnelleId ?? '';
    final paramsAvecUnite = ParamsAjouterTransaction(
      type:            params.type,
      categorie:       params.categorie,
      montant:         params.montant,
      dateTransaction: params.dateTransaction,
      uniteId:         uniteId,
      description:     params.description,
      beneficiaire:    params.beneficiaire,
      militantId:      params.militantId,
    );
    final result = await _ajouterTransaction(paramsAvecUnite);
    if (result.isRight()) await charger();
    return result.map((_) {});
  }

  Future<Either<Failure, void>> enregistrerCotisation(
      ParamsEnregistrerCotisation params) async {
    final result = await _enregistrerCotisation(params);
    if (result.isRight()) await charger();
    return result.map((_) {});
  }
}