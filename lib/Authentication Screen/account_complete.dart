import 'package:flutter/material.dart';

class AccountComplete extends StatelessWidget {
  final String username;
  const AccountComplete({Key? key, required this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 50,),
          Image.asset("assets/Images/BlackOxLogo.png"),
          SizedBox(height: 200,),
          Text("Confirm ! ",style: TextStyle(fontSize: 50,color: Colors.green,fontFamily: 'Roboto',fontWeight: FontWeight.bold),),
          Text("Congratulations",style: TextStyle(fontSize: 50,color: Colors.black,fontFamily: 'Roboto',fontWeight: FontWeight.bold)),
          Text.rich(
            TextSpan(
              text: "Welcome ",
              style: TextStyle(fontSize: 30,color: Colors.black,fontFamily: 'Roboto',fontWeight: FontWeight.normal),
              children: <TextSpan>[
                TextSpan(
                  text: username,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: " to Our BlackOx Family!",
                ),
              ],
            ),
          ),
          SizedBox(height: 30,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/Icon/FacebookIcon.png"),
              const SizedBox(width: 10),
              Image.asset("assets/Icon/googleIcon.png"),
              const SizedBox(width: 10),
              Image.asset("assets/Icon/InstagramIcon.png"),
              const SizedBox(width: 10),
              Image.asset("assets/Icon/WhatsAppIcon.png"),
            ],
          ),
        ],
      ),
    );
  }
}
