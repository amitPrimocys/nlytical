import 'dart:convert';
import 'package:http/http.dart' as http;

class FlutterwavePayment {
  final String secretKey;

  FlutterwavePayment({required this.secretKey});

  // Initialize payment
  Future<String> initializePayment({
    required String email,
    required double amount,
    required String currency,
    required String txRef,
  }) async {
    final url = Uri.parse('https://api.flutterwave.com/v3/payments');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer ${secretKey.toString()}',
        //'Bearer FLWSECK_TEST-c215879731e8ea2a4518fbdde90a7ad5-X',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'tx_ref': txRef,
        'amount': amount.toString(),
        'currency': currency,
        'payment_options': 'card, mobilemoney, ussd',
        'redirect_url':
            'https://your-callback-url.com/success', // Your dummy callback URL
        'customer': {'email': email},
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data']['link']; // Payment link
    } else {
      throw Exception('Failed to initialize payment');
    }
  }
}
