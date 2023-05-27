import 'package:flutter/material.dart';
import 'package:pocket_pose/ui/view/ml_kit_pose_detector_view.dart';

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
      body: const SafeArea(
        child: PoseDetectorView(),
      ),
    );
  }
}
