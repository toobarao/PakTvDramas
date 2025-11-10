import 'package:flutter/material.dart';

class DramasTiles<T> extends StatelessWidget {
  final List<T> items;
  final Widget Function(T) itemBuilder;

  const DramasTiles({
    Key? key,
    required this.items,
    required this.itemBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return itemBuilder(items[index]);
      },
    );
  }
}
