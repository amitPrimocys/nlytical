import 'dart:convert';

const String defaultGooglePay = '''{
  "provider": "google_pay",
  "data": {
    "environment": "TEST",
    "apiVersion": 2,
    "apiVersionMinor": 0,
    "allowedPaymentMethods": [
      {
        "type": "CARD",
        "tokenizationSpecification": {
          "type": "PAYMENT_GATEWAY",
          "parameters": {
            "gateway": "example",
            "gatewayMerchantId": "gatewayMerchantId"
          }
        },
        "parameters": {
          "allowedCardNetworks": ["VISA", "MASTERCARD"],
          "allowedAuthMethods": ["PAN_ONLY", "CRYPTOGRAM_3DS"],
          "billingAddressRequired": true,
          "billingAddressParameters": {
            "format": "FULL",
            "phoneNumberRequired": true
          }
        }
      }
    ],
    "merchantInfo": {
      "merchantId": "01234567890123456789",
      "merchantName": "Example Merchant Name"
    },
    "transactionInfo": {
      "countryCode": "US",
      "currencyCode": "USD"
    }
  }
}''';

const String defaultApplePay = '''{
  "provider": "apple_pay",
  "data": {
    "merchantIdentifier": "merchant.com.primocys.nlytical",
    "displayName": "Sam's Fish",
    "merchantCapabilities": ["3DS", "debit", "credit"],
    "supportedNetworks": ["amex", "visa", "discover", "masterCard"],
    "countryCode": "US",
    "currencyCode": "USD",
    "requiredBillingContactFields": ["emailAddress", "name", "phoneNumber", "postalAddress"],
    "requiredShippingContactFields": [],
    "shippingMethods": [
      {
        "amount": "0.00",
        "detail": "Available within an hour",
        "identifier": "in_store_pickup",
        "label": "In-Store Pickup"
      },
      {
        "amount": "4.99",
        "detail": "5-8 Business Days",
        "identifier": "flat_rate_shipping_id_2",
        "label": "UPS Ground"
      },
      {
        "amount": "29.99",
        "detail": "1-3 Business Days",
        "identifier": "flat_rate_shipping_id_1",
        "label": "FedEx Priority Mail"
      }
    ]
  }
}''';

String generateGooglePayConfig({
  required String environment,
  required String merchantId,
  required String merchantName,
  required String countryCode,
  required String currencyCode,
}) {
  Map<String, dynamic> googlePayConfig = {
    "provider": "google_pay",
    "data": {
      "environment": environment,
      "apiVersion": 2,
      "apiVersionMinor": 0,
      "allowedPaymentMethods": [
        // CARD Payment Method
        {
          "type": "CARD",
          "tokenizationSpecification": {
            "type": "PAYMENT_GATEWAY",
            "parameters": {
              "gateway": "example",
              "gatewayMerchantId": merchantId,
            },
          },
          "parameters": {
            "allowedCardNetworks": ["VISA", "MASTERCARD"],
            "allowedAuthMethods": ["PAN_ONLY", "CRYPTOGRAM_3DS"],
            "billingAddressRequired": true,
            "billingAddressParameters": {
              "format": "FULL",
              "phoneNumberRequired": true,
            },
          },
        },
        // UPI Payment Method
        // {
        //   "type": "UPI",
        //   "parameters": {
        //     "supportedMethods": ["UPI"]
        //   }
        // }
      ],
      "merchantInfo": {"merchantId": merchantId, "merchantName": merchantName},
      "transactionInfo": {
        "countryCode": countryCode,
        "currencyCode": currencyCode,
      },
    },
  };

  return jsonEncode(googlePayConfig);
}

String generateApplePayConfig({
  required String merchantIdentifier,
  required String displayName,
  required String countryCode,
  required String currencyCode,
}) {
  Map<String, dynamic> applePayConfig = {
    "provider": "apple_pay",
    "data": {
      "merchantIdentifier": merchantIdentifier,
      "displayName": displayName,
      "merchantCapabilities": ["3DS", "debit", "credit"],
      "supportedNetworks": ["amex", "visa", "discover", "masterCard"],
      "countryCode": countryCode,
      "currencyCode": currencyCode,
      "requiredBillingContactFields": [
        "emailAddress",
        "name",
        "phoneNumber",
        "postalAddress",
      ],
      "requiredShippingContactFields": [],
      "shippingMethods": [
        {
          "amount": "0.00",
          "detail": "Available within an hour",
          "identifier": "in_store_pickup",
          "label": "In-Store Pickup",
        },
        {
          "amount": "4.99",
          "detail": "5-8 Business Days",
          "identifier": "flat_rate_shipping_id_2",
          "label": "UPS Ground",
        },
        {
          "amount": "29.99",
          "detail": "1-3 Business Days",
          "identifier": "flat_rate_shipping_id_1",
          "label": "FedEx Priority Mail",
        },
      ],
    },
  };

  return jsonEncode(applePayConfig);
}
