import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pocket_pose/data/entity/response/signin_signup_response.dart';
import 'package:pocket_pose/data/remote/repository/signin_signup_repository.dart';

class SignInSignUpProvider extends ChangeNotifier {
  late SignInSignUpResponse? response;

  Future<void> login(String kakaoAccessToken) async {
    try {
      final repositoryResponse =
          await SignInSignUpRepository().login(kakaoAccessToken);
      response = repositoryResponse;

      notifyListeners();
    } catch (e) {
      debugPrint(
          "lib/data/remote/provider/signin_signup_provider.dart error catch: ${e.toString()}");
    }
  }
}
