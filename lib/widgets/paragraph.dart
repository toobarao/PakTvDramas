import 'package:flutter/material.dart';

class Paragraph extends StatelessWidget {
  final String text;
  const Paragraph(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 10.0),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }
}
