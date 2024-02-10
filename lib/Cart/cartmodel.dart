import 'package:flutter/material.dart';
class Book {
  final String name;
  final String author;
  final double price;
  final String imageUrl;

  Book({
    required this.name,
    required this.author,
    required this.price,
    required this.imageUrl,
  });
}

class CartModel extends ChangeNotifier {
  List<Book> _cartItems = [];

  List<Book> get cartItems => _cartItems;

  void addToCart(Book book) {
    _cartItems.add(book);
    notifyListeners();
  }

  void removeFromCart(Book book) {
    _cartItems.remove(book);
    notifyListeners();
  }
}