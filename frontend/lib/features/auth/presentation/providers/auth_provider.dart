import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/datasources/auth_remote_datasource_impl.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/utilisateur.dart';
import '../../domain/usecases/get_utilisateur_courant.dart';
import '../../domain/usecases/se_connecter.dart';
import '../../domain/usecases/se_deconnecter.dart';
import '../../domain/usecases/upload_photo_profile.dart';

part 'auth_provider.freezed.dart';

// --- État ---

@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial()                                         = AuthInitial;
  const factory AuthState.chargement()                                     = AuthChargement;
  const factory AuthState.connecte({required Utilisateur utilisateur})     = AuthConnecte;
  const factory AuthState.deconnecte()                                     = AuthDeconnecte;
  const factory AuthState.erreur({required Failure failure})               = AuthErreur;
}

// --- Providers d'infrastructure ---

final supabaseClientProvider = Provider<SupabaseClient>(
  (_) => Supabase.instance.client,
);

final authDatasourceProvider = Provider(
  (ref) => AuthRemoteDatasourceImpl(ref.watch(supabaseClientProvider)),
);

final authRepositoryProvider = Provider(
  (ref) => AuthRepositoryImpl(ref.watch(authDatasourceProvider)),
);

// --- Notifier ---

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(
    seConnecter:          SeConnecter(ref.watch(authRepositoryProvider)),
    seDeconnecter:        SeDeconnecter(ref.watch(authRepositoryProvider)),
    getUtilisateurCourant: GetUtilisateurCourant(ref.watch(authRepositoryProvider)),
    uploaderPhotoProfile: UploaderPhotoProfile(ref.watch(authRepositoryProvider)),
  ),
);

class AuthNotifier extends StateNotifier<AuthState> {
  final SeConnecter             _seConnecter;
  final SeDeconnecter           _seDeconnecter;
  final GetUtilisateurCourant   _getUtilisateurCourant;
  final UploaderPhotoProfile    _uploaderPhotoProfile;

  AuthNotifier({
    required SeConnecter seConnecter,
    required SeDeconnecter seDeconnecter,
    required GetUtilisateurCourant getUtilisateurCourant,
    required UploaderPhotoProfile uploaderPhotoProfile,
  })  : _seConnecter           = seConnecter,
        _seDeconnecter         = seDeconnecter,
        _getUtilisateurCourant = getUtilisateurCourant,
        _uploaderPhotoProfile  = uploaderPhotoProfile,
        super(const AuthState.initial()) {
    _verifierSession();
  }

  Future<void> _verifierSession() async {
    state = const AuthState.chargement();
    final result = await _getUtilisateurCourant(const NoParams());
    result.fold(
      (_)            => state = const AuthState.deconnecte(),
      (utilisateur)  => state = utilisateur != null
          ? AuthState.connecte(utilisateur: utilisateur)
          : const AuthState.deconnecte(),
    );
  }

  Future<void> seConnecter(String email, String motDePasse) async {
    state = const AuthState.chargement();
    final result = await _seConnecter(
      ParamsSeConnecter(email: email, motDePasse: motDePasse),
    );
    result.fold(
      (failure)     => state = AuthState.erreur(failure: failure),
      (utilisateur) => state = AuthState.connecte(utilisateur: utilisateur),
    );
  }

  Future<void> seDeconnecter() async {
    await _seDeconnecter(const NoParams());
    state = const AuthState.deconnecte();
  }

  Future<Either<Failure, void>> uploaderPhoto(ParamsUploaderPhoto params) async {
    final result = await _uploaderPhotoProfile(params);
    if (result.isRight()) {
      final url     = result.getOrElse(() => '');
      final courant = state.whenOrNull(connecte: (u) => u);
      if (courant != null) {
        state = AuthState.connecte(utilisateur: courant.copyWith(photoUrl: url));
      }
    }
    return result.fold((f) => Left(f), (_) => const Right(null));
  }
}