import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sajhabackup/EasyConst/Colors.dart';
import 'package:sajhabackup/EasyConst/Styles.dart';

class MyBook {
  final String name;
  final String author;
  final String picture;
  final double price;
  final String addedBy;

  MyBook({
    required this.name,
    required this.author,
    required this.picture,
    required this.price,
    required this.addedBy,
  });
}

class mybookstatus extends StatefulWidget {
  @override
  _mybookstatusState createState() => _mybookstatusState();
}

class _mybookstatusState extends State<mybookstatus> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User? _user;

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  void _getUser() async {
    _user = _auth.currentUser;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) {
      return CircularProgressIndicator(); // Loading indicator or login page
    } else {
      return Scaffold(
        //backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: color,
          title: Text(
            'My Books Status',
            style: TextStyle(color: color1, fontFamily: regular, fontSize: 20),
          ),
          leading: BackButton(
            color: color1,
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('books')
              .where('added by', isEqualTo: _user!.email)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final List<MyBook> books = snapshot.data!.docs.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                return MyBook(
                  name: data['name'],
                  author: data['author'],
                  picture: data['image_url'],
                  price: data['price'].toDouble(),
                  addedBy: data['added by'],
                );
              }).toList();

              if (books.isEmpty) {
                return Center(
                  child: Text('You have not added any books.'),
                );
              }

              return ListView.builder(
                itemCount: books.length,
                itemBuilder: (context, index) {
                  final book = books[index];
                  return Column(
                    children: [
                      ListTile(
                        leading: Image.network(
                          book.picture,
                          height: 50,
                          width: 50,
                          fit: BoxFit.cover,
                        ),
                        title: Text('${index + 1}. ${book.name}'),
                        subtitle: Text('Author: ${book.author}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Price: \Rs${book.price.toStringAsFixed(2)}'),
                            SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: () {
                                // Add your logic to delete the book
                                _deleteBook(book);
                              },
                              child: Text(
                                'Delete',
                                style: TextStyle(
                                    color: color,
                                    fontFamily: regular,
                                    fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        thickness: 1,
                        color: Colors.grey,
                      ), // Add a Divider between each book
                    ],
                  );
                },
              );
            }
          },
        ),
      );
    }
  }

  void _deleteBook(MyBook book) {
    // Add your logic to delete the book from Firebase
    FirebaseFirestore.instance
        .collection('books')
        .where('added by', isEqualTo: _user!.email)
        .where('name', isEqualTo: book.name)
        .get()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
      }
    });
  }
}
