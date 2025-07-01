import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://10.12.112.19:5000';

  static Future<Map<String, dynamic>> askQuestion(String question) async {
    try {
      print('API Request: Sending question: $question');

      final response = await http.post(
        Uri.parse('$baseUrl/answer'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'question': question}),
      );

      print('API Response: Status ${response.statusCode}, Body: ${response.body}');

      if (response.statusCode == 200) {
        return {'success': true, 'data': jsonDecode(response.body)};
      } else {
        return {
          'success': false,
          'error': 'Server error: ${response.statusCode}',
          'details': response.body,
        };
      }
    } catch (e) {
      print('API Error: $e');
      return {
        'success': false,
        'error': 'Network error: ${e.toString()}',
      };
    }
  }

  static Future<bool> checkServerHealth() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/health'));
      return response.statusCode == 200;
    } catch (e) {
      print('Health check error: $e');
      return false;
    }
  }
}