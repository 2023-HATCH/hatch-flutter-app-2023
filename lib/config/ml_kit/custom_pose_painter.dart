// 스켈레톤을 화면에 그려주는 클래스(추출된 포즈의 관절 랜드마크 배열, 이미지 크기, 이미지 회전 정보)
// translateX, translateY를 사용해 추출된 좌표를 휴대폰 화면 크기에 맞게 변형하여 그려줌
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:pocket_pose/config/app_color.dart';
import 'package:pocket_pose/config/ml_kit/coordinates_translator.dart';

class CustomPosePainter extends CustomPainter {
  CustomPosePainter(this.poses, this.absoluteImageSize, this.rotation);

  // 추출된 포즈의 랜드마크 리스트
  final List<Pose> poses;
  // 이미지 크기
  final Size absoluteImageSize;
  // 이미지 회전 정보
  final InputImageRotation rotation;

  @override
  void paint(Canvas canvas, Size size) {
    // Outer 네온 효과
    final neonOuterPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0
      ..strokeCap = StrokeCap.round
      ..color = AppColor.mintNeonColor
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3.0);

    // Inner 네온 효과
    final neonInnerPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round
      ..color = AppColor.mintNeonColor
      ..maskFilter = const MaskFilter.blur(BlurStyle.inner, 2.0);

    // 기본 라인
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round // 끝을 둥글게
      ..color = Colors.white;

    for (final pose in poses) {
      // 점1과 점2를 선으로 이어주는 함수(랜드마크 타입1, 랜드마크 타입2, 선 색깔 타입)
      void paintLine(
          PoseLandmarkType type1, PoseLandmarkType type2, Paint paintType) {
        final PoseLandmark joint1 = pose.landmarks[type1]!;
        final PoseLandmark joint2 = pose.landmarks[type2]!;
        canvas.drawLine(
            Offset(translateX(joint1.x, rotation, size, absoluteImageSize),
                translateY(joint1.y, rotation, size, absoluteImageSize)),
            Offset(translateX(joint2.x, rotation, size, absoluteImageSize),
                translateY(joint2.y, rotation, size, absoluteImageSize)),
            paintType);
      }

      // 점 1과 점 2를 네온 선으로 이어주는 함수(랜드마크 타입1, 랜드마크 타입2, 선 색깔 타입)
      // 네온은 총 3번 그려야한다.
      void paintNeonLine(
          PoseLandmarkType type1, PoseLandmarkType type2, Paint paintType) {
        paintLine(type1, type2, neonOuterPaint);
        paintLine(type1, type2, neonInnerPaint);
        paintLine(type1, type2, paintType);
      }

      //Draw arms
      paintNeonLine(
          PoseLandmarkType.leftShoulder, PoseLandmarkType.leftElbow, paint);
      paintNeonLine(
          PoseLandmarkType.leftElbow, PoseLandmarkType.leftWrist, paint);
      paintNeonLine(
          PoseLandmarkType.rightShoulder, PoseLandmarkType.rightElbow, paint);
      paintNeonLine(
          PoseLandmarkType.rightElbow, PoseLandmarkType.rightWrist, paint);

      //Draw hands
      paintNeonLine(
          PoseLandmarkType.leftThumb, PoseLandmarkType.leftWrist, paint);
      paintNeonLine(
          PoseLandmarkType.leftWrist, PoseLandmarkType.leftPinky, paint);
      paintNeonLine(
          PoseLandmarkType.leftPinky, PoseLandmarkType.leftIndex, paint);
      paintNeonLine(
          PoseLandmarkType.leftIndex, PoseLandmarkType.leftWrist, paint);
      paintNeonLine(
          PoseLandmarkType.rightThumb, PoseLandmarkType.rightWrist, paint);
      paintNeonLine(
          PoseLandmarkType.rightWrist, PoseLandmarkType.rightPinky, paint);
      paintNeonLine(
          PoseLandmarkType.rightPinky, PoseLandmarkType.rightIndex, paint);
      paintNeonLine(
          PoseLandmarkType.rightIndex, PoseLandmarkType.rightWrist, paint);

      //Draw foots
      paintNeonLine(
          PoseLandmarkType.leftAnkle, PoseLandmarkType.leftFootIndex, paint);
      paintNeonLine(
          PoseLandmarkType.leftFootIndex, PoseLandmarkType.leftHeel, paint);
      paintNeonLine(
          PoseLandmarkType.leftHeel, PoseLandmarkType.leftAnkle, paint);
      paintNeonLine(
          PoseLandmarkType.rightAnkle, PoseLandmarkType.rightFootIndex, paint);
      paintNeonLine(
          PoseLandmarkType.rightFootIndex, PoseLandmarkType.rightHeel, paint);
      paintNeonLine(
          PoseLandmarkType.rightHeel, PoseLandmarkType.rightAnkle, paint);

      //Draw Body
      paintNeonLine(
          PoseLandmarkType.leftShoulder, PoseLandmarkType.leftHip, paint);
      paintNeonLine(
          PoseLandmarkType.rightShoulder, PoseLandmarkType.rightHip, paint);

      //Draw legs
      paintNeonLine(PoseLandmarkType.leftHip, PoseLandmarkType.leftKnee, paint);
      paintNeonLine(
          PoseLandmarkType.leftKnee, PoseLandmarkType.leftAnkle, paint);
      paintNeonLine(
          PoseLandmarkType.rightHip, PoseLandmarkType.rightKnee, paint);
      paintNeonLine(
          PoseLandmarkType.rightKnee, PoseLandmarkType.rightAnkle, paint);

      //Draw connect body
      paintNeonLine(
          PoseLandmarkType.leftShoulder, PoseLandmarkType.rightShoulder, paint);
      paintNeonLine(PoseLandmarkType.leftHip, PoseLandmarkType.rightHip, paint);

      // Draw Face
      Offset centerPoint;
      Offset leftPoint;
      Offset rightPoint;

      final noseLandmark = pose.landmarks[PoseLandmarkType.nose];

      if (noseLandmark != null) {
        centerPoint = Offset(
          translateX(noseLandmark.x, rotation, size, absoluteImageSize),
          translateY(noseLandmark.y, rotation, size, absoluteImageSize),
        );

        final leftEyeLandmark = pose.landmarks[PoseLandmarkType.leftEye];
        final rightEyeLandmark = pose.landmarks[PoseLandmarkType.rightEye];

        if (leftEyeLandmark != null && rightEyeLandmark != null) {
          // 눈이 추출될 경우: 가장 perfect
          leftPoint = Offset(
            translateX(leftEyeLandmark.x, rotation, size, absoluteImageSize),
            translateY(leftEyeLandmark.y, rotation, size, absoluteImageSize),
          );
          rightPoint = Offset(
            translateX(rightEyeLandmark.x, rotation, size, absoluteImageSize),
            translateY(rightEyeLandmark.y, rotation, size, absoluteImageSize),
          );
        } else {
          //눈 추출이 안되면 임의의 값으로 그림
          int dis = 10; // 적당한 값인지 테스트 필요..
          leftPoint = Offset(
            translateX(noseLandmark.x - dis, rotation, size, absoluteImageSize),
            translateY(noseLandmark.y, rotation, size, absoluteImageSize),
          );
          rightPoint = Offset(
            translateX(noseLandmark.x + dis, rotation, size, absoluteImageSize),
            translateY(noseLandmark.y, rotation, size, absoluteImageSize),
          );
        }

        // Calculate face radius
        final distance = leftPoint.dx - rightPoint.dx;
        double faceRadius = distance * 2;

        if (faceRadius < 0) faceRadius = faceRadius * -1;

        debugPrint("faceRadius: ${faceRadius.toString()}");

        // Draw face circle
        canvas.drawCircle(centerPoint, faceRadius, neonOuterPaint);
        canvas.drawCircle(centerPoint, faceRadius, neonInnerPaint);
        canvas.drawCircle(centerPoint, faceRadius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPosePainter oldDelegate) {
    return oldDelegate.absoluteImageSize != absoluteImageSize ||
        oldDelegate.poses != poses;
  }
}
