import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AnimatedDancingPoPo extends StatelessWidget {
  const AnimatedDancingPoPo({
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
            child: SvgPicture.asset(
              'assets/icons/ic_dance_popo.svg',
            ),
          );
        },
      ),
    );
  }
}
