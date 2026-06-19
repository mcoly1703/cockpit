import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
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
    _tabs = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(palmaresProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titre
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text('Palmarès',
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: AppColors.text)),
          ),

          // Tabs
          Container(
            color: AppColors.card,
            child: TabBar(
              controller: _tabs,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.text2,
              indicatorColor: AppColors.primary,
              tabs: [
                Tab(
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    const Icon(Icons.groups_rounded, size: 16),
                    const SizedBox(width: 6),
                    const Text('Massificateurs'),
                    const SizedBox(width: 6),
                    _Badge(count: state.topMassificateurs.length),
                  ]),
                ),
                Tab(
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    const Icon(Icons.account_balance_wallet_outlined, size: 16),
                    const SizedBox(width: 6),
                    const Text('Cotiseurs'),
                    const SizedBox(width: 6),
                    _Badge(count: state.topCotiseurs.length),
                  ]),
                ),
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
                  icone: Icons.groups_rounded,
                ),
                ClassementList(
                  entries: state.topCotiseurs,
                  icone: Icons.account_balance_wallet_outlined,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.count});
  final int count;

  @override
  Widget build(BuildContext context) => Container(
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
      );
}
