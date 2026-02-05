// ignore_for_file: use_build_context_synchronously, library_prefixes, depend_on_referenced_packages, empty_catches

import 'package:flutter/material.dart';
import 'package:nlytical/Vendor/payment/paypal_service.dart';
import 'package:webview_flutter/webview_flutter.dart' as webView;

class PaypalPayment extends StatefulWidget {
  final String publickKey;
  final String secretKey;
  final String totalPrice;
  final Function(String paymentId) onFinish;

  const PaypalPayment({
    super.key,
    required this.publickKey,
    required this.secretKey,
    required this.onFinish,
    this.totalPrice = '',
  });

  @override
  State<StatefulWidget> createState() {
    return PaypalPaymentState();
  }
}

class PaypalPaymentState extends State<PaypalPayment> {
  String? checkoutUrl;
  String? executeUrl;
  String? accessToken;
  late webView.WebViewController controller;

  final String returnURL = 'return.example.com';
  final String cancelURL = 'cancel.example.com';

  @override
  void initState() {
    super.initState();
    final services = PaypalServices(
      clientId: widget.publickKey,
      secret: widget.secretKey,
    );

    Future.delayed(Duration.zero, () async {
      try {
        accessToken = await services.getAccessToken();

        final transactions = getOrderParams();
        final res = await services.createPaypalPayment(
          transactions,
          accessToken,
        );

        if (res != null &&
            res["approvalUrl"] != null &&
            res["executeUrl"] != null) {
          setState(() {
            checkoutUrl = res["approvalUrl"];
            executeUrl = res["executeUrl"];

            controller = webView.WebViewController()
              ..setJavaScriptMode(
                webView.JavaScriptMode.unrestricted,
              ) // Required by PayPal
              ..setBackgroundColor(const Color(0x00000000))
              ..setNavigationDelegate(
                webView.NavigationDelegate(
                  onNavigationRequest: (webView.NavigationRequest request) {
                    final uri = Uri.parse(request.url);
                    final host = uri.host;

                    // Allow PayPal and your redirect domains only
                    if (host.contains('paypal.com') ||
                        host == returnURL ||
                        host == cancelURL) {
                      if (request.url.contains(returnURL)) {
                        final payerID = uri.queryParameters['PayerID'];
                        if (payerID != null) {
                          services
                              .executePayment(executeUrl, payerID, accessToken)
                              .then((paymentId) {
                                widget.onFinish(paymentId);
                                Navigator.of(context).pop();
                              });
                        } else {
                          Navigator.of(context).pop(); // No payerID = cancel
                        }
                        return webView.NavigationDecision.prevent;
                      }

                      if (request.url.contains(cancelURL)) {
                        Navigator.of(context).pop();
                        return webView.NavigationDecision.prevent;
                      }

                      return webView.NavigationDecision.navigate;
                    }

                    // Block unknown domains
                    return webView.NavigationDecision.prevent;
                  },
                ),
              )
              ..loadRequest(Uri.parse(checkoutUrl!));
          });
        }
      } catch (e) {
        debugPrint("PayPal error: $e");
        Navigator.of(context).pop(); // Graceful fallback
      }
    });
  }

  Map<String, dynamic> getOrderParams() {
    return {
      "intent": "sale",
      "payer": {"payment_method": "paypal"},
      "transactions": [
        {
          "amount": {
            "total": widget.totalPrice,
            "currency": "USD",
            "details": {
              "subtotal": widget.totalPrice,
              "shipping": '0',
              "shipping_discount": '0',
            },
          },
          "description": "The payment transaction description.",
          "payment_options": {
            "allowed_payment_method": "INSTANT_FUNDING_SOURCE",
          },
        },
      ],
      "note_to_payer": "Contact us for any questions on your order.",
      "redirect_urls": {
        "return_url": "https://$returnURL",
        "cancel_url": "https://$cancelURL",
      },
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text('PayPal'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: checkoutUrl != null
          ? Column(
              children: [
                Expanded(child: webView.WebViewWidget(controller: controller)),
              ],
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
