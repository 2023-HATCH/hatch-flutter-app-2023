import 'package:pocket_pose/data/entity/socket_request/send_skeleton_request.dart';

abstract class SocketStageProvider {
  void connectWebSocket();
  void deactivateWebSocket();
  void onSubscribe();
  void sendMessage(String message);
  void sendReaction();
  void sendSkeleton(SendSkeletonRequest request);
}
