import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'https://reqres.in/api/login'; // Replace with your API base URL

  Future<bool> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'Email': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      // Handle successful login (e.g., save token)
      return true;
    } else {
      // Handle login error
      return false;
    }
  }
}