import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class editprofile extends StatefulWidget {
  @override
  _editprofileState createState() => _editprofileState();
}

class _editprofileState extends State<editprofile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  late User _user;

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  void _getUser() {
    _user = _auth.currentUser!;
    _loadUserData();
  }

  void _loadUserData() async {
    if (_user != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(_user.email).get();

      if (userDoc.exists) {
        setState(() {
          _nameController.text = userDoc['Full Name'];
          _phoneController.text = userDoc['Phone'];
          _addressController.text = userDoc['Address'];
        });
      }
    }
  }

  Future<void> _updateUserData() async {
    try {
      await _firestore.collection('users').doc(_user.email).update(
        {
          'Full Name': _nameController.text,
          'Phone': _phoneController.text,
          'Address': _addressController.text,
        },
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profile updated successfully!'),
          
        ),
        
      );
    } catch (e) {
      print('Error updating profile: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Full Name'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Phone'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(labelText: 'Address'),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: _updateUserData,
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}

