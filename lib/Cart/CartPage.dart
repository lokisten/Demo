import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sajhabackup/Cart/cartmodel.dart';
import 'package:sajhabackup/EasyConst/Colors.dart';
import 'package:sajhabackup/EasyConst/Styles.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var cartModel = Provider.of<CartModel>(context);

    // Calculate total price
    double totalPrice = cartModel.cartItems
        .fold(0, (previousValue, book) => previousValue + book.price);

    return Scaffold(
      //backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: color,
        title: Text(
          'Favorites',
          style: TextStyle(color: color1, fontFamily: regular, fontSize: 20),
        ),
        leading: BackButton(
          color: color1,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: cartModel.cartItems.isEmpty
                  ? Text('Your cart is empty.')
                  : ListView.builder(
                      itemCount: cartModel.cartItems.length,
                      itemBuilder: (context, index) {
                        var book = cartModel.cartItems[index];
                        return Card(
                          margin: EdgeInsets.all(8.0),
                          child: ListTile(
                            title: Text(book.name),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Author: ${book.author}'),
                                Image.network(
                                  book.imageUrl,
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover,
                                ),
                                Text(
                                    'Price: \Rs${book.price.toStringAsFixed(2)}'),
                              ],
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                // Remove the book from the cart
                                cartModel.removeFromCart(book);
                              },
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(16.0),
            color: Colors.grey.shade200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total Price: \Rs${totalPrice.toStringAsFixed(2)}'),
               
              ],
            ),
          ),
        ],
      ),
    );
  }
}
