import 'package:blackox/Authentication%20Screen/authentication_screen.dart';
import 'package:flutter/material.dart';
import 'package:postgres/postgres.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  String _email = '';
  String _password = '';
  String _mobile='';
  String _name='';

  @override
  void initState() {
    super.initState();
    _retrieveUserData();
  }

  Future<void> _retrieveUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _email = prefs.getString('Email') ?? '';
      _password = prefs.getString('Password') ?? '';
    });
    fetchUserData(_email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Email: $_email"),
            Text("Password: $_password"),
            Text("Name: $_name"),
            Text("Mobile: $_mobile"),
            ElevatedButton(
              onPressed: logout,
              child: const Text("Logout"),
            ),
          ],
        ),
      ),
    );
}
  Future<List<List<dynamic>>> fetchUserData(String email) async {
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

      final result = await connection.execute(
        'SELECT * FROM public.black_ox_user WHERE email = \$1',
        parameters: [email],
      );

      await connection.close();
      if(result.isNotEmpty) {
        setState(() {
          _name = result[0][0] as String;
          _mobile = result[0][3] as String;
        });
      }
      return result;
    } catch (e) {
      return [];
    }
  }

  void logout() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Navigator.push(
      // ignore: use_build_context_synchronously
      context,
      MaterialPageRoute(
        builder: (context) => const AuthenticationScreen(),
      ),
    );
  }
}
