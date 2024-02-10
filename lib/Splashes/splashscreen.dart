import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sajhabackup/EasyConst/Colors.dart';
import 'package:sajhabackup/HomePage/homepage.dart';
import 'package:sajhabackup/Pages/login.dart';

class splashscreen extends StatefulWidget {
  const splashscreen({Key? key}) : super(key: key);

  @override
  State<splashscreen> createState() => _splashscreenState();
}

class _splashscreenState extends State<splashscreen> {

  User? user;
  @override
  void initState() {
    super.initState();
    user= FirebaseAuth.instance.currentUser;
    goToLogin();
  }

  void goToLogin() async {
    await Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushAndRemoveUntil(
        context,

        MaterialPageRoute(builder: (context) {
  if (user != null) {
    return homepage(); // Replace with the desired page for the condition
  } else {
    return MainPage(); // Replace with the desired page for the else condition
  }
}),
(Route<dynamic> route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color,
      body: Stack(
        children: [
          Container(
            alignment: Alignment.center,
            child: Image.asset(
              "assets/images/logo.png",
              width: 250,
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(top: 10),
            padding: EdgeInsets.only(left: 10, top: 200),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  child: CircularProgressIndicator(
                    color: Colors.green,
                    backgroundColor: Colors.amberAccent,
                    strokeWidth: 2.0,
                  ),
                  width: 24,
                  height: 24,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: const Text(
                    'Welcome',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
              alignment: Alignment.bottomCenter,
              child: Text(
                '"तपाईको Online Bookstore"',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    wordSpacing: 1,
                    letterSpacing: 1),
              ))
        ],
      ),
    );
  }
}
