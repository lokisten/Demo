import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sajhabackup/EasyConst/Colors.dart';
//import 'package:sajhabackup/EasyConst/Colors.dart';
import 'package:sajhabackup/Splashes/splashpage.dart';
import 'package:sajhabackup/utils/toast.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ImagePicker _picker = ImagePicker();

  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  XFile? _pickedImage;

  Future<void> _pickImage() async {
    final XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _pickedImage = pickedImage;
      });
    }
  }

  Future<void> _register() async {
    try {
      if (_validateForm()) {
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

        String userId = userCredential.user!.uid;

        if (_pickedImage != null) {
          await _uploadProfilePicture(userId);
        }

        await _firestore.collection('users').doc(userId).set({
          'Full Name': _fullNameController.text,
          'Address': _addressController.text,
          'Username': _usernameController.text,
          'Phone': _phoneController.text,
          'Email': _emailController.text,
          'Password': _passwordController.text,
          'ProfilePicUrl': _pickedImage != null ? await _getProfilePicUrl(userId) : null,
        });

        showToast(message: 'Verification Email Sent!');
        await userCredential.user!.sendEmailVerification();

        
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SplashPage()),
        );

                 showToast(message: 'Successfully Verified');

        print('Registration successful');
      }
    } catch (e) {
     
      print('Error during registration: $e');
    }
  }

  Future<String?> _getProfilePicUrl(String userId) async {
    try {
      final ref = FirebaseStorage.instance.ref().child('profile_pic/$userId.jpg');
      return await ref.getDownloadURL();
    } catch (e) {
      
      print('Error getting profile picture URL: $e');
      return null;
    }
  }

  Future<void> _uploadProfilePicture(String userId) async {
    try {
      final Reference storageReference = FirebaseStorage.instance.ref().child('profile_pic/$userId.jpg');
      await storageReference.putFile(
        File(_pickedImage!.path),
        SettableMetadata(contentType: 'image/jpeg'),
      );
    } catch (e) {
      print('Error uploading profile picture: $e');
    }
  }

  bool _validateForm() {
    if (_fullNameController.text.isEmpty ||
        _addressController.text.isEmpty ||
        _usernameController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty ||
        (_pickedImage == null)) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('All fields must be filled'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
      return false;
    } else if (_passwordController.text != _confirmPasswordController.text) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Passwords do not match'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: color,
        leading: BackButton(),
      ),
      
      body: Container(
         decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color, Colors.white,Colors.deepPurple],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
         ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                 Center(
                  child: Text('Sign Up',style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
                ),
                SizedBox(height: 15),
                Container(
                  width: double.infinity,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey),
                    image: _pickedImage != null
                        ? DecorationImage(
                            image: FileImage(File(_pickedImage!.path)),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: IconButton(
                    onPressed: _pickImage,
                    icon: Icon(
                      Icons.camera_alt,
                      size: 40,
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _fullNameController,
                  decoration: InputDecoration(labelText: 'Full Name'),
                ),
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(labelText: 'Address'),
                ),
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(labelText: 'Username'),
                ),
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(labelText: 'Phone'),
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(labelText: 'Password'),
                ),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(labelText: 'Confirm Password'),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  
                  onPressed: _register,
                  child: Text('Register'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

