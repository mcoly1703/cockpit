import 'package:freezed_annotation/freezed_annotation.dart';

part 'failures.freezed.dart';

/// Erreurs métier exposées à la couche présentation.
///
/// Produit par la couche [data] qui intercepte les [Exception]s techniques
/// (Supabase, réseau) et les convertit en [Failure] compréhensibles par l'UI.
///
/// Utilisation dans un widget :
///   failure.when(
///     serveur:      (msg) => Text('Erreur : $msg'),
///     reseau:       ()    => Text('Pas de connexion'),
///     nonAutorise:  ()    => context.go(AppRoutes.login),
///     nonTrouve:    ()    => Text('Introuvable'),
///     validation:   (msg) => Text(msg),
///   )
@freezed
class Failure with _$Failure {
  const factory Failure.serveur({required String message}) = FailureServeur;
  const factory Failure.reseau() = FailureReseau;
  const factory Failure.nonAutorise() = FailureNonAutorise;
  const factory Failure.nonTrouve() = FailureNonTrouve;
  const factory Failure.validation({required String message}) = FailureValidation;
}