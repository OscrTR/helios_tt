import 'dart:convert';

import 'package:helios_tt/models/user_model.dart';
import 'package:http/http.dart' as http;

class UserRepository {
  final http.Client httpClient;

  UserRepository({required this.httpClient});

  static const String _baseUrl = 'https://randomuser.me/api/';
  static const int _resultsPerPage = 20;

  Future<List<User>> fetchUsers(int page) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl?page=$page&results=$_resultsPerPage&seed=abc'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List results = data['results'];
        return results.map((e) => User.fromJson(e)).toList();
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      throw Exception('Failed to connect to the service');
    }
  }
}
