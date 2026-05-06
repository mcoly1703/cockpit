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

      final profil = await supabase
          .from('profiles')
          .select()
          .eq('id', response.user!.id)
          .single();

      return UtilisateurModel.fromJson({
        ...profil,
        'email': response.user!.email,
      });
    } on AuthException catch (e) {
      throw ServerException(message: e.message);
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
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

      final profil = await supabase
          .from('profiles')
          .select()
          .eq('id', user.id)
          .single();

      return UtilisateurModel.fromJson({
        ...profil,
        'email': user.email,
      });
    } on PostgrestException catch (e) {
      throw ServerException(message: e.message);
    } catch (e) {
      throw const NetworkException();
    }
  }
}
