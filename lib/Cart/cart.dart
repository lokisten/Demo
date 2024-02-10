import 'package:flutter/material.dart';
import 'package:sajhabackup/Cart/cart_products.dart';
import 'package:sajhabackup/EasyConst/Colors.dart';
import 'package:sajhabackup/pages/search.dart';

class cart extends StatefulWidget {
  const cart({super.key});

  @override
  State<cart> createState() => _cartState();
}

class _cartState extends State<cart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: color,
        title: Text(
          'Favorites',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: color1),
        ),
        actions: [
          IconButton(
              onPressed: () {
                search;
              },
              icon: Icon(
                Icons.search,
                color: Colors.white,
              )),
          //IconButton(onPressed: (){}, icon: Icon(Icons.shopping_cart,color: Colors.white,))
        ],
      ),
      body: cartproducts(),
      bottomNavigationBar: Container(
        color: Colors.white,
        child: Row(
          children: [
            Expanded(
                child: ListTile(
              title: Text('Total:'),
              subtitle: Text('Rs'),
            )),
           
          ],
        ),
      ),
    );
  }
}
