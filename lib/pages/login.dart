import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sajhabackup/EasyConst/Colors.dart';
import 'package:sajhabackup/EasyConst/Styles.dart';
import 'package:sajhabackup/Pages/forgotpassword.dart';
import 'package:sajhabackup/Splashes/splashpage.dart';
import 'package:sajhabackup/pages/RegisterPage.dart';
import 'package:sajhabackup/services/auth_service.dart';
import 'package:sajhabackup/utils/toast.dart';

TextStyle mystyle = TextStyle(fontSize: 25);

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Theme.of(context).colorScheme.background,
      body: FutureBuilder(
        future: _initializeFirebase(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return loginscreen();
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

class loginscreen extends StatefulWidget {
  const loginscreen({super.key});

  @override
  State<loginscreen> createState() => _loginscreenState();
}

class _loginscreenState extends State<loginscreen> {
  static Future<User?> loginUsingEmailPassword(
      {required String email,
      required String password,
      required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        print("no user found");
      }
    }
    return user;
  }

  bool _issecuredpassword = true;
  String user = '';
  String pass = '';
  var auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();

    final userfield = TextField(
      controller: _emailController,
      style: mystyle,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(10),
        hintText: "Email or Phone",
        hintStyle:
            TextStyle(fontSize: 18, fontFamily: regular, color: Colors.grey),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32)),
      ),
    );

    final myloginbutton = Material(
      elevation: 3,
      borderRadius: BorderRadius.circular(30),
      color: color,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(12),
        onPressed: () async {
          User? user = await loginUsingEmailPassword(
              email: _emailController.text,
              password: _passwordController.text,
              context: context);
          print(user);
          if (user != null) {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => SplashPage()));
          } else {
            showToast(message: "Incorrect Password or Username");
          }
        },
        child: const Text(
          'Login',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
    return Scaffold(
      body: Center(
        child: Container(
          color: Colors.white,
          child: Padding(
              padding: EdgeInsets.all(20),
              child: ListView(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        child: Image.asset(
                          'assets/images/logo.png',
                          height: 250,
                        ),
                      ),
                      Container(
                        child: const Text(
                          'Buy, Sell & Rent Books',
                          style: TextStyle(
                              color: color,
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                              letterSpacing: 1,
                              wordSpacing: 1
                              //fontWeight: FontWeight.bold
                              ),
                        ),
                      ),
                      SizedBox(height: 20),
                      userfield,
                      SizedBox(height: 10),
                      TextField(
                        controller: _passwordController,
                        obscureText: _issecuredpassword,
                        style: mystyle,
                        decoration: InputDecoration(
                          suffixIcon: togglePassword(),
                          contentPadding: EdgeInsets.all(10),
                          hintText: "Password",
                          hintStyle: TextStyle(
                              fontSize: 18,
                              fontFamily: regular,
                              color: Colors.grey),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32)),
                        ),
                      ),
                      SizedBox(height: 1),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () {},
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                forgetpassword()));
                                  },
                                  child: Text('Forgot Password?',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          color: Colors.black)),
                                ),
                              ),
                            ]),
                      ),
                      SizedBox(height: 5),
                      myloginbutton,
                      SizedBox(height: 10),
                      Divider(
                        thickness: 1,
                        color: Colors.grey[400],
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Or Connect With',
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                      SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 140),
                        child: Row(
                          children: [
                            //googlebutton
                            GestureDetector(
                              onTap: () =>
                                  FirebaseService.signInwithGoogle(context),
                              child: Image.asset(
                                'assets/images/google.png',
                                height: 60,
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Not a member?',
                            style: TextStyle(
                                fontFamily: regular,
                                fontSize: 14,
                                color: Colors.black),
                          ),
                          SizedBox(width: 1),
                          TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => RegisterPage()));
                              },
                              child: Text(
                                'Register Now',
                                style: TextStyle(
                                    color: color,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14),
                              ))
                        ],
                      )
                    ],
                  ),
                ],
              )),
        ),
      ),
    );
  }

  Widget togglePassword() {
    return IconButton(
      onPressed: () {
        setState(() {
          _issecuredpassword = !_issecuredpassword;
        });
      },
      icon: _issecuredpassword
          ? Icon(Icons.visibility)
          : Icon(Icons.visibility_off),
      color: Colors.grey,
    );
  }
}
