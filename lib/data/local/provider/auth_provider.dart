import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const _storageKey = 'kakaoAccessToken';

class AuthProvider extends ChangeNotifier {
  final storage = const FlutterSecureStorage();
  String? _accessToken;

  String? get accessToken => _accessToken;

  Future<void> checkAccessToken() async {
    final accessToken = await storage.read(key: _storageKey);
    _accessToken = accessToken;

    notifyListeners();
  }

  Future<void> storeAccessToken(String accessToken) async {
    await storage.write(key: _storageKey, value: accessToken);
    _accessToken = accessToken;
    notifyListeners();
  }

  Future<void> removeAccessToken() async {
    await storage.delete(key: _storageKey);
    _accessToken = null;
    notifyListeners();
  }
}
