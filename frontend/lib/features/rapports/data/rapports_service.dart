import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/constants/app_tables.dart';

/// Génère les 5 types de rapports PDF à partir de Supabase.
class RapportsService {
  final SupabaseClient supabase;
  RapportsService(this.supabase);

  // ── Couleurs Pastef ────────────────────────────────────────────────────────
  static final _vert  = PdfColor.fromHex('#1B4D1B');
  static final _rouge = PdfColor.fromHex('#8B0000');
  static final _or    = PdfColor.fromHex('#C8950A');
  static const _fondClair = PdfColor(0.96, 0.95, 0.94);
  static const _texte     = PdfColors.grey900;
  static const _texte2    = PdfColors.grey600;

  // ══════════════════════════════════════════════════════════════════════════
  // 1 — CRA
  // ══════════════════════════════════════════════════════════════════════════

  Future<Uint8List> genererCra({
    required String   uniteId,
    required DateTime debut,
    required DateTime fin,
  }) async {
    final militants = await supabase
        .from(AppTables.militants)
        .select('${AppTables.colSexe}, ${AppTables.colStatut}, ${AppTables.colCreatedAt}')
        .eq(AppTables.colUniteId, uniteId);

    final newMil = militants.where((m) {
      final ca = DateTime.parse(m[AppTables.colCreatedAt] as String);
      return ca.isAfter(debut) && ca.isBefore(fin.add(const Duration(days: 1)));
    }).length;

    final events = await supabase
        .from(AppTables.evenements)
        .select('${AppTables.colId}, ${AppTables.colTitre}, ${AppTables.colType}')
        .eq(AppTables.colUniteId, uniteId)
        .gte(AppTables.colDateDebut, debut.toIso8601String())
        .lte(AppTables.colDateDebut, fin.toIso8601String());

    int presTotal = 0;
    if (events.isNotEmpty) {
      final ids = events.map((e) => e[AppTables.colId] as String).toList();
      final pres = await supabase
          .from(AppTables.presences)
          .select(AppTables.colId)
          .inFilter(AppTables.colEvenementId, ids);
      presTotal = pres.length;
    }

    final reunions = await supabase
        .from(AppTables.reunions)
        .select('${AppTables.colId}, ${AppTables.colTitre}, ${AppTables.colType}')
        .eq(AppTables.colUniteId, uniteId)
        .gte(AppTables.colDate, debut.toIso8601String())
        .lte(AppTables.colDate, fin.toIso8601String());

    int decisTotal = 0;
    if (reunions.isNotEmpty) {
      final ids = reunions.map((r) => r[AppTables.colId] as String).toList();
      final decis = await supabase
          .from(AppTables.decisions)
          .select(AppTables.colId)
          .inFilter(AppTables.colReunionId, ids);
      decisTotal = decis.length;
    }

    final prospects = await supabase
        .from(AppTables.prospects)
        .select(AppTables.colEtape)
        .eq(AppTables.colUniteId, uniteId);

    final font     = await PdfGoogleFonts.openSansRegular();
    final fontBold = await PdfGoogleFonts.openSansBold();
    final fmtMois  = DateFormat('MMMM yyyy', 'fr');

    final doc = pw.Document();
    doc.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(32),
      header: (_) => _entete(font, fontBold, 'Compte Rendu d\'Activité', fmtMois.format(debut)),
      footer: (_) => _piedPage(font),
      build: (_) => [
        _sectionTitre(fontBold, 'MILITANTS'),
        _kpisLigne(font, fontBold, [
          ('Total',     '${militants.length}'),
          ('Nouveaux',  '$newMil'),
          ('Hommes',    '${militants.where((m) => m[AppTables.colSexe] == AppEnums.sexeHomme).length}'),
          ('Femmes',    '${militants.where((m) => m[AppTables.colSexe] == AppEnums.sexeFemme).length}'),
        ]),
        _espacement,
        _sectionTitre(fontBold, 'ÉVÉNEMENTS'),
        _kpisLigne(font, fontBold, [
          ('Événements', '${events.length}'),
          ('Présences',  '$presTotal'),
          ('Moy./event', events.isEmpty ? '—' : '${(presTotal / events.length).round()}'),
        ]),
        if (events.isNotEmpty) ...[
          _espacement,
          _tableau(
            font: font, fontBold: fontBold,
            entetes: ['Événement', 'Type'],
            lignes: events.map((e) => [
              e[AppTables.colTitre] as String,
              AppEnums.typesEvenement.firstWhere(
                (t) => t.$1 == e[AppTables.colType], orElse: () => ('', e[AppTables.colType] as String)).$2,
            ]).toList(),
          ),
        ],
        _espacement,
        _sectionTitre(fontBold, 'RÉUNIONS'),
        _kpisLigne(font, fontBold, [
          ('Réunions',  '${reunions.length}'),
          ('Décisions', '$decisTotal'),
        ]),
        _espacement,
        _sectionTitre(fontBold, 'PROSPECTS (TOTAL CUMULÉ)'),
        _kpisLigne(font, fontBold, [
          ('Contact',      '${prospects.where((p) => p[AppTables.colEtape] == AppEnums.etapeContact).length}'),
          ('Sympathisant', '${prospects.where((p) => p[AppTables.colEtape] == AppEnums.etapeSympathisant).length}'),
          ('Adhérent',     '${prospects.where((p) => p[AppTables.colEtape] == AppEnums.etapeAdherent).length}'),
          ('Converti',     '${prospects.where((p) => p[AppTables.colEtape] == AppEnums.etapeConverti).length}'),
        ]),
      ],
    ));
    return doc.save();
  }

  // ══════════════════════════════════════════════════════════════════════════
  // 2 — Financier
  // ══════════════════════════════════════════════════════════════════════════

  Future<Uint8List> genererFinancier({
    required String   uniteId,
    required DateTime debut,
    required DateTime fin,
  }) async {
    final transactions = await supabase
        .from(AppTables.transactions)
        .select('${AppTables.colType}, ${AppTables.colMontant}, ${AppTables.colCategorie}, ${AppTables.colDateTransaction}, ${AppTables.colDescription}')
        .eq(AppTables.colUniteId, uniteId)
        .gte(AppTables.colDateTransaction, debut.toIso8601String())
        .lte(AppTables.colDateTransaction, fin.toIso8601String())
        .order(AppTables.colDateTransaction);

    final entrees  = transactions.where((t) => t[AppTables.colType] == AppEnums.transactionEntree).toList();
    final depenses = transactions.where((t) => t[AppTables.colType] == AppEnums.transactionDepense).toList();

    double totalEntrees  = entrees.fold(0.0,  (s, t) => s + (t[AppTables.colMontant] as num).toDouble());
    double totalDepenses = depenses.fold(0.0, (s, t) => s + (t[AppTables.colMontant] as num).toDouble());
    double solde         = totalEntrees - totalDepenses;

    final font     = await PdfGoogleFonts.openSansRegular();
    final fontBold = await PdfGoogleFonts.openSansBold();
    final fmtMois  = DateFormat('MMMM yyyy', 'fr');
    final fmtMontant = NumberFormat.currency(locale: 'fr', symbol: '€');
    final fmtDate    = DateFormat('dd/MM/yy', 'fr');

    final doc = pw.Document();
    doc.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(32),
      header: (_) => _entete(font, fontBold, 'Rapport Financier', fmtMois.format(debut)),
      footer: (_) => _piedPage(font),
      build: (_) => [
        _sectionTitre(fontBold, 'SOLDE DE LA PÉRIODE'),
        _kpisLigne(font, fontBold, [
          ('Entrées',  fmtMontant.format(totalEntrees)),
          ('Dépenses', fmtMontant.format(totalDepenses)),
          ('Solde',    fmtMontant.format(solde)),
        ]),
        _espacement,
        if (entrees.isNotEmpty) ...[
          _sectionTitre(fontBold, 'ENTRÉES'),
          _tableau(
            font: font, fontBold: fontBold,
            entetes: ['Date', 'Catégorie', 'Description', 'Montant'],
            lignes: entrees.map((t) => [
              fmtDate.format(DateTime.parse(t[AppTables.colDateTransaction] as String)),
              AppCategories.label(t[AppTables.colCategorie] as String),
              (t[AppTables.colDescription] as String? ?? '—').trim(),
              fmtMontant.format((t[AppTables.colMontant] as num).toDouble()),
            ]).toList(),
          ),
          _espacement,
        ],
        if (depenses.isNotEmpty) ...[
          _sectionTitre(fontBold, 'DÉPENSES'),
          _tableau(
            font: font, fontBold: fontBold,
            entetes: ['Date', 'Catégorie', 'Description', 'Montant'],
            lignes: depenses.map((t) => [
              fmtDate.format(DateTime.parse(t[AppTables.colDateTransaction] as String)),
              AppCategories.label(t[AppTables.colCategorie] as String),
              (t[AppTables.colDescription] as String? ?? '—').trim(),
              fmtMontant.format((t[AppTables.colMontant] as num).toDouble()),
            ]).toList(),
          ),
        ],
      ],
    ));
    return doc.save();
  }

  // ══════════════════════════════════════════════════════════════════════════
  // 3 — Réunion
  // ══════════════════════════════════════════════════════════════════════════

  Future<Uint8List> genererReunion({required String reunionId}) async {
    final reunionData = await supabase
        .from(AppTables.reunions)
        .select()
        .eq(AppTables.colId, reunionId)
        .single();

    final decisionsData = await supabase
        .from(AppTables.decisions)
        .select()
        .eq(AppTables.colReunionId, reunionId)
        .order(AppTables.colCreatedAt);

    final font     = await PdfGoogleFonts.openSansRegular();
    final fontBold = await PdfGoogleFonts.openSansBold();
    final fmtDate  = DateFormat('EEEE dd MMMM yyyy · HH:mm', 'fr');
    final fmtEch   = DateFormat('dd/MM/yyyy', 'fr');

    final typeLabel = AppEnums.typesReunion.firstWhere(
      (t) => t.$1 == reunionData[AppTables.colType],
      orElse: () => ('', reunionData[AppTables.colType] as String)).$2;

    final date = DateTime.parse(reunionData[AppTables.colDate] as String);

    final doc = pw.Document();
    doc.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(32),
      header: (_) => _entete(font, fontBold, 'Compte Rendu de Réunion',
          fmtDate.format(date)),
      footer: (_) => _piedPage(font),
      build: (_) => [
        _sectionTitre(fontBold, 'INFORMATIONS'),
        _ligneInfo(font, fontBold, 'Titre',       reunionData[AppTables.colTitre] as String),
        _ligneInfo(font, fontBold, 'Type',        typeLabel),
        _ligneInfo(font, fontBold, 'Lieu',        reunionData[AppTables.colLieu] as String),
        _ligneInfo(font, fontBold, 'Date',        fmtDate.format(date)),
        if (reunionData[AppTables.colOrdreJour] != null) ...[
          _espacement,
          _sectionTitre(fontBold, 'ORDRE DU JOUR'),
          pw.Padding(
            padding: const pw.EdgeInsets.symmetric(vertical: 4),
            child: _texteMultiligne(font, reunionData[AppTables.colOrdreJour] as String),
          ),
        ],
        _espacement,
        _sectionTitre(fontBold, 'DÉCISIONS (${decisionsData.length})'),
        if (decisionsData.isEmpty)
          pw.Text('Aucune décision enregistrée.',
              style: pw.TextStyle(font: font, fontSize: 10, color: _texte2))
        else
          _tableau(
            font: font, fontBold: fontBold,
            entetes: ['Décision', 'Responsable', 'Échéance', 'Statut'],
            lignes: decisionsData.map((d) {
              final ech = d[AppTables.colEcheance];
              return [
                d[AppTables.colTexte] as String,
                d[AppTables.colResponsable] as String? ?? '—',
                ech != null ? fmtEch.format(DateTime.parse(ech as String)) : '—',
                _labelStatutDecision(d[AppTables.colStatut] as String),
              ];
            }).toList(),
          ),
      ],
    ));
    return doc.save();
  }

  // ══════════════════════════════════════════════════════════════════════════
  // 4 — Événement
  // ══════════════════════════════════════════════════════════════════════════

  Future<Uint8List> genererEvenement({required String evenementId}) async {
    final evData = await supabase
        .from(AppTables.evenements)
        .select()
        .eq(AppTables.colId, evenementId)
        .single();

    final presData = await supabase
        .from(AppTables.presences)
        .select('${AppTables.colNom}, ${AppTables.colPrenom}, ${AppTables.colTelephone}, ${AppTables.colMilitantId}')
        .eq(AppTables.colEvenementId, evenementId)
        .order(AppTables.colNom);

    final font     = await PdfGoogleFonts.openSansRegular();
    final fontBold = await PdfGoogleFonts.openSansBold();
    final fmtDate  = DateFormat('EEEE dd MMMM yyyy · HH:mm', 'fr');

    final typeLabel = AppEnums.typesEvenement.firstWhere(
      (t) => t.$1 == evData[AppTables.colType],
      orElse: () => ('', evData[AppTables.colType] as String)).$2;

    final doc = pw.Document();
    doc.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(32),
      header: (_) => _entete(font, fontBold, 'Rapport d\'Événement',
          evData[AppTables.colTitre] as String),
      footer: (_) => _piedPage(font),
      build: (_) => [
        _sectionTitre(fontBold, 'INFORMATIONS'),
        _ligneInfo(font, fontBold, 'Type',  typeLabel),
        _ligneInfo(font, fontBold, 'Début', fmtDate.format(
            DateTime.parse(evData[AppTables.colDateDebut] as String))),
        _ligneInfo(font, fontBold, 'Lieu',  evData[AppTables.colLieu] as String),
        if (evData[AppTables.colDescription] != null)
          _ligneInfo(font, fontBold, 'Description', evData[AppTables.colDescription] as String),
        _espacement,
        _sectionTitre(fontBold, 'LISTE DES PRÉSENCES (${presData.length})'),
        if (presData.isEmpty)
          pw.Text('Aucune présence enregistrée.',
              style: pw.TextStyle(font: font, fontSize: 10, color: _texte2))
        else
          _tableau(
            font: font, fontBold: fontBold,
            entetes: ['Prénom', 'Nom', 'Téléphone', 'Militant'],
            lignes: presData.map((p) => [
              p[AppTables.colPrenom] as String,
              p[AppTables.colNom] as String,
              p[AppTables.colTelephone] as String? ?? '—',
              p[AppTables.colMilitantId] != null ? 'Oui' : '—',
            ]).toList(),
          ),
      ],
    ));
    return doc.save();
  }

  // ══════════════════════════════════════════════════════════════════════════
  // 5 — Cotisations
  // ══════════════════════════════════════════════════════════════════════════

  Future<Uint8List> genererCotisations({
    required String uniteId,
    required int    annee,
    required int    mois,
  }) async {
    final militants = await supabase
        .from(AppTables.militants)
        .select('${AppTables.colId}, ${AppTables.colNom}, ${AppTables.colPrenom}')
        .eq(AppTables.colUniteId, uniteId)
        .eq(AppTables.colStatut, AppEnums.militantActif)
        .order(AppTables.colNom);

    final milIds = militants.map((m) => m[AppTables.colId] as String).toList();
    final cotisations = milIds.isEmpty
        ? <Map<String, dynamic>>[]
        : await supabase
            .from(AppTables.cotisations)
            .select('${AppTables.colMilitantId}, ${AppTables.colStatutCotis}, ${AppTables.colMontantPaye}, ${AppTables.colMontantDu}')
            .eq(AppTables.colAnnee, annee)
            .eq(AppTables.colMois, mois)
            .inFilter(AppTables.colMilitantId, milIds);

    final font     = await PdfGoogleFonts.openSansRegular();
    final fontBold = await PdfGoogleFonts.openSansBold();
    final fmtMontant = NumberFormat.currency(locale: 'fr', symbol: '€');
    final nomMois = DateFormat('MMMM yyyy', 'fr').format(DateTime(annee, mois));

    final payees     = cotisations.where((c) => c[AppTables.colStatutCotis] == AppEnums.cotisationPayee).length;
    final enAttente  = cotisations.where((c) => c[AppTables.colStatutCotis] == AppEnums.cotisationEnAttente).length;
    final enRetard   = cotisations.where((c) => c[AppTables.colStatutCotis] == AppEnums.cotisationEnRetard).length;
    final sansCotis  = militants.length - cotisations.length;

    final doc = pw.Document();
    doc.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(32),
      header: (_) => _entete(font, fontBold, 'Rapport des Cotisations', nomMois),
      footer: (_) => _piedPage(font),
      build: (_) => [
        _sectionTitre(fontBold, 'RÉCAPITULATIF'),
        _kpisLigne(font, fontBold, [
          ('Payées',      '$payees'),
          ('En attente',  '$enAttente'),
          ('En retard',   '$enRetard'),
          ('Non saisi',   '$sansCotis'),
        ]),
        _espacement,
        _sectionTitre(fontBold, 'DÉTAIL PAR MILITANT'),
        _tableau(
          font: font, fontBold: fontBold,
          entetes: ['Militant', 'Statut', 'Payé', 'Dû'],
          lignes: militants.map((m) {
            final cotis = cotisations.cast<Map<String, dynamic>?>().firstWhere(
              (c) => c![AppTables.colMilitantId] == m[AppTables.colId],
              orElse: () => null,
            );
            return [
              '${m[AppTables.colPrenom]} ${m[AppTables.colNom]}',
              cotis != null ? _labelStatutCotis(cotis[AppTables.colStatutCotis] as String) : 'Non saisi',
              cotis != null ? fmtMontant.format((cotis[AppTables.colMontantPaye] as num).toDouble()) : '—',
              cotis != null ? fmtMontant.format((cotis[AppTables.colMontantDu] as num).toDouble()) : '—',
            ];
          }).toList(),
        ),
      ],
    ));
    return doc.save();
  }

  // ══════════════════════════════════════════════════════════════════════════
  // 6 — Rapport d'Activité (dashboard)
  // ══════════════════════════════════════════════════════════════════════════

  Future<Uint8List> genererRapportActivite({
    String?  uniteId, // null = global (BEX)
    required DateTime debut,
    required DateTime fin,
    bool inclureMilitants  = true,
    bool inclureProspects  = true,
    bool inclureFinances   = true,
    bool inclureEvenements = true,
    bool inclureReunions   = true,
    bool inclureBureau     = true,
  }) async {
    // Nom de l'unité
    String uniteNom = 'Section France';
    if (uniteId != null) {
      try {
        final ud = await supabase
            .from(AppTables.unitesOrganisationnelles)
            .select(AppTables.colCode)
            .eq(AppTables.colId, uniteId)
            .maybeSingle();
        if (ud != null) uniteNom = ud[AppTables.colCode] as String? ?? uniteNom;
      } catch (_) {}
    }

    final fmtPeriode = DateFormat('dd/MM/yyyy', 'fr');
    final periodeLabel = '${fmtPeriode.format(debut)} — ${fmtPeriode.format(fin)}';

    // Helper query optionnel par unité
    dynamic _filtreUnite(dynamic q) => uniteId != null ? q.eq(AppTables.colUniteId, uniteId) : q;

    // ── MILITANTS ─────────────────────────────────────────────────────────────
    List<Map<String, dynamic>> militants = [];
    if (inclureMilitants || inclureFinances) {
      militants = List<Map<String, dynamic>>.from(await _filtreUnite(supabase
          .from(AppTables.militants)
          .select('${AppTables.colId}, ${AppTables.colSexe}, ${AppTables.colStatut}, ${AppTables.colCreatedAt}'))
          .eq(AppTables.colStatut, AppEnums.militantActif));
    }

    final milIds = militants.map((m) => m[AppTables.colId] as String).toList();
    final newMil = militants.where((m) {
      final ca = DateTime.parse(m[AppTables.colCreatedAt] as String);
      return !ca.isBefore(debut) && !ca.isAfter(fin);
    }).length;

    // Cotisations (pour le taux de recouvrement, uniquement si section militants ou finances)
    List<Map<String, dynamic>> cotisations = [];
    if ((inclureMilitants || inclureFinances) && milIds.isNotEmpty) {
      cotisations = List<Map<String, dynamic>>.from(await supabase
          .from(AppTables.cotisations)
          .select('${AppTables.colMilitantId}, ${AppTables.colStatutCotis}')
          .eq(AppTables.colAnnee, debut.year)
          .inFilter(AppTables.colMilitantId, milIds));
    }
    final cotMilIds = cotisations.map((c) => c[AppTables.colMilitantId] as String).toSet();
    final aJour    = cotisations.where((c) { final s = c[AppTables.colStatutCotis] as String; return s == AppEnums.cotisationPayee || s == AppEnums.cotisationPartiel; }).length;
    final enRetard = cotisations.where((c) => c[AppTables.colStatutCotis] == AppEnums.cotisationEnRetard).length;
    final inactif  = milIds.length - cotMilIds.length;
    final taux     = milIds.isNotEmpty ? aJour / milIds.length : 0.0;

    // ── PROSPECTS ─────────────────────────────────────────────────────────────
    List<Map<String, dynamic>> prospects = [];
    if (inclureProspects) {
      prospects = List<Map<String, dynamic>>.from(await _filtreUnite(supabase
          .from(AppTables.prospects)
          .select('${AppTables.colEtape}, ${AppTables.colCreatedAt}')));
    }
    final prosperiode = prospects.where((p) {
      final d = DateTime.parse(p[AppTables.colCreatedAt] as String);
      return !d.isBefore(debut) && !d.isAfter(fin);
    }).toList();

    // ── FINANCES ──────────────────────────────────────────────────────────────
    List<Map<String, dynamic>> transactions = [];
    if (inclureFinances) {
      transactions = List<Map<String, dynamic>>.from(await _filtreUnite(supabase
          .from(AppTables.transactions)
          .select('${AppTables.colType}, ${AppTables.colMontant}, ${AppTables.colCategorie}, ${AppTables.colDateTransaction}'))
          .gte(AppTables.colDateTransaction, debut.toIso8601String())
          .lte(AppTables.colDateTransaction, fin.toIso8601String())
          .order(AppTables.colDateTransaction));
    }
    final entrees  = transactions.where((t) => t[AppTables.colType] == AppEnums.transactionEntree).toList();
    final depenses = transactions.where((t) => t[AppTables.colType] == AppEnums.transactionDepense).toList();
    final totalE   = entrees.fold(0.0,  (s, t) => s + (t[AppTables.colMontant] as num).toDouble());
    final totalD   = depenses.fold(0.0, (s, t) => s + (t[AppTables.colMontant] as num).toDouble());

    final parCatE = <String, double>{};
    for (final t in entrees) { final c = t[AppTables.colCategorie] as String; parCatE[c] = (parCatE[c] ?? 0) + (t[AppTables.colMontant] as num).toDouble(); }
    final parCatD = <String, double>{};
    for (final t in depenses) { final c = t[AppTables.colCategorie] as String; parCatD[c] = (parCatD[c] ?? 0) + (t[AppTables.colMontant] as num).toDouble(); }

    // ── ÉVÉNEMENTS ────────────────────────────────────────────────────────────
    List<Map<String, dynamic>> evenements = [];
    int presTotal = 0;
    if (inclureEvenements) {
      evenements = List<Map<String, dynamic>>.from(await _filtreUnite(supabase
          .from(AppTables.evenements)
          .select('${AppTables.colId}, ${AppTables.colTitre}, ${AppTables.colType}, ${AppTables.colDateDebut}, ${AppTables.colLieu}'))
          .gte(AppTables.colDateDebut, debut.toIso8601String())
          .lte(AppTables.colDateDebut, fin.toIso8601String())
          .order(AppTables.colDateDebut));
      if (evenements.isNotEmpty) {
        final ids = evenements.map((e) => e[AppTables.colId] as String).toList();
        final pres = await supabase.from(AppTables.presences).select(AppTables.colId).inFilter(AppTables.colEvenementId, ids);
        presTotal = pres.length;
      }
    }

    // ── RÉUNIONS ──────────────────────────────────────────────────────────────
    List<Map<String, dynamic>> reunions = [];
    int decisTotal = 0;
    if (inclureReunions) {
      reunions = List<Map<String, dynamic>>.from(await _filtreUnite(supabase
          .from(AppTables.reunions)
          .select('${AppTables.colId}, ${AppTables.colTitre}, ${AppTables.colType}, ${AppTables.colDate}, ${AppTables.colLieu}'))
          .gte(AppTables.colDate, debut.toIso8601String())
          .lte(AppTables.colDate, fin.toIso8601String())
          .order(AppTables.colDate));
      if (reunions.isNotEmpty) {
        final ids = reunions.map((r) => r[AppTables.colId] as String).toList();
        final decis = await supabase.from(AppTables.decisions).select(AppTables.colId).inFilter(AppTables.colReunionId, ids);
        decisTotal = decis.length;
      }
    }

    // ── BUREAU ────────────────────────────────────────────────────────────────
    List<Map<String, dynamic>> postes = [];
    if (inclureBureau) {
      postes = List<Map<String, dynamic>>.from(await _filtreUnite(supabase
          .from(AppTables.postesBureau)
          .select('${AppTables.colIntitule}, ${AppTables.colMilitantNom}, ${AppTables.colMilitantPrenom}, ${AppTables.colDateNomination}'))
          .order(AppTables.colIntitule));
    }

    // ── PDF ───────────────────────────────────────────────────────────────────
    final font     = await PdfGoogleFonts.openSansRegular();
    final fontBold = await PdfGoogleFonts.openSansBold();
    final fmtM     = NumberFormat.currency(locale: 'fr', symbol: '€', decimalDigits: 0);
    final fmtDate  = DateFormat('dd/MM/yyyy', 'fr');
    final fmtDateH = DateFormat('dd/MM/yy · HH:mm', 'fr');

    final sections = <pw.Widget>[];

    // MILITANTS
    if (inclureMilitants) {
      sections.addAll([
        _sectionTitre(fontBold, 'MILITANTS'),
        _kpisLigne(font, fontBold, [
          ('Total actifs',  '${militants.length}'),
          ('Nouveaux',      '$newMil'),
          ('Hommes',        '${militants.where((m) => m[AppTables.colSexe] == AppEnums.sexeHomme).length}'),
          ('Femmes',        '${militants.where((m) => m[AppTables.colSexe] == AppEnums.sexeFemme).length}'),
        ]),
        _espacement,
        _sectionTitre(fontBold, 'TAUX DE RECOUVREMENT'),
        _blocRecouvrement(font, fontBold, aJour, enRetard, inactif, milIds.length, taux),
        _espacement,
      ]);
    }

    // PROSPECTS
    if (inclureProspects) {
      sections.addAll([
        _sectionTitre(fontBold, 'PROSPECTS'),
        _kpisLigne(font, fontBold, [
          ('Sur la période', '${prosperiode.length}'),
          ('Contact',        '${prospects.where((p) => p[AppTables.colEtape] == AppEnums.etapeContact).length}'),
          ('Sympathisant',   '${prospects.where((p) => p[AppTables.colEtape] == AppEnums.etapeSympathisant).length}'),
          ('Converti',       '${prospects.where((p) => p[AppTables.colEtape] == AppEnums.etapeConverti).length}'),
        ]),
        _espacement,
      ]);
    }

    // FINANCES
    if (inclureFinances) {
      sections.addAll([
        _sectionTitre(fontBold, 'FINANCES'),
        _kpisLigne(font, fontBold, [
          ('Entrées',  fmtM.format(totalE)),
          ('Dépenses', fmtM.format(totalD)),
          ('Solde',    fmtM.format(totalE - totalD)),
        ]),
        if (parCatE.isNotEmpty) ...[
          _espacement,
          _sectionTitre(fontBold, 'ENTRÉES PAR CATÉGORIE'),
          _tableauCategories(font, fontBold, parCatE, fmtM),
        ],
        if (parCatD.isNotEmpty) ...[
          _espacement,
          _sectionTitre(fontBold, 'DÉPENSES PAR CATÉGORIE'),
          _tableauCategories(font, fontBold, parCatD, fmtM),
        ],
        _espacement,
      ]);
    }

    // ÉVÉNEMENTS
    if (inclureEvenements) {
      sections.addAll([
        _sectionTitre(fontBold, 'ÉVÉNEMENTS (${evenements.length})'),
        _kpisLigne(font, fontBold, [
          ('Événements', '${evenements.length}'),
          ('Présences',  '$presTotal'),
          ('Moy./event', evenements.isEmpty ? '—' : '${(presTotal / evenements.length).round()}'),
        ]),
        if (evenements.isNotEmpty) ...[
          _espacement,
          _tableau(
            font: font, fontBold: fontBold,
            entetes: ['Date', 'Titre', 'Type', 'Lieu'],
            lignes: evenements.map((e) => [
              fmtDate.format(DateTime.parse(e[AppTables.colDateDebut] as String)),
              e[AppTables.colTitre] as String,
              AppEnums.typesEvenement.firstWhere((t) => t.$1 == e[AppTables.colType], orElse: () => ('', e[AppTables.colType] as String)).$2,
              e[AppTables.colLieu] as String? ?? '—',
            ]).toList(),
          ),
        ],
        _espacement,
      ]);
    }

    // RÉUNIONS
    if (inclureReunions) {
      sections.addAll([
        _sectionTitre(fontBold, 'RÉUNIONS (${reunions.length})'),
        _kpisLigne(font, fontBold, [
          ('Réunions',  '${reunions.length}'),
          ('Décisions', '$decisTotal'),
        ]),
        if (reunions.isNotEmpty) ...[
          _espacement,
          _tableau(
            font: font, fontBold: fontBold,
            entetes: ['Date', 'Titre', 'Type', 'Lieu'],
            lignes: reunions.map((r) => [
              fmtDateH.format(DateTime.parse(r[AppTables.colDate] as String)),
              r[AppTables.colTitre] as String,
              AppEnums.typesReunion.firstWhere((t) => t.$1 == r[AppTables.colType], orElse: () => ('', r[AppTables.colType] as String)).$2,
              r[AppTables.colLieu] as String? ?? '—',
            ]).toList(),
          ),
        ],
        _espacement,
      ]);
    }

    // BUREAU
    if (inclureBureau && postes.isNotEmpty) {
      sections.addAll([
        _sectionTitre(fontBold, 'COMPOSITION DU BUREAU'),
        _tableau(
          font: font, fontBold: fontBold,
          entetes: ['Poste', 'Titulaire', 'Depuis'],
          lignes: postes.map((p) => [
            p[AppTables.colIntitule] as String? ?? '—',
            '${p[AppTables.colMilitantPrenom] ?? ''} ${p[AppTables.colMilitantNom] ?? ''}'.trim(),
            p[AppTables.colDateNomination] != null
                ? fmtDate.format(DateTime.parse(p[AppTables.colDateNomination] as String))
                : '—',
          ]).toList(),
        ),
      ]);
    }

    if (sections.isEmpty) {
      sections.add(pw.Text('Aucune section sélectionnée.',
          style: pw.TextStyle(font: font, fontSize: 11, color: _texte2)));
    }

    final doc = pw.Document();
    doc.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(32),
      header: (_) => _entete(font, fontBold, 'Rapport d\'Activité', '$uniteNom · $periodeLabel'),
      footer: (_) => _piedPage(font),
      build: (_) => sections,
    ));
    return doc.save();
  }

  // ══════════════════════════════════════════════════════════════════════════
  // Éléments PDF communs
  // ══════════════════════════════════════════════════════════════════════════

  pw.Widget _entete(pw.Font font, pw.Font fontBold, String titre, String sousTitre) {
    return pw.Container(
      color: _vert,
      padding: const pw.EdgeInsets.fromLTRB(20, 14, 20, 14),
      child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
          pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
            pw.Text('PASTEF FRANCE',
                style: pw.TextStyle(font: fontBold, color: PdfColors.white,
                    fontSize: 13, letterSpacing: 2)),
            pw.Text('Plateforme Militante',
                style: pw.TextStyle(font: font, color: PdfColors.grey300, fontSize: 8)),
          ]),
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: _or, width: 1),
              borderRadius: pw.BorderRadius.circular(4),
            ),
            child: pw.Text('CONFIDENTIEL',
                style: pw.TextStyle(font: fontBold, color: _or, fontSize: 7, letterSpacing: 1)),
          ),
        ]),
        pw.Divider(color: _or, thickness: 0.5),
        pw.Text(titre,
            style: pw.TextStyle(font: fontBold, color: PdfColors.white, fontSize: 15)),
        pw.Text(sousTitre,
            style: pw.TextStyle(font: font, color: PdfColors.grey300, fontSize: 9)),
      ]),
    );
  }

  pw.Widget _piedPage(pw.Font font) {
    final fmt = DateFormat('dd/MM/yyyy à HH:mm', 'fr');
    return pw.Container(
      decoration: const pw.BoxDecoration(
        border: pw.Border(top: pw.BorderSide(color: PdfColors.grey300)),
      ),
      padding: const pw.EdgeInsets.only(top: 6),
      child: pw.Row(children: [
        pw.Text('Généré le ${fmt.format(DateTime.now())}',
            style: pw.TextStyle(font: font, fontSize: 8, color: _texte2)),
        pw.Spacer(),
        pw.Text('Cockpit — Section France Pastef',
            style: pw.TextStyle(font: font, fontSize: 8, color: _texte2)),
      ]),
    );
  }

  pw.Widget _sectionTitre(pw.Font fontBold, String titre) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 8),
      child: pw.Row(children: [
        pw.Container(width: 3, height: 14, color: _vert),
        pw.SizedBox(width: 8),
        pw.Text(titre,
            style: pw.TextStyle(font: fontBold, fontSize: 10,
                color: _vert, letterSpacing: 0.5)),
      ]),
    );
  }

  pw.Widget _kpisLigne(pw.Font font, pw.Font fontBold, List<(String, String)> items) {
    return pw.Row(
      children: items.map((item) => pw.Expanded(
        child: pw.Container(
          margin: const pw.EdgeInsets.only(right: 6, bottom: 4),
          padding: const pw.EdgeInsets.all(10),
          decoration: pw.BoxDecoration(
            color: _fondClair,
            border: pw.Border(left: pw.BorderSide(color: _vert, width: 3)),
          ),
          child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
            pw.Text(item.$2,
                style: pw.TextStyle(font: fontBold, fontSize: 18, color: _texte)),
            pw.Text(item.$1,
                style: pw.TextStyle(font: font, fontSize: 7, color: _texte2)),
          ]),
        ),
      )).toList(),
    );
  }

  pw.Widget _ligneInfo(pw.Font font, pw.Font fontBold, String label, String valeur) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 3),
      child: pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
        pw.SizedBox(width: 90,
          child: pw.Text(label,
              style: pw.TextStyle(font: fontBold, fontSize: 9, color: _texte2))),
        pw.Expanded(child: _texteMultiligne(font, valeur, fontSize: 9, color: _texte)),
      ]),
    );
  }

  pw.Widget _texteMultiligne(pw.Font font, String texte, {double fontSize = 10, PdfColor? color}) {
    // Normalise les \n littéraux (venant du SQL) ET les vrais sauts de ligne (saisie utilisateur)
    final lignes = texte.replaceAll(r'\n', '\n').split('\n');
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: lignes.map((ligne) => pw.Text(
        ligne,
        style: pw.TextStyle(font: font, fontSize: fontSize, color: color ?? _texte2),
      )).toList(),
    );
  }

  pw.Widget _tableau({
    required pw.Font font,
    required pw.Font fontBold,
    required List<String> entetes,
    required List<List<String>> lignes,
  }) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
      children: [
        pw.TableRow(
          decoration: pw.BoxDecoration(color: _vert),
          children: entetes.map((h) => pw.Padding(
            padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: pw.Text(h,
                style: pw.TextStyle(font: fontBold, fontSize: 8,
                    color: PdfColors.white)),
          )).toList(),
        ),
        ...lignes.asMap().entries.map((entry) {
          final pair = entry.value;
          final isOdd = entry.key.isOdd;
          return pw.TableRow(
            decoration: isOdd ? pw.BoxDecoration(color: _fondClair) : null,
            children: pair.map((cell) => pw.Padding(
              padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: pw.Text(cell,
                  style: pw.TextStyle(font: font, fontSize: 8, color: _texte)),
            )).toList(),
          );
        }),
      ],
    );
  }

  pw.SizedBox get _espacement => pw.SizedBox(height: 16);

  pw.Widget _blocRecouvrement(pw.Font font, pw.Font fontBold,
      int aJour, int enRetard, int inactif, int total, double taux) {
    final pct = (taux * 100).round();
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(color: _fondClair, borderRadius: pw.BorderRadius.circular(4)),
      child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
        pw.Row(children: [
          pw.Text('$pct%', style: pw.TextStyle(font: fontBold, fontSize: 30, color: _vert)),
          pw.Spacer(),
          pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.end, children: [
            pw.Text('$aJour / $total militants',
                style: pw.TextStyle(font: fontBold, fontSize: 10, color: _texte)),
            pw.Text('Objectif : 80%',
                style: pw.TextStyle(font: font, fontSize: 9, color: _texte2)),
          ]),
        ]),
        pw.SizedBox(height: 8),
        _barreProgression(taux),
        pw.SizedBox(height: 8),
        pw.Row(children: [
          pw.Text('● À jour : $aJour',  style: pw.TextStyle(font: font, fontSize: 8, color: _vert)),
          pw.SizedBox(width: 14),
          pw.Text('● Retard : $enRetard', style: pw.TextStyle(font: font, fontSize: 8, color: _or)),
          pw.SizedBox(width: 14),
          pw.Text('● Inactif : $inactif', style: pw.TextStyle(font: font, fontSize: 8, color: _rouge)),
        ]),
      ]),
    );
  }

  pw.Widget _barreProgression(double taux) {
    final pct = (taux * 100).round().clamp(0, 100);
    return pw.SizedBox(
      height: 8,
      child: pw.Row(children: [
        if (pct > 0)   pw.Expanded(flex: pct,       child: pw.Container(color: _vert)),
        if (pct < 100) pw.Expanded(flex: 100 - pct, child: pw.Container(color: PdfColors.grey300)),
      ]),
    );
  }

  pw.Widget _tableauCategories(pw.Font font, pw.Font fontBold,
      Map<String, double> data, NumberFormat fmt) {
    final sorted = data.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    final total  = data.values.fold(0.0, (s, v) => s + v);
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
      children: [
        pw.TableRow(
          decoration: pw.BoxDecoration(color: _vert),
          children: ['Catégorie', 'Montant', '%'].map((h) => pw.Padding(
            padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: pw.Text(h, style: pw.TextStyle(font: fontBold, fontSize: 8, color: PdfColors.white)),
          )).toList(),
        ),
        ...sorted.asMap().entries.map((entry) {
          final isOdd = entry.key.isOdd;
          final cat   = entry.value.key;
          final montant = entry.value.value;
          final pct   = total > 0 ? (montant / total * 100).round() : 0;
          return pw.TableRow(
            decoration: isOdd ? pw.BoxDecoration(color: _fondClair) : null,
            children: [
              _cellule(font, AppCategories.label(cat)),
              _cellule(font, fmt.format(montant)),
              _cellule(font, '$pct%'),
            ],
          );
        }),
      ],
    );
  }

  pw.Widget _cellule(pw.Font font, String texte) => pw.Padding(
    padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 5),
    child: pw.Text(texte, style: pw.TextStyle(font: font, fontSize: 8, color: _texte)),
  );

  String _labelStatutDecision(String s) => switch (s) {
    AppEnums.decisionEnAttente => 'En attente',
    AppEnums.decisionEnCours   => 'En cours',
    AppEnums.decisionTerminee  => 'Terminée',
    AppEnums.decisionAbandon   => 'Abandonnée',
    _                          => s,
  };

  String _labelStatutCotis(String s) => switch (s) {
    AppEnums.cotisationPayee     => 'Payée',
    AppEnums.cotisationPartiel   => 'Partielle',
    AppEnums.cotisationEnAttente => 'En attente',
    AppEnums.cotisationEnRetard  => 'En retard',
    _                            => s,
  };
}