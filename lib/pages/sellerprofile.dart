import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sajhabackup/EasyConst/Colors.dart';
import 'package:sajhabackup/Settings/Components/helpcenter.dart';

class UserProfilePage extends StatefulWidget {
  final String userEmail;

  UserProfilePage({required this.userEmail});

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  late CollectionReference _usersCollection;
  late DocumentSnapshot _userSnapshot;

  @override
  void initState() {
    super.initState();
    _usersCollection = FirebaseFirestore.instance.collection('users');
    _loadUserData();
  }

  void _loadUserData() {
    _usersCollection
        .where('Email', isEqualTo: widget.userEmail)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          _userSnapshot = querySnapshot.docs.first;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seller Profile'),
        backgroundColor: color,
      ),
      body: _userSnapshot != null
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Name: ${_userSnapshot['Full Name']}'),
                  Text('Phone: ${_userSnapshot['Phone']}'),
                  Text('Address: ${_userSnapshot['Address']}'),
                  Text('Email: ${_userSnapshot['Email']}'),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: Text('Report User?'),
                                backgroundColor: Colors.grey[300],
                                content: TextField(
                                  autofocus: true,
                                  decoration: InputDecoration(
                                      hintText:
                                          'Are you sure you want to report ${_userSnapshot['Full Name']}'),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text(
                                      'Cancel',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  helpcenter()));
                                    },
                                    child: Text(
                                      'Yes',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ));
                    },
                    child: Text('Report'),
                  ),
                ],
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
