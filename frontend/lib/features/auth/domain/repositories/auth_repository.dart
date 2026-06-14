import 'dart:typed_data';

import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/utilisateur.dart';

class ParamsUploaderPhoto {
  final Uint8List bytes;
  final String extension;
  const ParamsUploaderPhoto({required this.bytes, required this.extension});
}

abstract class AuthRepository {
  Future<Either<Failure, Utilisateur>> seConnecter({
    required String email,
    required String motDePasse,
  });

  Future<Either<Failure, void>> seDeconnecter();

  Future<Either<Failure, Utilisateur?>> getUtilisateurCourant();

  Future<Either<Failure, String>> uploaderPhoto(ParamsUploaderPhoto params);
}