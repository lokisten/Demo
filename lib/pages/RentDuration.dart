import 'package:flutter/material.dart';
import 'package:sajhabackup/EasyConst/Colors.dart';
import 'package:sajhabackup/EasyConst/Styles.dart';

class RentDurationPage extends StatefulWidget {
  @override
  _RentDurationPageState createState() => _RentDurationPageState();
}

class _RentDurationPageState extends State<RentDurationPage> {
  int selectedDuration = 7; // Default duration in days
  double rentalCostPerDay = 2.5;
  late double totalCost;

  @override
  void initState() {
    super.initState();
    calculateTotalCost();
  }

  void calculateTotalCost() {
    if (selectedDuration == 2) {
      // Special case for 2 days
      totalCost = 5.0;
    } else if (selectedDuration > 30) {
      // Adjust the cost per day if duration is more than a month
      rentalCostPerDay = 5.0 / 5;
      totalCost = selectedDuration * rentalCostPerDay;
    } else {
      totalCost = selectedDuration * rentalCostPerDay;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: color,
        title: Text(
          'Choose Rent Duration',
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
              'Select the rental duration:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            Container(
              height: 60,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  for (int duration in [2, 7, 14, 30, 90, 180, 365])
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedDuration = duration;
                          calculateTotalCost();
                        });
                      },
                      child: Container(
                        width:
                            100, // Adjust the width of each item based on your preference
                        margin: EdgeInsets.symmetric(horizontal: 8),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: selectedDuration == duration
                              ? color
                              : Colors.grey,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            '${getDurationLabel(duration)}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Total Cost: Rs ${totalCost.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                print(
                    'Initiate Payment for Rs ${totalCost.toStringAsFixed(2)}');
              },
              child: Text(
                'Rent Now',
                style: TextStyle(
                    fontSize: 16, fontFamily: regular, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getDurationLabel(int days) {
    if (days == 2) {
      return '2 days';
    } else if (days == 7) {
      return '1 week';
    } else if (days == 14) {
      return '2 weeks';
    } else if (days == 30) {
      return '1 month';
    } else if (days == 90) {
      return '3 months';
    } else if (days == 180) {
      return '6 months';
    } else if (days == 365) {
      return '1 year';
    } else {
      return '$days days';
    }
  }
}
