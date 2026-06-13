import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../evenements/presentation/providers/evenements_provider.dart';
import '../../domain/entities/resultat_scan.dart';
import '../providers/scan_provider.dart';

class ScanPage extends ConsumerStatefulWidget {
  const ScanPage({super.key});

  @override
  ConsumerState<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends ConsumerState<ScanPage>
    with WidgetsBindingObserver {
  late final MobileScannerController _camera;
  bool _modeEvenement = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _camera = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      returnImage: false,
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_camera.value.isInitialized) return;
    if (state == AppLifecycleState.paused)  _camera.stop();
    if (state == AppLifecycleState.resumed) _camera.start();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _camera.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    for (final barcode in capture.barcodes) {
      final raw = barcode.rawValue;
      if (raw != null && raw.isNotEmpty) {
        ref.read(scanProvider.notifier).scanner(raw);
        return;
      }
    }
  }

  void _toggleModeEvenement(bool valeur) {
    setState(() => _modeEvenement = valeur);
    if (!valeur) ref.read(scanProvider.notifier).desactiverModeEvenement();
  }

  @override
  Widget build(BuildContext context) {
    final scanState = ref.watch(scanProvider);
    final notifier  = ref.read(scanProvider.notifier);

    final afficherResultat = scanState.maybeWhen(
      resultat: (_) => true,
      erreur:   (_) => true,
      orElse:   ()  => false,
    );
    final chargement = scanState.maybeWhen(
      chargement: () => true,
      orElse:     ()  => false,
    );

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // ── Caméra ───────────────────────────────────────────────────
          MobileScanner(
            controller: _camera,
            onDetect: afficherResultat ? null : _onDetect,
          ),

          // ── Overlay de scan ──────────────────────────────────────────
          CustomPaint(
            painter: _ScanOverlayPainter(
              actif: !afficherResultat,
              chargement: chargement,
            ),
            child: const SizedBox.expand(),
          ),

          // ── Top bar ──────────────────────────────────────────────────
          SafeArea(
            child: _TopBar(
              modeEvenement: _modeEvenement,
              compteur:      notifier.modeEvenement?.compteur,
              titreModeEv:   notifier.modeEvenement?.evenementTitre,
              onToggleFlash: () => _camera.toggleTorch(),
              onToggleCam:   () => _camera.switchCamera(),
              onToggleMode:  _toggleModeEvenement,
            ),
          ),

          // ── Sélecteur événement ──────────────────────────────────────
          if (_modeEvenement && notifier.modeEvenement == null)
            Align(
              alignment: Alignment.topCenter,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(top: 72),
                  child: _SelecteurEvenement(
                    onSelected: (id, titre) {
                      notifier.activerModeEvenement(id, titre);
                      setState(() {});
                    },
                  ),
                ),
              ),
            ),

          // ── Indicateur chargement ────────────────────────────────────
          if (chargement)
            const Center(child: CircularProgressIndicator(color: Colors.white)),

          // ── Résultat ─────────────────────────────────────────────────
          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedSlide(
              offset: afficherResultat ? Offset.zero : const Offset(0, 1),
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeOut,
              child: scanState.maybeWhen(
                resultat: (r) => _ResultatOverlay(resultat: r),
                erreur: (m) => _ErreurOverlay(message: m),
                orElse: () => const SizedBox.shrink(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Top bar ──────────────────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.modeEvenement,
    required this.compteur,
    required this.titreModeEv,
    required this.onToggleFlash,
    required this.onToggleCam,
    required this.onToggleMode,
  });
  final bool         modeEvenement;
  final int?         compteur;
  final String?      titreModeEv;
  final VoidCallback onToggleFlash;
  final VoidCallback onToggleCam;
  final void Function(bool) onToggleMode;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black.withValues(alpha: 0.7), Colors.transparent],
          ),
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Row(children: [
            // Titre
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('SCAN CARTE MEMBRE',
                    style: TextStyle(color: Colors.white, fontSize: 14,
                        fontWeight: FontWeight.w900, letterSpacing: 0.5)),
                if (modeEvenement && titreModeEv != null)
                  Text('Événement : $titreModeEv',
                      style: const TextStyle(color: Colors.white70, fontSize: 10),
                      overflow: TextOverflow.ellipsis),
              ]),
            ),
            // Compteur mode événement
            if (modeEvenement && compteur != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text('$compteur présence${compteur! > 1 ? 's' : ''}',
                    style: const TextStyle(color: Colors.white, fontSize: 12,
                        fontWeight: FontWeight.w700)),
              ),
              const SizedBox(width: 8),
            ],
            // Boutons
            _CamBtn(Icons.flash_on_outlined,   onToggleFlash),
            const SizedBox(width: 8),
            _CamBtn(Icons.flip_camera_ios_outlined, onToggleCam),
          ]),
          const SizedBox(height: 8),
          // Toggle mode événement
          Row(children: [
            const Text('Mode événement',
                style: TextStyle(color: Colors.white70, fontSize: 12)),
            const Spacer(),
            Switch(
              value: modeEvenement,
              onChanged: onToggleMode,
              activeThumbColor: Colors.white,
              activeTrackColor: AppColors.primary,
            ),
          ]),
        ]),
      );
}

class _CamBtn extends StatelessWidget {
  const _CamBtn(this.icon, this.onTap);
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
      );
}

// ─── Sélecteur événement ──────────────────────────────────────────────────────

class _SelecteurEvenement extends ConsumerWidget {
  const _SelecteurEvenement({required this.onSelected});
  final void Function(String id, String titre) onSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(evenementsProvider);
    final evs = state.maybeWhen(charge: (_) {
      return state.tous;
    }, orElse: () => <dynamic>[]);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Text('Choisir un événement',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),
        if (evs.isEmpty)
          const Text('Aucun événement disponible',
              style: TextStyle(color: Colors.white70, fontSize: 12))
        else
          ...evs.take(6).map((e) => ListTile(
                dense: true,
                title: Text(e.titre,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                    overflow: TextOverflow.ellipsis),
                trailing: const Icon(Icons.chevron_right, color: Colors.white54),
                onTap: () => onSelected(e.id, e.titre),
              )),
      ]),
    );
  }
}

// ─── Overlay résultat ─────────────────────────────────────────────────────────

class _ResultatOverlay extends StatelessWidget {
  const _ResultatOverlay({required this.resultat});
  final ResultatScan resultat;

  @override
  Widget build(BuildContext context) {
    return resultat.when(
      valide: (nom, prenom, carte, _) => _Bandeau(
        couleur: AppColors.primary,
        icone:   Icons.check_circle_rounded,
        titre:   '$prenom $nom',
        sousTitre: carte != null ? 'Carte $carte · Cotisation à jour' : 'Cotisation à jour',
        bg:      const Color(0xFF0D3B0D),
      ),
      retard: (nom, prenom, carte, periode) => _Bandeau(
        couleur: AppColors.accent,
        icone:   Icons.warning_amber_rounded,
        titre:   '$prenom $nom',
        sousTitre: 'Cotisation en retard — $periode',
        bg:      const Color(0xFF3D2D00),
      ),
      suspendu: (nom, prenom) => _Bandeau(
        couleur: AppColors.secondary,
        icone:   Icons.block_rounded,
        titre:   '$prenom $nom',
        sousTitre: 'Militant suspendu ou inactif',
        bg:      const Color(0xFF3D0000),
      ),
      inconnu: () => const _Bandeau(
        couleur: AppColors.secondary,
        icone:   Icons.help_outline_rounded,
        titre:   'Carte inconnue',
        sousTitre: 'Ce QR code ne correspond à aucun militant',
        bg:      Color(0xFF2D0000),
      ),
    );
  }
}

class _ErreurOverlay extends StatelessWidget {
  const _ErreurOverlay({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) => _Bandeau(
        couleur: AppColors.secondary,
        icone:   Icons.wifi_off_rounded,
        titre:   'Erreur réseau',
        sousTitre: message,
        bg:      const Color(0xFF2D0000),
      );
}

class _Bandeau extends StatelessWidget {
  const _Bandeau({
    required this.couleur,
    required this.icone,
    required this.titre,
    required this.sousTitre,
    required this.bg,
  });
  final Color    couleur;
  final IconData icone;
  final String   titre;
  final String   sousTitre;
  final Color    bg;

  @override
  Widget build(BuildContext context) => SafeArea(
        top: false,
        child: Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: couleur.withValues(alpha: 0.5), width: 1.5),
          ),
          child: Row(children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: couleur.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icone, color: couleur, size: 30),
            ),
            const SizedBox(width: 16),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(titre,
                  style: const TextStyle(color: Colors.white, fontSize: 18,
                      fontWeight: FontWeight.w900)),
              const SizedBox(height: 4),
              Text(sousTitre,
                  style: TextStyle(color: couleur.withValues(alpha: 0.85), fontSize: 12)),
            ])),
          ]),
        ),
      );
}

// ─── Overlay caméra ───────────────────────────────────────────────────────────

class _ScanOverlayPainter extends CustomPainter {
  const _ScanOverlayPainter({required this.actif, required this.chargement});
  final bool actif;
  final bool chargement;

  @override
  void paint(Canvas canvas, Size size) {
    final frameW  = size.width * 0.68;
    final frameH  = frameW;
    final left    = (size.width  - frameW) / 2;
    final top     = (size.height - frameH) / 2 - 40;
    final frame   = RRect.fromRectAndRadius(
      Rect.fromLTWH(left, top, frameW, frameH),
      const Radius.circular(14),
    );

    // Assombrissement
    final ombre = Paint()..color = Colors.black.withValues(alpha: 0.55);
    final path  = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRRect(frame)
      ..fillType = PathFillType.evenOdd;
    canvas.drawPath(path, ombre);

    // Cadre
    final couleurCadre = actif ? Colors.white : Colors.white38;
    canvas.drawRRect(frame, Paint()
      ..color       = couleurCadre
      ..style       = PaintingStyle.stroke
      ..strokeWidth = 2.5);

    // Coins colorés
    final coin  = Paint()
      ..color       = actif ? const Color(0xFF4CAF50) : Colors.white38
      ..style       = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap   = StrokeCap.round;
    const len = 24.0;
    final tl = Offset(left, top);
    final tr = Offset(left + frameW, top);
    final bl = Offset(left, top + frameH);
    final br = Offset(left + frameW, top + frameH);

    canvas.drawLine(tl, tl + const Offset(len, 0), coin);
    canvas.drawLine(tl, tl + const Offset(0, len), coin);
    canvas.drawLine(tr, tr + const Offset(-len, 0), coin);
    canvas.drawLine(tr, tr + const Offset(0, len), coin);
    canvas.drawLine(bl, bl + const Offset(len, 0), coin);
    canvas.drawLine(bl, bl + const Offset(0, -len), coin);
    canvas.drawLine(br, br + const Offset(-len, 0), coin);
    canvas.drawLine(br, br + const Offset(0, -len), coin);
  }

  @override
  bool shouldRepaint(covariant _ScanOverlayPainter old) =>
      old.actif != actif || old.chargement != chargement;
}