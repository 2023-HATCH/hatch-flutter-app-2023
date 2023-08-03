class AppUrl {
  // api 서버
  static const _apiBaseUrl = "http://3.37.178.56:8080/api/v1";
  // 인공지능 서버
  static const _aiBaseUrl = "http://43.200.133.86:5000";
  // web socket 서버
  static const webSocketUrl = "ws://3.37.178.56:8080/ws-popo";

  static const _stageUrl = "$_apiBaseUrl/stage";
  static const _talkUrl = "$_apiBaseUrl/talks";
  static const videoUrl = "$_apiBaseUrl/videos";

  // 로그인 & 회원가입
  static const signInSignUpUrl = "$_apiBaseUrl/auth/login?type=kakao";

  // 홈
  static const homeVideosUrl = "$_apiBaseUrl/videos";

  // 좋아요
  static const likeUrl = "$_apiBaseUrl/likes";

  // 포포 스테이지
  static const stageAccuracyUrl = "$_stageUrl/similarity";
  static const stageUserListUrl = "$_stageUrl/users";
  static const stageEnterUrl = "$_stageUrl/enter";
  static const stageExitUrl = "$_stageUrl/exit"; // 임시 url
  static const stageTalkUrl = "$_talkUrl/messages";

  // 스켈레톤 정확도 확인
  static const skeletonAccuracyUrl = "$_aiBaseUrl/api/similarity/test";

  // web socket
  static const subscribeStageUrl = "/topic/stage";
}
