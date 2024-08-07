import 'dart:convert';

import 'package:blackox/Model/business_details.dart';
import 'package:blackox/Model/category_type.dart';
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
  final String baseUrl = 'http://localhost:3000/api';

  /*Future<List<BusinessDetails>> getBusinessDetails() async {
    try {
      final connection = await Connection.open(
        Endpoint(
          host: '34.71.87.187',
          port: 5432,
          database: 'datagovernance',
          username: 'postgres',
          password: 'India@5555',
        ),
        settings: const ConnectionSettings(sslMode: SslMode.disable),
      );

      final results = await connection.execute(
        'SELECT * FROM public.business_details',
      );

      await connection.close();

      List<BusinessDetails> businessDetailsList = [];

      for (var row in results) {
        businessDetailsList.add(BusinessDetails(
          uName: row[0] as String,
          uNumber: row[1] as String,
          uEmail: row[2] as String,
          bName: row[3] as String,
          bAddress: row[4] as String,
          bPinCode: row[5] as int,
          bCity: row[6] as String,
          gstNO: row[7] as String,
          categoryType: row[8] as String,
          productName: row[9] as String,
          rate: row[10] as int,
          ratePer: row[11] as String,
          discountRate: row[12] as String,
          startDate: row[13] as DateTime,
          endDate: row[14] as DateTime,
          registerDate: row[15] as DateTime,
          imageUrl: row[16] as String,
        ));
      }

      return businessDetailsList;
    } catch (e) {
      return [];
    }
  }

  Future<List<CategoryType>> getCategoryType() async {
    try {
      final connection = await Connection.open(
        Endpoint(
          host: '34.71.87.187',
          port: 5432,
          database: 'datagovernance',
          username: 'postgres',
          password: 'India@5555',
        ),
        settings: const ConnectionSettings(sslMode: SslMode.disable),
      );

      final results = await connection.execute(
        'SELECT * FROM public.category_master',
      );

      await connection.close();

      List<CategoryType> categoryTypeList = [];

      for (var row in results) {
        categoryTypeList.add(CategoryType(
          categoryName: row[0] as String,
          color: row[1] as String,
          imageIcon: row[2] as String,
        ));
      }

      return categoryTypeList;
    } catch (e) {
      return [];
    }
  }*/

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
        Uri.parse('http://localhost:3000/login'),
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
        Uri.parse(
            'http://localhost:3000/user-data?email=$email'), // Use your server's URL
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
}
