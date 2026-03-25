import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../providers/wallet_provider.dart';

class WalletLedgerScreen extends ConsumerStatefulWidget {
  const WalletLedgerScreen({super.key});

  @override
  ConsumerState<WalletLedgerScreen> createState() => _WalletLedgerScreenState();
}

class _WalletLedgerScreenState extends ConsumerState<WalletLedgerScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(walletLedgerProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final ledgerAsync = ref.watch(walletLedgerProvider);
    final fmt = DateFormat('MMM dd, yyyy • hh:mm a');

    return Scaffold(
      backgroundColor: AppColors.dsSurface,
      extendBody: true,
      body: CustomScrollView(
        controller: _scrollController,
        physics: const ClampingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            backgroundColor: AppColors.dsSurface,
            surfaceTintColor: Colors.transparent,
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: GestureDetector(
                onTap: () => Navigator.maybePop(context),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.dsSurfaceContainerLow.withOpacity(0.9),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_back_rounded,
                      size: 20, color: AppColors.dsOnSurface),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.dsPrimary.withOpacity(0.18),
                      AppColors.dsPrimary.withOpacity(0.04),
                      AppColors.dsSurface,
                    ],
                    stops: const [0, 0.55, 1],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 48),
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: AppColors.dsPrimary.withOpacity(0.12),
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: AppColors.dsPrimary.withOpacity(0.3),
                            width: 2.5),
                      ),
                      child: const Center(
                        child: Icon(Icons.receipt_long_rounded,
                            color: AppColors.dsPrimary, size: 40),
                      ),
                    ).animate().scale(
                        duration: 400.ms,
                        curve: Curves.elasticOut,
                        begin: const Offset(0.6, 0.6)),
                    const SizedBox(height: 12),
                    Text(
                      'Transaction Ledger',
                      style: AppTextStyles.dsDisplayLg.copyWith(fontSize: 26),
                    ).animate().fadeIn(delay: 150.ms),
                    const SizedBox(height: 4),
                    Text(
                      'Your complete transaction history',
                      style: AppTextStyles.dsBodyMd.copyWith(
                          color: AppColors.dsOnSurface.withOpacity(0.55)),
                    ).animate().fadeIn(delay: 200.ms),
                  ],
                ),
              ),
            ),
          ),
          ledgerAsync.when(
            loading: () => const SliverFillRemaining(
              child: Center(
                  child: CircularProgressIndicator(color: AppColors.dsPrimary)),
            ),
            error: (err, _) => SliverFillRemaining(
              child: Center(
                child: Text('Failed to load ledger: $err',
                    style: AppTextStyles.dsBodyMd
                        .copyWith(color: AppColors.dsTertiaryPink)),
              ),
            ),
            data: (transactions) {
              if (transactions.isEmpty) {
                return SliverFillRemaining(
                  child: Center(
                    child: Text('No transactions found.',
                        style: AppTextStyles.dsBodyMd.copyWith(
                            color: AppColors.dsOnSurface.withOpacity(0.5))),
                  ),
                );
              }
              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index.isOdd) {
                        return const SizedBox(height: 16);
                      }
                      
                      final txIndex = index ~/ 2;
                      
                      if (txIndex >= transactions.length) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: CircularProgressIndicator(
                                color: AppColors.dsPrimary),
                          ),
                        );
                      }
                      
                      final tx = transactions[txIndex];
                      if (tx.type == 'EARNED') {
                        return _TransactionCard(
                          title: tx.note ?? 'Coins Earned',
                          amount: '+${tx.amount}',
                          subtext: 'Earned',
                          date: fmt.format(tx.createdAt),
                          icon: Icons.check_circle_outline_rounded,
                          iconColor: AppColors.dsSecondaryMint,
                        );
                      } else {
                        return _TransactionCardUsed(
                          title: tx.note ?? 'Coins Used',
                          amount: '-${tx.amount}',
                          subtext: 'Used',
                          date: fmt.format(tx.createdAt),
                          icon: Icons.storefront_rounded,
                        );
                      }
                    },
                    childCount: transactions.length * 2 + (ledgerAsync.isLoading ? 1 : -1),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _TransactionCard extends StatelessWidget {
  final String title;
  final String amount;
  final String subtext;
  final String date;
  final IconData icon;
  final Color iconColor;

  const _TransactionCard({
    required this.title,
    required this.amount,
    required this.subtext,
    required this.date,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.dsSurfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.dsOnSurface.withOpacity(0.03),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: AppTextStyles.dsTitleLg.copyWith(fontSize: 15),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(amount,
                        style: AppTextStyles.dsTitleLg
                            .copyWith(fontSize: 16, color: iconColor)),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(subtext,
                          style: AppTextStyles.dsLabelMd.copyWith(
                              color: AppColors.dsOnSurface.withOpacity(0.6))),
                    ),
                    const SizedBox(width: 16),
                    Text(date,
                        style: AppTextStyles.dsLabelMd.copyWith(
                            color: AppColors.dsOnSurface.withOpacity(0.4),
                            fontSize: 9)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TransactionCardUsed extends StatelessWidget {
  final String title;
  final String amount;
  final String subtext;
  final String date;
  final IconData icon;

  const _TransactionCardUsed({
    required this.title,
    required this.amount,
    required this.subtext,
    required this.date,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.dsSurfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.dsOnSurface.withOpacity(0.03),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 6,
              decoration: const BoxDecoration(
                color: AppColors.dsPrimary,
                borderRadius: BorderRadius.horizontal(left: Radius.circular(24)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const SizedBox(width: 4),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.dsPrimary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: AppColors.dsPrimary, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: AppTextStyles.dsTitleLg.copyWith(fontSize: 15),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(amount,
                              style: AppTextStyles.dsTitleLg.copyWith(
                                  fontSize: 16,
                                  color: AppColors.dsOnSurface
                                      .withOpacity(0.8))),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(subtext,
                                style: AppTextStyles.dsLabelMd.copyWith(
                                    color: AppColors.dsOnSurface
                                        .withOpacity(0.6))),
                          ),
                          const SizedBox(width: 8),
                          Text(date,
                              style: AppTextStyles.dsLabelMd.copyWith(
                                  color: AppColors.dsOnSurface.withOpacity(0.4),
                                  fontSize: 9)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
              ],
            ),
          ),
          Positioned(
            left: -12,
            top: 0,
            bottom: 0,
            child: Center(
              child: Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: AppColors.dsSurface,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          Positioned(
            right: -12,
            top: 0,
            bottom: 0,
            child: Center(
              child: Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: AppColors.dsSurface,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
