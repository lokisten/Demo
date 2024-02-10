import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sajhabackup/EasyConst/Colors.dart';
import 'package:sajhabackup/otpscreen.dart';

class phoneauth extends StatefulWidget {
  const phoneauth({super.key});

  @override
  State<phoneauth> createState() => _phoneauthState();
}

class _phoneauthState extends State<phoneauth> {
  TextEditingController phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PhoneAuth"),
        centerTitle: true,
        leading: BackButton(color: color1),
      ), // AppBar
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: TextField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
                hintText: "Enter your number",
                suffixIcon: Icon(Icons.phone),
                border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(24)) // OutlineInputBorder
                ), // InputDecoration
          ),
        ),
        SizedBox(height: 30),
        ElevatedButton(
          onPressed: () async {
            await FirebaseAuth.instance.verifyPhoneNumber(
                verificationCompleted: (PhoneAuthCredential credential) {},
                verificationFailed: (FirebaseAuthException ex) {},
                codeSent: (String verificationid, int? resendtoken) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              OTPScreen(verificationid: verificationid)));
                },
                codeAutoRetrievalTimeout: (String verificationId) {},
                phoneNumber: phoneController.text.toString());
          },
          child: const Text('Verify'),
        ),
      ]),
    );
  }
}
