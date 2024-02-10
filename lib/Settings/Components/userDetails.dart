import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sajhabackup/EasyConst/Colors.dart';
import 'package:sajhabackup/EasyConst/Styles.dart';
import 'package:sajhabackup/Settings/Components/edit_profile.dart';

class AccDetails extends StatefulWidget{
   @override
  _AccDetailsState createState() => _AccDetailsState();
}

class _AccDetailsState extends State<AccDetails> {
  User? user = FirebaseAuth.instance.currentUser;
  final usersCollection = FirebaseFirestore.instance.collection("users");
  final currentUser = FirebaseAuth.instance.currentUser!;
  String? _profilePicUrl;

  @override
  void initState() {
    super.initState();
    _getProfilePicUrl();
  }
 
  Future<String?> _getProfilePicUrl() async {
  try {
    final ref = FirebaseStorage.instance.ref().child('profile_pic/${user?.uid}.jpg');
    _profilePicUrl = await ref.getDownloadURL();
    return _profilePicUrl;
  } catch (e) {
    
    if (e is FirebaseException && e.code == 'object-not-found') {
      
      print('Profile picture not found');
    } else {
      
      print('Error getting profile picture URL: $e');
    }
    return null;
  }
}

  
  Widget _buildProfilePic(){
    return FutureBuilder<String?> (
      future: _getProfilePicUrl(), 
    builder:(context, AsyncSnapshot<String?> snapshot){
      if(snapshot.connectionState==ConnectionState.done && snapshot.hasData){
        return CircleAvatar(
          radius: 80,
          backgroundImage: NetworkImage(snapshot.data!),
        );
      }else{
             return CircleAvatar(
          radius: 80,
          backgroundImage: AssetImage('assets/images/profile.jpg'));
      }
    } );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Account',
          style: TextStyle(fontSize: 20, fontFamily: regular, color: color1),
        ),
        elevation: 0,
        backgroundColor: color,
        leading: BackButton(
          color: Colors.white,
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color, Colors.deepPurple,Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
         ),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("users")
              .where("Email", isEqualTo: user?.email)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something Went Wrong');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CupertinoActivityIndicator());
            }
            if (snapshot.data!.docs.isEmpty) {
              return Text("No data Found");
            }
            if (snapshot != null && snapshot.data != null) {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const SizedBox(height: 40),
                      _buildProfilePic(),
                        const SizedBox(height: 20),
                        itemProfile('Name', snapshot.data!.docs[index]['Full Name'],
                            CupertinoIcons.person, 'Name'),
                        const SizedBox(height: 10),
                        itemProfile(
                            'Phone', snapshot.data!.docs[index]['Phone'],
                            CupertinoIcons.phone, 'Phone'),
                        const SizedBox(height: 10),
                        itemProfile('Address',
                            snapshot.data!.docs[index]['Address'],
                            CupertinoIcons.location, 'Address'),
                        const SizedBox(height: 10),
                        itemProfile('Email', snapshot.data!.docs[index]['Email'],
                            CupertinoIcons.mail, 'Email'),
                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          
                          onPressed: (){
                          Navigator.push(context,MaterialPageRoute(builder: (context)=>EditProfilePage()));
                        }, child: Text('Edit Profile'))
                      ],
                    ),
                  );
                },
              );
            }
            return Container();
          },
        ),
      ),
    );
  }

  itemProfile(String title, String subtitle, IconData iconData, String field) {
    return Container(
      decoration: BoxDecoration(
          color: Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                offset: Offset(0, 5),
                color: Color.fromARGB(255, 49, 2, 58).withOpacity(.2),
                spreadRadius: 2,
                blurRadius: 10)
          ]),
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        leading: Icon(iconData),
       
        tileColor: Colors.white,
      ),
    );
  }

  Future<void> editField(String field) async {
    String newValue = "";
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Edit " + field, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.grey[500],
        content: TextField(
          autofocus: true,
          decoration: InputDecoration(
            hintText: "Enter New $field",
            hintStyle: TextStyle(color: Colors.grey),
          ),
          onChanged: (value) {
            newValue = value;
          },
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
            onPressed: () async {
              Navigator.pop(context, newValue);
              _updateUserData(field, newValue); 
            },
            child: Text(
              'Save',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _updateUserData(String field, String newValue) async {
    try {
      await usersCollection.doc(currentUser.email).update({field: newValue});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profile updated successfully!'),
        ),
      );
    } catch (e) {
      print('Error updating profile: $e');
    }
  }
}
