import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sajhabackup/EasyConst/Colors.dart';
import 'package:sajhabackup/EasyConst/Styles.dart';

class OTPScreen extends StatefulWidget {
  final String vid;
  final void Function(String code)
      registerFunction; // Function to register user

  const OTPScreen({Key? key, required this.vid, required this.registerFunction})
      : super(key: key);

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  var code = "";

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
          widget.registerFunction(code); // Call register function with OTP code
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
