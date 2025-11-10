import 'package:flutter/material.dart';

class NoInternetPage extends StatelessWidget {
  final VoidCallback onRetry;

  const NoInternetPage({Key? key, required this.onRetry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.wifi_off, size: 80, color: Colors.blueGrey),
              SizedBox(height: 20),
              Text(
                "No Internet Connection",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                "Please check your internet settings and try again.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  backgroundColor: Colors.blueGrey,
                ),
                child: Text("Retry", style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      );

  }
}
