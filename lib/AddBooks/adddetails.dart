import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickalert/models/quickalert_type.dart';
//import 'package:quickalert/models/quickalert_type.dart';
import 'dart:io';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:sajhabackup/EasyConst/Colors.dart';
import 'package:sajhabackup/EasyConst/Styles.dart';

class BookAddPage extends StatefulWidget {
  @override
  _BookAddPageState createState() => _BookAddPageState();
}

class _BookAddPageState extends State<BookAddPage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController authorController = TextEditingController();
  final TextEditingController conditionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController editionController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController additionalInfoController =
      TextEditingController();

  String selectedCategory = 'Masters';
  File? _image;

  Future<void> _uploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _addBook() async {
    if (_image == null) {
      
      return;
    }

    try {
     
      final Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('book_images/${DateTime.now()}.jpg');
      await storageReference.putFile(
        _image!,
        SettableMetadata(contentType: 'image/jpeg'),
      );

   
      final String imageUrl = await storageReference.getDownloadURL();

      
      await FirebaseFirestore.instance.collection('books').add({
        'name': nameController.text,
        'author': authorController.text,
        'condition': conditionController.text,
        'price': double.parse(priceController.text),
        'edition': editionController.text,
        'address': addressController.text,
        'additional_info': additionalInfoController.text,
        'category': selectedCategory,
        'image_url': imageUrl,
        'added by': currentUser.email!
      });

    
      nameController.clear();
      authorController.clear();
      conditionController.clear();
      priceController.clear();
      editionController.clear();
      addressController.clear();
      additionalInfoController.clear();
      setState(() {
        _image = null;
      });

      
      QuickAlert.show(context: context, type: QuickAlertType.success);
      
    } catch (error) {
     
      print(error);
      QuickAlert.show(context: context, type: QuickAlertType.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: color,
        leading: BackButton(
          color: color1,
        ),
        centerTitle: true,
        title: Text(
          'Add Book',
          style: TextStyle(fontSize: 20, fontFamily: regular, color: color1),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Book Name'),
              ),
              TextFormField(
                controller: authorController,
                decoration: InputDecoration(labelText: 'Author'),
              ),
              TextFormField(
                controller: conditionController,
                decoration: InputDecoration(labelText: 'Condition'),
              ),
              TextFormField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Price'),
              ),
              TextFormField(
                controller: editionController,
                decoration: InputDecoration(labelText: 'Edition'),
              ),
              TextFormField(
                controller: addressController,
                decoration: InputDecoration(labelText: 'Address'),
              ),
              TextFormField(
                controller: additionalInfoController,
                decoration: InputDecoration(labelText: 'Additional Info'),
              ),
              DropdownButton<String>(
                value: selectedCategory,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCategory = newValue!;
                  });
                },
                items: <String>['Masters', 'Bachelors', 'High School', 'Extra']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _uploadImage,
                child: Text(
                  'Pick Image',
                  style: TextStyle(
                      color: color, fontFamily: regular, fontSize: 18),
                ),
              ),
              _image != null
                  ? Image.file(
                      _image!,
                      height: 100,
                      width: 100,
                    )
                  : Container(),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addBook,
                child: Text(
                  'Add Book',
                  style: TextStyle(
                      color: color, fontFamily: regular, fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
