import 'package:flutter/material.dart';
import 'package:pocket_pose/ui/screen/popo_result_screen.dart';
import 'package:pocket_pose/ui/view/ml_kit_skeleton_custom_view.dart';

class PoPoPlayScreen extends StatelessWidget {
  const PoPoPlayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) =>
                        const PoPoResultScreen()));
              },
              icon: const Icon(Icons.navigate_next_rounded))
        ],
      ),
      body: const SkeletonCutomView(),
    );
  }
}
