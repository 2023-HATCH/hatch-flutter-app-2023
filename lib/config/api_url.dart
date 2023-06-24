class AppUrl {
  // api 서버
  static const _apiBaseUrl = "http://3.37.178.56:8080/api/v1";
  // 인공지능 서버
  static const _aiBaseUrl = "http://43.200.133.86:5000";

  static const _stageUrl = "$_apiBaseUrl/stages";

  // 로그인 & 회원가입
  static const signInSignUpUrl = "$_apiBaseUrl/auth/login?type=kakao";

  // 포포 스테이지
  static const stageAccuracyUrl = "$_stageUrl/similarity";

  // 스켈레톤 정확도 확인
  static const skeletonAccuracyUrl = "$_aiBaseUrl/api/similarity/test";
}
