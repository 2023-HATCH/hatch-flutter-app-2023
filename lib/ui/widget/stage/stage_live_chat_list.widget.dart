import 'package:flutter/material.dart';

class StageLiveChatListWidget extends StatelessWidget {
  const StageLiveChatListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> entries = <String>[
      'a',
      'b',
      'c',
      'd',
      'e',
      'f',
      'g',
      '1',
      '2',
      '3'
    ];

    return _buildStageChatList(entries);
  }

  SingleChildScrollView _buildStageChatList(List<String> entries) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.black.withOpacity(0.3),
        height: 150,
        child: ListView.separated(
            padding: const EdgeInsets.all(14),
            itemCount: entries.length,
            separatorBuilder: (context, index) {
              return const SizedBox(height: 12);
            },
            itemBuilder: (BuildContext context, int index) {
              return Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.asset(
                      'assets/images/home_profile_1.jpg',
                      width: 35,
                      height: 35,
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'nickname ${entries[index]}',
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        'content ${entries[index]}',
                        style: const TextStyle(color: Colors.white),
                      )
                    ],
                  )
                ],
              );
            }),
      ),
    );
  }
}
