import 'package:blackox/Model/business_details.dart';
import 'package:postgres/postgres.dart';
import 'package:blackox/Model/category_type.dart';

class DatabaseService {
  final connection = Connection.open(
    Endpoint(
      host: '34.71.87.187',
      port: 5432,
      database: 'airegulation_dev',
      username: 'postgres',
      password: 'India@5555',
    ),
    settings: const ConnectionSettings(sslMode: SslMode.disable),
  );

  Future<List<BusinessDetails>> getBusinessDetails() async {
    try {
      final connection = await Connection.open(
        Endpoint(
          host: '34.71.87.187',
          port: 5432,
          database: 'airegulation_dev',
          username: 'postgres',
          password: 'India@5555',
        ),
        settings: const ConnectionSettings(sslMode: SslMode.disable),
      );

      final results = await connection.execute(
        'SELECT * FROM ai.business_details',
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
          database: 'airegulation_dev',
          username: 'postgres',
          password: 'India@5555',
        ),
        settings: const ConnectionSettings(sslMode: SslMode.disable),
      );

      final results = await connection.execute(
        'SELECT * FROM ai.category_master',
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
    }
    catch (e) {
      return [];
    }
  }
}
