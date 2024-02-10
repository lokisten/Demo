import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sajhabackup/Pages/login.dart';
import 'package:sajhabackup/Splashes/splashpage.dart';
//import 'package:sajhabackup/pages/email_verification.dart';
import 'package:sajhabackup/utils/formcontainer.dart';
import 'package:sajhabackup/utils/toast.dart';


class register extends StatefulWidget {
  const register({Key? key}) : super(key: key);

  @override
  _registerState createState() => _registerState();
}

class _registerState extends State<register> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ImagePicker _picker=ImagePicker();
  TextEditingController _fullnameController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmpasswordController = TextEditingController();
  TextEditingController _addressController = TextEditingController();

  bool isSigningUp = false;
   XFile? _pickedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: BackButton(),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Sign Up",
                  style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 30,
                ),
                FormContainerWidget(
                  controller: _fullnameController,
                  hintText: "Full Name",
                  isPasswordField: false,
                ),
                SizedBox(height: 10),
               FormContainerWidget(
                  controller: _usernameController,
                  hintText: "Username",
                  isPasswordField: false,
                ),
                SizedBox(height: 10),
                FormContainerWidget(
                  controller: _addressController,
                  hintText: "Address",
                  isPasswordField: false,
                ),
                SizedBox(height: 10),
                FormContainerWidget(
                  controller: _phoneController,
                  hintText: "Phone Number",
                  isPasswordField: false,
                ),
                SizedBox(height: 10),
                FormContainerWidget(
                  controller: _emailController,
                  hintText: "Email",
                  isPasswordField: false,
                ),
                SizedBox(height: 10),
                FormContainerWidget(
                  controller: _passwordController,
                  hintText: "Password",
                  isPasswordField: true,
                ),
                SizedBox(height: 10),
                FormContainerWidget(
                  controller: _confirmpasswordController,
                  hintText: "Confirm Password",
                  isPasswordField: true,
                ),
                SizedBox(height: 10),
                SizedBox(height: 30),
               
                GestureDetector(
                  onTap: (){
                    _pickImage();
                  },
                  child: Container(
                    width: double.infinity,
                    height: 100,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: _pickedImage==null
                      ? Text('Choose Profile Picture',
                      style: TextStyle(color: Colors.grey),
                      )
                      :Image.file(File(_pickedImage!.path),
                      fit: BoxFit.cover,
                      )
                    ),
                  ),
                ),

                GestureDetector(
                  onTap: () {
                    _signUp();
                  },
                  child: Container(
                    width: double.infinity,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Color(0xFF9526BC),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: isSigningUp
                          ? CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Text(
                              "Sign Up",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account?"),
                    SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => loginscreen()),
                            (route) => false);
                      },
                      child: Text(
                        "Login",
                        style: TextStyle(
                            color: Color(0xFF9526BC),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                
              ],
            ),
          ),
        ),
      ),
    );
  }
  Future<void> _pickImage() async{
    final XFile? pickedImage= await _picker.pickImage(source: ImageSource.gallery);
    if(pickedImage!=null){
      setState(() {
        _pickedImage=pickedImage;
      });
    }
  }
  

 void _signUp() async {
  setState(() {
    isSigningUp = true;
  });

  try {
    String fullname = _fullnameController.text;
    String username = _usernameController.text;
    String email = _emailController.text;
    String phone = _phoneController.text;
    String password = _passwordController.text;
    String address = _addressController.text;

    if (_validateForm()) {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCredential.user!.sendEmailVerification();
      showToast(message: "Verification email sent!");

      await Future.delayed(Duration(seconds: 30));
      await userCredential.user!.reload();
      if(_pickedImage!=null){
        await _uploadProfilePicture(userCredential.user!.uid);
      }
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
       'Full Name':fullname,
       'Username':username,
       'Email':email,
       'Phone':phone,
       'Address':address,
       'Password':password,
       'ProfilePic':_pickedImage!=null ? _pickedImage!.path:null,
      });
     showToast(message: 'Registered Successfull');
     Navigator.push(context, MaterialPageRoute(builder: (context)=>SplashPage()));
    }
  } on FirebaseAuthException catch (e) {
    showToast(message: "Error: ${e.message}");
  }
}
 bool _validateForm() {
      if (_fullnameController.text.isEmpty ||
        _usernameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmpasswordController.text.isEmpty ||
        _addressController.text.isEmpty) {
      showToast(message: "All fields must be filled");
      return false;
    } else if (_passwordController.text != _confirmpasswordController.text) {
      showToast(message: "Passwords do not match");
      return false;
    }
    return true;
  }
Future<void> _uploadProfilePicture(String userId) async{
  try {
     
      final Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('profile_pic/$userId/ProfilePic.jpg');
          
      await storageReference.putFile(
        File(_pickedImage!.path),
        SettableMetadata(contentType: 'image/jpeg'),
        );
       String downloadUrl=await storageReference.getDownloadURL();
       await _firestore.collection('users').doc(userId).update({
        'ProfilePic':downloadUrl,
       });
       
}catch(e){
  showToast(message: 'Error');
}

 

  Future<void> _waitForEmailVerification(User user) async {
 // await user.sendEmailVerification();
 await user.reload();
   if(user.emailVerified){
    showToast(message: 'Registerd Sucessfully');
    Navigator.push(context, MaterialPageRoute(builder: (context)=>SplashPage()));
   }
}
}
}
