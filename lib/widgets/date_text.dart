import 'package:flutter/material.dart';
class DateText extends StatelessWidget {
  const DateText({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,

      margin: EdgeInsets.symmetric(horizontal: 15.0,vertical: 10.0),  // Explicitly remove margin
      child: Text(
        "As Of 2025-02-25",
        style: Theme.of(context).textTheme.headlineLarge,
      ),
    );


  }
}
