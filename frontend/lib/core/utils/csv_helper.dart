import 'package:intl/intl.dart';

import '../../features/militants/domain/entities/militant.dart';
import '../../features/militants/domain/entities/unite_organisationnelle.dart';

/// Parse un contenu CSV (séparateur virgule ou point-virgule, première ligne = entêtes).
List<Map<String, String>> parseCsv(String content) {
  final lignes = content
      .replaceAll('\r\n', '\n')
      .replaceAll('\r', '\n')
      .split('\n')
      .where((l) => l.trim().isNotEmpty)
      .toList();

  if (lignes.isEmpty) return [];

  final sep     = lignes[0].contains(';') ? ';' : ',';
  final entetes = lignes[0]
      .split(sep)
      .map((h) => h.trim().replaceAll('"', '').toLowerCase()
          .replaceAll(' ', '_')
          .replaceAll('é', 'e')
          .replaceAll('è', 'e')
          .replaceAll('ê', 'e')
          .replaceAll('à', 'a')
          .replaceAll('â', 'a'))
      .toList();

  return lignes.skip(1).map((ligne) {
    final valeurs = ligne.split(sep).map((v) => v.trim().replaceAll('"', '')).toList();
    final map     = <String, String>{};
    for (int i = 0; i < entetes.length; i++) {
      final val = i < valeurs.length ? valeurs[i] : '';
      if (val.isNotEmpty) map[entetes[i]] = val;
    }
    return map;
  }).where((m) => m.isNotEmpty).toList();
}

/// Convertit une ligne CSV en Map<String, dynamic> pour insertion Supabase.
/// Retourne null si les champs obligatoires manquent.
Map<String, dynamic>? csvRowVersSupabase(
    Map<String, String> row, String uniteId) {
  final nom    = row['nom'] ?? row['nom_de_famille'] ?? row['name'];
  final prenom = row['prenom'] ?? row['prenom'] ?? row['first_name'];
  if (nom == null || nom.isEmpty || prenom == null || prenom.isEmpty) return null;

  String? sexe;
  final rawSexe = (row['sexe'] ?? row['genre'] ?? '').toUpperCase();
  if (rawSexe == 'M' || rawSexe == 'HOMME' || rawSexe == 'H') sexe = 'M';
  if (rawSexe == 'F' || rawSexe == 'FEMME') sexe = 'F';

  DateTime dateAdhesion;
  try {
    dateAdhesion = _parseDate(row['date_adhesion'] ?? row['date_d_adhesion']) ??
        DateTime.now();
  } catch (_) {
    dateAdhesion = DateTime.now();
  }

  return {
    'nom':           nom.toUpperCase(),
    'prenom':        prenom,
    'telephone':     row['telephone'] ?? row['tel'],
    'email':         row['email'],
    'ville':         row['ville'] ?? row['city'],
    'code_postal':   row['code_postal'] ?? row['cp'],
    'sexe':          sexe,
    'unite_id':      uniteId,
    'statut':        'actif',
    'date_adhesion': DateFormat('yyyy-MM-dd').format(dateAdhesion),
  }..removeWhere((_, v) => v == null);
}

DateTime? _parseDate(String? s) {
  if (s == null || s.isEmpty) return null;
  try {
    if (s.contains('/')) {
      final p = s.split('/');
      if (p.length == 3) return DateTime(int.parse(p[2]), int.parse(p[1]), int.parse(p[0]));
    }
    return DateTime.parse(s);
  } catch (_) {
    return null;
  }
}

/// Génère un CSV à partir d'une liste de militants.
String formaterCsvMilitants(
    List<Militant> militants, List<UniteOrganisationnelle> unites) {
  final unitesMap = {for (final u in unites) u.id: u};
  final fmt       = DateFormat('dd/MM/yyyy');

  final entetes = [
    'Numéro Carte', 'Nom', 'Prénom', 'Email', 'Téléphone',
    'Sexe', 'Ville', 'Code Postal', 'Unité', 'Date Adhésion', 'Statut',
  ];

  final lignes = militants.map((m) => [
    m.numeroCarte,
    m.nom,
    m.prenom,
    m.email      ?? '',
    m.telephone  ?? '',
    m.sexe       ?? '',
    m.ville      ?? '',
    m.codePostal ?? '',
    unitesMap[m.uniteId]?.nom ?? '',
    fmt.format(m.dateAdhesion),
    m.statut,
  ].map((v) => '"$v"').join(';'));

  return '${entetes.map((h) => '"$h"').join(';')}\n${lignes.join('\n')}';
}