import 'package:flutter/material.dart';

class AboutSectionTitle extends StatelessWidget {
  final String title;
  const AboutSectionTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0, bottom: 12.0),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.red,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.start,
      ),
    );
  }
}