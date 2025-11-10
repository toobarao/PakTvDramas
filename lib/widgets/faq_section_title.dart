import 'package:flutter/material.dart';

class FaqSectionTitle extends StatelessWidget {
  final String title;
  const FaqSectionTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.red,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}