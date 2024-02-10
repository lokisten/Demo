import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sajhabackup/EasyConst/Colors.dart';
import 'package:sajhabackup/Splashes/splashpage.dart';

class OTPScreen extends StatefulWidget {
  String verificationid;
  OTPScreen({super.key, required this.verificationid});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  TextEditingController otpController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("OTP Screen"),
        centerTitle: true,
        leading: BackButton(color: color1),
      ), // AppBar
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: TextField(
            controller: otpController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
                hintText: "Enter The OTP",
                suffixIcon: Icon(Icons.phone),
                border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(25)) // OutlineInputBorder
                ), // InputDecoration
          ),
        ),
        SizedBox(height: 30),
        ElevatedButton(
          child: const Text('Confirm'),
          onPressed: () async {
            try {
              PhoneAuthCredential credential =
                  await PhoneAuthProvider.credential(
                      verificationId: widget.verificationid,
                      smsCode: otpController.text.toString());
              FirebaseAuth.instance
                  .signInWithCredential(credential)
                  .then((value) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SplashPage()));
              });
            } catch (ex) {
              log(ex.toString() as num);
            }
          },
        ),
      ]),
    );
  }
}
