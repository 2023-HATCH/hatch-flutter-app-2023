import 'package:flutter/material.dart';

class StageLiveChatListWidget extends StatelessWidget {
  const StageLiveChatListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> entries = <String>['a', 'b', 'c', 'd'];

    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          color: Colors.black.withOpacity(0.3),
          height: 200,
          child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 100),
              itemCount: entries.length,
              itemBuilder: (BuildContext context, int index) {
                return SizedBox(
                    child: Center(
                        child: Text(
                  '순서대로 ${entries[index]}',
                  style: const TextStyle(color: Colors.white),
                )));
              }),
        ),
      ),
    );
  }
}
