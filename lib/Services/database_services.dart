import 'dart:convert';

import 'package:blackox/Model/bom_item.dart';
import 'package:blackox/Model/business_details.dart';
import 'package:blackox/Model/category_type.dart';
import 'package:blackox/Model/crop_details.dart';
import 'package:http/http.dart' as http;
import 'package:postgres/postgres.dart';

class DatabaseService {
  final connection = Connection.open(
    Endpoint(
      host: '34.71.87.187',
      port: 5432,
      database: 'datagovernance',
      username: 'postgres',
      password: 'India@5555',
    ),
    settings: const ConnectionSettings(sslMode: SslMode.disable),
  );
  final String baseUrl = 'http://localhost:3000/black_ox_api';

  Future<List<BusinessDetails>> getBusinessDetails() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/businessDetails'));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        print('Response Data: ${response.body}');
        return data.map((json) => BusinessDetails.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load business details');
      }
    } catch (e) {
      print('Error fetching business details: $e');
      return [];
    }
  }

  Future<List<CategoryType>> getCategoryType() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/categoryTypes'));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => CategoryType.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load category types');
      }
    } catch (e) {
      print('Error fetching category types: $e');
      return [];
    }
  }

  Future<bool> fetchUserCredentials(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.headers['content-type']?.contains('application/json') ??
          false) {
        final responseData = jsonDecode(response.body);
        return response.statusCode == 200 && responseData['success'];
      } else {
        print('Unexpected content-type: ${response.headers['content-type']}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error fetching credentials: $e');
      return false;
    }
  }

  Future<List<dynamic>> fetchUserData(String email) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/user-data?email=$email'), // Use your server's URL
      );

      final responseData = jsonDecode(response.body);
      if (response.statusCode == 200 && responseData['success']) {
        return responseData['data'];
      } else {
        return [];
      }
    } catch (e) {
      print('Error fetching user data: $e');
      return [];
    }
  }

  Future<List<BOMItem>> fetchBOMItems(String bomCode, int bomId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/bom/$bomCode/$bomId'),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => BOMItem.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load BOM items');
    }
  }

  Future<List<CropDetails>> fetchCropItems() async {
    final response = await http.get(
      Uri.parse('$baseUrl/crop_details'),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => CropDetails.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load BOM items');
    }
  }
}
