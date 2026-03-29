// lib/features/profile/presentation/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/app_spacing.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.onSurface, size: 20),
          onPressed: () => context.pop(),
        ),
        title: Text('Merchant Profile', style: AppTextStyles.headlineSM),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xxxl),
        child: Column(
          children: [
            // Profile Header
            _buildProfileHeader(),
            const SizedBox(height: 32),

            // Approval Status
            _buildStatusCard(),
            const SizedBox(height: 32),

            // Contact Details
            _buildInfoCard(
              title: 'Contact Details',
              icon: Icons.contact_page_outlined,
              trailing: TextButton(
                onPressed: () {},
                child: Text('Edit Info', style: AppTextStyles.footerLink.copyWith(fontSize: 11)),
              ),
              children: [
                _buildInfoField('PRIMARY CONTACT', 'Vikram Singh Rathore'),
                _buildInfoField('EMAIL ADDRESS', 'v.rathore@nexuslogistics.in'),
                _buildInfoField('MOBILE NUMBER', '+91 98765 43210'),
                _buildInfoField('SUPPORT LINE', '1800-445-9988'),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),

            // Outlet Address
            _buildInfoCard(
              title: 'Outlet Address',
              icon: Icons.storefront_outlined,
              children: [
                Text(
                  'Plot 44-B, Sector 18, Udyog Vihar,\nGurugram, Haryana - 122015, India',
                  style: AppTextStyles.bodyMD.copyWith(height: 1.5, color: AppColors.onSurface.withOpacity(0.8)),
                ),
                const SizedBox(height: AppSpacing.xl),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.map_outlined, size: 18),
                    label: const Text('Update Location'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.surfaceContainerLow,
                      foregroundColor: AppColors.primary,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),

            // Settlement Details (Navy)
            _buildSettlementCard(),
            const SizedBox(height: AppSpacing.xl),

            // Operating Hours
            _buildInfoCard(
              title: 'Operating Hours',
              icon: Icons.access_time_rounded,
              children: [
                _buildHoursRow('Monday - Friday', '09:00 - 20:00'),
                _buildHoursRow('Saturday', '10:00 - 18:00'),
                _buildHoursRow('Sunday', 'Closed', isClosed: true),
                const SizedBox(height: AppSpacing.xl),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColors.onSurface.withOpacity(0.1)),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text('Manage Calendar', style: AppTextStyles.bodyMD.copyWith(fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),

            // Seller Rewards (Yellow)
            _buildRewardsCard(),
            const SizedBox(height: 32),

            // Settings Items
            _buildSettingsItem(Icons.security_outlined, 'Privacy & Security'),
            _buildSettingsItem(Icons.description_outlined, 'Compliance Docs'),
            _buildSettingsItem(Icons.help_outline_rounded, 'Help & Training'),
            const SizedBox(height: 48),

            // Logout
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => context.go('/login'),
                icon: const Icon(Icons.logout_rounded, size: 20),
                label: const Text('LOGOUT'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFEBEE),
                  foregroundColor: const Color(0xFFD32F2F),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  textStyle: AppTextStyles.buttonText.copyWith(letterSpacing: 1.2),
                ),
              ),
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFF14291F),
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.all(24),
              child: Icon(Icons.token_outlined, color: Colors.orange.shade300, size: 40),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.edit_rounded, color: Colors.white, size: 16),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          'Nexus\nLogistics Hub',
          textAlign: TextAlign.center,
          style: AppTextStyles.headlineMD.copyWith(fontSize: 28, height: 1.1),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFD1E7DD),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.verified_rounded, color: Color(0xFF0F5132), size: 14),
                  const SizedBox(width: 4),
                  const Text(
                    'VERIFIED',
                    style: TextStyle(color: Color(0xFF0F5132), fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Merchant ID: #7782-9910-DL',
          style: AppTextStyles.bodySM.copyWith(color: AppColors.textSecondary.withOpacity(0.6)),
        ),
      ],
    );
  }

  Widget _buildStatusCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: const Border(left: BorderSide(color: Color(0xFF1B5E20), width: 4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'APPROVAL STATUS',
            style: AppTextStyles.labelSM.copyWith(fontSize: 9, letterSpacing: 0.5),
          ),
          const SizedBox(height: 4),
          const Text(
            'ACTIVE & OPERATIONAL',
            style: TextStyle(color: Color(0xFF1B5E20), fontWeight: FontWeight.w800, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required IconData icon,
    Widget? trailing,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xxxl),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.onSurface.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 24),
              const SizedBox(width: 12),
              Expanded(child: Text(title, style: AppTextStyles.headlineSM.copyWith(fontSize: 18))),
              if (trailing != null) trailing,
            ],
          ),
          const SizedBox(height: 24),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.labelSM.copyWith(fontSize: 9, color: AppColors.textSecondary.withOpacity(0.5)),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: AppTextStyles.bodyMD.copyWith(fontWeight: FontWeight.w600, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildSettlementCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xxxl),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.account_balance_wallet_outlined, color: Colors.white, size: 24),
              const SizedBox(width: 12),
              Text(
                'Settlement Details',
                style: AppTextStyles.headlineSM.copyWith(color: Colors.white, fontSize: 18),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.tune_rounded, color: Colors.white, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Verified Bank & UPI endpoints',
            style: AppTextStyles.bodySM.copyWith(color: Colors.white.withOpacity(0.5)),
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PRIMARY VPA',
                      style: AppTextStyles.labelSM.copyWith(fontSize: 8, color: Colors.white.withOpacity(0.4)),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          'nexuslogistics@hdfcbank',
                          style: AppTextStyles.bodyMD.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.check_circle, color: Color(0xFFA6EFA6), size: 16),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'BANK ACCOUNT',
                  style: AppTextStyles.labelSM.copyWith(fontSize: 8, color: Colors.white.withOpacity(0.4)),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '••••  ••••  9901',
                      style: GoogleFonts.inter(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600, letterSpacing: 2),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text('HDFC BANK', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHoursRow(String day, String hours, {bool isClosed = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(day, style: AppTextStyles.bodyMD.copyWith(color: AppColors.onSurface.withOpacity(0.6))),
          Text(
            hours.toUpperCase(),
            style: AppTextStyles.bodyMD.copyWith(
              fontWeight: FontWeight.bold,
              color: isClosed ? const Color(0xFFD32F2F) : AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRewardsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xxxl),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEA80),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.stars_rounded, color: Color(0xFF332A00), size: 24),
              const SizedBox(width: 12),
              Text(
                'Seller Rewards',
                style: AppTextStyles.headlineSM.copyWith(color: const Color(0xFF332A00), fontSize: 18),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '12,450',
                style: AppTextStyles.headlineLG.copyWith(color: const Color(0xFF332A00), fontSize: 40, letterSpacing: -1),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text('COINS', style: AppTextStyles.labelSM.copyWith(color: const Color(0xFF332A00), fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Redeemable for platform fee discounts and priority support.',
            style: AppTextStyles.bodySM.copyWith(color: const Color(0xFF332A00).withOpacity(0.6)),
          ),
          const SizedBox(height: 24),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: 0.8,
              minHeight: 6,
              backgroundColor: const Color(0xFF332A00).withOpacity(0.1),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF332A00)),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '80% TO PLATINUM TIER',
            style: AppTextStyles.labelSM.copyWith(fontSize: 8, fontWeight: FontWeight.w800, color: const Color(0xFF332A00).withOpacity(0.5)),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsItem(IconData icon, String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary, size: 22),
        title: Text(title, style: AppTextStyles.bodyMD.copyWith(fontWeight: FontWeight.w600)),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textSecondary),
        onTap: () {},
      ),
    );
  }
}
