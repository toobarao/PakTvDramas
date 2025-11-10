import 'package:flutter/material.dart';

import '../screens/search_screen.dart';
class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Center(
              child: Text(
                "All Channel Dramas",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => SearchScreen()));
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
    );
  }
}

