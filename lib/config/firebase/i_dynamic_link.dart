abstract class IDynamicLink {
  Future<bool> setup();
  Future<String> getShortLink(String uuid);
}
