import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/errors/exceptions.dart';
import '../models/utilisateur_model.dart';
import 'auth_remote_datasource.dart';

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final SupabaseClient supabase;
  AuthRemoteDatasourceImpl(this.supabase);

  @override
  Future<UtilisateurModel> seConnecter({
    required String email,
    required String motDePasse,
  }) async {
    try {
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: motDePasse,
      );
      if (response.user == null) throw const UnauthorizedException();

      return await _chargerProfil(
        userId: response.user!.id,
        email: response.user!.email!,
      );
    } on AuthException catch (e) {
      throw ServerException(message: e.message);
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } on NotFoundException {
      rethrow;
    } catch (e) {
      throw const NetworkException();
    }
  }

  @override
  Future<void> seDeconnecter() async {
    try {
      await supabase.auth.signOut();
    } on AuthException catch (e) {
      throw ServerException(message: e.message);
    }
  }

  @override
  Future<UtilisateurModel?> getUtilisateurCourant() async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) return null;

      return await _chargerProfil(userId: user.id, email: user.email!);
    } on NotFoundException {
      return null;
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw const NetworkException();
    }
  }

  // Cherche d'abord dans profiles (militants), puis dans admins_techniques
  Future<UtilisateurModel> _chargerProfil({
    required String userId,
    required String email,
  }) async {
    final profil = await supabase
        .from('profiles')
        .select()
        .eq('id', userId)
        .maybeSingle();

    if (profil != null) {
      return UtilisateurModel.fromJson({...profil, 'email': email});
    }

    final admin = await supabase
        .from('admins_techniques')
        .select()
        .eq('id', userId)
        .maybeSingle();

    if (admin != null) {
      return UtilisateurModel.fromJson({
        ...admin,
        'email': email,
        'role': 'admin_technique',
        'unite_organisationnelle_id': null,
      });
    }

    throw const NotFoundException();
  }
}
