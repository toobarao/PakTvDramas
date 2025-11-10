import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final String first;
  final String second;
  final bool isRedSecond;

  const SectionTitle({
    Key? key,
    required this.first,
    required this.second,
    this.isRedSecond = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(

      margin: EdgeInsets.symmetric(vertical: 10.0,horizontal: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            first,
            style:
            Theme.of(context).textTheme.headlineLarge

          ),
          Text(
            second,
            style:
            Theme.of(context).textTheme.headlineLarge?.copyWith(
              color: isRedSecond ? Colors.red : null,
            )
            ,
          ),
        ],
      ),
    );
  }
}
