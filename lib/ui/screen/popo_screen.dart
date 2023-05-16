import 'package:flutter/material.dart';

class PoPoScreen extends StatelessWidget {
  const PoPoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Navigator.popUntil(
                  context,
                  (route) {
                    return route.isFirst;
                  },
                );
              },
              icon: const Icon(Icons.home))
        ],
      ),
      backgroundColor: Colors.pink,
      body: const Text(
        "popo",
        style: TextStyle(color: Colors.white, fontSize: 50),
      ),
    );
  }
}
