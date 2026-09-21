import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/app_header.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(AppColors.dsSurface)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() => _isLoading = true);
          },
          onPageFinished: (String url) {
            setState(() => _isLoading = false);
            // Inject CSS and JS to hide header, footer and prevent zooming
            _controller.runJavaScript('''
              // Disable zooming
              var meta = document.createElement('meta');
              meta.name = 'viewport';
              meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';
              document.head.appendChild(meta);
              
              // Attempt to remove common header/nav/footer tags
              var headers = document.getElementsByTagName('header');
              for(var i=0; i<headers.length; i++) headers[i].style.display = 'none';
              var navs = document.getElementsByTagName('nav');
              for(var i=0; i<navs.length; i++) navs[i].style.display = 'none';
              var footers = document.getElementsByTagName('footer');
              for(var i=0; i<footers.length; i++) footers[i].style.display = 'none';
              
              // Scroll exactly to privacy policy section if it exists
              var el = document.getElementById('privacy-policy');
              if (el) {
                el.scrollIntoView();
              }
            ''');
          },
          onNavigationRequest: (NavigationRequest request) {
            // Prevent navigating away from the privacy policy
            if (request.url != 'https://couponcode360.com/#privacy-policy' && 
                request.url != 'https://couponcode360.com/') {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://couponcode360.com/#privacy-policy'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.dsSurface,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            AppHeader(
              title: 'Privacy Policy',
              showSearchBar: false,
              titleStyle: AppTextStyles.dsTitleLg.copyWith(
                color: AppColors.dsPrimary,
                fontWeight: FontWeight.w800,
                fontSize: 20,
              ),
              leftWidget: Builder(
                builder: (ctx) => GestureDetector(
                  onTap: () => Navigator.pop(ctx),
                  child: const Icon(Icons.arrow_back_rounded, color: AppColors.dsPrimary, size: 28),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Stack(
                children: [
                  WebViewWidget(controller: _controller),
                  if (_isLoading)
                    const Center(
                      child: CircularProgressIndicator(),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
