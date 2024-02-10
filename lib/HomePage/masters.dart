import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:sajhabackup/AddBooks/bookdetails.dart';
import 'package:sajhabackup/AddBooks/bookdetails2.dart';

class masters extends StatefulWidget {
  

  @override
  State<masters> createState() => _mastersState();
}

class _mastersState extends State<masters> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchBooksFromFirebase(),
      builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          var product_list = snapshot.data ?? [];
          return GridView.builder(
            itemCount: product_list.length,
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemBuilder: (BuildContext context, int index) {
              return SingleProd(
                prodName: product_list[index]['name'],
                prodPicture: product_list[index]['image_url'],
                prodPrice: product_list[index]['price'].toDouble(),
                prodAuthor: product_list[index]['author'],
                prodCondition: product_list[index]['condition'],
                prodEdition: product_list[index]['edition'],
                prodAddInfo: product_list[index]['additional_info'],
                prodAddress: product_list[index]['address'],
                
                prodAddedBy:product_list[index]['added by']
                
              );
            },
          );
        }
      },
    );
  }

  Future<List<Map<String, dynamic>>> fetchBooksFromFirebase() async {
    final QuerySnapshot<Map<String, dynamic>> result = await FirebaseFirestore
        .instance
        .collection('books')
        .where('category', isEqualTo: 'Masters')
        .limit(4)
        .get();

    return result.docs.map((doc) => doc.data()).toList();
  }
}

class SingleProd extends StatelessWidget {
  final String prodName;
  final String prodPicture;
  final double prodPrice;

  final String prodAuthor;
 final String prodCondition;
 final String prodEdition;
  final String prodAddress;
   final String prodAddInfo;
    final String prodAddedBy;
  SingleProd({
    required this.prodName,
    required this.prodPicture,
    required this.prodPrice,
    required this.prodAuthor,
    required this.prodCondition,
    required this.prodEdition,
    required this.prodAddInfo,
    required this.prodAddedBy,
    required this.prodAddress,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Hero(
        tag: prodName,
        child: Material(
          child: InkWell(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => booksdetails2(book: {
                    'name': prodName,
                    'image_url': prodPicture,
                    'author': prodAuthor, 
                    'edition': prodEdition, 
                    'price': prodPrice,
                    'condition': prodCondition, 
                    'address':prodAddress , 
                    'additional_info': prodAddInfo, 
                    'added by': prodAddedBy, 
                  }),
            )),
            child: GridTile(
              footer: Container(
                color: Colors.white70,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        prodName,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(
                      '\Rs$prodPrice',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              child: Image.network(
                prodPicture,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
