import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_tables.dart';
import '../../domain/entities/evenement.dart';
import '../../domain/entities/presence.dart';
import '../../domain/repositories/evenements_repository.dart';
import '../providers/evenements_provider.dart';

class EvenementDetailPage extends ConsumerWidget {
  const EvenementDetailPage({super.key, required this.evenement});
  final Evenement evenement;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final presencesState = ref.watch(presencesProvider(evenement.id));
    final fmt = DateFormat('EEEE dd MMMM yyyy · HH:mm', 'fr');

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(evenement.titre, overflow: TextOverflow.ellipsis),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Infos événement ────────────────────────────────────────
          _InfoCard(evenement: evenement, fmt: fmt),
          const SizedBox(height: 12),

          // ── QR Code inscription ────────────────────────────────────
          _QrCodeCard(evenementId: evenement.id),
          const SizedBox(height: 12),

          // ── Présences ──────────────────────────────────────────────
          presencesState.when(
            initial:    () => const SizedBox.shrink(),
            chargement: () => const Center(child: CircularProgressIndicator()),
            erreur: (f) => Text('Erreur chargement présences',
                style: TextStyle(color: AppColors.secondary)),
            charge: (presences) => _PresencesCard(
              presences: presences,
              evenement: evenement,
              onAjouter: () => _ajouterPresence(context, ref),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _ajouterPresence(BuildContext context, WidgetRef ref) async {
    final params = await showDialog<ParamsEnregistrerPresence>(
      context: context,
      builder: (_) => _DialogPresence(evenementId: evenement.id),
    );
    if (params == null || !context.mounted) return;

    final result = await ref.read(presencesProvider(evenement.id).notifier)
        .enregistrerPresence(params);
    if (!context.mounted) return;
    result.fold(
      (f) => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text('Erreur'), backgroundColor: AppColors.secondary)),
      (_) => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text('Présence enregistrée'),
              backgroundColor: AppColors.primary)),
    );
  }
}

// ─── Infos événement ──────────────────────────────────────────────────────────

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.evenement, required this.fmt});
  final Evenement      evenement;
  final DateFormat     fmt;

  String _labelType(String type) =>
      AppEnums.typesEvenement.firstWhere((t) => t.$1 == type,
          orElse: () => (type, type)).$2;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(13),
          boxShadow: AppColors.cardShadow,
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Badge type
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(_labelType(evenement.type),
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700,
                    color: AppColors.primary)),
          ),
          const SizedBox(height: 12),
          _InfoLigne(Icons.calendar_today_outlined,
              fmt.format(evenement.dateDebut)),
          if (evenement.dateFin != null) ...[
            const SizedBox(height: 6),
            _InfoLigne(Icons.access_time_outlined,
                'Fin : ${fmt.format(evenement.dateFin!)}'),
          ],
          const SizedBox(height: 6),
          _InfoLigne(Icons.location_on_outlined, evenement.lieu),
          if (evenement.description != null) ...[
            const Divider(height: 20),
            Text(evenement.description!,
                style: TextStyle(fontSize: 13, color: AppColors.text2)),
          ],
        ]),
      );
}

class _InfoLigne extends StatelessWidget {
  const _InfoLigne(this.icone, this.texte);
  final IconData icone;
  final String   texte;

  @override
  Widget build(BuildContext context) => Row(children: [
        Icon(icone, size: 16, color: AppColors.text2),
        const SizedBox(width: 8),
        Expanded(child: Text(texte,
            style: const TextStyle(fontSize: 13, color: AppColors.text))),
      ]);
}

// ─── QR Code ──────────────────────────────────────────────────────────────────

class _QrCodeCard extends StatelessWidget {
  const _QrCodeCard({required this.evenementId});
  final String evenementId;

  @override
  Widget build(BuildContext context) {
    final url = '${AppConfig.appUrl}/event/$evenementId/register';
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(13),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('QR CODE D\'INSCRIPTION',
            style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700,
                color: AppColors.text2, letterSpacing: 0.8)),
        const SizedBox(height: 4),
        Text('Scannez pour vous inscrire à cet événement',
            style: TextStyle(fontSize: 11, color: AppColors.text2)),
        const SizedBox(height: 12),
        Center(
          child: QrImageView(
            data: url,
            version: QrVersions.auto,
            size: 180,
            backgroundColor: Colors.white,
            eyeStyle: const QrEyeStyle(
              eyeShape: QrEyeShape.square,
              color: AppColors.primary,
            ),
            dataModuleStyle: const QrDataModuleStyle(
              dataModuleShape: QrDataModuleShape.square,
              color: AppColors.primary,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: Text(url,
              style: TextStyle(fontSize: 10, color: AppColors.text2),
              textAlign: TextAlign.center),
        ),
      ]),
    );
  }
}

// ─── Présences ────────────────────────────────────────────────────────────────

class _PresencesCard extends StatelessWidget {
  const _PresencesCard({
    required this.presences,
    required this.evenement,
    required this.onAjouter,
  });
  final List<Presence> presences;
  final Evenement      evenement;
  final VoidCallback   onAjouter;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(13),
          boxShadow: AppColors.cardShadow,
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('PRÉSENCES',
                  style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700,
                      color: AppColors.text2, letterSpacing: 0.8)),
              Text('${presences.length} participant${presences.length > 1 ? 's' : ''}',
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900,
                      color: AppColors.text)),
            ])),
            ElevatedButton.icon(
              onPressed: onAjouter,
              icon: const Icon(Icons.person_add_outlined, size: 16),
              label: const Text('Ajouter', style: TextStyle(fontSize: 12)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ]),
          if (presences.isEmpty) ...[
            const SizedBox(height: 16),
            Center(child: Text('Aucune présence enregistrée',
                style: TextStyle(fontSize: 13, color: AppColors.text2))),
          ] else ...[
            const Divider(height: 20),
            ...presences.map((p) => _PresenceTile(presence: p)),
          ],
        ]),
      );
}

class _PresenceTile extends StatelessWidget {
  const _PresenceTile({required this.presence});
  final Presence presence;

  String get _initiales =>
      '${presence.prenom.isNotEmpty ? presence.prenom[0] : ''}${presence.nom.isNotEmpty ? presence.nom[0] : ''}'
          .toUpperCase();

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                shape: BoxShape.circle),
            child: Center(child: Text(_initiales,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700,
                    color: AppColors.primary))),
          ),
          const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('${presence.prenom} ${presence.nom}',
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
                    color: AppColors.text)),
            if (presence.telephone != null)
              Text(presence.telephone!,
                  style: TextStyle(fontSize: 11, color: AppColors.text2)),
          ])),
          if (presence.militantId != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text('Militant',
                  style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700,
                      color: AppColors.primary)),
            ),
        ]),
      );
}

// ─── Dialog ajout présence ────────────────────────────────────────────────────

class _DialogPresence extends StatefulWidget {
  const _DialogPresence({required this.evenementId});
  final String evenementId;

  @override
  State<_DialogPresence> createState() => _DialogPresenceState();
}

class _DialogPresenceState extends State<_DialogPresence> {
  final _nomCtrl    = TextEditingController();
  final _prenomCtrl = TextEditingController();
  final _telCtrl    = TextEditingController();
  final _formKey    = GlobalKey<FormState>();

  @override
  void dispose() {
    _nomCtrl.dispose();
    _prenomCtrl.dispose();
    _telCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: const Text('Enregistrer une présence'),
        content: Form(
          key: _formKey,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            TextFormField(
              controller: _prenomCtrl,
              decoration: const InputDecoration(labelText: 'Prénom'),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Requis' : null,
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _nomCtrl,
              decoration: const InputDecoration(labelText: 'Nom'),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Requis' : null,
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _telCtrl,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Téléphone (optionnel)'),
            ),
          ]),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              if (!_formKey.currentState!.validate()) return;
              Navigator.of(context).pop(
                ParamsEnregistrerPresence(
                  evenementId: widget.evenementId,
                  nom:         _nomCtrl.text.trim(),
                  prenom:      _prenomCtrl.text.trim(),
                  telephone:   _telCtrl.text.trim().isEmpty ? null : _telCtrl.text.trim(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary,
                foregroundColor: Colors.white),
            child: const Text('Enregistrer'),
          ),
        ],
      );
}