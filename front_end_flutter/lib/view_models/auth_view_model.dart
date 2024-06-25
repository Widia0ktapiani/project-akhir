// lib/view_models/auth_view_model.dart
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class AuthViewModel extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<Map<String, dynamic>> login(User user) async {
    _isLoading = true;
    notifyListeners();

    final response = await http.post(
      Uri.parse('http://10.10.11.199:3000/users/login'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({'username': user.username, 'password': user.password}),
    );

    _isLoading = false;
    notifyListeners();

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      return {'success': true, 'token': responseBody['token']};
    } else {
      return {'success': false};
    }
  }

  Future<Map<String, dynamic>> register(User user, {File? imageFile}) async {
    _isLoading = true;
    notifyListeners();

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('http://10.10.11.199:3000/users/register'),
    );
    request.fields['username'] = user.username;
    request.fields['password'] = user.password;
    if (imageFile != null) {
      request.files
          .add(await http.MultipartFile.fromPath('image', imageFile.path));
    }

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    _isLoading = false;
    notifyListeners();

    if (response.statusCode == 201) {
      return {'success': true};
    } else {
      final errorMsg = jsonDecode(responseBody)['error'];
      return {'success': false, 'message': errorMsg};
    }
  }
}
