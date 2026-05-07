// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$PointGraphique {
  DateTime get mois => throw _privateConstructorUsedError;
  double get valeur => throw _privateConstructorUsedError;

  /// Create a copy of PointGraphique
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PointGraphiqueCopyWith<PointGraphique> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PointGraphiqueCopyWith<$Res> {
  factory $PointGraphiqueCopyWith(
    PointGraphique value,
    $Res Function(PointGraphique) then,
  ) = _$PointGraphiqueCopyWithImpl<$Res, PointGraphique>;
  @useResult
  $Res call({DateTime mois, double valeur});
}

/// @nodoc
class _$PointGraphiqueCopyWithImpl<$Res, $Val extends PointGraphique>
    implements $PointGraphiqueCopyWith<$Res> {
  _$PointGraphiqueCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PointGraphique
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? mois = null, Object? valeur = null}) {
    return _then(
      _value.copyWith(
            mois: null == mois
                ? _value.mois
                : mois // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            valeur: null == valeur
                ? _value.valeur
                : valeur // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PointGraphiqueImplCopyWith<$Res>
    implements $PointGraphiqueCopyWith<$Res> {
  factory _$$PointGraphiqueImplCopyWith(
    _$PointGraphiqueImpl value,
    $Res Function(_$PointGraphiqueImpl) then,
  ) = __$$PointGraphiqueImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DateTime mois, double valeur});
}

/// @nodoc
class __$$PointGraphiqueImplCopyWithImpl<$Res>
    extends _$PointGraphiqueCopyWithImpl<$Res, _$PointGraphiqueImpl>
    implements _$$PointGraphiqueImplCopyWith<$Res> {
  __$$PointGraphiqueImplCopyWithImpl(
    _$PointGraphiqueImpl _value,
    $Res Function(_$PointGraphiqueImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PointGraphique
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? mois = null, Object? valeur = null}) {
    return _then(
      _$PointGraphiqueImpl(
        mois: null == mois
            ? _value.mois
            : mois // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        valeur: null == valeur
            ? _value.valeur
            : valeur // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc

class _$PointGraphiqueImpl implements _PointGraphique {
  const _$PointGraphiqueImpl({required this.mois, required this.valeur});

  @override
  final DateTime mois;
  @override
  final double valeur;

  @override
  String toString() {
    return 'PointGraphique(mois: $mois, valeur: $valeur)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PointGraphiqueImpl &&
            (identical(other.mois, mois) || other.mois == mois) &&
            (identical(other.valeur, valeur) || other.valeur == valeur));
  }

  @override
  int get hashCode => Object.hash(runtimeType, mois, valeur);

  /// Create a copy of PointGraphique
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PointGraphiqueImplCopyWith<_$PointGraphiqueImpl> get copyWith =>
      __$$PointGraphiqueImplCopyWithImpl<_$PointGraphiqueImpl>(
        this,
        _$identity,
      );
}

abstract class _PointGraphique implements PointGraphique {
  const factory _PointGraphique({
    required final DateTime mois,
    required final double valeur,
  }) = _$PointGraphiqueImpl;

  @override
  DateTime get mois;
  @override
  double get valeur;

  /// Create a copy of PointGraphique
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PointGraphiqueImplCopyWith<_$PointGraphiqueImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$DashboardStats {
  // --- Militants ---
  int get totalMilitants => throw _privateConstructorUsedError;
  int get nouveauxCeMois => throw _privateConstructorUsedError;
  int get objectifMilitants => throw _privateConstructorUsedError;
  double get pourcentageHommes => throw _privateConstructorUsedError;
  double get pourcentageFemmes => throw _privateConstructorUsedError;
  List<PointGraphique> get evolutionMilitants =>
      throw _privateConstructorUsedError; // --- Finances ---
  double get soldeGlobal => throw _privateConstructorUsedError;
  double get tauxRecouvrement => throw _privateConstructorUsedError;
  double get objectifRecouvrement => throw _privateConstructorUsedError;
  List<PointGraphique> get evolutionFinances =>
      throw _privateConstructorUsedError; // --- Militants (complément) ---
  int get nouveauxCetteAnnee =>
      throw _privateConstructorUsedError; // --- Finances (complément) ---
  double get totalEntrees =>
      throw _privateConstructorUsedError; // --- Activité ---
  int get prospectsActifs => throw _privateConstructorUsedError;
  double get tauxConversion => throw _privateConstructorUsedError;
  int get evenementsCeMois => throw _privateConstructorUsedError;
  int get evenementsAVenir => throw _privateConstructorUsedError;
  int get decisionsEnAttente => throw _privateConstructorUsedError;
  int get actionsEnRetard =>
      throw _privateConstructorUsedError; // --- Structure ---
  int get nombreCellules => throw _privateConstructorUsedError;

  /// Create a copy of DashboardStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DashboardStatsCopyWith<DashboardStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DashboardStatsCopyWith<$Res> {
  factory $DashboardStatsCopyWith(
    DashboardStats value,
    $Res Function(DashboardStats) then,
  ) = _$DashboardStatsCopyWithImpl<$Res, DashboardStats>;
  @useResult
  $Res call({
    int totalMilitants,
    int nouveauxCeMois,
    int objectifMilitants,
    double pourcentageHommes,
    double pourcentageFemmes,
    List<PointGraphique> evolutionMilitants,
    double soldeGlobal,
    double tauxRecouvrement,
    double objectifRecouvrement,
    List<PointGraphique> evolutionFinances,
    int nouveauxCetteAnnee,
    double totalEntrees,
    int prospectsActifs,
    double tauxConversion,
    int evenementsCeMois,
    int evenementsAVenir,
    int decisionsEnAttente,
    int actionsEnRetard,
    int nombreCellules,
  });
}

/// @nodoc
class _$DashboardStatsCopyWithImpl<$Res, $Val extends DashboardStats>
    implements $DashboardStatsCopyWith<$Res> {
  _$DashboardStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DashboardStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalMilitants = null,
    Object? nouveauxCeMois = null,
    Object? objectifMilitants = null,
    Object? pourcentageHommes = null,
    Object? pourcentageFemmes = null,
    Object? evolutionMilitants = null,
    Object? soldeGlobal = null,
    Object? tauxRecouvrement = null,
    Object? objectifRecouvrement = null,
    Object? evolutionFinances = null,
    Object? nouveauxCetteAnnee = null,
    Object? totalEntrees = null,
    Object? prospectsActifs = null,
    Object? tauxConversion = null,
    Object? evenementsCeMois = null,
    Object? evenementsAVenir = null,
    Object? decisionsEnAttente = null,
    Object? actionsEnRetard = null,
    Object? nombreCellules = null,
  }) {
    return _then(
      _value.copyWith(
            totalMilitants: null == totalMilitants
                ? _value.totalMilitants
                : totalMilitants // ignore: cast_nullable_to_non_nullable
                      as int,
            nouveauxCeMois: null == nouveauxCeMois
                ? _value.nouveauxCeMois
                : nouveauxCeMois // ignore: cast_nullable_to_non_nullable
                      as int,
            objectifMilitants: null == objectifMilitants
                ? _value.objectifMilitants
                : objectifMilitants // ignore: cast_nullable_to_non_nullable
                      as int,
            pourcentageHommes: null == pourcentageHommes
                ? _value.pourcentageHommes
                : pourcentageHommes // ignore: cast_nullable_to_non_nullable
                      as double,
            pourcentageFemmes: null == pourcentageFemmes
                ? _value.pourcentageFemmes
                : pourcentageFemmes // ignore: cast_nullable_to_non_nullable
                      as double,
            evolutionMilitants: null == evolutionMilitants
                ? _value.evolutionMilitants
                : evolutionMilitants // ignore: cast_nullable_to_non_nullable
                      as List<PointGraphique>,
            soldeGlobal: null == soldeGlobal
                ? _value.soldeGlobal
                : soldeGlobal // ignore: cast_nullable_to_non_nullable
                      as double,
            tauxRecouvrement: null == tauxRecouvrement
                ? _value.tauxRecouvrement
                : tauxRecouvrement // ignore: cast_nullable_to_non_nullable
                      as double,
            objectifRecouvrement: null == objectifRecouvrement
                ? _value.objectifRecouvrement
                : objectifRecouvrement // ignore: cast_nullable_to_non_nullable
                      as double,
            evolutionFinances: null == evolutionFinances
                ? _value.evolutionFinances
                : evolutionFinances // ignore: cast_nullable_to_non_nullable
                      as List<PointGraphique>,
            nouveauxCetteAnnee: null == nouveauxCetteAnnee
                ? _value.nouveauxCetteAnnee
                : nouveauxCetteAnnee // ignore: cast_nullable_to_non_nullable
                      as int,
            totalEntrees: null == totalEntrees
                ? _value.totalEntrees
                : totalEntrees // ignore: cast_nullable_to_non_nullable
                      as double,
            prospectsActifs: null == prospectsActifs
                ? _value.prospectsActifs
                : prospectsActifs // ignore: cast_nullable_to_non_nullable
                      as int,
            tauxConversion: null == tauxConversion
                ? _value.tauxConversion
                : tauxConversion // ignore: cast_nullable_to_non_nullable
                      as double,
            evenementsCeMois: null == evenementsCeMois
                ? _value.evenementsCeMois
                : evenementsCeMois // ignore: cast_nullable_to_non_nullable
                      as int,
            evenementsAVenir: null == evenementsAVenir
                ? _value.evenementsAVenir
                : evenementsAVenir // ignore: cast_nullable_to_non_nullable
                      as int,
            decisionsEnAttente: null == decisionsEnAttente
                ? _value.decisionsEnAttente
                : decisionsEnAttente // ignore: cast_nullable_to_non_nullable
                      as int,
            actionsEnRetard: null == actionsEnRetard
                ? _value.actionsEnRetard
                : actionsEnRetard // ignore: cast_nullable_to_non_nullable
                      as int,
            nombreCellules: null == nombreCellules
                ? _value.nombreCellules
                : nombreCellules // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DashboardStatsImplCopyWith<$Res>
    implements $DashboardStatsCopyWith<$Res> {
  factory _$$DashboardStatsImplCopyWith(
    _$DashboardStatsImpl value,
    $Res Function(_$DashboardStatsImpl) then,
  ) = __$$DashboardStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int totalMilitants,
    int nouveauxCeMois,
    int objectifMilitants,
    double pourcentageHommes,
    double pourcentageFemmes,
    List<PointGraphique> evolutionMilitants,
    double soldeGlobal,
    double tauxRecouvrement,
    double objectifRecouvrement,
    List<PointGraphique> evolutionFinances,
    int nouveauxCetteAnnee,
    double totalEntrees,
    int prospectsActifs,
    double tauxConversion,
    int evenementsCeMois,
    int evenementsAVenir,
    int decisionsEnAttente,
    int actionsEnRetard,
    int nombreCellules,
  });
}

/// @nodoc
class __$$DashboardStatsImplCopyWithImpl<$Res>
    extends _$DashboardStatsCopyWithImpl<$Res, _$DashboardStatsImpl>
    implements _$$DashboardStatsImplCopyWith<$Res> {
  __$$DashboardStatsImplCopyWithImpl(
    _$DashboardStatsImpl _value,
    $Res Function(_$DashboardStatsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DashboardStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalMilitants = null,
    Object? nouveauxCeMois = null,
    Object? objectifMilitants = null,
    Object? pourcentageHommes = null,
    Object? pourcentageFemmes = null,
    Object? evolutionMilitants = null,
    Object? soldeGlobal = null,
    Object? tauxRecouvrement = null,
    Object? objectifRecouvrement = null,
    Object? evolutionFinances = null,
    Object? nouveauxCetteAnnee = null,
    Object? totalEntrees = null,
    Object? prospectsActifs = null,
    Object? tauxConversion = null,
    Object? evenementsCeMois = null,
    Object? evenementsAVenir = null,
    Object? decisionsEnAttente = null,
    Object? actionsEnRetard = null,
    Object? nombreCellules = null,
  }) {
    return _then(
      _$DashboardStatsImpl(
        totalMilitants: null == totalMilitants
            ? _value.totalMilitants
            : totalMilitants // ignore: cast_nullable_to_non_nullable
                  as int,
        nouveauxCeMois: null == nouveauxCeMois
            ? _value.nouveauxCeMois
            : nouveauxCeMois // ignore: cast_nullable_to_non_nullable
                  as int,
        objectifMilitants: null == objectifMilitants
            ? _value.objectifMilitants
            : objectifMilitants // ignore: cast_nullable_to_non_nullable
                  as int,
        pourcentageHommes: null == pourcentageHommes
            ? _value.pourcentageHommes
            : pourcentageHommes // ignore: cast_nullable_to_non_nullable
                  as double,
        pourcentageFemmes: null == pourcentageFemmes
            ? _value.pourcentageFemmes
            : pourcentageFemmes // ignore: cast_nullable_to_non_nullable
                  as double,
        evolutionMilitants: null == evolutionMilitants
            ? _value._evolutionMilitants
            : evolutionMilitants // ignore: cast_nullable_to_non_nullable
                  as List<PointGraphique>,
        soldeGlobal: null == soldeGlobal
            ? _value.soldeGlobal
            : soldeGlobal // ignore: cast_nullable_to_non_nullable
                  as double,
        tauxRecouvrement: null == tauxRecouvrement
            ? _value.tauxRecouvrement
            : tauxRecouvrement // ignore: cast_nullable_to_non_nullable
                  as double,
        objectifRecouvrement: null == objectifRecouvrement
            ? _value.objectifRecouvrement
            : objectifRecouvrement // ignore: cast_nullable_to_non_nullable
                  as double,
        evolutionFinances: null == evolutionFinances
            ? _value._evolutionFinances
            : evolutionFinances // ignore: cast_nullable_to_non_nullable
                  as List<PointGraphique>,
        nouveauxCetteAnnee: null == nouveauxCetteAnnee
            ? _value.nouveauxCetteAnnee
            : nouveauxCetteAnnee // ignore: cast_nullable_to_non_nullable
                  as int,
        totalEntrees: null == totalEntrees
            ? _value.totalEntrees
            : totalEntrees // ignore: cast_nullable_to_non_nullable
                  as double,
        prospectsActifs: null == prospectsActifs
            ? _value.prospectsActifs
            : prospectsActifs // ignore: cast_nullable_to_non_nullable
                  as int,
        tauxConversion: null == tauxConversion
            ? _value.tauxConversion
            : tauxConversion // ignore: cast_nullable_to_non_nullable
                  as double,
        evenementsCeMois: null == evenementsCeMois
            ? _value.evenementsCeMois
            : evenementsCeMois // ignore: cast_nullable_to_non_nullable
                  as int,
        evenementsAVenir: null == evenementsAVenir
            ? _value.evenementsAVenir
            : evenementsAVenir // ignore: cast_nullable_to_non_nullable
                  as int,
        decisionsEnAttente: null == decisionsEnAttente
            ? _value.decisionsEnAttente
            : decisionsEnAttente // ignore: cast_nullable_to_non_nullable
                  as int,
        actionsEnRetard: null == actionsEnRetard
            ? _value.actionsEnRetard
            : actionsEnRetard // ignore: cast_nullable_to_non_nullable
                  as int,
        nombreCellules: null == nombreCellules
            ? _value.nombreCellules
            : nombreCellules // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$DashboardStatsImpl implements _DashboardStats {
  const _$DashboardStatsImpl({
    required this.totalMilitants,
    required this.nouveauxCeMois,
    required this.objectifMilitants,
    required this.pourcentageHommes,
    required this.pourcentageFemmes,
    required final List<PointGraphique> evolutionMilitants,
    required this.soldeGlobal,
    required this.tauxRecouvrement,
    required this.objectifRecouvrement,
    required final List<PointGraphique> evolutionFinances,
    required this.nouveauxCetteAnnee,
    required this.totalEntrees,
    required this.prospectsActifs,
    required this.tauxConversion,
    required this.evenementsCeMois,
    required this.evenementsAVenir,
    required this.decisionsEnAttente,
    required this.actionsEnRetard,
    required this.nombreCellules,
  }) : _evolutionMilitants = evolutionMilitants,
       _evolutionFinances = evolutionFinances;

  // --- Militants ---
  @override
  final int totalMilitants;
  @override
  final int nouveauxCeMois;
  @override
  final int objectifMilitants;
  @override
  final double pourcentageHommes;
  @override
  final double pourcentageFemmes;
  final List<PointGraphique> _evolutionMilitants;
  @override
  List<PointGraphique> get evolutionMilitants {
    if (_evolutionMilitants is EqualUnmodifiableListView)
      return _evolutionMilitants;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_evolutionMilitants);
  }

  // --- Finances ---
  @override
  final double soldeGlobal;
  @override
  final double tauxRecouvrement;
  @override
  final double objectifRecouvrement;
  final List<PointGraphique> _evolutionFinances;
  @override
  List<PointGraphique> get evolutionFinances {
    if (_evolutionFinances is EqualUnmodifiableListView)
      return _evolutionFinances;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_evolutionFinances);
  }

  // --- Militants (complément) ---
  @override
  final int nouveauxCetteAnnee;
  // --- Finances (complément) ---
  @override
  final double totalEntrees;
  // --- Activité ---
  @override
  final int prospectsActifs;
  @override
  final double tauxConversion;
  @override
  final int evenementsCeMois;
  @override
  final int evenementsAVenir;
  @override
  final int decisionsEnAttente;
  @override
  final int actionsEnRetard;
  // --- Structure ---
  @override
  final int nombreCellules;

  @override
  String toString() {
    return 'DashboardStats(totalMilitants: $totalMilitants, nouveauxCeMois: $nouveauxCeMois, objectifMilitants: $objectifMilitants, pourcentageHommes: $pourcentageHommes, pourcentageFemmes: $pourcentageFemmes, evolutionMilitants: $evolutionMilitants, soldeGlobal: $soldeGlobal, tauxRecouvrement: $tauxRecouvrement, objectifRecouvrement: $objectifRecouvrement, evolutionFinances: $evolutionFinances, nouveauxCetteAnnee: $nouveauxCetteAnnee, totalEntrees: $totalEntrees, prospectsActifs: $prospectsActifs, tauxConversion: $tauxConversion, evenementsCeMois: $evenementsCeMois, evenementsAVenir: $evenementsAVenir, decisionsEnAttente: $decisionsEnAttente, actionsEnRetard: $actionsEnRetard, nombreCellules: $nombreCellules)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DashboardStatsImpl &&
            (identical(other.totalMilitants, totalMilitants) ||
                other.totalMilitants == totalMilitants) &&
            (identical(other.nouveauxCeMois, nouveauxCeMois) ||
                other.nouveauxCeMois == nouveauxCeMois) &&
            (identical(other.objectifMilitants, objectifMilitants) ||
                other.objectifMilitants == objectifMilitants) &&
            (identical(other.pourcentageHommes, pourcentageHommes) ||
                other.pourcentageHommes == pourcentageHommes) &&
            (identical(other.pourcentageFemmes, pourcentageFemmes) ||
                other.pourcentageFemmes == pourcentageFemmes) &&
            const DeepCollectionEquality().equals(
              other._evolutionMilitants,
              _evolutionMilitants,
            ) &&
            (identical(other.soldeGlobal, soldeGlobal) ||
                other.soldeGlobal == soldeGlobal) &&
            (identical(other.tauxRecouvrement, tauxRecouvrement) ||
                other.tauxRecouvrement == tauxRecouvrement) &&
            (identical(other.objectifRecouvrement, objectifRecouvrement) ||
                other.objectifRecouvrement == objectifRecouvrement) &&
            const DeepCollectionEquality().equals(
              other._evolutionFinances,
              _evolutionFinances,
            ) &&
            (identical(other.nouveauxCetteAnnee, nouveauxCetteAnnee) ||
                other.nouveauxCetteAnnee == nouveauxCetteAnnee) &&
            (identical(other.totalEntrees, totalEntrees) ||
                other.totalEntrees == totalEntrees) &&
            (identical(other.prospectsActifs, prospectsActifs) ||
                other.prospectsActifs == prospectsActifs) &&
            (identical(other.tauxConversion, tauxConversion) ||
                other.tauxConversion == tauxConversion) &&
            (identical(other.evenementsCeMois, evenementsCeMois) ||
                other.evenementsCeMois == evenementsCeMois) &&
            (identical(other.evenementsAVenir, evenementsAVenir) ||
                other.evenementsAVenir == evenementsAVenir) &&
            (identical(other.decisionsEnAttente, decisionsEnAttente) ||
                other.decisionsEnAttente == decisionsEnAttente) &&
            (identical(other.actionsEnRetard, actionsEnRetard) ||
                other.actionsEnRetard == actionsEnRetard) &&
            (identical(other.nombreCellules, nombreCellules) ||
                other.nombreCellules == nombreCellules));
  }

  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    totalMilitants,
    nouveauxCeMois,
    objectifMilitants,
    pourcentageHommes,
    pourcentageFemmes,
    const DeepCollectionEquality().hash(_evolutionMilitants),
    soldeGlobal,
    tauxRecouvrement,
    objectifRecouvrement,
    const DeepCollectionEquality().hash(_evolutionFinances),
    nouveauxCetteAnnee,
    totalEntrees,
    prospectsActifs,
    tauxConversion,
    evenementsCeMois,
    evenementsAVenir,
    decisionsEnAttente,
    actionsEnRetard,
    nombreCellules,
  ]);

  /// Create a copy of DashboardStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DashboardStatsImplCopyWith<_$DashboardStatsImpl> get copyWith =>
      __$$DashboardStatsImplCopyWithImpl<_$DashboardStatsImpl>(
        this,
        _$identity,
      );
}

abstract class _DashboardStats implements DashboardStats {
  const factory _DashboardStats({
    required final int totalMilitants,
    required final int nouveauxCeMois,
    required final int objectifMilitants,
    required final double pourcentageHommes,
    required final double pourcentageFemmes,
    required final List<PointGraphique> evolutionMilitants,
    required final double soldeGlobal,
    required final double tauxRecouvrement,
    required final double objectifRecouvrement,
    required final List<PointGraphique> evolutionFinances,
    required final int nouveauxCetteAnnee,
    required final double totalEntrees,
    required final int prospectsActifs,
    required final double tauxConversion,
    required final int evenementsCeMois,
    required final int evenementsAVenir,
    required final int decisionsEnAttente,
    required final int actionsEnRetard,
    required final int nombreCellules,
  }) = _$DashboardStatsImpl;

  // --- Militants ---
  @override
  int get totalMilitants;
  @override
  int get nouveauxCeMois;
  @override
  int get objectifMilitants;
  @override
  double get pourcentageHommes;
  @override
  double get pourcentageFemmes;
  @override
  List<PointGraphique> get evolutionMilitants; // --- Finances ---
  @override
  double get soldeGlobal;
  @override
  double get tauxRecouvrement;
  @override
  double get objectifRecouvrement;
  @override
  List<PointGraphique> get evolutionFinances; // --- Militants (complément) ---
  @override
  int get nouveauxCetteAnnee; // --- Finances (complément) ---
  @override
  double get totalEntrees; // --- Activité ---
  @override
  int get prospectsActifs;
  @override
  double get tauxConversion;
  @override
  int get evenementsCeMois;
  @override
  int get evenementsAVenir;
  @override
  int get decisionsEnAttente;
  @override
  int get actionsEnRetard; // --- Structure ---
  @override
  int get nombreCellules;

  /// Create a copy of DashboardStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DashboardStatsImplCopyWith<_$DashboardStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
