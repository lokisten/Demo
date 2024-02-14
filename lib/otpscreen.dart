import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sajhabackup/EasyConst/Colors.dart';
import 'package:sajhabackup/EasyConst/Styles.dart';
import 'package:sajhabackup/Settings/Components/helpcenter.dart';

class OTPScreen extends StatefulWidget {
  final String vid;

  const OTPScreen({Key? key, required this.vid}) : super(key: key);

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  var code = "";

  Future<void> signIn() async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: widget.vid,
      smsCode: code,
    );

    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => helpcenter()));
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
      resizeToAvoidBottomInset: true,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset('assets/images/otp.png', height: 200, width: 200),
              Center(
                child: Text(
                  "OTP Verification",
                  style: TextStyle(fontSize: 39),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 6),
                child: Text(
                  "Enter OTP",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: regular,
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 20),
              textCode(),
              SizedBox(height: 80),
              button(),
            ],
          ),
        ),
      ),
    );
  }

  Widget button() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          signIn();
        },
        style: ElevatedButton.styleFrom(
          primary: color,
          padding: const EdgeInsets.all(16.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 80),
          child: Text(
            'Verify & Proceed',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget textCode() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: PinCodeTextField(
          appContext: context,
          length: 6,
          onChanged: (value) {
            setState(() {
              code = value;
            });
          },
          // Other properties you may need to customize the appearance
        ),
      ),
    );
  }
}
