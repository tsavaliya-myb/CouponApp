import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../providers/influencers_provider.dart';

class InfluencersListScreen extends ConsumerStatefulWidget {
  const InfluencersListScreen({super.key});

  @override
  ConsumerState<InfluencersListScreen> createState() => _InfluencersListScreenState();
}

class _InfluencersListScreenState extends ConsumerState<InfluencersListScreen> {
  String _searchQuery = '';
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final influencersAsync = ref.watch(customerInfluencersProvider(_searchQuery));

    return Scaffold(
      backgroundColor: AppColors.dsSurface,
      appBar: AppBar(
        title: Text('Influencers', style: AppTextStyles.heading2),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchController,
              onChanged: (val) {
                setState(() => _searchQuery = val);
              },
              decoration: InputDecoration(
                hintText: 'Search influencers or niches...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ),
      body: influencersAsync.when(
        data: (influencers) {
          if (influencers.isEmpty) {
            return const Center(child: Text('No influencers found.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: influencers.length,
            itemBuilder: (context, index) {
              final inf = influencers[index];
              return _buildInfluencerCard(context, inf);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildInfluencerCard(BuildContext context, Map<String, dynamic> inf) {
    return InkWell(
      onTap: () => context.push('/influencer-detail/${inf['id']}'),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person, color: AppColors.primary, size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(inf['displayName'] ?? '', style: AppTextStyles.heading2),
                  const SizedBox(height: 4),
                  Text(inf['niche']?['name'] ?? '', style: AppTextStyles.bodySmall),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${(inf['totalFollowers'] ?? 0) / 1000}k',
                  style: AppTextStyles.heading3.copyWith(color: AppColors.primary),
                ),
                Text('Followers', style: AppTextStyles.label),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
