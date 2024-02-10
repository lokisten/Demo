import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sajhabackup/EasyConst/Colors.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ImagePicker _picker = ImagePicker();

  late User _user;
  late TextEditingController _fullNameController;
  late TextEditingController _addressController;
  late TextEditingController _usernameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late String _profilePicUrl;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser!;
    _fullNameController = TextEditingController(text: _user.displayName ?? '');
    _addressController = TextEditingController();
    _usernameController = TextEditingController(text: _user.displayName ?? '');
    _phoneController = TextEditingController();
    _emailController = TextEditingController(text: _user.email ?? '');
    _profilePicUrl = _user.photoURL ?? '';

    _loadUserDetails();
  }

  Future<void> _loadUserDetails() async {
    try {
      DocumentSnapshot userSnapshot =
          await _firestore.collection('users').doc(_user.uid).get();

      if (userSnapshot.exists) {
        setState(() {
                    _fullNameController.text = userSnapshot['Full Name'] ?? '';
          _usernameController.text = userSnapshot['Username'] ?? '';
          _addressController.text = userSnapshot['Address'] ?? '';
          _phoneController.text = userSnapshot['Phone'] ?? '';
          _profilePicUrl = userSnapshot['ProfilePicUrl'] ?? _profilePicUrl;
        });
      }
    } catch (e) {
      print('Error loading user details: $e');
    }
  }

  Future<void> _updateProfile() async {
    try {
      await _user.updateDisplayName(_usernameController.text);

      await _firestore.collection('users').doc(_user.uid).update({
        'Full Name': _fullNameController.text,
        'Address': _addressController.text,
        'Phone': _phoneController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profile updated successfully!'),
        ),
      );
    } catch (e) {
      print('Error updating profile: $e');
    }
  }

  Future<void> _pickImage() async {
    try {
      XFile? pickedImage = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedImage != null) {
        await _uploadProfilePicture(_user.uid, pickedImage);
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> _uploadProfilePicture(String userId, XFile pickedImage) async {
    try {
      final Reference storageReference =
          FirebaseStorage.instance.ref().child('profile_pic/$userId.jpg');

      await storageReference.putFile(
        File(pickedImage.path),
        SettableMetadata(contentType: 'image/jpeg'),
      );

      String downloadUrl = await storageReference.getDownloadURL();
      await _firestore.collection('users').doc(userId).update({
        'ProfilePicUrl': downloadUrl,
      });

      setState(() {
        _profilePicUrl = downloadUrl;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profile picture updated successfully!'),
        ),
      );
    } catch (e) {
      print('Error uploading profile picture: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: color,
        centerTitle: true,
        title: Text('Edit Profile'),
       leading: BackButton(),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color, Colors.deepPurple,Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
         ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Center(
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(_profilePicUrl),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: _fullNameController,
                decoration: InputDecoration(labelText: 'Full Name'),
              ),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Username'),
              ),
              TextField(
                controller: _addressController,
                decoration: InputDecoration(labelText: 'Address'),
              ),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Phone'),
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                readOnly: true,
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _updateProfile,
                  child: Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


