import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:onlyhocamsui/models/CategoryDTO.dart';
import 'package:onlyhocamsui/models/PostDTOListResponse.dart';
import '../models/CategoryDTOListResponse.dart';
import '../models/UserDTO.dart';
import 'constants.dart';

import 'package:multi_image_picker_view/multi_image_picker_view.dart';

class ApiService {
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<String?> getJwtToken() async {
    try {
      final jwtToken = await storage.read(key: 'jwt_token');
      return jwtToken;
    } catch (error) {
      return "NOT_FOUND";
    }
  }

  Future<void> saveJwtToken(String token) async {
    await storage.write(key: 'jwt_token', value: token);
  }

  Future<void> logout() async {
    await storage.deleteAll();
  }

  Future<void> saveRole(String token) async {
    await storage.write(key: 'role', value: token);
  }

  Future<Map<String, dynamic>> loginRequest(dynamic body) async {
    final response = await http.post(
      Uri.parse('${Constants.apiBaseUrl}/api/auth/login'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );
    Map<String, dynamic> jsonResponse = jsonDecode(response.body);
    if (response.statusCode == 200) {
      await saveJwtToken(jsonResponse['data']['jwt']);
    }
    return jsonResponse;
  }


  Future<Map<String, dynamic>> registerRequest(dynamic body) async {
    final response = await http.post(
      Uri.parse('${Constants.apiBaseUrl}/api/auth/register'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );
    Map<String, dynamic> jsonResponse = jsonDecode(response.body);
    if (response.statusCode == 200) {
      await saveJwtToken(jsonResponse['data']['jwt']);
      await saveRole(jsonResponse['data']['role']);
    }
    return jsonResponse;
  }

  Future<UserDTO> getUserDetails() async {
    final jwtToken = await getJwtToken();
    final response = await http.get(
      Uri.parse('${Constants.apiBaseUrl}/api/user/getUserDetails'),
      headers: {
        'Authorization': 'Bearer $jwtToken',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 401) {
      throw CustomException("NEED_LOGIN");
    }
    Map<String, dynamic> jsonResponse = jsonDecode(response.body);
    return UserDTO.fromJson(jsonResponse['data']);
  }

  Future<CategoryDTOListResponse> getCategories() async{
    final jwtToken = await getJwtToken();
    final response = await http.get(
      Uri.parse('${Constants.apiBaseUrl}/api/user/category'),
      headers: {
        'Authorization': 'Bearer $jwtToken',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 401) {
      throw CustomException("NEED_LOGIN");
    }
    print(response.body);
    Map<String, dynamic> jsonResponse = jsonDecode(response.body);
    print("test");
    return CategoryDTOListResponse.fromJson(jsonResponse);
  }

  Future<PostDTOListResponse> getPosts(int limit, int offset, int id) async {
    final jwtToken = await getJwtToken();
    final response = await http.get(
      Uri.parse('${Constants.apiBaseUrl}/api/user/post?offset=$offset&limit=$limit&categoryId=$id'),
      headers: {
        'Authorization': 'Bearer $jwtToken',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 401) {
      throw CustomException("NEED_LOGIN");
    }
    print("buradayim");
    print(response.body);
    Map<String, dynamic> jsonResponse = jsonDecode(response.body);
    print("test");
    return PostDTOListResponse.fromJson(jsonResponse);

  }


}

class CustomException implements Exception {
  final String message;

  CustomException(this.message);
}
