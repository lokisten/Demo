import 'package:flutter/material.dart';
import 'package:sajhabackup/EasyConst/Colors.dart';
import 'package:sajhabackup/EasyConst/Styles.dart';
import 'package:sajhabackup/pages/RentDuration.dart';

class RentingExplanationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xFF9526BC),
        title: Text(
          'How Renting Works',
          style: TextStyle(color: color1, fontFamily: regular, fontSize: 20),
        ),
        leading: BackButton(
          color: color1,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'How Renting Works?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Renting books from other users is a seamless process designed to make your reading experience enjoyable and cost-effective. Here\'s a quick overview of how it works:',
              style: TextStyle(
                fontSize: 16,
                fontFamily: regular,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Renting is a feature only provided by Sajha Bookstore. Users can rent books for certain period of time and then return. The user interested to rent the book has to specify the duration of renting. Then he/she has to pay full amount of the book. After returning the book, the user will get some amount back subtracting the cost of renting from the deposit.',
              style: TextStyle(
                fontSize: 16,
                fontFamily: regular,
              ),
            ),
            Container(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RentDurationPage()));
                    },
                    child: Text(
                      'Next',
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: regular,
                          color: Colors.black),
                    )))
          ],
        ),
      ),
    );
  }
}
