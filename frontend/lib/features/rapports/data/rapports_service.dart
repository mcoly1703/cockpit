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
  static final _vert = PdfColor.fromHex('#1B4D1B');
  static final _or   = PdfColor.fromHex('#C8950A');
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
            child: pw.Text(reunionData[AppTables.colOrdreJour] as String,
                style: pw.TextStyle(font: font, fontSize: 10, color: _texte2)),
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
        pw.Expanded(child: pw.Text(valeur,
            style: pw.TextStyle(font: font, fontSize: 9, color: _texte))),
      ]),
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