// lib/features/auth/presentation/screens/agreement_signing_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/di/injection.dart';
import '../../../profile/presentation/providers/profile_provider.dart';
import '../../domain/repositories/auth_repository.dart';

/// The WebView screen that handles the actual Leegality signing flow.
/// Navigated to from [AgreementIntroScreen] when the seller taps "Start Signing".
class AgreementSigningScreen extends ConsumerStatefulWidget {
  const AgreementSigningScreen({super.key});

  @override
  ConsumerState<AgreementSigningScreen> createState() =>
      _AgreementSigningScreenState();
}

class _AgreementSigningScreenState
    extends ConsumerState<AgreementSigningScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _isInitFailed = false;
  String? _signUrl;
  String? _virtualSignUrl;
  Timer? _pollingTimer;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith(
              'https://couponcode360.com/leegality/success/1',
            )) {
              // First sign completed, navigate to virtual sign if available
              if (_virtualSignUrl != null) {
                _isVirtualSignLoaded = true;
                _controller.loadRequest(Uri.parse(_virtualSignUrl!));
              }
              return NavigationDecision.prevent;
            } else if (request.url.startsWith(
              'https://couponcode360.com/leegality/success/2',
            )) {
              // Second sign completed, redirect to success/dashboard
              _handleCompletion();
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      );

    _initiateAgreement();
  }

  Future<void> _initiateAgreement() async {
    final repo = getIt<AuthRepository>();
    final result = await repo.initiateAgreement();
    result.fold(
      (failure) {
        setState(() {
          _isInitFailed = true;
          _isLoading = false;
        });
      },
      (data) {
        final signUrl = data['signUrl'] as String?;
        final virtualSignUrl = data['virtualSignUrl'] as String?;
        setState(() {
          _signUrl = signUrl;
          _virtualSignUrl = virtualSignUrl;
        });
        if (signUrl != null) {
          _controller.loadRequest(Uri.parse(signUrl));
        }
        // _startPolling();
      },
    );
  }

  bool _isVirtualSignLoaded = false;

  void _handleCompletion() {
    _pollingTimer?.cancel();
    if (mounted) {
      ref.read(profileNotifierProvider.notifier).refresh().then((_) {
        if (mounted) {
          final profile = ref.read(profileNotifierProvider).value;
          final userStatus = profile?.status ?? 'PENDING';
          if (userStatus == 'ACTIVE') {
            context.go('/dashboard');
          } else {
            context.go('/approval-pending', extra: userStatus);
          }
        }
      });
    }
  }

  void _startPolling() {
    // We still poll as a fallback in case the URL interception fails or user closes/reopens
    _pollingTimer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      final repo = getIt<AuthRepository>();
      final result = await repo.checkAgreementStatus();
      result.fold(
        (failure) {
          // Ignore polling failures silently
        },
        (data) {
          final status = data['status'] as String?;
          final virtualSignUrl = data['virtualSignUrl'] as String?;

          if (status == 'COMPLETED') {
            _handleCompletion();
          } else if (status == 'AADHAAR_SIGNED' &&
              !_isVirtualSignLoaded &&
              virtualSignUrl != null) {
            _isVirtualSignLoaded = true;
            _controller.loadRequest(Uri.parse(virtualSignUrl));
          }
        },
      );
    });
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text(
          'Sign Agreement',
          style: AppTextStyles.headlineSM.copyWith(color: AppColors.onSurface),
        ),
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false, // Prevent bypassing signing via back
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isInitFailed) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: AppColors.error),
            const SizedBox(height: 16),
            Text('Failed to load agreement.', style: AppTextStyles.bodyMD),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isInitFailed = false;
                  _isLoading = true;
                });
                _initiateAgreement();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return Stack(
      children: [
        if (_signUrl != null) WebViewWidget(controller: _controller),
        if (_isLoading)
          const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
      ],
    );
  }
}
