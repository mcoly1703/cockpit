import 'package:dartz/dartz.dart';

import '../errors/failures.dart';

/// Contrat que tout UseCase doit respecter.
///
/// [Type]   = type du résultat en cas de succès (ex: List<Militant>)
/// [Params] = paramètres d'entrée (ex: FiltresMilitants). Utiliser [NoParams] si aucun.
///
/// La méthode [call] permet d'appeler l'instance comme une fonction :
///   final result = await getMilitants(NoParams());
///
/// Retourne toujours Either<Failure, Type> :
///   - Left(Failure)  → une erreur métier
///   - Right(valeur)  → le résultat attendu
/// Jamais d'exception qui s'échappe vers la présentation.
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// À utiliser quand le UseCase ne nécessite aucun paramètre.
class NoParams {
  const NoParams();
}