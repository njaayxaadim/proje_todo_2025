import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../models/task.dart';
import '../utils/constants.dart';

class ApiService {
  static const String baseUrl = apiBaseUrl;

  // INSCRIPTION
  Future<Map<String, dynamic>> register(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    print('REGISTER: ${response.statusCode} | ${response.body}');
    return jsonDecode(response.body);
  }

  // CONNEXION
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    print('LOGIN: ${response.statusCode} | ${response.body}');
    return jsonDecode(response.body);
  }

  // TÂCHES
  Future<List<Task>> getTasks(int accountId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/todos.php?account_id=$accountId'));
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Task.fromJson(e)).toList();
    }
    return [];
  }

  Future<Map<String, dynamic>> createTask(Task task) async {
    final response = await http.post(
      Uri.parse('$baseUrl/todos.php?account_id=${task.accountId}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(task.toJson()),
    );
    print('CREATE: ${response.body}');
    return jsonDecode(response.body);
  }

  Future<void> updateTask(Task task) async {
    await http.put(
      Uri.parse('$baseUrl/todos.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(task.toJson()),
    );
  }

  Future<void> deleteTask(int todoId, int accountId) async {
    await http.delete(
        Uri.parse('$baseUrl/todos.php?todo_id=$todoId&account_id=$accountId'));
  }
}

final apiProvider = Provider((ref) => ApiService());
