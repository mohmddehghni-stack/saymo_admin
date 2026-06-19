import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:html' as html;

class ApiService {
  static const String baseUrl = 'https://couple-api.liara.run/api';

  static String? _token;

  static void loadToken() {
    _token = html.window.localStorage['admin_token'];
  }

  static Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/admin-login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _token = data['token'];
      html.window.localStorage['admin_token'] = _token!;
      return true;
    }
    return false;
  }

  static Map<String, String> get headers {
    if (_token == null) {
      loadToken(); // ← اگر خالی بود، از localStorage پر کن
    }
    return {
      'Authorization': 'Bearer ${_token ?? ''}',
      'Content-Type': 'application/json',
    };
  }

  static Future<List<dynamic>> getTickets() async {
    print('🔍 getTickets called');
    print('🔑 Token in memory: $_token');
    print(
      '💾 Token in localStorage: ${html.window.localStorage['admin_token']}',
    );

    final resp = await http.get(
      Uri.parse('$baseUrl/support/tickets'),
      headers: headers,
    );

    print('📡 Status: ${resp.statusCode}');
    print('📡 Body: ${resp.body}');

    if (resp.statusCode == 200) return jsonDecode(resp.body)['tickets'];
    return [];
  }

  static Future<Map<String, dynamic>?> getTicket(int id) async {
    final resp = await http.get(
      Uri.parse('$baseUrl/support/tickets/$id'),
      headers: headers,
    );
    if (resp.statusCode == 200) return jsonDecode(resp.body);
    return null;
  }

  static Future<bool> replyToTicket(int ticketId, String message) async {
    final resp = await http.post(
      Uri.parse('$baseUrl/support/tickets/$ticketId/reply'),
      headers: headers,
      body: jsonEncode({'message': message}),
    );
    return resp.statusCode == 201;
  }

  static Future<bool> updateTicketStatus(int ticketId, String status) async {
    final resp = await http.patch(
      Uri.parse('$baseUrl/support/tickets/$ticketId/status'),
      headers: headers,
      body: jsonEncode({'status': status}),
    );
    return resp.statusCode == 200;
  }
}
