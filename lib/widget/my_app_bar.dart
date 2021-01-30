import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget {

  final String title;
  MyAppBar(this.title);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyText1,
      ),
    );
  }
}