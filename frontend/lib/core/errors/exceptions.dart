/// Exceptions techniques levées par la couche [data] uniquement.
///
/// Ces exceptions ne remontent JAMAIS jusqu'à la présentation.
/// La couche data les attrape et les convertit en [Failure].
///
/// Exemple dans un repository :
///   try {
///     final data = await supabase.from('militants').select();
///     return Right(data.map(MilitantModel.fromJson).toList());
///   } on PostgrestException catch (e) {
///     throw ServerException(message: e.message);
///   } catch (_) {
///     throw const NetworkException();
///   }

class ServerException implements Exception {
  final String message;
  const ServerException({this.message = 'Erreur serveur'});
}

class NetworkException implements Exception {
  const NetworkException();
}

class UnauthorizedException implements Exception {
  const UnauthorizedException();
}

class NotFoundException implements Exception {
  const NotFoundException();
}

class ValidationException implements Exception {
  final String message;
  const ValidationException({required this.message});
}