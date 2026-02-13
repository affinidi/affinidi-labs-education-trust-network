import 'dart:convert';
import 'package:http/http.dart' as http;

/// Makes HTTP API calls to trust registry endpoints
class TrustRegistryApiClient {
  Future<Map<String, dynamic>?> call(
    String url, {
    String method = 'POST',
    Map<String, dynamic>? body,
  }) async {
    final headers = {'Content-Type': 'application/json'};

    print('API call: $url with method $method and body ${jsonEncode(body)}');

    final response = await _makeRequest(url, method, headers, body);

    return _parseResponse(response);
  }

  Future<http.Response> _makeRequest(
    String url,
    String method,
    Map<String, String> headers,
    Map<String, dynamic>? body,
  ) async {
    if (method.toUpperCase() == 'GET') {
      return await http.get(Uri.parse(url), headers: headers);
    } else {
      return await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );
    }
  }

  Map<String, dynamic>? _parseResponse(http.Response response) {
    if (response.statusCode == 200 && response.body.isNotEmpty) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      print('API call completed: ${jsonEncode(data)}');
      return data;
    } else {
      print('API call failed with status: ${response.statusCode}');
      return null;
    }
  }
}
