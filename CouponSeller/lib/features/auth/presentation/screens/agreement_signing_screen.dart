import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/di/injection.dart';
import '../../domain/repositories/auth_repository.dart';

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
      (signUrl) {
        setState(() {
          _signUrl = signUrl;
        });
        _controller.loadRequest(Uri.parse(signUrl));
        _startPolling();
      },
    );
  }

  void _startPolling() {
    // Poll every 5 seconds
    _pollingTimer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      final repo = getIt<AuthRepository>();
      final result = await repo.checkAgreementStatus();
      result.fold(
        (failure) {
          // Ignore polling failures
        },
        (status) {
          if (status == 'COMPLETED') {
            timer.cancel();
            if (mounted) {
              context.go('/approval-pending', extra: 'PENDING');
            }
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
        automaticallyImplyLeading:
            false, // Prevent going back to bypass signing
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
