import 'package:flutter/material.dart';
import 'package:sajhabackup/EasyConst/Styles.dart';
import 'package:sajhabackup/EasyConst/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class helpcenter extends StatefulWidget {
  const helpcenter({Key? key}) : super(key: key);

  @override
  State<helpcenter> createState() => _helpcenterState();
}

class _helpcenterState extends State<helpcenter> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     // backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: color,
          title: Text(
            'Help Center',
            style: TextStyle(
                color: Colors.white, fontFamily: regular, fontSize: 20),
          ),
          leading: BackButton(
            color: Colors.white,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () async {
                      final call = Uri.parse('tel:+977 9847600569');
                      if (await canLaunchUrl(call)) {
                        launchUrl(call);
                      } else {
                        throw 'Could not launch $call';
                      }
                    },
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: color,
                      ),
                      child: Icon(
                        Icons.call,
                        color: Colors.white,
                        size: 70,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        children: [
                          Text(
                            'Call Us',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontFamily: regular),
                          ),
                          Text(
                            '9AM-9PM[Sun-Sat]',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.normal,
                                color: Colors.black,
                                fontFamily: regular),
                          ),
                        ],
                      ))
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () async {
                      final email = Uri(
                        scheme: 'mailto',
                        path: 'sajhabookstore@gmail.com',
                        query: 'subject=Hello&body=How to use this app?',
                      );
                      if (await canLaunchUrl(email)) {
                        launchUrl(email);
                      } else {
                        throw 'Could not launch $email';
                      }
                    },
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: color,
                      ),
                      child: Icon(
                        Icons.mail_lock_sharp,
                        color: Colors.white,
                        size: 70,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        children: [
                          Text(
                            'Email Us',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontFamily: regular),
                          ),
                          Text(
                            '    Within 48 Hours',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.normal,
                                color: Colors.black,
                                fontFamily: regular),
                          ),
                        ],
                      ))
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Divider(
                height: 5,
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                child: Text(
                  'What is Sajha Bookstore?',
                  style: TextStyle(
                      fontFamily: regular,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: color),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '“SAJHA BOOKSTORE” is a platform for students and booklovers of Nepal to buy, sell and rent old books online.',
                  style: TextStyle(
                      fontFamily: regular,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
              Image.asset(
                'assets/images/read.png',
                height: 300,
              )
            ],
          ),
        ));
  }
}
