import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:pocket_pose/ui/view/ml_kit_pose_detector_view.dart';

// 카메라 목록 변수
List<CameraDescription> cameras = [];

Future<void> main() async {
  // 비동기 메서드를 사용함
  WidgetsFlutterBinding.ensureInitialized();
  // 사용 가능한 카메라 목록 받아옴
  cameras = await availableCameras();
}

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
