import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      'http://10.0.2.2:3000'; // Adjust for emulator if needed

  static Future<Map<String, dynamic>?> login(
    String phoneNumber,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/logins'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'login': {
            'phone_number': phoneNumber,
            'password_digest':
                password, // Note: Backend uses password_digest for now
          },
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      print('Login error: $e');
    }
    return null;
  }

  // Generic methods for other resources
  static Future<List<dynamic>> getResources(String path) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl$path'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      print('Error fetching $path: $e');
    }
    return [];
  }

  static Future<Map<String, dynamic>?> createResource(
    String path,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$path'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      print('Error creating resource at $path: $e');
    }
    return null;
  }

  static Future<Map<String, dynamic>?> updateResource(
    String path,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl$path'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      print('Error updating resource at $path: $e');
    }
    return null;
  }

  static Future<bool> deleteResource(String path) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl$path'));
      return response.statusCode == 204 || response.statusCode == 200;
    } catch (e) {
      print('Error deleting resource at $path: $e');
      return false;
    }
  }
}
