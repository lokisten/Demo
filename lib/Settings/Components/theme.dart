import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sajhabackup/EasyConst/Colors.dart';
import 'package:sajhabackup/EasyConst/Styles.dart';
import 'package:sajhabackup/Widgets/box.dart';
import 'package:sajhabackup/Widgets/mybutton.dart';
import 'package:sajhabackup/themes/themeprovider.dart';

class theme extends StatelessWidget {
  const theme({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF9526BC),
          centerTitle: true,
          title: Text(
            'Theme',
            style: TextStyle(fontSize: 20, fontFamily: regular, color: color1),
          ),
          leading: BackButton(
            color: color1,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Center(
          child: MyBox(
              color: Theme.of(context).colorScheme.primary,
              child: MyButton(
                color: Theme.of(context).colorScheme.secondary,
                onTap: () {
                  Provider.of<ThemeProvider>(context, listen: false)
                      .toggleTheme();
                },
              )),
        ));
  }
}
