class AppUrl {
  // api 서버
  static const _apiBaseUrl = "http://43.202.211.36:8080/api/v1";
  // web socket 서버
  static const webSocketUrl = "ws://43.202.211.36:8080/ws-popo";

  // 로그인 & 회원가입
  static const signInSignUpUrl = "$_apiBaseUrl/auth/login?type=kakao";

  // 로그아웃
  static const logOutUrl = "$_apiBaseUrl/auth/logout?type=kakao";

  // 비디오
  static const videoUrl = "$_apiBaseUrl/videos";

  // 좋아요
  static const likeUrl = "$_apiBaseUrl/likes";

  // 댓글
  static const commentUrl = "$_apiBaseUrl/comments";

  // 팔로우
  static const followUrl = "$_apiBaseUrl/users/follow";

  // 프로필
  static const profileUrl = "$_apiBaseUrl/users/profile";
  static const profileEditUrl = "$_apiBaseUrl/users/me";
  static const profileVideoUrl = "$_apiBaseUrl/users/videos";
  static const profileLikeVideoUrl = "$_apiBaseUrl/likes";

  // 검색
  static const searchTagsUrl = "$videoUrl/tags";
  static const searchTagVideoUrl = "$videoUrl/search";
  static const searchUserUrl = "$_apiBaseUrl/users/search";

  // 포포 스테이지
  // 스테이지
  static const _stageUrl = "$_apiBaseUrl/stage";
  static const _talkUrl = "$_apiBaseUrl/talks";
  static const stageAccuracyUrl = "$_stageUrl/similarity";
  static const stageUserListUrl = "$_stageUrl/users";
  static const stageEnterUrl = "$_stageUrl/enter";
  static const stageCatchUrl = "$_stageUrl/catch";
  static const stageTalkUrl = "$_talkUrl/messages";

  // web socket
  // 스테이지
  static const socketSubscribeStageUrl = "/topic/stage";
  static const socketTalkUrl = "/app/talks/messages";
  static const socketReactionUrl = "/app/talks/reactions";
  static const socketPlaySkeletonUrl = "/app/stage/play/skeleton";
  static const socketMVPSkeletonUrl = "/app/stage/mvp/skeleton";
  static const socketExitUrl = "/app/stage/exit";

  // 채팅
  static const _chatUrl = "$_apiBaseUrl/chats";
  static const chatSearchUserListUrl = "$_apiBaseUrl/users/all";
  static const chatRoomUrl = "$_chatUrl/rooms";
  static const socketSubscribeChatUrl = "/topic/chats/rooms";
  static const socketChatkUrl = "/app/chats/messages";

  // 에러
  static const socketErrorUrl = "/user/topic/errors";
}
