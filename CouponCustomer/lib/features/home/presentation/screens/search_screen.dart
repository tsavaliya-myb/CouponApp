// lib/features/home/presentation/screens/search_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/coupon_card.dart';
import '../../../../core/widgets/seller_card.dart';
import '../providers/home_provider.dart';
import '../../../../core/providers/categories_provider.dart';
import '../../../../core/utils/category_utils.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchController = TextEditingController();
  String _query = '';


  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onCategoryTap(String categoryLabel) {
    _searchController.text = categoryLabel;
    setState(() {
      _query = categoryLabel;
    });
  }

  @override
  Widget build(BuildContext context) {
    final sellersAsync = ref.watch(nearbySellersProvider);
    final couponsAsync = ref.watch(allCouponsProvider);

    final String queryLower = _query.trim().toLowerCase();

    final categories = ref.watch(categoriesProvider).valueOrNull ?? [];
    final sellers = sellersAsync.valueOrNull ?? [];
    final matchingSellers = queryLower.isEmpty
        ? []
        : sellers.where((s) {
            return s.name.toLowerCase().contains(queryLower) ||
                s.category.toLowerCase().contains(queryLower);
          }).toList();

    final coupons = couponsAsync.valueOrNull ?? [];
    final matchingCoupons = queryLower.isEmpty
        ? []
        : coupons.where((c) {
            final desc = c.description?.toLowerCase() ?? '';
            final sellerName = c.sellerName.toLowerCase();
            final discountStr = c.discountPercent.toString();
            final typeStr = c.couponType.toLowerCase();

            return sellerName.contains(queryLower) ||
                desc.contains(queryLower) ||
                discountStr.contains(queryLower) ||
                typeStr.contains(queryLower);
          }).toList();

    final hasResults = matchingSellers.isNotEmpty || matchingCoupons.isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.dsSurface,
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: AppColors.dsSurface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: TextField(
            controller: _searchController,
            autofocus: true,
            style: AppTextStyles.dsBodyMd,
            decoration: InputDecoration(
              hintText: 'Search coupons, sellers...',
              hintStyle: AppTextStyles.dsBodyMd
                  .copyWith(color: AppColors.dsOnSurface.withOpacity(0.5)),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              fillColor: Colors.transparent,
              filled: true,
              contentPadding: EdgeInsets.zero,
              suffixIcon: queryLower.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _query = '');
                      },
                    )
                  : null,
            ),
            onChanged: (val) {
              setState(() => _query = val);
            },
          ),
        ),
      ),
      body: queryLower.isEmpty
          ? _buildEmptyState(sellers, categories)
          : (!hasResults)
              ? Center(
                  child: Text(
                    'no result found',
                    style: AppTextStyles.dsTitleLg.copyWith(
                        color: AppColors.dsOnSurface.withOpacity(0.4)),
                  ),
                )
              : ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  children: [
                    if (matchingSellers.isNotEmpty) ...[
                      Text('Sellers', style: AppTextStyles.dsTitleLg),
                      const SizedBox(height: 12),
                      ...matchingSellers.map((seller) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: SellerCard(
                              seller: seller,
                              onTap: () =>
                                  context.push('/seller-detail', extra: seller),
                            ),
                          )),
                      const SizedBox(height: 24),
                    ],
                    if (matchingCoupons.isNotEmpty) ...[
                      Text('Coupons', style: AppTextStyles.dsTitleLg),
                      const SizedBox(height: 12),
                      ...matchingCoupons.map((coupon) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: CouponCard(
                              coupon: coupon,
                              showUsesLeft: true,
                              onTap: () =>
                                  context.push('/coupon-detail', extra: coupon),
                            ),
                          )),
                    ],
                  ],
                ),
    );
  }

  Widget _buildEmptyState(List sellers, List categories) {
    final recommendedSellers = sellers.take(5).toList();

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          'Quick Categories',
          style: AppTextStyles.dsTitleLg.copyWith(fontSize: 18),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: categories.map((cat) {
            return GestureDetector(
              onTap: () => _onCategoryTap(cat.name),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.dsSurfaceContainerLow,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: AppColors.dsPrimary.withOpacity(0.1), width: 1.5),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(CategoryUtils.getIcon(cat.slug),
                        size: 18, color: AppColors.dsPrimary),
                    const SizedBox(width: 8),
                    Text(
                      cat.name,
                      style: AppTextStyles.dsLabelMd.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.dsOnSurface,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 32),
        if (recommendedSellers.isNotEmpty) ...[
          Text(
            'Popular Near You',
            style: AppTextStyles.dsTitleLg.copyWith(fontSize: 18),
          ),
          const SizedBox(height: 16),
          ...recommendedSellers.map((seller) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: SellerCard(
                  seller: seller,
                  onTap: () => context.push('/seller-detail', extra: seller),
                ),
              )),
        ],
      ],
    );
  }
}
