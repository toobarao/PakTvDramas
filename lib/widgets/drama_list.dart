import 'package:flutter/material.dart';

class DramaList<T> extends StatelessWidget {
  final List<T> items;
  final Widget Function(T) itemBuilder;

  const DramaList({
    Key? key,
    required this.items,
    required this.itemBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 230,
      margin: EdgeInsets.symmetric(horizontal: 10.0),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) {
          return itemBuilder(items[index]);
        },
      ),
    );
  }
}
