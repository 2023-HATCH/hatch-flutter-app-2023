class AppUrl {
  // api 서버
  static const _apiBaseUrl = "http://3.37.178.56:8080/api/v1";
  // 인공지능 서버
  static const _aiBaseUrl = "http://43.200.133.86:5000";
  // web socket 서버
  static const webSocketUrl = "ws://3.37.178.56:8080/ws-popo";

  static const _stageUrl = "$_apiBaseUrl/stage";
  static const _talkUrl = "$_apiBaseUrl/talks";
  static const _chatUrl = "$_apiBaseUrl/chats";

  // 로그인 & 회원가입
  static const signInSignUpUrl = "$_apiBaseUrl/auth/login?type=kakao";

  // 비디오
  static const videoUrl = "$_apiBaseUrl/videos";

  // 좋아요
  static const likeUrl = "$_apiBaseUrl/likes";

  // 댓글
  static const commentUrl = "$_apiBaseUrl/comments";

  // 포포 스테이지
  static const stageAccuracyUrl = "$_stageUrl/similarity";
  static const stageUserListUrl = "$_stageUrl/users";
  static const stageEnterUrl = "$_stageUrl/enter";
  static const stageCatchUrl = "$_stageUrl/catch";
  static const stageTalkUrl = "$_talkUrl/messages";

  // 스켈레톤 정확도 확인
  static const skeletonAccuracyUrl = "$_aiBaseUrl/api/similarity/test";

  // 채팅
  static const chatRoomCreateUrl = "$_chatUrl/rooms";

  // web socket
  static const socketSubscribeStageUrl = "/topic/stage";
  static const socketTalkUrl = "/app/talks/messages";
  static const socketReactionUrl = "/app/talks/reactions";
  static const socketPlaySkeletonUrl = "/app/stage/play/skeleton";
  static const socketMVPSkeletonUrl = "/app/stage/mvp/skeleton";
  static const socketExitUrl = "/app/stage/exit";
}
