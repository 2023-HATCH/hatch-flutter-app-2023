import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ProfileScreenLoader extends StatelessWidget {
  const ProfileScreenLoader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
          child: SpinKitPumpingHeart(
        color: Colors.pink[100],
        size: 50.0,
      )),
    );
  }
}
