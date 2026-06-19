import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_tables.dart';
import '../../../militants/domain/entities/unite_organisationnelle.dart';
import '../providers/palmares_provider.dart';
import '../widgets/classement_list.dart';

class PalmaresPage extends ConsumerStatefulWidget {
  const PalmaresPage({super.key});

  @override
  ConsumerState<PalmaresPage> createState() => _PalmaresPageState();
}

class _PalmaresPageState extends ConsumerState<PalmaresPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(palmaresProvider);
    final notifier = ref.read(palmaresProvider.notifier);

    final sousSections = state.unites
        .where((u) => u.type == AppUniteTypes.sousSection)
        .toList()
      ..sort((a, b) => a.nom.compareTo(b.nom));

    final cellules = state.filtreUniteId != null
        ? (state.unites
            .where((u) =>
                u.type == AppUniteTypes.cellule &&
                u.parentId == state.filtreUniteId)
            .toList()
          ..sort((a, b) => a.nom.compareTo(b.nom)))
        : <UniteOrganisationnelle>[];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titre
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: Text('Palmarès',
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: AppColors.text)),
          ),

          // Filtre par unité
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 4, 14, 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('PÉRIMÈTRE',
                    style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: AppColors.text2,
                        letterSpacing: 0.8)),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    ChoiceChip(
                      label: Text('Section France',
                          style: TextStyle(
                              fontSize: 11,
                              color: state.filtreUniteId == null
                                  ? Colors.white
                                  : AppColors.text2)),
                      selected: state.filtreUniteId == null,
                      onSelected: (_) => notifier.filtrerParUnite(null),
                      selectedColor: AppColors.primary,
                      backgroundColor: AppColors.card,
                      side: BorderSide(
                          color: state.filtreUniteId == null
                              ? AppColors.primary
                              : AppColors.border),
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                    ),
                    ...sousSections.map((ss) {
                      final actif = state.filtreUniteId == ss.id;
                      final label = ss.code?.split('-').last ?? ss.nom;
                      return ChoiceChip(
                        label: Text(label,
                            style: TextStyle(
                                fontSize: 11,
                                color:
                                    actif ? Colors.white : AppColors.text)),
                        selected: actif,
                        onSelected: (_) =>
                            notifier.filtrerParUnite(actif ? null : ss.id),
                        selectedColor: AppColors.primary,
                        backgroundColor: AppColors.card,
                        side: BorderSide(
                            color: actif
                                ? AppColors.primary
                                : AppColors.border),
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                      );
                    }),
                  ],
                ),
                if (cellules.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: cellules.map((c) {
                      final actif = state.filtreUniteId == c.id;
                      return ChoiceChip(
                        label: Text(c.nom,
                            style: TextStyle(
                                fontSize: 11,
                                color:
                                    actif ? Colors.white : AppColors.text)),
                        selected: actif,
                        onSelected: (_) =>
                            notifier.filtrerParUnite(actif ? null : c.id),
                        selectedColor: AppColors.accent,
                        backgroundColor: AppColors.card,
                        side: BorderSide(
                            color: actif
                                ? AppColors.accent
                                : AppColors.border),
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 4),

          // Tabs
          Container(
            color: AppColors.card,
            child: TabBar(
              controller: _tabs,
              isScrollable: true,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.text2,
              indicatorColor: AppColors.primary,
              tabs: [
                _TabLabel(
                    icone: Icons.groups_rounded,
                    label: 'Massificateurs',
                    count: state.topMassificateurs.length),
                _TabLabel(
                    icone: Icons.account_balance_wallet_outlined,
                    label: 'Cotiseurs',
                    count: state.topCotiseurs.length),
                _TabLabel(
                    icone: Icons.volunteer_activism_outlined,
                    label: 'Donateurs',
                    count: state.topDonateurs.length),
              ],
            ),
          ),

          // Contenu
          Expanded(
            child: TabBarView(
              controller: _tabs,
              children: [
                ClassementList(
                    entries: state.topMassificateurs,
                    icone: Icons.groups_rounded),
                ClassementList(
                    entries: state.topCotiseurs,
                    icone: Icons.account_balance_wallet_outlined),
                ClassementList(
                    entries: state.topDonateurs,
                    icone: Icons.volunteer_activism_outlined),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TabLabel extends StatelessWidget {
  const _TabLabel(
      {required this.icone, required this.label, required this.count});
  final IconData icone;
  final String label;
  final int count;

  @override
  Widget build(BuildContext context) => Tab(
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icone, size: 16),
          const SizedBox(width: 6),
          Text(label),
          if (count > 0) ...[
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text('$count',
                  style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.accent)),
            ),
          ],
        ]),
      );
}
