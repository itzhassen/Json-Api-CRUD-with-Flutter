import 'dart:convert';
import 'package:http/http.dart' as http;
import 'user.dart';
import 'package:collection/collection.dart';

class DataManager {
  final String baseUrl = 'http://10.0.2.2:3000'; // Change this to your JSON Server URL

  Future<void> saveUserData(User newUser) async {
    try {
      // Only post the newUser
      await http.post(
        Uri.parse('$baseUrl/users'), // Change the URL as needed
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(newUser.toJson()), // Post only the newUser
      );
    } catch (e) {
      print('Error saving user data: $e');
      throw Exception('Failed to save users');
    }
  }

  Future<void> editUser(int userId, User editedUser) async {
    try {
      print(userId);
      print(editedUser);
          // Send a PUT request to update the data on the server.
      await http.put(
        Uri.parse('$baseUrl/users/${userId.toString()}'), // Use the specific user ID
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(editedUser.toJson()), // Only send the edited user
      );

    } catch (e) {
      print('Error editing user: $e');
      throw Exception('Failed to edit user');
    }
  }

  Future<List<User>?> loadUserData() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/users'));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as List;
        return jsonData.map((data) => User.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      print('Error loading user data: $e');
      return null;
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      await http.delete(Uri.parse('$baseUrl/users/$userId'));
    } catch (e) {
      print('Error deleting user: $e');
      throw Exception('Failed to delete user');
    }
  }
}
