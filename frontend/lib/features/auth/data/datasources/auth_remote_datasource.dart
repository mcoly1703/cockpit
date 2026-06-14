import 'dart:typed_data';

import '../models/utilisateur_model.dart';

abstract class AuthRemoteDatasource {
  Future<UtilisateurModel> seConnecter({
    required String email,
    required String motDePasse,
  });

  Future<void> seDeconnecter();

  Future<UtilisateurModel?> getUtilisateurCourant();

  Future<String> uploaderPhoto(Uint8List bytes, String extension);
}