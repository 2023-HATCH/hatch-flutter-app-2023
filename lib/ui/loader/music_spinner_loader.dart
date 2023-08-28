import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class MusicSpinner extends StatelessWidget {
  const MusicSpinner({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black87,
      child: SpinKitSpinningCircle(
        size: 160.0,
        duration: const Duration(milliseconds: 2400),
        itemBuilder: (context, index) {
          return Center(
            child: Image.asset(
              'assets/icons/ic_spinner.png',
            ),
          );
        },
      ),
    );
  }
}
