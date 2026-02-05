import 'package:flutter/material.dart';
import 'package:nlytical/utils/colors.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class PaymentWebView extends StatefulWidget {
  final String paymentUrl;
  const PaymentWebView({super.key, required this.paymentUrl});
  @override
  State<PaymentWebView> createState() => PaymentWebViewState();
}

class PaymentWebViewState extends State<PaymentWebView> {
  late final PlatformWebViewController _controller;
  @override
  void initState() {
    super.initState();
    final PlatformWebViewControllerCreationParams params =
        WebKitWebViewControllerCreationParams(
          allowsInlineMediaPlayback: true,
          mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
        );
    _controller = PlatformWebViewController(params)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(LoadRequestParams(uri: Uri.parse(widget.paymentUrl)))
      ..setPlatformNavigationDelegate(
        PlatformNavigationDelegate(
          const PlatformNavigationDelegateCreationParams(),
        )..setOnNavigationRequest((NavigationRequest request) async {
          final url = request.url;

          if (url.contains('status=successful')) {
            // ✅ Detect success
            Navigator.pop(context, 'success');
            return NavigationDecision.prevent;
          }
          if (url.contains('status=failed') ||
              url.contains('status=cancelled')) {
            // ✅ Detect failure/cancellation
            Navigator.pop(context, 'failure');
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        }),
      );
  }

  @override
  void dispose() {
    _controller.clearCache();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Nlytical Payment',
          style: TextStyle(color: Appcolors.white),
        ),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios, color: Appcolors.white, size: 20),
        ),
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Appcolors.appPriSecColor.appPrimblue,
      ),
      body: PlatformWebViewWidget(
        PlatformWebViewWidgetCreationParams(controller: _controller),
      ).build(context),
    );
  }
}
