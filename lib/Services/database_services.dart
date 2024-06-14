import 'package:blackox/Model/business_detials.dart';
import 'package:postgres/postgres.dart';

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
        ));
      }

      return businessDetailsList;
    } catch (e) {
      print('Error fetching business details: $e');
      return [];
    }
  }
}
