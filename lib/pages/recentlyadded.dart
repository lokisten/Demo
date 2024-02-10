import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sajhabackup/EasyConst/Colors.dart';
import 'package:sajhabackup/EasyConst/Styles.dart';
import 'package:sajhabackup/AddBooks/bookdetails2.dart';

class BookListPage extends StatefulWidget {
  @override
  _BookListPageState createState() => _BookListPageState();
}

class _BookListPageState extends State<BookListPage> {
  String selectedCategory = 'All'; // Default category
  String selectedPriceRange = 'All'; // Default price range

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: color,
        centerTitle: true,
        elevation: 0,
        leading: BackButton(
          color: color1,
        ),
        title: Text(
          'Recently Added',
          style: TextStyle(color: color1, fontFamily: regular),
        ),
      ),
      body: Column(
        children: [
          _buildFilterSection(),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('books').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                List<DocumentSnapshot<Object?>> books = snapshot.data!.docs;

                // Filter books based on selected category and price range
                if (selectedCategory != 'All') {
                  books = books.where((book) => book['category'] == selectedCategory).toList();
                }

                books = _filterBooksByPriceRange(books);

                return ListView.builder(
                  itemCount: books.length,
                  itemBuilder: (context, index) {
                    var book = books[index].data() as Map<String, dynamic>;

                    return ListTile(
                      title: Text(book['name']),
                      subtitle: Text(
                          'Author: ${book['author']}\nPrice: \Rs${book['price']}'),
                      leading: Image.network(
                        book['image_url'],
                        height: 50,
                        width: 50,
                        fit: BoxFit.cover,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => booksdetails2(
                              book: book,
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    return Column(
      children: [
        _buildCategoryDropdown(),
        _buildPriceRangeDropdown(),
      ],
    );
  }

  Widget _buildCategoryDropdown() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButton<String>(
        value: selectedCategory,
        onChanged: (String? newValue) {
          setState(() {
            selectedCategory = newValue!;
          });
        },
        items: <String>['All', 'Masters', 'Bachelors', 'Extra']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPriceRangeDropdown() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButton<String>(
        value: selectedPriceRange,
        onChanged: (String? newValue) {
          setState(() {
            selectedPriceRange = newValue!;
          });
        },
        items: <String>['All', 'Rs. 0 to 500', 'Rs. 500 to 1000', 'Rs. 1000 to 2000', 'Above 2000']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  List<DocumentSnapshot> _filterBooksByPriceRange(List<DocumentSnapshot> books) {
    if (selectedPriceRange == 'All') {
      return books;
    }

    List<DocumentSnapshot> filteredBooks = [];

    for (var book in books) {
      double price = book['price'].toDouble();
      switch (selectedPriceRange) {
        case 'Rs. 0 to 500':
          if (price >= 0 && price <= 500) {
            filteredBooks.add(book);
          }
          break;
        case 'Rs. 500 to 1000':
          if (price > 500 && price <= 1000) {
            filteredBooks.add(book);
          }
          break;
        case 'Rs. 1000 to 2000':
          if (price > 1000 && price <= 2000) {
            filteredBooks.add(book);
          }
          break;
        case 'Above 2000':
          if (price > 2000) {
            filteredBooks.add(book);
          }
          break;
      }
    }

    return filteredBooks;
  }
}
