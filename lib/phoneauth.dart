import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sajhabackup/EasyConst/Colors.dart';
import 'package:sajhabackup/otpscreen.dart';

class PhoneHome extends StatefulWidget {
  const PhoneHome({Key? key}) : super(key: key);

  @override
  _PhoneHomeState createState() => _PhoneHomeState();
}

class _PhoneHomeState extends State<PhoneHome> {
  TextEditingController phonenumber = TextEditingController();

  Future<void> sendcode() async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+977' + phonenumber.text,
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error Occurred: ${e.code}'),
            ),
          );
        },
        codeSent: (String vid, int? token) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OTPScreen(vid: vid),
            ),
          );
        },
        codeAutoRetrievalTimeout: (String vid) {},
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error Occurred: ${e.code}'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error Occurred: ${e.toString()}'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 300,
              width: 300,
            ),
            Center(
              child: Text(
                "Sajha Bookstore",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            /* Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 6),
              child: Text("OTP Sent"),
            ),*/
            SizedBox(height: 29),
            phonetext(),
            SizedBox(height: 50),
            button(),
          ],
        ),
      ),
    );
  }

  Widget button() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          sendcode();
        },
        style: ElevatedButton.styleFrom(
          primary: color,
          padding: const EdgeInsets.all(16.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 90),
          child: Text(
            'Receive OTP',
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget phonetext() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: TextField(
        controller: phonenumber,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          prefix: Text("+977"),
          prefixIcon: Icon(Icons.phone),
          labelText: 'Enter Phone Number',
          hintStyle: TextStyle(color: Colors.grey),
          labelStyle: TextStyle(color: Colors.grey),
          enabledBorder: UnderlineInputBorder(),
        ),
      ),
    );
  }
}


