import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_colors.dart';
import '../constants/app_routes.dart';
import '../constants/app_tables.dart';
import '../../features/auth/domain/entities/utilisateur.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';

class AppShell extends ConsumerWidget {
  const AppShell({required this.child, super.key});
  final Widget child;

  static const List<String> _tabRoutes = [
    AppRoutes.dashboard,
    AppRoutes.militants,
    AppRoutes.finances,
    AppRoutes.prospects,
    AppRoutes.modules,
  ];

  void _showMenuUtilisateur(
      BuildContext context, WidgetRef ref, Utilisateur? utilisateur) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _MenuUtilisateur(
        utilisateur: utilisateur,
        onDeconnexion: () async {
          Navigator.of(context).pop();
          await ref.read(authProvider.notifier).seDeconnecter();
        },
      ),
    );
  }

  int _tabIndex(String location) {
    for (int i = 0; i < _tabRoutes.length; i++) {
      if (location.startsWith(_tabRoutes[i])) return i;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final utilisateur = ref.watch(authProvider).whenOrNull(connecte: (u) => u);
    final location    = GoRouterState.of(context).uri.path;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _Topbar(
            utilisateur: utilisateur,
            onScanTap:   () => context.go(AppRoutes.scan),
            onAvatarTap: () => _showMenuUtilisateur(context, ref, utilisateur),
          ),
          _RoleBanner(utilisateur: utilisateur),
          Expanded(child: child),
        ],
      ),
      bottomNavigationBar: _BottomNav(
        currentIndex: _tabIndex(location),
        onTap: (i) => context.go(_tabRoutes[i]),
      ),
    );
  }
}

String _initiales(Utilisateur? u) {
  if (u == null) return '?';
  final p = u.prenom.isNotEmpty ? u.prenom[0] : '?';
  final n = u.nom.isNotEmpty ? u.nom[0] : '';
  return '$p$n'.toUpperCase();
}

// ---------- TOPBAR ----------

class _Topbar extends StatelessWidget {
  const _Topbar({
    required this.utilisateur,
    required this.onScanTap,
    required this.onAvatarTap,
  });
  final Utilisateur? utilisateur;
  final VoidCallback onScanTap;
  final VoidCallback onAvatarTap;

  @override
  Widget build(BuildContext context) {
    final initiales = _initiales(utilisateur);
    const sousTitre = 'Section France';

    return Container(
      color: AppColors.primary,
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 56,
          child: Stack(
            children: [
              // Fond bicolore vert | rouge
              Row(children: [
                Expanded(child: Container(color: AppColors.primary)),
                Expanded(child: Container(color: AppColors.secondary)),
              ]),

              // Contenu
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  children: [
                    // Titre gauche
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'PASTEF',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2,
                            ),
                          ),
                          Text(
                            sousTitre.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 8,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Bouton scan
                    _TopbarBtn(
                      icon:  Icons.qr_code_scanner_rounded,
                      onTap: onScanTap,
                    ),
                    const SizedBox(width: 8),

                    // Bouton notifications avec point
                    Stack(
                      children: [
                        _TopbarBtn(icon: Icons.notifications_outlined, onTap: () {}),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: Container(
                            width: 7,
                            height: 7,
                            decoration: const BoxDecoration(
                              color: AppColors.accent,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 8),

                    // Avatar (tappable → menu utilisateur)
                    GestureDetector(
                      onTap: onAvatarTap,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.25),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.4),
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            initiales,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopbarBtn extends StatelessWidget {
  const _TopbarBtn({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 17),
      ),
    );
  }
}

// ---------- ROLE BANNER ----------

class _RoleBanner extends StatelessWidget {
  const _RoleBanner({required this.utilisateur});
  final Utilisateur? utilisateur;

  String _labelRole(String? role) {
    if (role == null) return '—';
    return switch (role) {
      AppRoles.bureauExecutif         => 'Bureau Exécutif',
      AppRoles.coordinateur           => 'Coordinateur',
      AppRoles.responsableSousSection => 'Resp. Sous-section',
      AppRoles.responsableMouvement   => 'Resp. Mouvement',
      AppRoles.responsableSecretariat => 'Resp. Secrétariat',
      AppRoles.coordinateurCellule    => 'Coord. Cellule',
      AppRoles.adminTechnique         => 'Admin Technique',
      _ => role,
    };
  }

  String _labelPerimetre(Utilisateur? u) {
    if (u == null) return '';
    final role = u.role;
    if (role == AppRoles.bureauExecutif || role == AppRoles.coordinateur) {
      return 'Vue globale France';
    }
    return u.uniteOrganisationnelleId ?? 'Pastef France';
  }

  @override
  Widget build(BuildContext context) {
    final role      = _labelRole(utilisateur?.role);
    final perimetre = _labelPerimetre(utilisateur);

    return Container(
      color: AppColors.primary,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      child: Row(
        children: [
          Text(
            role,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
            ),
          ),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              perimetre,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------- BOTTOM NAV ----------

class _BottomNav extends StatelessWidget {
  const _BottomNav({
    required this.currentIndex,
    required this.onTap,
  });
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    const labels = [
      'Accueil',
      'Militants',
      'Finances',
      'Prospects',
      'Modules',
    ];

    const icons = [
      Icons.home_rounded,
      Icons.people_rounded,
      Icons.account_balance_wallet_rounded,
      Icons.person_add_rounded,
      Icons.grid_view_rounded,
    ];

    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: AppColors.card,
        border: Border(top: BorderSide(color: AppColors.border)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: List.generate(5, (i) {
          final actif = i == currentIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () => onTap(i),
              behavior: HitTestBehavior.opaque,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  // Indicateur gradient en haut si actif
                  if (actif)
                    Container(
                      width: 26,
                      height: 3,
                      decoration: BoxDecoration(
                        gradient: AppColors.topbarGradient,
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(4),
                        ),
                      ),
                    ),

                  // Icône + label
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedScale(
                          scale: actif ? 1.1 : 1.0,
                          duration: const Duration(milliseconds: 150),
                          child: Icon(
                            icons[i],
                            size: 22,
                            color: actif
                                ? AppColors.primary
                                : const Color(0xFF9A9088),
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          labels[i].toUpperCase(),
                          style: TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.7,
                            color: actif
                                ? AppColors.primary
                                : const Color(0xFF9A9088),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ---------- MENU UTILISATEUR ----------

class _MenuUtilisateur extends StatelessWidget {
  const _MenuUtilisateur({
    required this.utilisateur,
    required this.onDeconnexion,
  });
  final Utilisateur? utilisateur;
  final VoidCallback onDeconnexion;

  String _labelRole(String? role) {
    if (role == null) return '—';
    return switch (role) {
      AppRoles.bureauExecutif         => 'Bureau Exécutif',
      AppRoles.coordinateur           => 'Coordinateur',
      AppRoles.responsableSousSection => 'Resp. Sous-section',
      AppRoles.responsableMouvement   => 'Resp. Mouvement',
      AppRoles.responsableSecretariat => 'Resp. Secrétariat',
      AppRoles.coordinateurCellule    => 'Coord. Cellule',
      AppRoles.adminTechnique         => 'Admin Technique',
      _ => role,
    };
  }

  @override
  Widget build(BuildContext context) {
    final nom       = utilisateur != null
        ? '${utilisateur!.prenom} ${utilisateur!.nom}'.trim()
        : 'Utilisateur';
    final initiales = _initiales(utilisateur);
    final role  = _labelRole(utilisateur?.role);
    final email = utilisateur?.email ?? '';

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              width: 36, height: 4,
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Avatar grand format
          Container(
            width: 64, height: 64,
            decoration: const BoxDecoration(
              gradient: AppColors.kpiVertGradient,
              shape:    BoxShape.circle,
            ),
            child: Center(
              child: Text(
                initiales,
                style: const TextStyle(
                  color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          Text(nom,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(role,
                style: const TextStyle(color: AppColors.primary, fontSize: 12,
                    fontWeight: FontWeight.w600)),
          ),
          const SizedBox(height: 4),

          if (email.isNotEmpty)
            Text(email,
                style: const TextStyle(color: Colors.black45, fontSize: 12)),

          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 8),

          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onDeconnexion,
              icon:  const Icon(Icons.logout_rounded, size: 18),
              label: const Text('Se déconnecter'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.secondary,
                side:    const BorderSide(color: AppColors.secondary),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}