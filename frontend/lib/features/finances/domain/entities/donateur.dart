import 'package:freezed_annotation/freezed_annotation.dart';

part 'donateur.freezed.dart';

@freezed
class Donateur with _$Donateur {
  const factory Donateur({
    required String id,
    required String nom,
    String? prenom,
    String? telephone,
    String? email,
    String? ville,
  }) = _Donateur;
}
