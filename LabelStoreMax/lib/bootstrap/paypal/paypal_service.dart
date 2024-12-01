import 'dart:convert';
import 'dart:async';
import 'dart:convert' as convert;

import '/app/networking/api_service.dart';
import 'package:nylo_framework/nylo_framework.dart';

class PaypalServices {
  final String clientId, secretKey;
  final bool sandboxMode;
  PaypalServices({
    required this.clientId,
    required this.secretKey,
    required this.sandboxMode,
  });

  getAccessToken() async {
    String baseUrl = sandboxMode
        ? "https://api-m.sandbox.paypal.com"
        : "https://api.paypal.com";

    try {
      var authToken = base64.encode(
        utf8.encode("$clientId:$secretKey"),
      );
      final body = await api<ApiService>(
          (request) => request
              .post('$baseUrl/v1/oauth2/token?grant_type=client_credentials'),
          headers: {
            'Authorization': 'Basic $authToken',
            'Content-Type': 'application/x-www-form-urlencoded'
          });

      return {
        'error': false,
        'message': "Success",
        'token': body["access_token"]
      };
    } on DioException {
      return {
        'error': true,
        'message': "Your PayPal credentials seems incorrect"
      };
    } catch (e) {
      return {
        'error': true,
        'message': "Unable to proceed, check your internet connection."
      };
    }
  }

  Future<Map> createPaypalPayment(
    transactions,
    accessToken,
  ) async {
    String domain = sandboxMode
        ? "https://api.sandbox.paypal.com"
        : "https://api.paypal.com";

    try {
      final response = await Dio().post('$domain/v1/payments/payment',
          data: jsonEncode(transactions),
          options: Options(
            headers: {
              'Authorization': 'Bearer $accessToken',
              'Content-Type': 'application/json'
            },
          ));

      final body = response.data;
      if (body["links"] != null && body["links"].length > 0) {
        List links = body["links"];

        String executeUrl = "";
        String approvalUrl = "";
        final item = links.firstWhere((o) => o["rel"] == "approval_url",
            orElse: () => null);
        if (item != null) {
          approvalUrl = item["href"];
        }
        final item1 =
            links.firstWhere((o) => o["rel"] == "execute", orElse: () => null);
        if (item1 != null) {
          executeUrl = item1["href"];
        }
        return {"executeUrl": executeUrl, "approvalUrl": approvalUrl};
      }
      return {};
    } on DioException catch (e) {
      return {
        'error': true,
        'message': "Payment Failed.",
        'data': e.response?.data,
      };
    } catch (e) {
      rethrow;
    }
  }

  Future<Map> executePayment(
    url,
    payerId,
    accessToken,
  ) async {
    try {
      final response = await Dio().post(url,
          data: convert.jsonEncode({"payer_id": payerId}),
          options: Options(
            headers: {
              'Authorization': 'Bearer $accessToken',
              'Content-Type': 'application/json'
            },
          ));

      final body = response.data;
      return {'error': false, 'message': "Success", 'data': body};
    } on DioException catch (e) {
      return {
        'error': true,
        'message': "Payment Failed.",
        'data': e.response?.data,
      };
    } catch (e) {
      return {'error': true, 'message': e, 'exception': true, 'data': null};
    }
  }
}
